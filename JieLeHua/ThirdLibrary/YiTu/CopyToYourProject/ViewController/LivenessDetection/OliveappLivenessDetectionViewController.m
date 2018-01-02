//
//  LivenessDetectionViewController.m
//  LivenessDetectionViewSDK
//
//  Created by Jiteng Hao on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "OliveappCameraPreviewController.h"
#import "OliveappViewUpdateEventDelegate.h"
#import "OliveappLivenessDetectionViewController.h"
#import "OliveappVerificationController.h"
#import "GifView.h"
#import "OliveappStructLivenessFrameResult.h"
#import "RMDisplayLabel.h"
#import "RMDownloadIndicator.h"
#import "OliveappLivenessDataType.h"
#import "OliveappViewUpdateEventDelegate.h"
@interface OliveappLivenessDetectionViewController() <AVAudioPlayerDelegate,OliveappViewUpdateEventDelegate>

#if !TARGET_IPHONE_SIMULATOR
// 相机预览
@property (weak, nonatomic) IBOutlet UIView *mCameraPreview;
// 步骤提示文本标签
@property (weak, nonatomic) IBOutlet UILabel *mStepHintTextLabel;
// 淡淡的背景图片
@property (weak, nonatomic) IBOutlet UIView *hintBackgoundImageView;
// gif动画
@property (weak, nonatomic) IBOutlet UIImageView *stepHintAnimation;
// 倒计时位置的view
@property (weak, nonatomic) IBOutlet UIView *countDownTimer;
// 倒计时的文字和圆圈
@property (weak, nonatomic) IBOutlet UILabel *countDownTimerLabel;
// 封闭的指示
@property (weak, nonatomic) RMDownloadIndicator *closedIndicator;
// Gif动画对象
@property (strong, nonatomic) GifView *dataView;
//音频
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;
@property (weak) id<OliveappLivenessResultDelegate> mLivenessResultDelegate;
//摄像头对象
@property (strong) OliveappCameraPreviewController* mCameraController;
//流程控制器
@property (strong) OliveappVerificationController* mVerificationController;
//提示文字
@property (strong) NSDictionary *mActionHintTextDict;
// 动作图片
@property (strong) NSDictionary *mAnimationDict;
// 音频对应字典
@property (strong) NSDictionary *mAudioDict;
// 动作切换时的线程队列
@property NSOperationQueue * mAudioHandlerQueue;
// 动作切换的模式
@property int mMode;


@end

@implementation OliveappLivenessDetectionViewController


////////// View Controller Event /////////////
- (void) viewDidLoad {
    [super viewDidLoad];
    if (_mCameraController == nil) {
        _mCameraController = [[OliveappCameraPreviewController alloc] init];
    }

    //读取提示文字plist
    NSString *textConstantsFilePath = [[NSBundle bundleForClass:[self class]] pathForResource: @"TextConstants"
                                                                                       ofType: @"plist"];
    _mActionHintTextDict = [NSDictionary dictionaryWithContentsOfFile:textConstantsFilePath];
    
    //读取gif动画plist
    NSString *animationConstantsPath = [[NSBundle bundleForClass:[self class]] pathForResource: @"AnimationConstants"
                                                                                       ofType: @"plist"];
    _mAnimationDict = [NSDictionary dictionaryWithContentsOfFile:animationConstantsPath];
    
    
    //读取音频plist
    NSString *audioConstantsPath = [[NSBundle bundleForClass:[self class]] pathForResource: @"AudioConstants"
                                                                                    ofType: @"plist"];
    _mAudioDict = [NSDictionary dictionaryWithContentsOfFile:audioConstantsPath];
    
    // 绑定APP切回事件，切出APP被认为是取消活体检测。活体检测过程中不允许APP切出切回，否则用户可以换人Hack算法
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:app];
    
    //使步骤提示文字可以换行
    _mStepHintTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _mStepHintTextLabel.numberOfLines = 0;
    // 设置步骤提示文字颜色和圆角矩形
    _mStepHintTextLabel.layer.cornerRadius = 22.5;
    _mStepHintTextLabel.clipsToBounds = YES;
    _mStepHintTextLabel.layer.borderWidth = 2.0;
    _mStepHintTextLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    //初始化消息队列
    _mAudioHandlerQueue = [[NSOperationQueue alloc] init];
    [_mAudioHandlerQueue setMaxConcurrentOperationCount:1];

    
}

