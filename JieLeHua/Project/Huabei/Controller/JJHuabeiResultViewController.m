//
//  JJHuabeiResultViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/3.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJHuabeiResultViewController.h"
#import "JJHuabeiProgressView.h"
#import "VVLoanAplicationProcessViewController.h"
#import "JJCommerceModel.h"
#import "JJCrawlstatusModel.h"
#import "JJBaicModel.h"
#import "JJHuabeiBackgroundManager.h"

static float progress = 0.00;

@interface JJHuabeiResultViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, strong) NSTimer *stopRequestTimer;

//成功获得蚂蚁花呗额度
@property (nonatomic, strong) UILabel *topTipLabel;
@property (nonatomic, strong) UILabel *amountLabel;//额度
@property (nonatomic, strong) UIImageView *successImage;
@property (nonatomic, strong) UILabel *successResultLabel;
@property (nonatomic, strong) VVCommonButton *applyBtn;//马上申请

//没有蚂蚁花呗额度
@property (nonatomic, strong) UIImageView *failImage;
@property (nonatomic, strong) UILabel *failResultLabel;
@property (nonatomic, strong) VVCommonButton *failBtn;//马上申请

//计算蚂蚁花呗额度
@property (nonatomic, strong) UIImageView *progressTipImage;
@property (nonatomic, strong) UIProgressView *bgProgress;//进度条
@property (nonatomic, strong) UIProgressView *progress;//进度条
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) JJHuabeiProgressView *huabeiProgressView;

//重新获取花呗额度
@property (nonatomic, strong) UIImageView *regetImage;
@property (nonatomic, strong) UILabel *regetTipLabel;
@property (nonatomic, strong) VVCommonButton *regetBtn;
@property (nonatomic, strong) VVCommonButton *nextTimeBtn;




@property (nonatomic, strong) JJBaicModel *baicModel;
@end

@implementation JJHuabeiResultViewController
//如果是代码 xib 创建ViewController 则JCRouter会调用此方法
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        VVLog(@"%@", params);
        self.token = [params safeObjectForKey:@"token"];
        self.result = [params safeObjectForKey:@"result"];
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
    [self.progressTimer invalidate];
    [self.stopRequestTimer invalidate];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    progress = 0.00;
    [self setNavigationBarTitle:@"蚂蚁花呗额度"];
    [self addBackButton];
    if (kScreenHeight-64 > 610) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44)];
    }else{
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 610)];
    }
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#75cbfd"];
    [self.scrollView addSubview:self.bgView];
    
    UIImageView *topImage = [[UIImageView alloc] init];
    topImage.image = [UIImage imageNamed:@"img_Yun_top"];
    [self.bgView addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(0);
        make.right.mas_equalTo(self.bgView.mas_right).offset(0);
        make.top.mas_equalTo(self.bgView.mas_top).offset(64);
        make.height.mas_equalTo(163);
    }];
    
    UIImageView *bottomImage = [[UIImageView alloc] init];
    bottomImage.image = [UIImage imageNamed:@"img_Yun_bottom"];
    [self.bgView addSubview:bottomImage];
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(0);
        make.right.mas_equalTo(self.bgView.mas_right).offset(0);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(-143.5f);
        make.height.mas_equalTo(143.5f);
    }];
    if ([self.result isEqualToString:@"1"]) {
        //有结果,更新token
        [self updateHuabeiToken];
    }else{
        [self beginApply];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimerAction
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(getCrawlstatus) userInfo:nil repeats:YES];
    [self.timer fire];
    
    self.stopRequestTimer = [NSTimer scheduledTimerWithTimeInterval:8*60 target:self selector:@selector(stopRequest) userInfo:nil repeats:NO];
}

- (void)startProgress
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [self.progressTimer fire];
}

- (void)backAction:(id)sender
{
    [[JCRouter shareRouter] popToRootViewControllerAnimated:YES];
}

- (void)stopRequest
{
    [self setupRegetAmountView];
    [self.timer invalidate];
    [self.progressTimer invalidate];
    [self.stopRequestTimer invalidate];
}

#pragma mark - 初始化不同页面
/**
 * 隐藏进度条
 */
- (void)hideProgressView
{
    [self.progressTipImage.layer removeAnimationForKey:@"catAnim"];
    self.huabeiProgressView.hidden = self.progressTipImage.hidden = self.bgProgress.hidden = self.progress.hidden = self.progressLabel.hidden = YES;
}

