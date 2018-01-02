//
//  MemberOrderViewController.m
//  JieLeHua
//
//  Created by admin on 2017/12/21.
//Copyright © 2017年 Vcredit. All rights reserved.
//

#import "MemberOrderViewController.h"
#import "JJWechatPayMemberRequest.h"
#import "PayToolsManager.h"
#import "WXApi.h"
#import "JJWKWebViewViewController.h"
#import "JJUnionPayWebViewController.h"
#import "JJMemberRequest.h"
#import "JJIsMemeberShipRequest.h"
#pragma mark Constants


#pragma mark - Class Extension

@interface MemberOrderViewController ()

@property (nonatomic, strong) NSMutableArray *groupButtons;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIButton *repayBtn;

@property (nonatomic, strong) UILabel *payMoneyLab;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, assign) NSInteger payTag;

@property(nonatomic,assign) BOOL isDrawWebPage;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation MemberOrderViewController


#pragma mark - Properties

+ (id)allocWithRouterParams:(NSDictionary *)params {
    MemberOrderViewController *instance = [[MemberOrderViewController alloc]init];
    instance.isDrawWebPage = [[params objectForKey:@"isDrawWebPage"] boolValue];
    return instance;
}

- (UILabel *)payMoneyLab {
    if (!_payMoneyLab) {
        _payMoneyLab = [[UILabel alloc] init];
        _payMoneyLab.textAlignment = NSTextAlignmentRight;
        _payMoneyLab.textColor = kColor_TipColor;
//        _payMoneyLab.text = @"299元";
        _payMoneyLab.font = kFont_NormalTitle;
    }
    return _payMoneyLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.textColor = kColor_TipColor;
//        _timeLab.text = @"2017-12-20至2018-12-20";
        _timeLab.font = kFont_NormalTitle;
    }
    return _timeLab;
}

//- (UIButton *)repayBtn {
//    if (!_repayBtn) {
//        _repayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _repayBtn.layer.cornerRadius = 22.5f;
//        _repayBtn.clipsToBounds = YES;
//        [_repayBtn addTarget:self action:@selector(repayBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _repayBtn;
//}

- (NSMutableArray *)groupButtons {
    if (!_groupButtons) {
        _groupButtons = [[NSMutableArray alloc] init];
    }
    return _groupButtons;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self setNavigationBarTitle:@"会员费"];
    [self addBackButton];
    self.view.backgroundColor = RGB(241, 244, 246);
    [self getMemberFeeValidityPeriod];

    //--默认微信支付
    self.payTag = 1616;
    [self initAndLayoutUI];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.gradientLayer.frame = self.repayBtn.bounds;
//    [self.repayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.repayBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [self.repayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    

    
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods
-(void)getIsMemeberShip:(void (^)( BOOL succ))success{
    
    JJIsMemeberShipRequest *request = [[JJIsMemeberShipRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJIsMemeberSHipModel *model = [(JJIsMemeberShipRequest *)request response];
        JJIsMemeberSHipDataModel *data = model.data;
        if(model.success){
            if ([data.isMemberShip isEqualToString:@"1"]) {
                [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"您已经是优享会员，无需再次支付" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != kCancelButtonTag) {
                        [alertView hideAlertViewAnimated:YES];
                    }
                }];
                if (success) {
                    success(YES);
                }
                
            }else{
                if (success) {
                    success(NO);
                }
            }
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:[weakSelf strFromErrCode:error]];
    }];
}

-(void)getMemberFeeValidityPeriod{
    
    JJMemberRequest *request = [[JJMemberRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJMemberModel *model = [(JJMemberRequest *)request response];
        
        JJMemberDataModel *data = model.data;
        
        if(model.success){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showInforMation:data];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:[weakSelf strFromErrCode:error]];
    }];
}

-(void)showInforMation:(JJMemberDataModel *)model{
    self.payMoneyLab.text = [NSString stringWithFormat:@"%d元",model.memberFee];
    self.timeLab.text = [NSString stringWithFormat:@"%@至%@",model.paymentTime,model.validityPeriod];
    if(model.isPayEnable){
        self.repayBtn.userInteractionEnabled  = YES;
        self.repayBtn.enabled = YES;
        
    }else{
        [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"正在确认上一笔订单支付结果，请稍后再试" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex != kCancelButtonTag) {
                [alertView hideAlertViewAnimated:YES];
            }
        }];
        self.repayBtn.userInteractionEnabled  = NO;
        self.repayBtn.enabled = NO;
    }
}