- (void) viewWillAppear:(BOOL)animated {
    VVLog(@"[PROFILE] LivenessDetectionViewController.viewWillAppear");
    [super viewWillAppear:animated];
    [_mCameraController startCamera:AVCaptureDevicePositionFront];
    
    //设置预检gif
    NSString *animationFile = [_mAnimationDict objectForKey:[NSString stringWithFormat:@"mAnimation_%d", 0]];
    [_stepHintAnimation setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:animationFile ofType:@"gif"]]];
    
    //设置预检文字
    [_mStepHintTextLabel setText:[_mActionHintTextDict objectForKey: [NSString stringWithFormat:@"hinttext_action_%d", 0]]];
    VVLog(@"[PROFILE] LivenessDetectionViewController.viewWillAppear finish");
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    VVLog(@"[LivenessDetectionViewController viewDidAppear]");
    NSError * error;
    [self startDetection:&error];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    VVLog(@"[LivenessDetectionViewController] viewDidLayoutSubviews");
    // 设置界面预览,第二个参数请传nil
    [_mCameraController setupPreview: _mCameraPreview withVideoGravity:nil];

    // 实现提示动画的圆角
    CGFloat num = (CGRectGetHeight(_stepHintAnimation.frame)) / 2;
    _stepHintAnimation.layer.cornerRadius = num;
    _stepHintAnimation.clipsToBounds = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mAudioHandlerQueue cancelAllOperations];
    [_audioPlayer stop];
    _audioPlayer = nil;
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    VVLog(@"[LivenessDetectionViewController] viewDidDisappear");
    // 当界面消失时析构所有对象
    [_mCameraController stopCamera];
    [_mVerificationController unInit];
    _mVerificationController = nil;
    
    [self removeNotification];
}

// 重要
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    VVLog(@"applicationDidBecomeActive...");
    // 用户切出APP又切回，切出APP我们认为是取消活体检测
    [_mLivenessResultDelegate onLivenessCancel];
}

- (void) removeNotification {
    // 失败后不再监听APP活跃事件，否则会造成ViewController被两次dismiss，现象是UIAlert无法消除
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:app];
}


#pragma mark -
#pragma mark -- 活体检测相关
////////// Liveness Detection Related ////////

// 设置配置活性检测
- (BOOL) setConfigLivenessDetection: (id<OliveappLivenessResultDelegate>) delegate
                           withMode: (int) mode
                          withError: (NSError **) error {
    
    _mMode = mode;
    // 设置参数
    _mLivenessResultDelegate = delegate;
    return YES;
}

- (void)startDetection:(NSError **)error {
    
    //初始化VerificationController
    _mVerificationController = [OliveappVerificationController new];
    
    /**
     *  动作生成规则和通过规则配置
     *  注意：默认参数平衡了通过率和防Hack能力，一般情况下不需要更改，如有需求请咨询依图工程师
     */
    OliveappSessionManagerConfig* config = [OliveappSessionManagerConfig new];
    [config usePredefinedConfig: 0]; // 使用默认的配置
    
    /**
     *  部分自定义配置
     */
//    config.totalActions = @3; //动作总数
//    config.minPass = @3;      //最少通过数
//    config.maxFail = @0;      //最大失败数
//    config.timeoutMs = @10000;//超时时间
//    固定动作序列，现在只支持这四个动作
//    config.actionList = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:FACIAL_ACTION_EYE_CLOSE],
//                                                         [NSNumber numberWithInteger:FACIAL_ACTION_MOUTH_OPEN],
//                                                         [NSNumber numberWithInteger:FACIAL_ACTION_HEAD_UP],
//                                                         [NSNumber numberWithInteger:FACIAL_ACTION_HEAD_SHAKE_SIDE_TO_SIDE],nil];
    
    
    [_mVerificationController setConfig:config
                               withMode:_mMode
                           withDelegate:self
                              withError:error];
    
    //设置摄像头回调
    [_mCameraController setCameraPreviewDelegate: _mVerificationController];
    
    //打开音频，从AudioConstants.plist文件获取音频
    NSString *audioFile = [_mAudioDict objectForKey:[NSString stringWithFormat:@"audio_action_%d", 0]];
    [self playBackgroundSoundEffect:audioFile];
    
    // 启动活体检测，可以使用下面这段代码来实现“开始”按钮功能
    if ([_mVerificationController getCurrentStep] == STEP_READY) {
        VVLog(@"启动检测");
        [_mVerificationController nextVerificationStep];
    }
}
// 初始化结果
// 处理初始化事件

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
//////////////    Initialization Result       ///////////////////
//////////////    Handle Initialization Event ///////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/**
 * 初始化成功的回调
 */