/**
 * 花呗进度条
 */
- (void)setupProgressView
{
    if (self.progressTipImage == nil) {
        self.progressTipImage = [[UIImageView alloc] init];
    }
    self.progressTipImage.image = [UIImage imageNamed:@"img_MaoDengDai"];
    [self.bgView addSubview:self.progressTipImage];
    [self.progressTipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(81);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.bgView.mas_top).offset(84.5);
        make.height.mas_equalTo(95);
    }];
    
    if (self.bgProgress == nil) {
        self.bgProgress = [[UIProgressView alloc] init];
    }
    self.bgProgress.trackTintColor = [UIColor whiteColor];
    self.bgProgress.progress = 0;
    self.bgProgress.layer.cornerRadius = 14.0;
    self.bgProgress.layer.masksToBounds = YES;
    [self.bgView addSubview:self.bgProgress];
    [self.bgProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(16);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-16);
        make.top.mas_equalTo(self.progressTipImage.mas_bottom).offset(108.5f);
        make.height.mas_equalTo(28.f);
    }];
    
    if (self.progress == nil) {
        self.progress = [[UIProgressView alloc] init];
    }
    self.progress.trackTintColor = [UIColor whiteColor];
    self.progress.progressImage = [[UIImage imageNamed:@"img_HuaBei_JinDuTiao"] stretchableImageWithLeftCapWidth:17 topCapHeight:0];
    self.progress.layer.cornerRadius = 10.0;
    self.progress.layer.masksToBounds = YES;
    [self.bgView addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(20);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
        make.top.mas_equalTo(self.progressTipImage.mas_bottom).offset(108.5f+4.f);
        make.height.mas_equalTo(20.f);
    }];
    
    if (self.progressLabel == nil) {
        self.progressLabel = [[UILabel alloc] init];
    }
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = [UIFont systemFontOfSize:15];
    self.progressLabel.numberOfLines = 0;
    NSString *contentString = @"正在计算您的蚂蚁花呗额度\n请勿离开本页面，以免长时间等待！";
    self.progressLabel.text = contentString;
    [self.bgView addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(42);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-42);
        make.top.mas_equalTo(self.progress.mas_bottom).offset(86.5);
        CGSize size = [self.progressLabel sizeThatFits:CGSizeMake(kScreenWidth-84, MAXFLOAT)];
        make.height.mas_equalTo(size.height);
    }];
    
    [self.scrollView setContentSize: CGSizeMake(kScreenWidth, self.bgView.frame.size.height)];
    
    //小猫上下跳动动画
    //        self.progressTipImage
    CABasicAnimation *postionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    postionAnimation.fromValue =@84.5;
    postionAnimation.toValue = @105;
    postionAnimation.repeatCount = MAXFLOAT;
    postionAnimation.duration = 1.5;
    postionAnimation.removedOnCompletion = NO;
    postionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.progressTipImage.layer addAnimation:postionAnimation forKey:@"catAnim"];
    
    self.huabeiProgressView.hidden = self.progressTipImage.hidden = self.bgProgress.hidden = self.progress.hidden = self.progressLabel.hidden = NO;
}

/**
 * 成功获取花呗额度
 */
