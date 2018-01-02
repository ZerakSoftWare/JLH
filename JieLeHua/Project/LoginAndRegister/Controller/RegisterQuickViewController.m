//
//  RegisterQuickViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/6/19.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "RegisterQuickViewController.h"
#import "RegisterAgreementViewController.h"
#import "CollectDeviceTokenCommand.h"
#import "UITextField+LimitLength.h"
#import "UIButton+Gradient.h"
#import "JJReviewManager.h"

@interface RegisterQuickViewController ()

@property (nonatomic, strong) UITextField *phoneNumField;

@property (nonatomic, strong) UITextField *codeField;

@property (nonatomic, strong) UITextField *pwdField;

/**
 *  密码是否可见按钮
 */
@property (nonatomic, strong) UIButton *visibleBtn;

/**
 *  我已阅读并同意《用户协议》
 */
@property (nonatomic, strong) UIButton *readBtn;

@property (nonatomic, strong) UIButton *readTypeBtn;

/**
 *  短信验证码
 */
@property (nonatomic, strong) UIButton *receiveSMSCode;


@end

@implementation RegisterQuickViewController


#pragma mark - Properties

- (UIButton *)receiveSMSCode {
    if (!_receiveSMSCode) {
        _receiveSMSCode = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveSMSCode.titleLabel.font = kFont_TipTitle;
        [_receiveSMSCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_receiveSMSCode setBackgroundColor:kColor_Main_Color forState:UIControlStateNormal];
        [_receiveSMSCode gradientButtonWithSize:CGSizeMake(300, 44) colorArray:@[(id)RGB(39, 177, 251),(id)RGB(17, 103, 241)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftToRight];
        
        [_receiveSMSCode addTarget:self action:@selector(receiveSMSCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveSMSCode;
}

- (UITextField *)phoneNumField {
    if (!_phoneNumField) {
        _phoneNumField = [[UITextField alloc] init];
        _phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumField.font = kFont_Title;
        _phoneNumField.textColor = kColor_TitleColor;
        _phoneNumField.placeholder = @"请输入手机号";
    }
    return _phoneNumField;
}

- (UITextField *)codeField {
    if (!_codeField) {
        _codeField = [[UITextField alloc] init];
        _codeField.font = kFont_Title;
        _codeField.textColor = kColor_TitleColor;
        _codeField.placeholder = @"请输入验证码";
    }
    return _codeField;
}

- (UITextField *)pwdField {
    if (!_pwdField) {
        _pwdField = [[UITextField alloc] init];
        _pwdField.secureTextEntry = YES;
        _pwdField.font = kFont_Title;
        _pwdField.textColor = kColor_TitleColor;
        _pwdField.placeholder = @"请输入密码";
    }
    return _pwdField;
}

- (UIButton *)visibleBtn {
    if (!_visibleBtn) {
        _visibleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_visibleBtn setImage:kGetImage(@"btn_password_hidden") forState:UIControlStateNormal];
        [_visibleBtn setImage:kGetImage(@"btn_password_see") forState:UIControlStateSelected];
        [_visibleBtn addTarget:self action:@selector(showPwd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visibleBtn;
}

- (UIButton *)readTypeBtn {
    if (!_readTypeBtn) {
        _readTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _readTypeBtn.selected = YES;
        [_readTypeBtn setImage:kGetImage(@"btn_unread_agree_pre") forState:UIControlStateNormal];
        [_readTypeBtn setImage:kGetImage(@"btn_read_agree_pre") forState:UIControlStateSelected];
        [_readTypeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readTypeBtn;
}

- (UIButton *)readBtn {
    if (!_readBtn) {
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readBtn setTitle:@"我已阅读并同意《用户协议》" forState:UIControlStateNormal];
        [_readBtn setTitleColor:kColor_Main_Color forState:UIControlStateNormal];
        _readBtn.titleLabel.font = kFont_TipTitle;
        [_readBtn addTarget:self action:@selector(readAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readBtn;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc
{
    
}


#pragma mark - Public Methods

#pragma mark - Routable load

- (id)initWithRouterParams:(NSDictionary *)params
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [MobClick event:@"apply_regist"];
    
    [self initAndLayoutUI];
    
    [self limitTextFieldLength];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.hidden = YES;
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
    
    [self.receiveSMSCode cornerRadiusInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

/**
 *  限制UITextField字数限制
 */
- (void)limitTextFieldLength
{
    [self.phoneNumField limitTextLength:11 block:^(NSString *text) {
        self.phoneNumField.text = text;
    }];
    
    [self.pwdField limitTextLength:18 block:^(NSString *text) {
        self.pwdField.text = text;
    }];
}

- (void)initAndLayoutUI
{
    /*********背景*********/
    UIImageView *topImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_login")];
    [self.view addSubview:topImg];
    
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(topImg.mas_width).multipliedBy(614.0/750.0);
    }];
    
    
    
    UIImageView *cardImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_login_card_bg")];
    [self.view addSubview:cardImg];
    [cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ISIPHONE5) {
            make.top.equalTo(self.view).offset(123);
            make.height.equalTo(@340);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
        }else if (ISIPHONE4){
            make.top.equalTo(self.view).offset(93);
            make.height.equalTo(@300);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
        }
        else{
            make.top.equalTo(self.view).offset(193);
            make.height.equalTo(@340);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
        }
    }];
    //icon+title
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_default_portrait")];
    [self.view addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@75);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(cardImg.mas_top).offset(-5);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = RGB(13, 136, 255);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"借乐花-快贷";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(iconImg.mas_bottom).offset(12);
    }];
    
    
    /*********左上角关闭按钮*********/
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.titleLabel.font = kFont_Title;
    [closeBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    //    [closeBtn setImage:kGetImage(@"btn_return_white") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.size.mas_equalTo(CGSizeMake(58, 24));
        make.left.equalTo(self.view);
    }];
    
    /*********底部登录*********/
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitleColor:kColor_Main_Color forState:UIControlStateNormal];
    loginBtn.titleLabel.font = kFont_Title;
    [loginBtn setTitle:@"已有账号，立即登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    CGFloat loginBtnOffset = 28.0*vScreenHeight/667.0;
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-loginBtnOffset);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 24));
    }];
    
    /*********注册文本输入框*********/
    NSArray *imgAry = @[@"icon_phone_number",@"icon_verification_code",@"icon_password"];
    NSArray *fieldAry = @[self.phoneNumField,self.codeField,self.pwdField];
    
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (ISIPHONE5) {
            make.top.equalTo(self.view).offset(250);
        }else if (ISIPHONE4){
            make.top.equalTo(self.view).offset(200);
        }
        else{
            make.top.equalTo(self.view).offset(300);
        }
        make.height.equalTo(@138);
    }];
    
    for (int i = 0; i < imgAry.count; i++)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(imgAry[i])];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.frame = CGRectMake(66.5f, 10+46*i, 22, 26);
        [backView addSubview:img];
        
        UITextField *textField = fieldAry[i];
        [backView addSubview:textField];
        
        switch (i) {
            case 0:
            {
                textField.frame = CGRectMake(CGRectGetMaxX(img.frame)+14.5f, 46*i, kScreenWidth-122-42, 46);
            }
                break;
            case 1:
            {
                textField.frame = CGRectMake(CGRectGetMaxX(img.frame)+14.5f, 46*i, kScreenWidth-122-42-78, 46);
            }
                break;
            case 2:
            {
                textField.frame = CGRectMake(CGRectGetMaxX(img.frame)+14.5f, 46*i, kScreenWidth-122-42-30, 46);
            }
                break;
            default:
                break;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(61, 46*(i+1), kScreenWidth-122, 0.5f)];
        line.backgroundColor = RGB(196, 208, 215);
        [backView addSubview:line];
    }
    
    /*********立即注册btn*********/
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.titleLabel.font = kFont_BarButtonItem_Title;
    [registerBtn setTitle:@"立 即 注 册" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:kGetImage(@"btn_login") forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (ISIPHONE5 || ISIPHONE4) {
        registerBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 10, 0);
    }else{
        registerBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
    }

    [self.view addSubview:registerBtn];
    
    CGFloat heightOffset = 22.0*vScreenHeight/667.0;
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ISIPHONE5) {
            make.top.equalTo(backView.mas_bottom).offset(heightOffset);
        }else if (ISIPHONE4){
            make.top.equalTo(backView.mas_bottom).offset(heightOffset-15);
        }else if(ISIPHONE6Plus){
            make.top.equalTo(backView.mas_bottom).offset(heightOffset);
        }
        else{
            make.top.equalTo(backView.mas_bottom).offset(heightOffset+15);
        }
        make.centerX.equalTo(self.view.mas_centerX);
        if (ISIPHONE5) {
            make.top.equalTo(backView.mas_bottom).offset(heightOffset);
            make.left.equalTo(self.view).offset(72.5);
            make.right.equalTo(self.view).offset(-72.5);
        }else{
            make.left.equalTo(self.view).offset(92.5);
            make.right.equalTo(self.view).offset(-92.5);
        }
        make.height.equalTo(registerBtn.mas_width).multipliedBy(255.0/569.0);
    }];
    
    
    /*********visibleBtn*********/
    [self.view addSubview:self.visibleBtn];
    [self.visibleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneNumField);
        make.top.bottom.equalTo(self.pwdField);
        make.width.equalTo(@30);
    }];
    
    [self.view addSubview:self.receiveSMSCode];
    [self.receiveSMSCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeField).offset(10);
        make.right.equalTo(self.phoneNumField);
        make.size.mas_equalTo(CGSizeMake(78, 26));
    }];
    
    
    //审核期间不显示注册协议
    if (![JJReviewManager reviewManager].reviewing) {
        [self.view addSubview:self.readBtn];
        [self.view addSubview:self.readTypeBtn];
        
        [self.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX).offset(15);
            make.size.mas_equalTo(CGSizeMake(180, 20));
            make.top.equalTo(registerBtn.mas_bottom).with.offset(7);
        }];
        
        [self.readTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(registerBtn.mas_bottom).with.offset(7);
            make.right.equalTo(self.readBtn.mas_left);
            make.size.mas_equalTo(CGSizeMake(30, 20));
        }];
    }
}

