//
//  LoginViewController.m
//  JieLeHua
//
//  Created by kuang on 2017/4/25.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "LoginViewController.h"
#import "CollectDeviceTokenCommand.h"
#import "JJBillAndNotiCountManager.h"
#import "UITextField+LimitLength.h"
#import "EmployeeWebViewController.h"
#ifdef JIELEHUA
#pragma mark - 转介绍
#import "IntroduceRootViewController.h"
#endif
#pragma mark Constants


#pragma mark - Class Extension

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *phoneNumField;

@property (nonatomic, strong) UITextField *pwdField;

/**
 *  密码是否可见按钮
 */
@property (nonatomic, strong) UIButton *visibleBtn;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation LoginViewController


#pragma mark - Properties

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

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Routable load

- (id)initWithRouterParams:(NSDictionary *)params
{
    if ((self = [super init]))
    {
        self.isEmployee = NO;
        
        if ([[params objectForKey:@"isEmployee"] boolValue])
        {
            self.isEmployee = YES;
        }
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initAndLayoutUI];
    
    if (self.isEmployee)
    {
        self.phoneNumField.keyboardType = UIKeyboardTypeDefault;
        self.phoneNumField.placeholder = @"请输入您的VBS账号";
    }
    else
    {
        self.phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneNumField.placeholder = @"请输入手机号";
        [self limitTextFieldLength];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"uuid"];
    [defaults synchronize];
    
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
    
    
    /*********左上角关闭按钮*********/
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.titleLabel.font = kFont_Title;
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    if (self.isEmployee)
    {
        closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        [closeBtn setImage:kGetImage(@"btn_return_white") forState:UIControlStateNormal];
    }
    else
    {
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    }
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.size.mas_equalTo(CGSizeMake(58, 24));
        make.left.equalTo(self.view);
    }];
    
    
    /*********底部注册*********/
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitleColor:kColor_Main_Color forState:UIControlStateNormal];
    registerBtn.titleLabel.font = kFont_Title;
    [registerBtn setTitle:@"暂无账号，立即注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    CGFloat registerBtnOffset = 28.0*vScreenHeight/667.0;
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-registerBtnOffset);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 24));
    }];
    
    
    /*********登录文本框*********/
    NSArray *imgAry = @[@"icon_phone_number",@"icon_password"];
    NSArray *fieldAry = @[self.phoneNumField,self.pwdField];
    
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topImg.mas_bottom).offset(6.5f);
        make.height.equalTo(@108);
    }];
    
    for (int i = 0; i < imgAry.count; i++)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(imgAry[i])];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.frame = CGRectMake(66.5f, 20+54*i, 20, 26);
        [backView addSubview:img];
        
        UITextField *textField = fieldAry[i];
        textField.frame = CGRectMake(CGRectGetMaxX(img.frame)+14.5f, 12+54*i, kScreenWidth-122-40-i*30, 42);
        [backView addSubview:textField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(61, 54*(i+1), kScreenWidth-122, 0.5f)];
        line.backgroundColor = RGB(196, 208, 215);
        [backView addSubview:line];
    }
    
    
    /*********登录btn*********/
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.titleLabel.font = kFont_BarButtonItem_Title;
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:kGetImage(@"btn_login") forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    CGFloat heightOffset = 49.0*vScreenHeight/667.0;
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(heightOffset);
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view).offset(72);
        make.right.equalTo(self.view).offset(-77);
        make.height.equalTo(loginBtn.mas_width).multipliedBy(115.0/455.0);
    }];
    
    
    /*********员工登录btn*********/
    UIButton *employeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [employeBtn setTitleColor:kColor_Main_Color forState:UIControlStateNormal];
    employeBtn.titleLabel.font = kFont_TipTitle;
    [employeBtn setTitle:@"员工登录" forState:UIControlStateNormal];
    [employeBtn addTarget:self action:@selector(employeLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:employeBtn];
    
    [employeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.left.equalTo(loginBtn.mas_left);
        make.top.equalTo(loginBtn.mas_bottom);
    }];
    
    
    /*********忘记密码btn*********/
    UIButton *forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdButton setTitleColor:kColor_Main_Color forState:UIControlStateNormal];
    forgetPwdButton.titleLabel.font = kFont_TipTitle;
    [forgetPwdButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPwdButton addTarget:self action:@selector(forgetPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdButton];
    
    [forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.top.equalTo(loginBtn.mas_bottom);
        make.right.equalTo(loginBtn.mas_right);
    }];
    
    
    /*********visibleBtn*********/
    [self.view addSubview:self.visibleBtn];
    [self.visibleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneNumField);
        make.top.bottom.equalTo(self.pwdField);
        make.width.equalTo(@30);
    }];
    
    /**
     *  判断是否是员工登录
     */
    employeBtn.hidden = self.isEmployee;
    registerBtn.hidden = self.isEmployee;
    forgetPwdButton.hidden = self.isEmployee;
}

/**
 *  dismiss ViewController
 */
