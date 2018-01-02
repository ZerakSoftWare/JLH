//
//  JJMineViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/2/17.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJMineViewController.h"
#import "MineTableViewCell.h"
#import "UILabel+MoneyRich.h"
#import "WeChatJlhAccountRequest.h"
#import "UnBindCommand.h"
#import "JJBillAndNotiCountManager.h"
#import "JJVersionSourceManager.h"
#import "AppDelegate+HelpDesk.h"
#import "JJHomeVipShowManager.h"

@interface JJMineViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL iMisLogin;
}

@property(nonatomic,strong) UIImageView *topTimeImg;

@property(nonatomic,strong) UIView * showStautsLabBgView;
@property(nonatomic,strong) UIImageView * iconImgView;
@property(nonatomic,strong) UILabel * phoneNumLab;
@property(nonatomic,strong) UILabel * loginAndRegisterLab;
@property(nonatomic,strong) VVCommonButton * loginAndRegisterBtn;
@property(nonatomic,strong) UILabel * leftTilteLab;
@property(nonatomic,strong) UILabel * leftDetialLab;
@property(nonatomic,strong) UILabel * rightTilteLab;
@property(nonatomic,strong) UILabel * rightDetialLab;
@property(nonatomic,strong) UILabel * middleTilteLab;
@property(nonatomic,strong) UILabel * middleDetialLab;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) VVCommonButton * quitBtn;
@property(nonatomic,assign) NSInteger  currentHour;


@property (nonatomic, strong) NSArray *titleAry;
@property (nonatomic, strong) NSArray *imageTitleAry;

/*加入乐花优享*/
@property (nonatomic, strong) UIButton *joinBtn;

/*会员标签*/
@property (nonatomic, strong) UILabel *memberLab;

@end

@implementation JJMineViewController

- (UILabel *)memberLab {
    if (!_memberLab) {
        _memberLab = [[UILabel alloc] init];
        _memberLab.textColor = [UIColor whiteColor];
        _memberLab.font = kFont_TipTitle;
        _memberLab.text = @"会员有效期至：2018-12-30";
        _memberLab.hidden = YES;
    }
    return _memberLab;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinBtn.titleLabel.font = kFont_NormalTitle;
        [_joinBtn setTitle:@"立即加入 乐花优享" forState:UIControlStateNormal];
        _joinBtn.layer.cornerRadius = 15;
        _joinBtn.clipsToBounds = YES;
        _joinBtn.layer.borderWidth = 1.5f;
        _joinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_joinBtn addTarget:self action:@selector(joinBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _joinBtn.hidden = YES;
    }
    return _joinBtn;
}

- (void)joinBtnClick
{
    [[JCRouter shareRouter] pushURL:@"memberArgeement" extraParams:@{@"isDrawWebPage":@"0"}];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/**
 *  根据是否登录状态来隐藏控件
 */
- (void)initAndLayoutUI
{
    BOOL isLogin = [UserModel isLoggedIn];
    
    self.loginAndRegisterLab.hidden = isLogin;
    self.loginAndRegisterBtn.hidden = isLogin;
    
    self.iconImgView.hidden = !isLogin;
    self.phoneNumLab.hidden = !isLogin;
    self.showStautsLabBgView.hidden = !isLogin;
    self.quitBtn.hidden = !isLogin;
    self.phoneNumLab.text = [VVUtils formatPhoneNumber:[UserModel currentUser].phone];
    
    CGFloat offset = isLogin ? 0 : -66;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.showStautsLabBgView.mas_bottom).with.offset(offset);
    }];
    
    /*获取是否是会员*/
    if (isLogin)
    {
        [self getIsMemberRequest];
    }
    else
    {
        /*会员标签*/
        self.joinBtn.hidden = !isLogin;
        self.memberLab.hidden = !isLogin;
    }
    
    /**
     *  如果已登录且没有账户信息
     */
    if (isLogin && !VV_SHDAT.mainStateModel)
    {
        [self getWeChatJlhAccount];
    }
    if (VV_SHDAT.mainStateModel) {
        if (VV_SHDAT.mainStateModel.summary.vbsCreditMoney <= 0) {
            //授信额度
            self.leftDetialLab.text = @"暂无";
            //已用额度
            self.middleDetialLab.text = @"暂无";
            //可用额度
            self.rightDetialLab.text = @"暂无";
        }else{
            
            //授信额度
            [self.leftDetialLab setMoneyRichText:[NSString stringWithFormat:@"%.f",VV_SHDAT.mainStateModel.summary.vbsCreditMoney]];
            
            //已用额度
            [self.middleDetialLab setMoneyRichText:[NSString stringWithFormat:@"%.f",VV_SHDAT.mainStateModel.summary.usedMoney]];
            
            //可用额度
            [self.rightDetialLab setMoneyRichText:[NSString stringWithFormat:@"%.f",(VV_SHDAT.mainStateModel.summary.vbsCreditMoney-VV_SHDAT.mainStateModel.summary.usedMoney)]];
        }
    }
    _currentHour = [[VVCommonFunc currentTime] integerValue];
    
    if (_currentHour >= 6 && _currentHour <9)
    {
        self.topTimeImg.image  = kGetImage(@"img_my_bg_morning");
    }
    else if (_currentHour >=9 && _currentHour <18)
    {
        self.topTimeImg.image = kGetImage(@"img_my_bg_afternoon");
    }
    else
    {
        self.topTimeImg.image = kGetImage(@"img_my_bg_evening");
    }
}

