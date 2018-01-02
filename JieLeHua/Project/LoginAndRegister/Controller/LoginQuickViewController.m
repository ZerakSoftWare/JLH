//
//  LoginQuickViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/6/19.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "LoginQuickViewController.h"
#import "CollectDeviceTokenCommand.h"
#import "JJBillAndNotiCountManager.h"
#import "UITextField+LimitLength.h"
#import "EmployeeWebViewController.h"
@interface LoginQuickViewController ()

@property (nonatomic, strong) UITextField *phoneNumField;

@property (nonatomic, strong) UITextField *pwdField;

/**
 *  密码是否可见按钮
 */
@property (nonatomic, strong) UIButton *visibleBtn;

@end

@implementation LoginQuickViewController
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
        make.height.equalTo(topImg.mas_width).multipliedBy(793.0/750.0);
    }];
    
    
    UIImageView *cardImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_login_card_bg")];
    [self.view addSubview:cardImg];
    [cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@318);
        if (ISIPHONE5) {
            make.top.equalTo(self.view).offset(123);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
        }else if (ISIPHONE4){
            make.top.equalTo(self.view).offset(103);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
        }
        else{
            make.top.equalTo(self.view).offset(193);
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
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (ISIPHONE5) {
            make.top.equalTo(self.view).offset(250);
            make.height.equalTo(@91);
        }else if (ISIPHONE4){
            make.top.equalTo(self.view).offset(210);
            make.height.equalTo(@91);
        }
        else{
            make.top.equalTo(self.view).offset(300);
            make.height.equalTo(@91);
        }
    }];
    
    for (int i = 0; i < imgAry.count; i++)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(imgAry[i])];
        img.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat width;
        if (ISIPHONE5 || ISIPHONE4) {
            width = 10;
        }else{
            width = 20;
        }
        img.frame = CGRectMake(width+66.5f, 20+54*i, 20, 26);
        [backView addSubview:img];
        
        UITextField *textField = fieldAry[i];
        textField.frame = CGRectMake(CGRectGetMaxX(img.frame)+14.5f, 12+54*i, kScreenWidth-122-40-i*30-width, 42);
        [backView addSubview:textField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(61, 54*(i+1), kScreenWidth-122, 0.5f)];
        line.backgroundColor = RGB(196, 208, 215);
        [backView addSubview:line];
    }
    
    /*********忘记密码btn*********/
    UIButton *forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdButton setTitleColor:kColor_Main_Color forState:UIControlStateNormal];
    forgetPwdButton.titleLabel.font = kFont_TipTitle;
    [forgetPwdButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPwdButton addTarget:self action:@selector(forgetPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwdButton];
    
    [forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.top.equalTo(backView.mas_bottom).offset(18);
        make.right.equalTo(backView.mas_right).offset(-60);
    }];
    
    /*********登录btn*********/
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.titleLabel.font = kFont_BarButtonItem_Title;
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:kGetImage(@"btn_login") forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if (ISIPHONE5 || ISIPHONE4) {
        loginBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 10, 0);
    }else{
        loginBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
    }
    
    [self.view addSubview:loginBtn];
    
    CGFloat heightOffset = 49.0*vScreenHeight/667.0;
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        if (ISIPHONE5) {
            make.top.equalTo(backView.mas_bottom).offset(heightOffset);
            make.left.equalTo(self.view).offset(72.5);
            make.right.equalTo(self.view).offset(-72.5);
        }else if (ISIPHONE4){
            make.top.equalTo(backView.mas_bottom).offset(heightOffset+20);
            make.left.equalTo(self.view).offset(72.5);
            make.right.equalTo(self.view).offset(-72.5);
        }
        else if(ISIPHONE6Plus){
            make.top.equalTo(backView.mas_bottom).offset(heightOffset);
            make.left.equalTo(self.view).offset(92.5);
            make.right.equalTo(self.view).offset(-92.5);
        }
        else{
            make.top.equalTo(backView.mas_bottom).offset(heightOffset+10);
            make.left.equalTo(self.view).offset(92.5);
            make.right.equalTo(self.view).offset(-92.5);
        }
        make.height.equalTo(loginBtn.mas_width).multipliedBy(255.0/569.0);
    }];
    
    
    /*********员工登录btn*********/
    //    UIButton *employeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [employeBtn setTitleColor:kColor_Main_Color forState:UIControlStateNormal];
    //    employeBtn.titleLabel.font = kFont_TipTitle;
    //    [employeBtn setTitle:@"员工登录" forState:UIControlStateNormal];
    //    [employeBtn addTarget:self action:@selector(employeLogin) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:employeBtn];
    //
    //    [employeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.size.mas_equalTo(CGSizeMake(70, 30));
    //        make.left.equalTo(loginBtn.mas_left);
    //        make.top.equalTo(loginBtn.mas_bottom);
    //    }];
    
    
    
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
    //    employeBtn.hidden = self.isEmployee;
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
    
    //    if (self.isEmployee)
    //    {
    //        [self sendEmployeeRequest];
    //    }
    //    else
    //    {
    [self sendUserRequest];
    //    }
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
//- (void)employeLogin
//{
//    NSDictionary *param = @{
//                            @"isEmployee":[NSNumber numberWithBool:YES]
//                            };
//
//    [[JCRouter shareRouter] pushURL:@"login" extraParams:param];
//}
//
///**
// *  员工登录
// */
//- (void)sendEmployeeRequest
//{
//    NSString *phoneStr = self.phoneNumField.text;
//    NSString *pwdStr = self.pwdField.text;
//
//    BOOL error = NO;
//    NSString *errorStr = @"";
//
//    if (!pwdStr.length) {
//        error = YES;
//        errorStr = @"请输入密码";
//    }
//    if (!phoneStr.length) {
//        error = YES;
//        errorStr = @"请输入用户名";
//    }
//
//    if (error) {
//        [MBProgressHUD bwm_showTitle:errorStr
//                              toView:self.view
//                           hideAfter:1.2f];
//        return;
//    }
//
//    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
//
//    [[VVNetWorkUtility netUtility] getEmployeeAppJlhLogin:phoneStr
//                                             withPassWord:pwdStr
//                                                  Success:^(id result)
//     {
//         if ([result[@"success"] integerValue] == 1) {
//
//             [HUD hide:YES];
//
//             NSString *url = [[result safeObjectForKey:@"data"] safeObjectForKey:@"url"];
//
//             [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"JJEmployeUrl"];
//             [[NSUserDefaults standardUserDefaults] synchronize];
//
//             EmployeeWebViewController *rootVC = [[EmployeeWebViewController alloc] init];
//             rootVC.url = url;
//             [self.navigationController pushViewController:rootVC animated:YES];
//         }
//         else
//         {
//             [HUD bwm_hideWithTitle:result[@"message"]
//                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
//         }
//
//     } failure:^(NSError *error)
//     {
//         [HUD bwm_hideWithTitle:@"网络不给力"
//                      hideAfter:kBWMMBProgressHUDHideTimeInterval];
//     }];
//}
//
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