- (void)initAndLayoutUI
{
    UIView *payInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kScreenWidth, 91)];
    payInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payInfoView];
    
    NSArray *payInfoArry = @[@"会员费",@"有效期"];
    NSArray *infoLabs = @[self.payMoneyLab, self.timeLab];
    for(int i = 0; i < payInfoArry.count; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 46*i, 100, 45)];
        lab.textColor = kColor_TitleColor;
        lab.font = kFont_NormalTitle;
        lab.text = payInfoArry[i];
        [payInfoView addSubview:lab];
        
        UILabel *infoLab = infoLabs[i];
        infoLab.frame = CGRectMake(kScreenWidth-295, 46*i, 280, 45);
        [payInfoView addSubview:infoLab];
    }
    
    /****************支付方式****************/
    UIView *payWayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(payInfoView.frame)+10, kScreenWidth, 91)]; 
    payWayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payWayView];
    
    NSArray *imageArry = @[@"icon_weixin", @"icon_yinlian"];
    NSArray *payTitleArry = @[@"微信支付", @"银联支付"];
    for (int j = 0; j < imageArry.count; j++)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(imageArry[j])];
        img.frame = CGRectMake(10, 13+45*j, 33, 20);
        img.contentMode = UIViewContentModeScaleAspectFit;
        [payWayView addSubview:img];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(53, 46*j, 100, 45)];
        lab.textColor = kColor_TitleColor;
        lab.font = kFont_NormalTitle;
        lab.text = payTitleArry[j];
        [payWayView addSubview:lab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth-45, 46*j, 45, 45);
        [btn setImage:kGetImage(@"btn_round_grey") forState:UIControlStateNormal];
        [btn setImage:kGetImage(@"btn_round_check") forState:UIControlStateSelected];
        btn.tag = 1616+j;
        [btn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
        [payWayView addSubview:btn];
        if (j == 0)
        {
            btn.selected = YES;
        }
        [self.groupButtons addObject:btn];

    }
    
    /****************线****************/
    NSArray *views = @[payInfoView, payWayView];
    for (int k = 0; k < views.count; k++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 46, kScreenWidth, 0.5f)];
        line.backgroundColor = RGB(230, 230, 230);
        UIView *item = views[k];
        [item addSubview:line];
    }
    VVCommonButton *repayBtn = [VVCommonButton solidBlueButtonWithTitle:@"立即支付"];
    [repayBtn addTarget:self  action:@selector(repayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.repayBtn = repayBtn;
    [self.view addSubview:self.repayBtn];
    [self.repayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(80);
        make.right.equalTo(self.view.mas_right).offset(-80);
        make.bottom.equalTo(self.view.mas_bottom).offset(-21);
        make.height.equalTo(@45);
    }];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.locations = @[@0,@1.0f];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5f);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5f);
    [self.repayBtn.layer addSublayer:self.gradientLayer];
    self.gradientLayer.colors = @[(__bridge id)RGB(255, 199, 150).CGColor,
                                  (__bridge id)RGB(255, 107, 149).CGColor];
}

- (void)selectPayWay:(UIButton *)sender
{
    //--tag:1616微信支付，1617银联支付
    if (sender.selected) return;
    
    for (UIButton *btn in self.groupButtons)
    {
        btn.selected = NO;
    }
    sender.selected = !sender.selected;
    
    self.payTag = sender.tag;
}


-(void)repayBtnClick{
    
    [self getIsMemeberShip:^(BOOL succ) {
        if(!succ){
            if(self.payTag == 1616){
                // 先判断是否安装微信
                if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
                    [VLToast showWithText:@"您未安装最新版本微信，不支持微信支付，请安装或升级微信版本"];
                    return;
                }
                [self wechatPay];
            }else if(self.payTag == 1617){
                //银联支付
                [self testPush];
            }
        }
    }];
   
}

-(void)wechatPay{
    VVLog(@"wechatPay=============");
    JJWechatPayMemberRequest *request = [[JJWechatPayMemberRequest alloc] init] ;
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        JJWechatPayModel *model = [(JJWechatPayMemberRequest *)request response];
        if (model.success) {
            JJWechatPayDataModel * data = model.data;
            [[PayToolsManager defaultManager] startWeChatPayWithAppId:data.appId timeStamp:data.timeStamp nonceStr:data.nonceStr packageValue:data.packageValue paySign:data.paySign partnerid:data.partnerid prepayid:data.prepayid paySuccess:^{
                VVLog(@"========微信支付成功========");
                [VLToast showWithText:@"微信支付成功"];
                if (self.isDrawWebPage) {
                    NSDictionary  *dict = @{
                                            @"isMemberShip":@"1"
                                            };
                    NSNotification *notification = [NSNotification notificationWithName:@"DrawChoosePayMethod" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [[JCRouter shareRouter] popViewControllerWithIndex:3 animated:YES];
                }else{
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf customPopToRootViewController];
                }
                
            } payFaild:^(NSString *desc) {
                VVLog(@"=======微信支付失败===========");
                [VLToast showWithText:desc];
                
            }];
        }else{
            [VVAlertUtils showAlertViewWithTitle:@"" message:nil customView:[self showAlertViewWith:model.message] cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != kCancelButtonTag) {
                    [alertView hideAlertViewAnimated:YES];
                }
            }];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"调用微信失败，请稍后再试"];
    }];
}

-(void)testPush{
    __weak __typeof(self)weakSelf = self;
    NSString *token = [UserModel currentUser].token;
    JJUnionPayWebViewController *webVC = [[JJUnionPayWebViewController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@/unionPay.html?token=%@&type=%@",WEB_BASE_URL,token,@"3"];
    webVC.startPage = url;
    webVC.webTitle = @"银联支付";
    webVC.paySuccess = ^(BOOL isSuccess) {
        if (isSuccess) {
          
            if (self.isDrawWebPage) {
                NSDictionary  *dict = @{
                                        @"isMemberShip":@"1"
                                        };
                
                NSNotification *notification = [NSNotification notificationWithName:@"DrawChoosePayMethod" object:nil userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [[JCRouter shareRouter] popViewControllerWithIndex:3 animated:YES];
            }else{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf customPopToRootViewController];
            }
        }
    };
    [self customPushViewController:webVC withType:nil subType:nil];
}

-(UIView *)showAlertViewWith:(NSString*)message{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 210, 260)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 210,180)];
    lab.text = message;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:15];
    [view addSubview:lab];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_repayment"]];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab.mas_bottom).offset(0);
        make.centerX.mas_equalTo(lab.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    return view;
}


@end