- (void)setupSuccessAmount
{
    //隐藏进度条视图,取消8分钟定时器
    [self.stopRequestTimer invalidate];
    [self hideProgressView];
    [self hideRegetAmountView];
    if (self.topTipLabel == nil) {
        self.topTipLabel = [[UILabel alloc] init];
    }
    self.topTipLabel.text = @"您的当前\n蚂蚁花呗额度为";
//    self.topTipLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    self.topTipLabel.numberOfLines = 0;
    self.topTipLabel.textAlignment = NSTextAlignmentCenter;
    self.topTipLabel.textColor = [UIColor whiteColor];
    [self.bgView addSubview:self.topTipLabel];
    [self.topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.bgView.mas_top).offset(23);
        make.height.mas_equalTo(56);
    }];
    
    if (self.amountLabel == nil) {
        self.amountLabel = [[UILabel alloc] init];
    }
    NSString *amountString = [NSString stringWithFormat:@"%.f元",self.baicModel.Result.FlowersBalance];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:amountString];
    //设置字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.f] range:NSMakeRange(0, amountString.length-1)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.f] range:NSMakeRange(amountString.length-1,1)];
    //添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0d88ff"] range:NSMakeRange(0, amountString.length)];
    self.amountLabel.attributedText = attrStr;
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    self.amountLabel.layer.borderColor = [UIColor colorWithHexString:@"0d88ff"].CGColor;
    self.amountLabel.layer.borderWidth = 2.f;
    self.amountLabel.layer.cornerRadius = 20;
    self.amountLabel.backgroundColor = [UIColor whiteColor];
    self.amountLabel.layer.masksToBounds = YES;
    [self.bgView addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(184);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.topTipLabel.mas_bottom).offset(10.5);
        make.height.mas_equalTo(40);
    }];
    
    if (self.successImage == nil) {
        self.successImage = [[UIImageView alloc] init];
    }
    self.successImage.image = [UIImage imageNamed:@"img_HuaBei_ManZu"];
    [self.bgView addSubview:self.successImage];
    [self.successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(349);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(0);
        make.height.mas_equalTo(303);
    }];
    
    if (self.successResultLabel == nil) {
        self.successResultLabel = [[UILabel alloc] init];
    }
    self.successResultLabel.textAlignment = NSTextAlignmentCenter;
    self.successResultLabel.font = [UIFont systemFontOfSize:15];
    self.successResultLabel.text = @"恭喜，您的蚂蚁花呗额度已满足申请要求";
    [self.bgView addSubview:self.successResultLabel];
    [self.successResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(0);
        make.right.mas_equalTo(self.bgView.mas_right).offset(0);
        make.top.mas_equalTo(self.successImage.mas_bottom).offset(-21);
        make.height.mas_equalTo(21);
    }];
    
    if (self.applyBtn == nil) {
        self.applyBtn = [VVCommonButton solidButtonWithTitle:@"立即申请"];
    }
    [self.applyBtn setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.cornerRadius = 22.5;
    [self.bgView addSubview:self.applyBtn];
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(54.5);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-54.5);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.successResultLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(45);
    }];
    [self.applyBtn removeTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView setContentSize: CGSizeMake(kScreenWidth, self.bgView.frame.size.height)];
}

/**
 * 没有花呗额度
 */
- (void)setupNoAmountView
{
    //隐藏进度条视图,取消8分钟定时器
    [self.stopRequestTimer invalidate];
    [self hideProgressView];
    if (self.failImage == nil) {
        self.failImage = [[UIImageView alloc] init];
    }
    self.failImage.image = [UIImage imageNamed:@"img_HuaBei_WuZiGe"];
    [self.bgView addSubview:self.failImage];
    [self.failImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(108);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.bgView.mas_top).offset(172.f);
        make.height.mas_equalTo(110);
    }];
    
    if (self.failResultLabel == nil) {
        self.failResultLabel = [[UILabel alloc] init];
    }
    self.failResultLabel.textAlignment = NSTextAlignmentCenter;
    self.failResultLabel.font = [UIFont systemFontOfSize:15];
    self.failResultLabel.numberOfLines = 0;
    NSString *contentString = @"很遗憾，您暂时没有蚂蚁花呗额度不能申请\n赶快去支付宝获取蚂蚁花呗额度吧！";
    self.failResultLabel.text = contentString;
    [self.bgView addSubview:self.failResultLabel];
    [self.failResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(42);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-42);
        make.top.mas_equalTo(self.failImage.mas_bottom).offset(86.5);
        CGSize size = [self.failResultLabel sizeThatFits:CGSizeMake(kScreenWidth-84, MAXFLOAT)];
        make.height.mas_equalTo(size.height);
    }];
    
    if (self.applyBtn == nil) {
        self.applyBtn = [VVCommonButton solidButtonWithTitle:@"确定"];
    }
    [self.applyBtn setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.cornerRadius = 22.5;
    [self.bgView addSubview:self.applyBtn];
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(54.5);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-54.5);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.failResultLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(45);
    }];
    [self.applyBtn removeTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.applyBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView setContentSize: CGSizeMake(kScreenWidth, self.bgView.frame.size.height)];
}

/**
 * 隐藏重新获取
 */
- (void)hideRegetAmountView
{
    self.regetImage.hidden = self.regetBtn.hidden = self.regetTipLabel.hidden = self.nextTimeBtn.hidden = YES;
}


/**
 * 重新获取花呗
 */