/**
 *  获取账户信息
 */
- (void)getWeChatJlhAccount
{
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] getMainUserStateWithAccountId:[UserModel currentUser].customerId vc:self success:^(id result) {
        VVLog(@"成功-- %@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJMainStateModel *statusModel = [JJMainStateModel mj_objectWithKeyValues:result];
        if (statusModel.success) {
//            strongSelf.homeStatusModel = statusModel;
            VV_SHDAT.mainStateModel = statusModel;
            if (VV_SHDAT.mainStateModel.summary.vbsCreditMoney <= 0) {
                //授信额度
                strongSelf.leftDetialLab.text = @"暂无";
                //已用额度
                strongSelf.middleDetialLab.text = @"暂无";
                //可用额度
                strongSelf.rightDetialLab.text = @"暂无";
            }else{
                
                //授信额度
                [strongSelf.leftDetialLab setMoneyRichText:[NSString stringWithFormat:@"%.f",VV_SHDAT.mainStateModel.summary.vbsCreditMoney]];
                
                //已用额度
                [strongSelf.middleDetialLab setMoneyRichText:[NSString stringWithFormat:@"%.f",VV_SHDAT.mainStateModel.summary.usedMoney]];
                
                //可用额度
                [strongSelf.rightDetialLab setMoneyRichText:[NSString stringWithFormat:@"%.f",(VV_SHDAT.mainStateModel.summary.vbsCreditMoney-VV_SHDAT.mainStateModel.summary.usedMoney)]];
            }
            
        }else{
            [MBProgressHUD bwm_showTitle:result[@"message"]
                                  toView:self.view
                               hideAfter:1.0
                                 msgType:BWMMBProgressHUDMsgTypeError];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:[self strFromErrCode:error]
                              toView:self.view
                           hideAfter:1.0
                             msgType:BWMMBProgressHUDMsgTypeError];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initAndLayoutUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 30);
    
    self.navigationBar.hidden = YES;
    self.titleAry = @[@[@"我的银行卡",@"我的优惠券",@"乐花优享"],
                      @[@"在线客服",@"帮助中心",@"问题反馈"],
                      @[@"关于我们"]];
    self.imageTitleAry = @[@[@"icon_my_card",@"icon_my_vouchers", @"icon_my_Member"],
                           @[@"icon_customer_service",@"icon_help_center",@"icon_problem_feedback"],
                           @[@"icon_about_us"]];
    
    [self setSubView];
}

