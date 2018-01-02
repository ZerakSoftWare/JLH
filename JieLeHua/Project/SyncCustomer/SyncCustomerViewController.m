//
//  SyncCustomerViewController.m
//  JieLeHua
//
//  Created by kuang on 2017/3/26.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "SyncCustomerViewController.h"
#import "CollectDeviceTokenCommand.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface SyncCustomerViewController ()

@property (nonatomic, strong) UIImageView *topImgView;

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) UIImageView *bottomImgView;

@property (nonatomic, strong) VVCommonButton *sureBtn;

@property (nonatomic, strong) UITextField *idCardTextField;

@property (nonatomic, strong) NSDictionary *dic;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation SyncCustomerViewController


#pragma mark - Properties

- (VVCommonButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [VVCommonButton solidButtonWithTitle:@"确定"];
        _sureBtn.titleLabel.font  = [UIFont systemFontOfSize:16.0];
        _sureBtn.layer.cornerRadius = 6.f;
        [_sureBtn setBackgroundColor:VVColor(170, 195, 226) forState:UIControlStateDisabled];
        [_sureBtn addTarget:self action:@selector(checkIdCardIsInList) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.enabled = NO;
    }
    return _sureBtn;
}

- (UITextField *)idCardTextField {
    if (!_idCardTextField) {
        _idCardTextField = [[UITextField alloc] init];
        _idCardTextField.placeholder = @"请输入您的身份证号码";
        _idCardTextField.font = [UIFont systemFontOfSize:15];
        _idCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _idCardTextField.textColor = VVColor(51, 51, 51);
        [_idCardTextField setValue:VVColor(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _idCardTextField;
}

- (UIImageView *)topImgView {
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc] initWithImage:kGetImage(@"img_tongbu_1")];
    }
    return _topImgView;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithImage:kGetImage(@"img_tongbu_2")];
    }
    return _titleImageView;
}

- (UIImageView *)bottomImgView {
    if (!_bottomImgView) {
        _bottomImgView = [[UIImageView alloc] initWithImage:kGetImage(@"img_9")];
    }
    return _bottomImgView;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (id)initWithRouterParams:(NSDictionary *)params
{
    if ((self = [super init]))
    {
        self.dic = params;
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [MobClick event:@"regist_claim_sync"];
    
    [self setNavigationBarTitle:@"账号同步"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView.frame = CGRectMake(0, 64, vScreenWidth, vScreenHeight-64);
    
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
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)initAndLayoutUI
{
    [_scrollView addSubview:self.topImgView];
    [_scrollView addSubview:self.titleImageView];
    [_scrollView addSubview:self.bottomImgView];
    
    self.titleImageView.userInteractionEnabled = YES;
    
    [_scrollView addSubview:self.idCardTextField];
    [_scrollView addSubview:self.sureBtn];
    
    [self.idCardTextField addTarget:self action:@selector(updateLogInButton)
                   forControlEvents:UIControlEventEditingChanged];
    
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.top.equalTo(self.scrollView.mas_top).offset(0);
        make.height.equalTo(self.topImgView.mas_width).multipliedBy(0.4);
    }];
    
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.topImgView.mas_bottom).offset(-20);
        make.height.equalTo(self.titleImageView.mas_width).multipliedBy(122.0/670.0);
    }];
    
    [self setTitleSubview];
}

