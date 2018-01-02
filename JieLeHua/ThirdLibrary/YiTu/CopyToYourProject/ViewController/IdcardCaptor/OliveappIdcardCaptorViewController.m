//
//  CameraViewController.m
//  DemoFanPai
//
//  Created by Xiaoyang Lin on 16/4/22.
//  Copyright © 2016年 com.yitutech. All rights reserved.
//

#import "OliveappIdcardCaptorViewController.h"
#import "OliveappCameraPreviewController.h"
#import "OliveappImageForVerifyConf.h"
#import "OliveappStructOcrFrameResult.h"
#import "OliveappAsyncIdcardCaptorDelegate.h"
#import "OliveappIdcardVerificationController.h"

@interface OliveappIdcardCaptorViewController () <OliveappAsyncIdcardCaptorDelegate>{
    UIImageView *_scanLineView;
    CGFloat _linePoint;
}
#if !TARGET_IPHONE_SIMULATOR

@property (strong, nonatomic) OliveappCameraPreviewController * mCameraController;
@property (strong, nonatomic) OliveappIdcardVerificationController * mIdcardVerificationController;
@property (strong, nonatomic) id<OliveappIdcardCaptorResultDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (weak, nonatomic) IBOutlet UIImageView *idCardLocation;
@property (strong, nonatomic) IBOutlet UIView *superFullView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) OliveappImageForVerifyConf * mOliveappImageForVerifyConf;
@property (strong, nonatomic) NSDictionary * statusDict;
@property (strong, nonatomic) NSArray * boundsArray;
@property int boundsIndex;
@end

@implementation OliveappIdcardCaptorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     VVLog(@"[OliveappIdcardCaptorViewController] viewDidLoad");
    // 调用摄像头
    if (_mCameraController == nil) {
        _mCameraController = [[OliveappCameraPreviewController alloc] init];
    }
    
    //初始化图片配置
    _mOliveappImageForVerifyConf = [[OliveappImageForVerifyConf alloc] init];
    
    //提示文字旋转90度
    _resultLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    //提示文字字典
    NSString * path = [[NSBundle mainBundle] pathForResource:@"OliveappOcrStatus" ofType:@"plist"];
    _statusDict = [NSDictionary dictionaryWithContentsOfFile:path];
    _scanLineView = [[UIImageView alloc]initWithFrame:CGRectMake( (kScreenWidth- _fullView.width)/2,(kScreenHeight- _idCardLocation.height/2)/2, _fullView.width, 3)];
    _scanLineView.image = VV_GETIMG(@"saomiao");
    [self.view addSubview:_scanLineView];
    [VV_NC addObserver:self selector:@selector(didEnterBackgroundNotification)  name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    VVLog(@"[OliveappIdcardCaptorViewController] viewWillAppear");
    
    //使用后置摄像头
    [_mCameraController startCamera:AVCaptureDevicePositionBack];
    
    //初始化算法模块
    NSError * error;
    _mIdcardVerificationController = [[OliveappIdcardVerificationController alloc] init];
    [_mIdcardVerificationController setDelegate:self
                                      withError:&error];
    
    // 设置委托方法
    [_mCameraController setCameraPreviewDelegate:_mIdcardVerificationController];
    [_mIdcardVerificationController setIdCardPreviewView:self.idCardLocation withFullView:self.fullView withSuperView:self.superFullView];
    
    [self loadScanImageLine];
}

/**
 *  在这里设置预览
 */
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    VVLog(@"[OliveappIdcardCaptorViewController] viewDidLayoutSubviews");
    
    // 设置界面预览，使用全屏
    [_mCameraController setupPreview: _fullView
                    withVideoGravity: AVLayerVideoGravityResizeAspectFill];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     VVLog(@"[OliveappIdcardCaptorViewController] viewWillDisappear");

}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    VVLog(@"[OliveappIdcardCaptorViewController] viewDidDisappear");
    //关闭摄像头
    [_mCameraController stopCamera];
    // 析构算法模块
    [_mIdcardVerificationController unInit];
    _mIdcardVerificationController = nil;
    _delegate = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onDetectionSucc: (NSData *) imgData {
    // 一定要在UI线程
    assert([NSThread isMainThread] == 1);
    _scanLineView.hidden = YES;
    [_scanLineView removeFromSuperview];
    UIImage * idcardImage = [UIImage imageWithData:imgData];
    idcardImage = [UIImage imageWithCGImage:idcardImage.CGImage scale:1 orientation:UIImageOrientationRight];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:idcardImage];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [_fullView addSubview:imageView];
    
    [_delegate onDetectionSucc:imgData];
}

- (void) onDetectionStatus: (int) status {
    // 一定要在UI线程
    assert([NSThread isMainThread] == 1);
    VVLog(@"[OliveappIdcardCaptorViewController] onDetectionStatus: %d",status);
    [self.resultLabel setText:[_statusDict objectForKey:[NSString stringWithFormat:@"ocr_status_%d",status]]];
}

- (IBAction)cancelButton:(UIButton *)sender {
    // 先停止算法模块，然后退出界面
    [_delegate onIdcardCaptorCancel];
}

- (void) setDelegate: (id<OliveappIdcardCaptorResultDelegate>) delegate {
    _delegate = delegate;
}

- (void)didEnterBackgroundNotification{
    [_delegate onIdcardCaptorCancel];

}
- (void)loadScanImageLine{

    [UIView animateWithDuration:2 delay:0.1 options:UIViewAnimationOptionRepeat animations:^{
        _linePoint = (kScreenHeight + _idCardLocation.height/2)/2;
        _scanLineView.top = _linePoint;
    } completion:^(BOOL finished) {
        _linePoint = (kScreenHeight - _idCardLocation.height/2)/2;
        _scanLineView.top = _linePoint;
    }];

}

- (void) dealloc {
    [VV_NC removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    VVLog(@"OliveappIdcardCaptorViewController deallo");
}
#endif
@end