- (void)setupRegetAmountView
{
    //隐藏进度条视图,取消8分钟定时器
    [self.progressTimer invalidate];
    [self.timer invalidate];
    [self.stopRequestTimer invalidate];
    [self hideProgressView];
    if (self.regetImage == nil) {
        self.regetImage = [[UIImageView alloc] init];
    }
    self.regetImage.image = [UIImage imageNamed:@"img_HuaBei_HuoQuShiBai"];
    [self.bgView addSubview:self.regetImage];
    [self.regetImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(196.f);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(36.f);//图片左右不对称
        make.top.mas_equalTo(self.bgView.mas_top).offset(167.5);
        make.height.mas_equalTo(129.f);
    }];
    
    if (self.regetTipLabel == nil) {
        self.regetTipLabel = [[UILabel alloc] init];
    }
    self.regetTipLabel.textAlignment = NSTextAlignmentCenter;
    self.regetTipLabel.font = [UIFont systemFontOfSize:15];
    self.regetTipLabel.numberOfLines = 0;
    NSString *contentString = @"好可惜，花花没能找到您的蚂蚁花呗额度，\n让花花再找一次吧";
    self.regetTipLabel.text = contentString;
    [self.bgView addSubview:self.regetTipLabel];
    [self.regetTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(42);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-42);
        make.top.mas_equalTo(self.regetImage.mas_bottom).offset(60.f);
        CGSize size = [self.failResultLabel sizeThatFits:CGSizeMake(kScreenWidth-84, MAXFLOAT)];
        make.height.mas_equalTo(size.height);
    }];
    
    if (self.regetBtn == nil) {
        self.regetBtn = [VVCommonButton solidButtonWithTitle:@"重新获取"];
    }
    //    self.regetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.regetBtn.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    //    [self.regetBtn setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    self.regetBtn.layer.masksToBounds = YES;
    self.regetBtn.layer.cornerRadius = 22.5;
    [self.bgView addSubview:self.regetBtn];
    [self.regetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(54.5);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-54.5);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.regetTipLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(45);
    }];
    [self.regetBtn addTarget:self action:@selector(reGet) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    self.nextTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.nextTimeBtn == nil) {
        self.nextTimeBtn = [VVCommonButton hollowButtonWithTitle:@"不了，下次再说"];
    }
    self.nextTimeBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    //    [self.nextTimeBtn setTitle:@"不了，下次再说" forState:UIControlStateNormal];
    [self.nextTimeBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self.nextTimeBtn setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    self.nextTimeBtn.layer.masksToBounds = YES;
    self.nextTimeBtn.layer.cornerRadius = 22.5;
    self.nextTimeBtn.layer.borderColor = [UIColor globalThemeColor].CGColor;
    self.nextTimeBtn.layer.borderWidth = 2.f;
    
    [self.bgView addSubview:self.nextTimeBtn];
    [self.nextTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(54.5);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-54.5);
        make.centerX.mas_equalTo(self.bgView.mas_centerX).offset(0);
        make.top.mas_equalTo(self.regetBtn.mas_bottom).offset(12);
        make.height.mas_equalTo(45);
    }];
    [self.nextTimeBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.scrollView setContentSize: CGSizeMake(kScreenWidth, self.bgView.frame.size.height)];
    self.regetImage.hidden = self.regetBtn.hidden = self.regetTipLabel.hidden = self.nextTimeBtn.hidden = NO;
}


#pragma mark - 按钮事件
- (void)applyAction
{
    VVLog(@"马上申请");
    UserModel *userModel = [UserModel currentUser];
    VVLog(@"用户id：%@",userModel.customerId);
    [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:userModel.customerId success:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            VVOrderInfoModel *orderInfo = nil;
            NSDictionary *resultData = [result safeObjectForKey:@"data"];
            
            orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.orderInfo = orderInfo;
            VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.creditBaseInfoModel = baseInfoModel;
            
            JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.authenticationModel = authenticationModel;
            VV_SHDAT.timestamp =  result[@"timestamp"];

            
            if ([orderInfo.applyStatusCode integerValue] == applyTypeBase|| [orderInfo.applyStatusCode integerValue] ==applyTypeCredit || [orderInfo.applyStatusCode integerValue] ==applyTypeMobileVerification) {
                [[JCRouter shareRouter] pushURL:@"fillInformation"];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)goBack
{
    VVLog(@"返回首页");
    [[JCRouter shareRouter] popToRootViewControllerAnimated:YES];
}

- (void)reGet
{
    VVLog(@"重新获取,重新计时");
    progress = 0.00;
    [self.huabeiProgressView setProgress:progress animated:YES];
    [self startTimerAction];
    [self startProgress];
    //隐藏重新获取页面+显示进度条
    [self hideRegetAmountView];
    [self setupProgressView];
}

#pragma mark - 网络请求
//采集状态查询，每40s查询一次，直到成功后查询基本信息，超过8分钟取消请求
- (void)getCrawlstatus
{
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] getCrawlstatusWithToken:self.token success:^(id result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJCrawlstatusModel *statusModel = [JJCrawlstatusModel mj_objectWithKeyValues:result];
        if (statusModel.CrawlStatus == 2002) {
            //数据采集成功后获取基本信息
            [strongSelf getBaic];
        }
        else if(statusModel.CrawlStatus == 2000 || statusModel.CrawlStatus == 1007 || statusModel.CrawlStatus == 1008 || statusModel.CrawlStatus == 2001){
            //登录成功 || 正在登录 || 等待发送短信验证码 || 数据正在采集
        }
        else{
            [strongSelf setupRegetAmountView];
        }
        //加载重新获取页面
    } failure:^(NSError *error) {
        //加载重新获取页面
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf setupRegetAmountView];
    }];
}