- (void)setTitleSubview
{
    UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(@"icon_id_card")];
    [_scrollView addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageView.mas_left).offset(16);
        make.top.equalTo(self.titleImageView).offset(92);
        make.size.mas_equalTo(CGSizeMake(27, 22));
    }];
    
    [self.idCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).offset(12);
        make.height.equalTo(@44);
        make.right.equalTo(self.titleImageView.mas_right).offset(-16);
        make.top.equalTo(img.mas_top).offset(-10);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = VVColor(205, 205, 205);
    [self.idCardTextField addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(43.5f, 0.0, 0, 0.5));
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageView).offset(10);
        make.height.equalTo(@44);
        make.right.equalTo(self.titleImageView).offset(-10);
        make.top.equalTo(self.idCardTextField.mas_bottom).offset(40);
    }];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_tongbu_bg_2")];
    [_scrollView addSubview:leftImg];
    
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(9);
        make.top.equalTo(self.titleImageView.mas_bottom).offset(-30);
        make.width.equalTo(@6);
        make.bottom.equalTo(self.sureBtn.mas_bottom).offset(40);
    }];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_tongbu_bg_3")];
    [_scrollView addSubview:rightImg];
    
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-9);
        make.top.equalTo(self.titleImageView.mas_bottom).offset(-30);
        make.width.equalTo(@6);
        make.bottom.equalTo(self.sureBtn.mas_bottom).offset(40);
    }];
    
    UIImageView *lastImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_tongbu_bg_1")];
    [_scrollView addSubview:lastImg];
    
    [lastImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureBtn.mas_bottom).offset(39);
        make.left.equalTo(self.view.mas_left).offset(9);
        make.right.equalTo(self.view.mas_right).offset(-9);
        make.height.equalTo(self.bottomImgView.mas_width).multipliedBy(28.0/714.0);
    }];
    
    
    UIButton *noSyncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [noSyncBtn setTitle:@"暂不同步" forState:UIControlStateNormal];
    [noSyncBtn setTitleColor:VVBASE_OLD_COLOR forState:UIControlStateNormal];
    noSyncBtn.titleLabel.font  = [UIFont systemFontOfSize:13.0];
    [noSyncBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:noSyncBtn];
    
    [noSyncBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleImageView).offset(-10);
        make.top.equalTo(self.sureBtn.mas_bottom).offset(14);
        make.bottom.equalTo(lastImg).offset(-20);
    }];
    
    CGFloat offset = 0;
    if (ISIPHONE6Plus)
    {
        offset = 25;
    }
    
    [self.bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.bottomImgView.mas_width).multipliedBy(368.0/750.0);
        make.top.equalTo(lastImg).offset(42.5f+offset);
    }];
    
    [_scrollView layoutIfNeeded];
    
    _scrollView.contentSize = CGSizeMake(vScreenWidth, self.bottomImgView.bottom);
}

- (void)checkIdCardIsInList
{
    [self.idCardTextField resignFirstResponder];
    
    NSArray *idCards = self.dic[@"idCards"];
    
    if ([idCards containsObject:self.idCardTextField.text])
    {
        [self sureBtnClick];
    }
    else
    {
        [self showErrorIdCardView];
    }
}

/**
 *  未找到身份证弹窗
 */
- (void)showErrorIdCardView
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message:@"未同步到该身份证号码，请重新输入"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"暂不绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self submitRegeditInfo];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"重新绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  同步接口
 */
- (void)sureBtnClick
{
    NSDictionary *dic = @{
                          @"idCard":self.idCardTextField.text,
                          @"mobile":self.dic[@"mobile"],
                          @"passWord":self.dic[@"passWord"],
                          @"token":self.dic[@"token"]
                          };
    
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在同步中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] postSyncCustomerParameters:dic
                                                      success:^(id result)
     {
         if ([result[@"success"] integerValue] == 1)
         {
             [MobClick event:@"regist_complete_sync"];
             
             [HUD bwm_hideWithTitle:@"同步成功！"
                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
             
             UserModel *user = [[UserModel alloc] init];
             user.token = result[@"accessToken"];
             user.customerId = result[@"customerId"];
             user.phone = result[@"mobile"];
             [user persist];
             
             dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DEFAULT_DISPLAY_DURATION * NSEC_PER_SEC));
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

- (void)turnBack
{
    [[JCRouter shareRouter] dismissViewControllerWithIndex:2 animated:YES completion:nil];
}

- (void)cancelClick
{
    [MobClick event:@"regist_un_bind"];
    [self submitRegeditInfo];
}

- (void)submitRegeditInfo
{
    NSDictionary *prama = @{
                            @"mobile":self.dic[@"mobile"],
                            @"passWord":self.dic[@"passWord"],
                            @"smsCode":self.dic[@"smsCode"]
                            };
    
    [[VVNetWorkUtility netUtility] postRegeditSubmitParameters:prama success:^(id result)
     {
         if ([result[@"success"] integerValue] == 1)
         {
             UserModel *user = [[UserModel alloc] init];
             user.token = result[@"accessToken"];
             user.customerId = result[@"customerId"];
             user.phone = result[@"mobile"];
             [user persist];
             
             [MobClick event:@"regist_success"];
             
             [MBProgressHUD bwm_showTitle:@"注册成功"
                                   toView:self.view
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
             [MBProgressHUD bwm_showTitle:result[@"message"]
                                   toView:self.view
                                hideAfter:kBWMMBProgressHUDHideTimeInterval];
         }
         
     } failure:^(NSError *error)
     {
         [MBProgressHUD bwm_showTitle:[self strFromErrCode:error]
                               toView:self.view
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

- (void)updateLogInButton
{
    BOOL textFieldsNonEmpty = self.idCardTextField.text.length > 0;
    self.sureBtn.enabled = textFieldsNonEmpty;
}

@end