/**
 *  dismiss ViewController
 */
- (void)turnBack
{
    [[JCRouter shareRouter] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/**
 *  出栈
 */
- (void)closeBtnClick
{
    [[JCRouter shareRouter] popViewControllerAnimated:YES];
}

/**
 *  密码是否可见
 */
- (void)showPwd:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        self.pwdField.secureTextEntry = NO;
    }
    else
    {
        self.pwdField.secureTextEntry = YES;
    }
}

- (void)readAction:(UIButton *)sender
{
    RegisterAgreementViewController *agreementVC = [[RegisterAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

- (void)changeAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

/**
 *  立即注册
 */
- (void)registerBtnClick
{
    NSString *phoneStr = self.phoneNumField.text;
    NSString *codeStr = self.codeField.text;
    NSString *pwdStr = self.pwdField.text;
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    if (!self.readTypeBtn.selected) {
        error = YES;
        errorStr = @"请阅读并同意《用户协议》";
    }
    if (pwdStr.length < 6 || pwdStr.length > 18) {
        error = YES;
        errorStr = @"请输入6-18位密码";
    }
    if (!pwdStr.length) {
        error = YES;
        errorStr = @"请输入密码";
    }
    if (!codeStr.length) {
        error = YES;
        errorStr = @"请输入验证码";
    }
    if (!phoneStr.length || ![phoneStr isMobileNumber]) {
        error = YES;
        errorStr = @"请输入正确的手机号码";
    }
    
    if (error) {
        [MBProgressHUD bwm_showTitle:errorStr
                              toView:self.view
                           hideAfter:1.2f];
        return;
    }
    
    NSDictionary *prama = @{
                            @"mobile":phoneStr,
                            @"passWord":[[pwdStr md5]uppercaseString],
                            @"smsCode":codeStr
                            };
    
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    
    __block BOOL isIdCard = NO;
    
    [[VVNetWorkUtility netUtility] getAaccountIsIdCard:phoneStr
                                           withSMSCode:codeStr
                                               Success:^(id result)
     {
         
         if ([[result safeObjectForKey:@"success"] integerValue] == 1)
         {
             /* "isIdCard":true,//true表示在微信端已有账号
              idCards":"",//身份证号的集合
              */
             
             isIdCard = [[[result safeObjectForKey:@"data"] safeObjectForKey:@"isIdCard"] boolValue];
             
             if (isIdCard)
             {
                 NSDictionary *param = @{
                                         @"mobile":phoneStr,
                                         @"passWord":[[pwdStr md5]uppercaseString],
                                         @"token":[[result safeObjectForKey:@"data"] safeObjectForKey:@"token"],
                                         @"idCards":[[result safeObjectForKey:@"data"] safeObjectForKey:@"idCards"],
                                         @"smsCode":codeStr,
                                         @"userSource":@"iOS_kuaidai"
                                         };
                 
                 [[JCRouter shareRouter] presentURL:@"tongbu" extraParams:param withNavigationClass:[UINavigationController class] completion:nil];
                 
             }
         }
         
         dispatch_group_leave(group);
         
     } failure:^(NSError *error)
     {
         dispatch_group_leave(group);
     }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (!isIdCard)
        {
            [self submitRegeditInfoWithPrama:prama withHUD:HUD];
        }
    });
}

- (void)submitRegeditInfoWithPrama:(NSDictionary *)prama withHUD:(MBProgressHUD *)HUD
{
    [[VVNetWorkUtility netUtility] postRegeditSubmitParameters:prama success:^(id result)
     {
         if ([result[@"success"] integerValue] == 1)
         {
             UserModel *user = [[UserModel alloc] init];
             user.token = result[@"accessToken"];
             user.customerId = result[@"customerId"];
             user.phone = self.phoneNumField.text;
             [user persist];
             
             [MobClick event:@"regist_success"];
             
             [HUD bwm_hideWithTitle:@"注册成功"
                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
             
             CollectDeviceTokenCommand *command = [CollectDeviceTokenCommand command];
             [command execute];
             
             dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
             dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                 [self turnBack];
             });
             
         }
         else
         {
             [HUD bwm_hideWithTitle:result[@"message"]
                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
         }
         
     } failure:^(NSError *error)
     {
         [HUD bwm_hideWithTitle:[self strFromErrCode:error]
                      hideAfter:kBWMMBProgressHUDHideTimeInterval];
     }];
}

#pragma mark - 错误码转成文字

- (NSString*)strFromErrCode:(NSError*)error
{
    NSString* msg = @"网络不给力";
    if (error.code == NSURLErrorTimedOut) {
        msg = @"网络连接超时";
    }else if(error.code == NSURLErrorCannotConnectToHost)
    {
        msg = @"未能连接到服务器";
    }else if(error.code == NSURLErrorCancelled){
        msg = @"";
    }else if(error.code == NSURLErrorNotConnectedToInternet){
        msg = @"网络不给力";
    }else{
        msg = [error localizedDescription];
    }
    return msg;
}

/**
 *  发送短信验证码
 */
- (void)receiveSMSCodeClick
{
    NSString *phoneStr = self.phoneNumField.text;
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    if (!phoneStr.length || ![phoneStr isMobileNumber]) {
        error = YES;
        errorStr = @"请输入正确的手机号码";
    }
    
    if (error) {
        [MBProgressHUD bwm_showTitle:errorStr
                              toView:self.view
                           hideAfter:1.2f];
        return;
    }
    
    [self.receiveSMSCode startTime:59 title:@"重新获取" waitTittle:@"重新获取"];
    
    [[VVNetWorkUtility netUtility] getCommonVerificationMobile:phoneStr picNum:@"" st:@""
                                                       success:^(id result)
     {
         if ([result[@"success"] integerValue] != 1)
         {
             [MBProgressHUD bwm_showTitle:result[@"message"]
                                   toView:self.view
                                hideAfter:1.2f];
         }
         
     } failure:^(NSError *error)
     {
         
     }];
}
@end