- (void)setSubView
{
    UIImage *img;
    _currentHour = [[VVCommonFunc currentTime] integerValue];

    if (_currentHour >= 6 && _currentHour <9) {
        img  = [UIImage imageNamed:@"img_my_bg_morning"];
    }else if (_currentHour >= 9 && _currentHour <18){
        img  = [UIImage imageNamed:@"img_my_bg_afternoon"];
    }else{
        img  = [UIImage imageNamed:@"img_my_bg_evening"];
    }

    UIImageView *topTimeImg = [[UIImageView  alloc]initWithImage:img];
    topTimeImg.contentMode = UIViewContentModeScaleAspectFill;
    topTimeImg.clipsToBounds = YES;
    topTimeImg.userInteractionEnabled = YES;
    [_scrollView addSubview:topTimeImg];
    self.topTimeImg = topTimeImg;
    
    [topTimeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.scrollView.mas_top).offset(0);
        make.height.equalTo(@215);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的";
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self.topTimeImg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topTimeImg.mas_top).offset(15+12);
        make.centerX.mas_equalTo(self.topTimeImg.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    UIImageView * iconImgView = [[UIImageView alloc]init];
    iconImgView.image = kGetImage(@"img_user_head_protrait_m");
    [self.topTimeImg addSubview:iconImgView];
    
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topTimeImg.mas_top).offset(65);
        make.left.mas_equalTo(10);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    _iconImgView = iconImgView;
    
    UILabel * phoneNumLab = [[UILabel alloc]init];
    phoneNumLab.font = [UIFont systemFontOfSize:14.f];
    phoneNumLab.textAlignment = NSTextAlignmentCenter;
    phoneNumLab.textColor = VVWhiteColor;
    phoneNumLab.text = @"12345678901";
    [_topTimeImg addSubview:phoneNumLab];
    _phoneNumLab = phoneNumLab;
    
    [phoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@22);
        make.left.mas_equalTo(iconImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.topTimeImg.mas_top).offset(65);
    }];
    
    [self.topTimeImg addSubview:self.joinBtn];
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneNumLab);
        make.size.mas_equalTo(CGSizeMake(140, 30));
        make.top.mas_equalTo(phoneNumLab.mas_bottom).offset(3);
    }];
    
    [self.topTimeImg addSubview:self.memberLab];
    [self.memberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneNumLab.mas_bottom).offset(3);
        make.left.mas_equalTo(phoneNumLab);
        make.size.mas_equalTo(CGSizeMake(240, 30));
    }];
    
    UILabel * loginAndRegisterLab = [[UILabel alloc]init];
    loginAndRegisterLab.font = [UIFont systemFontOfSize:14.f];
    loginAndRegisterLab.textAlignment = NSTextAlignmentCenter;
    loginAndRegisterLab.textColor = VVWhiteColor;
    loginAndRegisterLab.text = @"登录后尊享更多精彩";
    [_topTimeImg addSubview:loginAndRegisterLab];
    _loginAndRegisterLab = loginAndRegisterLab;
    
    [loginAndRegisterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topTimeImg.mas_top).offset(65);
        make.centerX.mas_equalTo(self.topTimeImg.centerX).offset(0);
        make.height.equalTo(@16);
    }];
    
    VVCommonButton * loginAndRegisterBtn = [VVCommonButton solidButtonWithTitle:@"登录/注册"] ;
    loginAndRegisterBtn.layer.cornerRadius = 18.f;
    [loginAndRegisterBtn addTarget:self action:@selector(loginAndRegisterBtnClck) forControlEvents:UIControlEventTouchUpInside];
    [_topTimeImg addSubview:loginAndRegisterBtn];
    _loginAndRegisterBtn = loginAndRegisterBtn;
    
    [loginAndRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginAndRegisterLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.topTimeImg.centerX).offset(0);
        make.width.equalTo(@108);
        make.height.equalTo(@36);
    }];
    
    
    UIView * showStautsLabBgView = [[UIView alloc]init];
    showStautsLabBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:showStautsLabBgView];
    _showStautsLabBgView = showStautsLabBgView;
    
    [showStautsLabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@66);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.top.mas_equalTo(self.topTimeImg.mas_bottom).offset(-1);
    }];
    
    UILabel * leftTilteLab = [[UILabel alloc]init];
    leftTilteLab.font = [UIFont systemFontOfSize:14];
    leftTilteLab.textAlignment = NSTextAlignmentCenter;
    leftTilteLab.textColor = VVColor999999;
    leftTilteLab.text = @"授信额度";
    [_showStautsLabBgView addSubview:leftTilteLab];
    _leftTilteLab = leftTilteLab;
    
    [leftTilteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.showStautsLabBgView);
        make.top.mas_equalTo(self.showStautsLabBgView.mas_top).offset(4);
        make.width.equalTo(@(vScreenWidth/3.0));
        make.height.equalTo(@20);
    }];
    
    UILabel * leftDetialLab = [[UILabel alloc]init];
    leftDetialLab.textAlignment = NSTextAlignmentCenter;
    leftDetialLab.textColor = [UIColor colorWithHexString:@"333333"];
    leftDetialLab.font = [UIFont fontWithName:@"DINPro-Regular" size:18];
    [leftDetialLab setMoneyRichText:@"0.00"];
    [_showStautsLabBgView addSubview:leftDetialLab];
    _leftDetialLab = leftDetialLab;
    
    [leftDetialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTilteLab.mas_left).offset(0);
        make.right.mas_equalTo(self.leftTilteLab.mas_right).offset(0);
        make.top.mas_equalTo(self.leftTilteLab.mas_bottom).offset(5);
        make.height.equalTo(@26);
    }];

    
    UILabel * rightTilteLab= [[UILabel alloc]init];
    rightTilteLab.font = [UIFont systemFontOfSize:14.f];
    rightTilteLab.textAlignment = NSTextAlignmentCenter;
    rightTilteLab.textColor = VVColor999999;
    rightTilteLab.text = @"可用额度";
    [_showStautsLabBgView addSubview:rightTilteLab];
    _rightTilteLab = rightTilteLab;
    
    [rightTilteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.showStautsLabBgView);
        make.top.mas_equalTo(self.showStautsLabBgView.mas_top).offset(4);
        make.width.equalTo(@(vScreenWidth/3.0));
        make.height.equalTo(@20);
    }];

    UILabel * rightDetialLab = [[UILabel alloc]init];
    rightDetialLab.font = [UIFont systemFontOfSize:18.f];
    rightDetialLab.textAlignment = NSTextAlignmentCenter;
    rightDetialLab.textColor = [UIColor colorWithHexString:@"333333"];
    rightDetialLab.font = [UIFont fontWithName:@"DINPro-Regular" size:18];
    [rightDetialLab setMoneyRichText:@"0.00"];
    [_showStautsLabBgView addSubview:rightDetialLab];
    _rightDetialLab = rightDetialLab;
    
    [rightDetialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightTilteLab.mas_left).offset(0);
        make.right.mas_equalTo(self.rightTilteLab.mas_right).offset(0);
        make.top.mas_equalTo(self.rightTilteLab.mas_bottom).offset(5);
        make.height.equalTo(@26);
    }];
    
    UILabel * middleTilteLab= [[UILabel alloc]init];
    middleTilteLab.font = [UIFont systemFontOfSize:14.f];
    middleTilteLab.textAlignment = NSTextAlignmentCenter;
    middleTilteLab.textColor = VVColor999999;
    middleTilteLab.text = @"已用额度";
    [_showStautsLabBgView addSubview:middleTilteLab];
    _middleTilteLab = middleTilteLab;
    
    [middleTilteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.showStautsLabBgView.centerX);
        make.top.mas_equalTo(self.showStautsLabBgView.mas_top).offset(4);
        make.width.equalTo(@(vScreenWidth/3.0));
        make.height.equalTo(@20);
    }];
    
    UILabel * middleDetialLab = [[UILabel alloc]init];
    middleDetialLab.textAlignment = NSTextAlignmentCenter;
    middleDetialLab.textColor = [UIColor colorWithHexString:@"333333"];
    middleDetialLab.font = [UIFont fontWithName:@"DINPro-Regular" size:18];
    [middleDetialLab setMoneyRichText:@"0.00"];
    [_showStautsLabBgView addSubview:middleDetialLab];
    _middleDetialLab = middleDetialLab;
    
    [middleDetialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.showStautsLabBgView.centerX);
        make.top.mas_equalTo(self.middleTilteLab.mas_bottom).offset(5);
        make.height.equalTo(@26);
    }];
    
    [_scrollView layoutIfNeeded];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource  =  self;
    tableView.rowHeight = 48;
    [_scrollView addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(@372);
        make.top.mas_equalTo(self.showStautsLabBgView.mas_bottom);
    }];
        
    VVCommonButton *quitBtn = [VVCommonButton solidButtonWithTitle:@"退出登录"];
    quitBtn.titleLabel.font  = [UIFont systemFontOfSize:16.0];
    quitBtn.layer.cornerRadius = 6.f;
    [quitBtn addTarget:self action:@selector(quitBntClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:quitBtn];
    _quitBtn = quitBtn;
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(30);
        make.height.equalTo(@44);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.bottom.mas_equalTo(quitBtn.mas_bottom).offset(60);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)quitBntClick
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定要退出登录吗！" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self quitRequest];
    }];
    
    [alert addAction:updateAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)quitRequest
{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate userAccountDidRemoveFromServer];
    
    [self showHud];
    [[VVNetWorkUtility netUtility] getLogoutWithCustomerId:[UserModel currentUser].customerId
                                                   success:^(id result)
     {
         [self hideHud];
         if ([result[@"success"] integerValue] == 1)
         {
             UnBindCommand *command = [UnBindCommand command];
             [command execute];
             
             [[UserModel currentUser] clear];
             //清空token等
             VV_SHDAT.mainStateModel = nil;
             VV_SHDAT.antsToken = nil;
             VV_SHDAT.timestamp = nil;
             VV_SHDAT.changeMobileNum = nil;
             VV_SHDAT.mobileInitModel = nil;//／移动初始化信息
             VV_SHDAT.orderInfo = nil; //订单信息
             VV_SHDAT.vcreditInitModel = nil;//／征信初始化信息
             VV_SHDAT.userInfo = nil; //用户信息
             VV_SHDAT.creditBaseInfoModel = nil; //／征信用户信息
             VV_SHDAT.authenticationModel = nil;//身份认证
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:@"" forKey:@"uuid"];
             [defaults setObject:nil forKey:@"huabeiFailTip"];
             [defaults setObject:nil forKey:@"gongjijinFailTip"];
             [defaults setBool:NO forKey:@"firstIncreaseSuccess"];
             [defaults setBool:NO forKey:@"firstIncrease"];
             [defaults setBool:NO forKey:@"firstShowVip"];
             [defaults synchronize];
             [JJVersionSourceManager versionSourceManager].versionSource = @"";//清除versionsource
             [JJHomeVipShowManager homeVipShowManager].isVipShowed = NO;//清除isVipShowed
             [JJHomeVipShowManager homeVipShowManager].isVipShowedWithdrawing = NO;//清除isVipShowedWithdrawing
             [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] clearRedStatus];
             [[NSNotificationCenter defaultCenter] postNotificationName:JJLogout object:nil];
             [self initAndLayoutUI];
         }
         else
         {
             [MBProgressHUD bwm_showTitle:result[@"message"]
                                   toView:self.view
                                hideAfter:1.0f];
         }
         
     } failure:^(NSError *error)
     {
         [self hideHud];
         [MBProgressHUD bwm_showTitle:[self strFromErrCode:error]
                               toView:self.view
                            hideAfter:1.0f];
     }];
}