- (void)closeBtnClick
{
    if (self.isEmployee)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[JCRouter shareRouter] dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

/**
 *  goto注册
 */
- (void)registerButtonClick
{
    [[JCRouter shareRouter] pushURL:@"register"];
}

/**
 *  login
 */
- (void)loginBtnClick
{
    [self.view endEditing:YES];
    
    if (self.isEmployee)
    {
#ifdef JIELEHUA
        [self sendEmployeeRequest];
#endif
    }
    else
    {
        [self sendUserRequest];
    }
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

/**
 *  忘记密码
 */
- (void)forgetPasswordButtonClick
{
    [[JCRouter shareRouter]pushURL:@"forgetPassword"];
}

/**
 *  员工登录
 */
- (void)employeLogin
{
    NSDictionary *param = @{
                            @"isEmployee":[NSNumber numberWithBool:YES]
                            };
    
    [[JCRouter shareRouter] pushURL:@"login" extraParams:param];
}

/**
 *  员工登录
 */
#ifdef JIELEHUA
- (void)sendEmployeeRequest
{
    NSString *phoneStr = self.phoneNumField.text;
    NSString *pwdStr = self.pwdField.text;
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    if (!pwdStr.length) {
        error = YES;
        errorStr = @"请输入密码";
    }
    if (!phoneStr.length) {
        error = YES;
        errorStr = @"请输入用户名";
    }
    
    if (error) {
        [MBProgressHUD bwm_showTitle:errorStr
                              toView:self.view
                           hideAfter:1.2f];
        return;
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] getEmployeeAppJlhLogin:phoneStr
                                             withPassWord:pwdStr
                                                  Success:^(id result)
     {
         if ([result[@"success"] integerValue] == 1) {
             
             [HUD hide:YES];
             
             NSString *salesId = [NSString stringWithFormat:@"%@",[[result safeObjectForKey:@"data"] safeObjectForKey:@"salesId"]];
             
//             accessToken_sales
             NSString *salesToken = [NSString stringWithFormat:@"%@",[[result safeObjectForKey:@"data"] safeObjectForKey:@"accessToken_sales"]];
             
             [[NSUserDefaults standardUserDefaults] setObject:phoneStr forKey:@"JJEmployeVbsAccount"];
             [[NSUserDefaults standardUserDefaults] setObject:salesId forKey:@"JJEmployeSalesId"];
             [[NSUserDefaults standardUserDefaults] setObject:salesToken forKey:@"JJEmployeSalesToken"];
             
             [[NSUserDefaults standardUserDefaults] synchronize];
             IntroduceRootViewController *tabBarController = [[IntroduceRootViewController alloc] init];
             [self.navigationController pushViewController:tabBarController animated:YES];
//             EmployeeWebViewController *rootVC = [[EmployeeWebViewController alloc] init];
//             rootVC.url = url;
//             [self.navigationController pushViewController:rootVC animated:YES];
         }
         else
         {
             [HUD bwm_hideWithTitle:result[@"message"]
                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
         }
         
     } failure:^(NSError *error)
     {
         [HUD bwm_hideWithTitle:@"网络不给力"
                      hideAfter:kBWMMBProgressHUDHideTimeInterval];
     }];
}
#endif
/**
 *  用户登录
 */
- (void)sendUserRequest
{
    NSString *phoneStr = self.phoneNumField.text;
    NSString *pwdStr = self.pwdField.text;
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    if (!pwdStr.length) {
        error = YES;
        errorStr = @"请输入密码";
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
    
    NSDictionary *prama = @{@"mobile":phoneStr,
                            @"passWord":[[pwdStr md5]uppercaseString]};
    
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] postSecurityLoginParameters:prama success:^(id result) {
        if ([result[@"success"] integerValue] == 1) {
            
            [HUD hide:YES];
            
            NSString *customerId, *accsessToken;
            
            customerId = result[@"customerId"];
            accsessToken = result[@"accessToken"];
            VV_SHDAT.userInfo.data.accountId = customerId;
            
            UserModel *user = [UserModel mj_objectWithKeyValues:result];
            user.token = result[@"accessToken"];
            user.phone = phoneStr;
            [user persist];
            
            [MobClick event:@"login"];
            
//            [self getBasicDictionaries];
            CollectDeviceTokenCommand *command = [CollectDeviceTokenCommand command];
            [command execute];
            [self closeBtnClick];
            [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] updateNotiCount];
        }
        else
        {
            [HUD bwm_hideWithTitle:result[@"message"]
                         hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }
        
    } failure:^(NSError *error) {
        [HUD bwm_hideWithTitle:@"网络不给力"
                     hideAfter:kBWMMBProgressHUDHideTimeInterval];
    }];
}

/**
 *  登录成功，请求基本信息
 */
//- (void)getBasicDictionaries{
//    
//    NSString *plistPath = [VVPathUtils basicPlistPath];
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    [[VVNetWorkUtility netUtility] getCommonDictionariesSuccess:^(id result) {
//        if ([[result safeObjectForKey:@"success"] boolValue]) {
//            NSArray *dataDic = [result safeObjectForKey:@"data"];
//            [fileMgr removeItemAtPath:plistPath error:nil];
//            BOOL isWrited  =   [dataDic writeToFile:plistPath atomically:YES];
//            VVLog(@"dataDicwriteToFile:%d",isWrited);
//        }
//    } failure:^(NSError *error) {
//        //        [VLToast showWithText:[self strFromErrCode:error]];
//    }];
//}


@end