- (void) onInitializeSucc {
    assert([NSThread isMainThread] == 1);
    VVLog(@"活体检测初始化成功");
    
}

/**
 * 初始化失败的回调
 */
- (void) onInitializeFail:(NSError*) error {
    assert([NSThread isMainThread] == 1);
    VVLog(@"活体检测初始化失败，错误信息: %@", [error localizedDescription]);
}


// 异步启动验证委托
// 重启验证事件处理

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
////////////// AsyncPrestartValidatorDelegate ///////////////////
////////////// Handle PrestartValidator Event ///////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/**
 *  预检成功回调
 *
 *  @param detectedFrame 捕获到的图片
 */
- (void) onPrestartSuccess: (OliveappDetectedFrame*) detectedFrame {
    assert([NSThread isMainThread] == 1);
    
    // 预检成功
    VVLog(@"预检成功");
    
    if (FLUENT_CHANGE == _mMode) {
        //添加操作
        NSBlockOperation * blockOperation = [[NSBlockOperation alloc] init];
        //为了能够Cancel掉正在进行的线程
        __weak NSBlockOperation * weakOperation = blockOperation;
        
        [weakOperation addExecutionBlock:^(){
            //这里只会阻塞当前线程，不会阻塞UI线程
            while ([_audioPlayer isPlaying]) {
                 [NSThread sleepForTimeInterval:0.1];
            }
            [_mVerificationController enterLivenessDetection];
        }];
        [_mAudioHandlerQueue addOperation:weakOperation];
    } else {
        [_mVerificationController enterLivenessDetection];
    }
}

/**
 *  预检失败回调
 */
- (void) onPrestartFail {
    assert([NSThread isMainThread] == 1);
    // 处理预检失败事件(一般为超时)
    NSAssert(false, @"预检失败，现在的实现不应该运行到这里");
}

/**
 *  单帧回调
 *
 *  @param remainingTimeoutMilliSecond 剩余时间
 */
- (void) onFrameDetected: (int) remainingTimeoutMilliSecond {
    assert([NSThread isMainThread] == 1);
    // 单帧处理结束事件
    // 不需要处理
}


// 异步委托的活性检测
// 事件处理的活性检测

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
////////////// AsyncLivenessDetectorDelegate ////////////////////
////////////// Handle LivenessDetector Event ////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/**
 *  活体检测成功的回调
 *
 *  @param detectedFrame 活体检测抓取的图片
 */
- (void) onLivenessSuccess: (OliveappDetectedFrame*) detectedFrame {
    assert([NSThread isMainThread] == 1);
    assert(detectedFrame.frameData == nil);

    // 失败后不再监听APP活跃事件，否则会造成ViewController被两次dismiss，现象是UIAlert无法消除
    [self removeNotification];
    
    if (FLUENT_CHANGE == _mMode) {
        //添加操作
        NSBlockOperation * blockOperation = [[NSBlockOperation alloc] init];
        //为了能够Cancel掉正在进行的线程
        __weak NSBlockOperation * weakOperation = blockOperation;
        
        [weakOperation addExecutionBlock:^(){
            //这里只会阻塞当前线程，不会阻塞UI线程
            while ([_audioPlayer isPlaying]) {
                 [NSThread sleepForTimeInterval:0.1];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_closedIndicator removeFromSuperview];
                [_countDownTimer setHidden:YES];
                [_mStepHintTextLabel setText:@"活体检测成功"];
            });
            //播放成功地音频
            [self playBackgroundSoundEffect:@"oliveapp_step_hint_verificationpass"]; // 考虑取消提示结果的语音
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^() {
                // 回调给用户
                [_mLivenessResultDelegate onLivenessSuccess:detectedFrame];
            });
        }];
        [_mAudioHandlerQueue addOperation:weakOperation];
    } else {
        //播放成功地音频
        [self playBackgroundSoundEffect:@"oliveapp_step_hint_verificationpass"]; // 考虑取消提示结果的语音
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^() {
            //回调给用户
            [_mLivenessResultDelegate onLivenessSuccess:detectedFrame];
        });
    }
}