- (void)loginAndRegisterBtnClck
{
    [[JCRouter shareRouter] presentURL:@"login" withNavigationClass:[AppNavigationController class] completion:nil];
}

#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleAry[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headCell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, vScreenWidth, 12)];
    headCell.backgroundColor = VVColor(241, 244, 246);
    return  headCell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = [MineTableViewCell  cellWithTableView:tableView];

    cell.lab.text = self.titleAry[indexPath.section][indexPath.row];
    cell.leftImg.image = [UIImage imageNamed:self.imageTitleAry[indexPath.section][indexPath.row]];
    
    switch (indexPath.section) {
        case 0:

        case 1:
        {
            if (indexPath.row != 2)
            {
                cell.bottomSeparateLine.hidden = NO;
            }
            else
            {
                cell.bottomSeparateLine.hidden = YES;
            }
        }
            break;
        case 2:
        {
            cell.bottomSeparateLine.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isLogin = [UserModel isLoggedIn];
    
    NSString *vcClass = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            if (!isLogin)
            {
                [self loginAndRegisterBtnClck];
                return;
            }
            
            if (indexPath.row == 0)
            {
                vcClass = @"bankList";
            }
            else if(indexPath.row == 1)
            {
                vcClass = @"couponList";
            }
            else
            {
                vcClass = @"myMember";
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 1)
            {
                vcClass = @"helpCenter";
            }
            else
            {
                if (!isLogin)
                {
                    [self loginAndRegisterBtnClck];
                    return;
                }
                
                if (indexPath.row == 0)
                {
                    vcClass = @"onlineService";
                    
                    [self chatActionLogin];
                    return;
                }
                else
                {
                    vcClass = @"feedback";
                }
            }
        }
            break;
        case 2:
        {
            vcClass = @"aboutUs";
        }
            break;
        default:
            break;
    }
    
    [[JCRouter shareRouter] pushURL:vcClass];
}