//查询基本信息
- (void)getBaic
{
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] getBaicWithToken:self.token success:^(id result) {
        VVLog(@"%@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJBaicModel *baicModel = [JJBaicModel mj_objectWithKeyValues:result];
        if (baicModel.StatusCode == 0) {
            strongSelf.baicModel = baicModel;
            [strongSelf.timer invalidate];
            [strongSelf.progressTimer invalidate];
            if (baicModel.Result.FlowersBalance > 0) {
                //有花呗额度
                [strongSelf antsChantFlowersMoney];
            }else{
                //没有花呗额度的情况
                [strongSelf setupNoAmountView];
            }
        }else{
            [strongSelf setupRegetAmountView];
        }
        
    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf setupRegetAmountView];
        
    }];
}

#pragma mark - 更新进度,虚假进度
- (void)updateProgress
{
    if (self.progress == nil) {
        [self setupProgressView];
    }
    if (progress>0.98) {
        [self.progressTimer invalidate];
    }else{
        if (_huabeiProgressView == nil) {
            _huabeiProgressView = [[JJHuabeiProgressView alloc] initWithFrame:self.bgProgress.frame];
            _huabeiProgressView.backgroundColor = [UIColor clearColor];
            _huabeiProgressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
            [_huabeiProgressView showPopUpViewAnimated:YES];
            [_huabeiProgressView setPopUpViewColor:[UIColor orangeColor]];
            [self.scrollView addSubview:_huabeiProgressView];
        }
        _huabeiProgressView.frame = self.bgProgress.frame;
        
        progress = progress+0.01;
        self.progress.progress = progress;
        [self.huabeiProgressView setProgress:progress animated:YES];
    }
}


#pragma mark - 与本地服务器交互信息
- (void)beginApply
{
    UserModel *userModel = [UserModel currentUser];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] beginApplyWithToken:self.token customerId:userModel.customerId success:^(id result) {
        VVLog(@"%@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf startTimerAction];
        [strongSelf startProgress];
    } failure:^(NSError *error) {
        
    }];
}

//更新花呗token
- (void)updateHuabeiToken
{
    UserModel *userModel = [UserModel currentUser];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] updateTokenWithCustomerId:userModel.customerId token:self.token success:^(id result) {
        VVLog(@"%@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf startTimerAction];
        [strongSelf startProgress];
    } failure:^(NSError *error) {
        
    }];
}

//更新额度信息
- (void)antsChantFlowersMoney
{
    UserModel *userModel = [UserModel currentUser];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] applyAntsChantFlowersMoneyWithParam:@{@"antsChantFlowersMoney":[NSString stringWithFormat:@"%.f",self.baicModel.Result.FlowersBalance],@"commercelimitIn3Use":@"",@"commercelimitIsoverdue":@"",@"customerId":userModel.customerId} success:^(id result) {
        VVLog(@"%@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            [strongSelf.huabeiProgressView setProgress:1 animated:YES];
            strongSelf.progress.progress = 1;
            [strongSelf setupSuccessAmount];
            [[JJHuabeiBackgroundManager huabeiBackgroundManager] getSummaryWithToken:strongSelf.token];
        }
    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[JJHuabeiBackgroundManager huabeiBackgroundManager] getSummaryWithToken:strongSelf.token];
    }];
}

@end