/**
 *  活体检测失败的回调
 *
 *  @param sessionState  session状态，用于区别超时还是动作不过关
 *  @param detectedFrame 活体检测抓取的图片
 */
- (void) onLivenessFail: (int) sessionState
      withDetectedFrame: (OliveappDetectedFrame *) detectedFrame{
    assert([NSThread isMainThread] == 1);
    VVLog(@"LivenessDetectionViewController::onLivenessFail");

    // 失败后不再监听APP活跃事件，否则会造成ViewController被两次dismiss，现象是UIAlert无法消除
    [self removeNotification];
    
    if (FLUENT_CHANGE == _mMode) {
        //添加操作
        NSBlockOperation * blockOperation = [[NSBlockOperation alloc] init];
        //为了能够Cancel掉正在进行的线程
        __weak NSBlockOperation * weakOperation = blockOperation;
        
        [weakOperation addExecutionBlock:^(){
            //这里只会阻塞当前线程，不会阻塞UI线程
            while ([_audioPlayer isPlaying]) {
                 [NSThread sleepForTimeInterval:0.1];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_closedIndicator removeFromSuperview];
                [_countDownTimer setHidden:YES];
                [_mStepHintTextLabel setText:@"活体检测失败"];
            });
            
            if (sessionState == SESSION_TIMEOUT) {
                [self playBackgroundSoundEffect:@"oliveapp_step_hint_timeout"];
            } else {
                [self playBackgroundSoundEffect:@"oliveapp_step_hint_verificationfail"];
            }
            // 回调给用户
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^() {
                // 回调给用户
                [_mLivenessResultDelegate onLivenessFail:sessionState withDetectedFrame:detectedFrame];
            });
        }];
        [_mAudioHandlerQueue addOperation:weakOperation];
    } else {
        if (sessionState == SESSION_TIMEOUT) {
            [self playBackgroundSoundEffect:@"oliveapp_step_hint_timeout"];
        } else {
            [self playBackgroundSoundEffect:@"oliveapp_step_hint_verificationfail"];
        }
        // 回调给用户
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^() {
            // 回调给用户
            [_mLivenessResultDelegate onLivenessFail:sessionState withDetectedFrame:detectedFrame];
        });
    }
}


/**
 *  活体检测进入下一个动作时的回调
 *
 *  @param lastActionType     上一个动作类型
 *  @param lastActionResult   上一个动作的检测结果，通过或者不通过
 *  @param newActionType      新动作的类型
 *  @param currentActionIndex 当前是第几个动作，下标从0开始
 */
- (void) onActionChanged: (int)lastActionType
    withLastActionResult: (int)lastActionResult
       withNewActionType: (int)newActionType
  withCurrentActionIndex: (int)currentActionIndex {
    
    if (FLUENT_CHANGE == _mMode) {
        //添加操作
        NSBlockOperation * blockOperation = [[NSBlockOperation alloc] init];
        //为了能够Cancel掉正在进行的线程
        __weak NSBlockOperation * weakOperation = blockOperation;
        [weakOperation addExecutionBlock:^(){
            
            //隐藏倒计时按钮
            dispatch_async(dispatch_get_main_queue(), ^{
                [_closedIndicator removeFromSuperview];
                [_countDownTimer setHidden:YES];
            });
            //这里只会阻塞当前线程，不会阻塞UI线程
            while ([_audioPlayer isPlaying]) {
                 [NSThread sleepForTimeInterval:0.1];
            }
            //如果单个动作通过，播放很好
            if (lastActionResult == 1000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mStepHintTextLabel setText:@"很好"];
                });
                if ([weakOperation isCancelled]) {
                    return;
                }
                //不能放到主线程，会导致下面的while循环失效
                [self playBackgroundSoundEffect:@"oliveapp_step_hint_nextaction"];
            }
            while ([_audioPlayer isPlaying]) {
                [NSThread sleepForTimeInterval:0.1];   
            }
            
            [self changeToNextAction:newActionType];
            
        }];
        [_mAudioHandlerQueue addOperation:weakOperation];
    } else {
        
        [self playBackgroundSoundEffect:@"oliveapp_step_hint_nextaction"];
        [self changeToNextAction:newActionType];
    }
}