- (void)chatActionLogin
{
    //登录IM
    if (iMisLogin == YES) {
        return;
    }
    iMisLogin = YES;
    
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"连接客服中……" toView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SCLoginManager *lgM = [SCLoginManager shareLoginManager];
        if ([lgM loginKefuSDK]) {

            OnlineServiceViewController *chat = [[OnlineServiceViewController alloc] initWithConversationChatter:lgM.cname];
            
            chat.visitorInfo = [self visitorInfo];
            
            NSString *queue = @"客服组";
            HQueueIdentityInfo *queueIdentityInfo = [[HQueueIdentityInfo alloc] initWithValue:queue];
            chat.queueInfo = queueIdentityInfo;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hideAnimated:YES];

                [self.navigationController pushViewController:chat animated:YES];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD bwm_hideWithTitle:@"联系客服失败,请重试..."
                             hideAfter:kBWMMBProgressHUDHideTimeInterval];
            });
            NSLog(@"登录失败");
        }
    });
    
    iMisLogin = NO;
}

- (HVisitorInfo *)visitorInfo {
    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
    visitor.name = [UserModel currentUser].customerId;
    visitor.desc = @"借乐花用户";
    return visitor;
}

- (void)getIsMemberRequest
{
    [[VVNetWorkUtility netUtility] getIsMemberRequestWithCustomerId:[UserModel currentUser].customerId
                                                            success:^(id result)
     {
         if ([result[@"success"] integerValue] == 1)
         {
             //isMemberShip    String    是否会员（0：非会员；1：会员）2、付款中
             NSString *str = [[result safeObjectForKey:@"data"] safeObjectForKey:@"isMemberShip"];
             if ([str isEqualToString:@"0"])
             {
                 self.joinBtn.hidden = NO;
             }
             else if([str isEqualToString:@"2"])
             {
                 self.joinBtn.hidden = YES;
                 self.memberLab.text = @"暂未缴费";
             }
             else
             {
                 self.joinBtn.hidden = YES;
                 NSString *timeStr = [[[result safeObjectForKey:@"data"] safeObjectForKey:@"validityPeriod"] substringToIndex:10];
                 
                 NSString *str = [NSString stringWithFormat:@"\t会员有效期至：%@",timeStr];
                 NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                 textAttachment.image = kGetImage(@"icon_user_head_VIP");
                 textAttachment.bounds = CGRectMake(0, -3, 22, 20);
                 NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
                 NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
                 [attributedString insertAttributedString:attrStringWithImage atIndex:0];
                 self.memberLab.attributedText = attributedString;
             }
             
             self.memberLab.hidden = !self.joinBtn.hidden;
         }
         else
         {
             self.joinBtn.hidden = YES;
             self.memberLab.hidden = YES;
         }
     } failure:^(NSError *error)
     {
         self.joinBtn.hidden = YES;
         self.memberLab.hidden = YES;
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