/**
 *
 *  这个函数能使活体检测进入下一个动作，请在上面onActionChanged触发后再调用
 *  @param newActionType 新的动作代号，用于下一个动作的动画显示
 */
- (void) changeToNextAction:(int) newActionType {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        assert([NSThread isMainThread] == 1);
        // 重置倒计时
        [self startAnimation:_countDownTimer];
        
        // 更新动作提示，从TextConstants.plist文件获取提示文字
        NSString *hintText = [_mActionHintTextDict objectForKey: [NSString stringWithFormat:@"hinttext_action_%d", newActionType]];
        [_mStepHintTextLabel setText: hintText];
        
        // 从AnimationConstants.plist文件获取动画图片
        NSString *animationFile = [_mAnimationDict objectForKey:[NSString stringWithFormat:@"mAnimation_%d", newActionType]];
        NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:animationFile ofType:@"gif"]];
        
        if (localData) {
            //设置gif动画
            _dataView = [[GifView alloc] initWithFrame:_stepHintAnimation.frame data:localData];
            [_stepHintAnimation setHidden:YES];
            [_hintBackgoundImageView addSubview:_dataView];
            
            CGFloat radius = (CGRectGetHeight(_stepHintAnimation.frame))/2;
            _dataView.layer.cornerRadius = radius;
            _dataView.clipsToBounds = YES;
            
            //播放当前新动作的音频
            // 从AudioConstants.plist文件获取音频
            NSString *audioFile = [_mAudioDict objectForKey:[NSString stringWithFormat:@"audio_action_%d", newActionType]];
            [self playBackgroundSoundEffect:audioFile];
        }
        NSError * error;
        [_mVerificationController nextAction:&error];
        VVLog(@"nextAction,%@",[error localizedDescription]);
    });
}
/**
 *  通知每帧处理完毕后活体检测session的情况
 *
 *  @return
 */
- (void) onFrameDetected: (int)currentActionType
         withActionState: (int)actionState
        withSessionState: (int)sessionState
        withRemainingTimeoutMilliSecond: (int)remainingTimeoutMilliSecond {
    assert([NSThread isMainThread] == 1);

    // 更新倒计时
    VVLog(@"更新倒计时 %@ 秒",_countDownTimerLabel.text);
    [_countDownTimerLabel setText: [NSString stringWithFormat:@"%d", (int) ((remainingTimeoutMilliSecond + 500) / 1000)]];
}

////////////// UI Event /////////////

/**
 *  点击取消按钮，退出界面
 *
 *  @param sender <#sender description#>
 */
- (IBAction)onCancelClicked:(id)sender {
    // 失败后不再监听APP活跃事件，否则会造成ViewController被两次dismiss，现象是UIAlert无法消除
    [self removeNotification];

    [_mLivenessResultDelegate onLivenessCancel];
}



/**
 *  倒计时的方法
 *
 *  @param uiView 放置倒计时的View
 */
- (void) circleIndicators:(UIView*) uiView;
{
    //设置倒计时风格
    RMDownloadIndicator *closedIndicator = [[RMDownloadIndicator alloc] initWithFrame:uiView.frame type:kRMClosedIndicator];
    [closedIndicator setBackgroundColor:[UIColor clearColor]];
    [closedIndicator setFillColor:[UIColor clearColor]];
    [closedIndicator setStrokeColor:[UIColor whiteColor]];
    closedIndicator.radiusPercent = 0.25;
    [_hintBackgoundImageView addSubview:closedIndicator];
    [closedIndicator loadIndicator];
    _closedIndicator = closedIndicator;
}

/**
 *  重置倒计时
 *
 *  @param uiView 放置倒计时的View
 */
- (void) startAnimation:(UIView*) uiView
{
    [self circleIndicators:uiView];
    [_closedIndicator setIndicatorAnimationDuration:10];
    [_closedIndicator updateWithTotalBytes:10 downloadedBytes:10];
    [_hintBackgoundImageView bringSubviewToFront:_countDownTimer];
    [_countDownTimer setHidden:NO];
}


/**
 *  播放音频
 *
 *  @param resource 音频名字
 */
- (void) playBackgroundSoundEffect: (NSString*) resource {
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: resource ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    @synchronized (_audioPlayer) {
        if ([_audioPlayer isPlaying]) {
            [_audioPlayer stop];
        }
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error:nil];
        [_audioPlayer play];
    }
}


#endif
@end






