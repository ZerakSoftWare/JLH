//
//  JJHomeViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/2/17.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJHomeViewController.h"
#import "VVMainStateModel.h"
#import "VVLoanAplicationProcessViewController.h"
#import "VVOrderInfoModel.h"
#import "VVNetWorkUtility.h"
#import "JJReviewStatusViewController.h"
#import "JJAuthenticationModel.h"
#import "JJMainStateModel.h"
#import "AmountStatusView.h"
#import "WithdrawStatusView.h"
#import "BillStatusView.h"
#import "JJHomeStatusRouterManager.h"
#import "VVTabBarViewController.h"
#import "JJBillAndNotiCountManager.h"
#import "JJFindViewController.h"
#import "JJGetBannerRequest.h"
#import "SDCycleScrollView.h"
#import "VVWebAppViewController.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"
#import "JJHomeStatusRequest.h"
#import "OliveappLivenessDetectionViewController.h"
#import "OliveappLivenessDataType.h"
#import "KSShare.h"
#import "JJGetApplyInfoByCustomerIdRequest.h"
#import "JJVersionSourceManager.h"
#import "JJHomeNoApplyView.h"
#import "JJBeginApplyRequest.h"
#import "NoAmountView.h"
#import "JJServiceTipView.h"
#import "IncreaseMoneyView.h"
#import "VVDeviceUtils.h"
#import "JJUniqueIdRequest.h"
#import "JJReCreditRequest.h"
#import "BillStatusDetailView.h"
#import "IncreaseTypeViewController.h"
#import "JJPayVipViewController.h"
#import "ZJAnimationPopView.h"
#import "JJGoToPayView.h"
#import "JJHomeVipShowManager.h"

#ifdef JIELEHUAQUICK
#import "JJReviewManager.h"
#endif

#define  kLayoutTabbarHeight    49


@interface JJHomeViewController ()<HomeStatusProtocal,SDCycleScrollViewDelegate,UIWebViewDelegate,IncreaseTypeDelegate>
{
    VVWebView *webview;
}
/**  滚动视图*/
@property(nonatomic,weak)SDCycleScrollView *scrollPic;
/**  图片数据组*/
@property(nonatomic,strong) NSArray * picUrlArrs;
@property(nonatomic,strong) UIImageView * homeStatusBg;
@property(nonatomic,strong) UIImageView * amountApprovingImg;
@property(nonatomic,strong) UILabel * approvingStatusLab;
@property(nonatomic,strong) VVCommonButton *applyBtn;
@property(nonatomic,strong) UILabel * approvingTipLab;
@property(nonatomic,strong) UIImageView * billBgImg;
@property(nonatomic,strong) UILabel * billLabTop;
@property(nonatomic,strong) UILabel * billLabBottom;
@property(nonatomic,strong) UILabel * billTipLab;
@property(nonatomic,strong) UILabel * repaymentLab;
@property(nonatomic,strong) UILabel * repaymentTipLab;

@property(nonatomic,strong) UILabel *availableLimitLab;
@property(nonatomic,strong) UILabel *availableLimitDetialLab;
@property(nonatomic,strong) UIView * horizontalSeparateLine;
@property(nonatomic,strong) UILabel *usedLimitLab;
@property(nonatomic,strong) UILabel *usedLimitDetialLab;
@property(nonatomic,strong) UILabel *lineOfCreditLimitLab;
@property(nonatomic,strong) UILabel *lineOfCreditLimitDetialLab;
@property(nonatomic,strong) UIView * verticalSeparateLine;
//@property(nonatomic,strong) NSDictionary * allStateDic;

//@property (nonatomic, strong) JJHomeStatusView *statusView;
//@property(nonatomic,strong) VVMainStateModel *state;

@property (nonatomic, strong) JJMainStateModel *homeStatusModel;

@property (nonatomic, copy) NSDictionary *localStatusDict;
@property (nonatomic, strong) AmountStatusView *amoutStatusView;
@property (nonatomic, strong) WithdrawStatusView *withdrawStatusView;
@property (nonatomic, strong) BillStatusView *billStatusView;
@property (nonatomic, strong) JJHomeNoApplyView *noApplyView;
@property (nonatomic, strong) NoAmountView *noAmountView;
@property (nonatomic, strong) IncreaseMoneyView *increaseMoneyView;
@property (nonatomic, strong) BillStatusDetailView *billStatusDetailView;

@property(nonatomic,strong) NSString * mobileBillId;

//测试功能代码
@property (nonatomic, assign) NSInteger statusTestValue;
@property(nonatomic,assign)   NSInteger applyTimes  ;
@property(nonatomic,assign)  NSInteger status ;

//小红点
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) JJBannnerModel *bannerModel;

//定时器
@property (nonatomic, strong) NSTimer *previewTimer;
@property(nonatomic,strong) NSTimer * crawlerStateTimer;

@property (nonatomic, strong) UIButton *messageBtn;

@property (nonatomic, strong) JJGoToPayView *customView;

//是否展示会员特权
@property (nonatomic, assign) BOOL isVipShowed;
//是否展示提现状态开通会员页
@property (nonatomic, assign) BOOL isVipShowedWithdrawing;

@end

@implementation JJHomeViewController
#pragma mark - getter
- (BillStatusDetailView *)billStatusDetailView
{
    if (_billStatusDetailView == nil) {
        _billStatusDetailView = [BillStatusDetailView billStatusWithType:HomeStatus_Repayment_Overdate_Not frame:CGRectMake(0, 0, vScreenWidth - 32 *2, 410)];
        _billStatusDetailView.delegate = self;
        _billStatusDetailView.centerX = self.view.centerX;
        _billStatusDetailView.y = _scrollPic.bottom + 32.5;
        [_scrollView addSubview:_billStatusDetailView];
    }
    return _billStatusDetailView;
}

- (UIButton *)messageBtn
{
    if (_messageBtn == nil) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.frame = CGRectMake(vScreenWidth-32, _scrollPic.bottom + 25, 30, 30);
        [_messageBtn setBackgroundImage:[UIImage imageNamed:@"icon_message_inform"] forState:UIControlStateNormal];
        [_scrollView addSubview:_messageBtn];
    }
    return _messageBtn;
}


- (IncreaseMoneyView *)increaseMoneyView
{
    if (_increaseMoneyView == nil) {
        _increaseMoneyView = [IncreaseMoneyView increaseStatusWithType:HomeStatus_AdvanceIn30Days frame:CGRectMake(0, 0, vScreenWidth - 32 *2, 430)];
        
        _increaseMoneyView.delegate = self;
        _increaseMoneyView.centerX = self.view.centerX;
        _increaseMoneyView.y = _scrollPic.bottom + 32.5;
        [_scrollView addSubview:_increaseMoneyView];
    }
    return _increaseMoneyView;
}

- (NoAmountView *)noAmountView
{
    if (_noAmountView == nil) {
        _noAmountView = [NoAmountView amountStatusWithType:HomeStatus_NoAmount frame:CGRectMake(0, 0, vScreenWidth - 32 *2, 410)];
        _noAmountView.delegate = self;
        _noAmountView.centerX = self.view.centerX;
        _noAmountView.y = _scrollPic.bottom + 32.5;
        [_scrollView addSubview:_noAmountView];

    }
    return _noAmountView;
}

- (AmountStatusView *)amoutStatusView
{
    if (_amoutStatusView == nil) {
        _amoutStatusView = [AmountStatusView amountStatusWithType:HomeStatus_NoAmount frame:CGRectMake(0, 0, vScreenWidth - 32 *2, 410)];
        _amoutStatusView.delegate = self;
        _amoutStatusView.centerX = self.view.centerX;
        _amoutStatusView.y = _scrollPic.bottom + 32.5;
        //_statusView.delegate = self;
        [_scrollView addSubview:_amoutStatusView];
    }
    return _amoutStatusView;
}

- (WithdrawStatusView *)withdrawStatusView
{
    if (_withdrawStatusView == nil) {
        _withdrawStatusView = [WithdrawStatusView withdrawStatusWithType:HomeStatus_AdvanceIn30Days frame:CGRectMake(0, 0, vScreenWidth - 32 *2, 410)];
        _withdrawStatusView.delegate = self;
        _withdrawStatusView.frame = CGRectMake(0, 0, vScreenWidth - 32 *2, 410);
        _withdrawStatusView.centerX = self.view.centerX;
        _withdrawStatusView.y = _scrollPic.bottom + 32.5;
        //_statusView.delegate = self;
        [_scrollView addSubview:_withdrawStatusView];
    }
    return _withdrawStatusView;
}

- (BillStatusView *)billStatusView
{
    if (_billStatusView == nil) {
        _billStatusView = [BillStatusView billStatusWithType:HomeStatus_Repayment_Overdate_Not frame:CGRectMake(0, 0, vScreenWidth - 32 *2, 410)];
        _billStatusView.delegate = self;
        _billStatusView.frame = CGRectMake(0, 0, vScreenWidth - 32 *2, 410);
        _billStatusView.centerX = self.view.centerX;
        _billStatusView.y = _scrollPic.bottom + 32.5;
        //_statusView.delegate = self;
        [_scrollView addSubview:_billStatusView];
    }
    return _billStatusView;
}

- (JJHomeNoApplyView *)noApplyView
{
    if (_noApplyView == nil) {
        _noApplyView = [JJHomeNoApplyView noApplyWithType:HomeStatus_NoAmount frame:CGRectMake(0, 0, vScreenWidth, 410)];
        _noApplyView.delegate = self;
        _noApplyView.frame = CGRectMake(0, 0, vScreenWidth, 410);
        _noApplyView.centerX = self.view.centerX;
        _noApplyView.y = _scrollPic.bottom + 32.5;
        [_scrollView addSubview:_noApplyView];
    }
    return _noApplyView;
}

- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,3, 6, 6)];
        _countLabel.layer.cornerRadius = 3;
        _countLabel.layer.masksToBounds = YES;
        _countLabel.backgroundColor = [UIColor redColor];
        [_messageBtn addSubview:_countLabel];
    }
    return _countLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationBar.hidden = YES;
//#if DEBUG
//    self.statusTestValue = 1;
//#endif
    
    self.navigationController.navigationBar.hidden = YES;
    
    BOOL isLogin = [UserModel isLoggedIn];
    if (!isLogin) {
        [self hiddenFailLoadViewView];
        [self setFailY:0];

        self.countLabel.hidden = YES;
        self.noApplyView.hidden = YES;
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = YES;
        self.billStatusView.hidden = YES;
        self.amoutStatusView.hidden = YES;
        self.billStatusDetailView.hidden = YES;
        self.noAmountView.hidden = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.noApplyView.bottom + 50);
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.amoutStatusView.bottom + 20  );
    }else{
        [self postUniqueId];
        UserModel *userModel = [UserModel currentUser];
        self.countLabel.hidden = NO;
        if (![[JJBillAndNotiCountManager sharedBillAndNotiCountManager] showMessageRed]) {
            self.countLabel.hidden = YES;
        }else{
            self.countLabel.hidden = NO;
        }
        //199422
        [self getMainStateRequestWithUserID:userModel.customerId];
    }
    if (self.bannerModel == nil) {
        [self getBanner];
    }
}

- (void)reloadData
{
    [self hiddenFailLoadViewView];
    if (self.bannerModel == nil) {
        [self getBanner];
    }
    UserModel *userModel = [UserModel currentUser];
    [self getMainStateRequestWithUserID:userModel.customerId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = VVWhiteColor;
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 30);
    [self setNavigation];
    self.navigationBar.hidden = YES;
    [self setupStatusShip];
    [self addScrollPic];
    [self addBackButton];
    self.btnBack.hidden = YES;
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"f1f4f7"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRightStatus:) name:JJUpdateHomeRightBtn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTimer:) name:JJLogout object:nil];
    [self addReloadTarget:self action:@selector(reloadData)];
    [self.messageBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
//    JJServiceTipView *testView = [[JJServiceTipView alloc] initServiceTipWithFrame:self.view.frame];
//    [self.view addSubview:testView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightAction:(id)sender{
#if DEBUG
//    self.homeStatusModel.summary.applyStatus++；
//    return;
//    JJPayVipViewController *payVipVC = [JJPayVipViewController viewController];
//    payVipVC.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:payVipVC animated:YES completion:nil];
//    return;
#endif

    if (![UserModel isLoggedIn]) {
        [[JCRouter shareRouter] presentURL:@"login" withNavigationClass:[AppNavigationController class] completion:nil];
        return;
    }
    [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] saveTimeStamp];
    [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] clearMessageStatus];
    [VV_App.tabBarController selectViewControllerAtIndex:2];
    VVLog(@"%@",VV_App.tabBarController.selectedViewController);
    JJFindViewController *findVC = (JJFindViewController *)VV_App.tabBarController.selectedViewController;
    [findVC gotoMsg];
}

-(void)setSubView{
    NSString *appStatus = [NSString stringWithFormat:@"%@",@(self.homeStatusModel.summary.applyStatus)]; //当天申请状态
    NSString *className = [self.localStatusDict objectForKey:appStatus];
//    VVLog(@"显示的View:%@",className);
//    if ([appStatus isEqualToString:@"1"] && [[JJVersionSourceManager versionSourceManager].versionSource isEqualToString:@"4"]) {
//        //首页展示按钮去申请
//        self.noApplyView.hidden = NO;
//        self.withdrawStatusView.hidden = YES;
//        self.billStatusView.hidden = YES;
//        self.amoutStatusView.hidden = YES;
//        self.noAmountView.hidden = YES;
//        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.noApplyView.bottom + 50  );
//        return;
//    }else{
//        self.noApplyView.hidden = YES;
//    }
    
//#ifdef JIELEHUAQUICK
//    
//#else
    if (self.homeStatusModel.summary.reApply == 1 && [appStatus isEqualToString:@"4"] && [self.homeStatusModel.summary.userSource isEqualToString:@"0"]) {
//        只显示webview
        self.noApplyView.hidden = YES;
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = YES;
        self.billStatusView.hidden = YES;
        self.amoutStatusView.hidden = YES;
        self.noAmountView.hidden = YES;
        self.scrollPic.hidden = YES;
        [self showWebview];
        [self showVipTipView];
        return;
    }else{
        self.scrollPic.hidden = NO;
        webview.hidden = YES;
    }
//#endif
  
    
    if ([className isEqualToString:@"AmountStatusView"]) {
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = YES;
        self.billStatusView.hidden = YES;
        self.noAmountView.hidden = YES;
        self.amoutStatusView.hidden = NO;
        self.billStatusDetailView.hidden = YES;
        [self.amoutStatusView updateUIWithData:self.homeStatusModel.summary type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.amoutStatusView.bottom + 20);
        [self showVipTipView];
    }
    else if ([className isEqualToString:@"NoAmountView"]){
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = YES;
        self.billStatusView.hidden = YES;
        self.noAmountView.hidden = NO;
        self.amoutStatusView.hidden = YES;
        self.billStatusDetailView.hidden = YES;
        [self.noAmountView updateUIWithData:self.homeStatusModel.summary type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.noAmountView.bottom + 20);
        [self showVipTipView];
    }
    else if ([className isEqualToString:@"WithdrawStatusView"]){
        self.billStatusDetailView.hidden = YES;
        [self showWithDrawView:appStatus];
    }else if ([className isEqualToString:@"BillStatusView"]){
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = YES;
        self.amoutStatusView.hidden = YES;
        self.noAmountView.hidden = YES;
        self.billStatusDetailView.hidden = YES;
        self.billStatusView.hidden = NO;
        [self.billStatusView updateUIWithData:self.homeStatusModel.summary type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.billStatusView.bottom + 20  );
        [self showVipTipView];
    }
    else if ([className isEqualToString:@"BillStatusDetailView"]) {
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = YES;
        self.amoutStatusView.hidden = YES;
        self.noAmountView.hidden = YES;
        self.billStatusView.hidden = YES;
        self.billStatusDetailView.hidden = NO;
        [self.billStatusDetailView updateUIWithData:self.homeStatusModel.summary type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.billStatusView.bottom + 20  );
        [self showVipTipView];
    }
}

- (void)showWithDrawView:(NSString *)appStatus
{
    self.amoutStatusView.hidden = YES;
    self.billStatusView.hidden = YES;
    self.noAmountView.hidden = YES;
    if ([appStatus isEqualToString:@"33"]) {
        //再贷
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = NO;
        [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
        [self showVipTipView];
        return;
    }
    NSString *avaibleMoney = [NSString stringWithFormat:@"%.f",self.homeStatusModel.summary.vbsCreditMoney-self.homeStatusModel.summary.usedMoney];
    if (self.homeStatusModel.summary.reApply == 2) {
        //再贷
        self.withdrawStatusView.hidden = NO;
        self.increaseMoneyView.hidden = YES;
        [self.withdrawStatusView updateUIWithData:self.homeStatusModel.summary type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.withdrawStatusView.bottom + 20);
        if ([appStatus isEqualToString:@"5"]) {
            //再贷，不显示提额
            self.withdrawStatusView.hidden = YES;
            self.increaseMoneyView.hidden = NO;
            [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:33];
            _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
            return;
        }
        [self showVipTipView];
    }else{
        //
        [self setWithStatus:appStatus money:avaibleMoney];
    }
}

- (void)setWithStatus:(NSString *)appStatus money:(NSString *)avaibleMoney
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstShowVip = [[defaults objectForKey:@"firstShowVip"] boolValue];
//    BOOL isFirstIncrease = [[defaults objectForKey:@"firstIncrease"] boolValue];

    
   
    
    if ([appStatus isEqualToString:@"5"] && (self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 0 && self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 0)) {
        
        self.withdrawStatusView.hidden = NO;
        self.increaseMoneyView.hidden = YES;
        [self.withdrawStatusView updateUIWithData:self.homeStatusModel.summary type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.withdrawStatusView.bottom + 20);
        
        if (self.homeStatusModel.summary.reApply == 1 && ![self.homeStatusModel.summary.isMemberShip isEqualToString:@"1"]&& !isFirstShowVip) {
            //是否首次
            [self showPopAnimationWithAnimationStyle:3 money:avaibleMoney];
            [defaults setBool:YES forKey:@"firstShowVip"];
            [defaults synchronize];
        }
        
//        if (!isFirstIncrease && avaibleMoney.intValue < 30000) {
//            //首次提额
//            //首次提示立即提现
//            NSString *message = [NSString stringWithFormat:@"您已成功获得%@元额度，验证花呗额度和公积金可再次提额哟!",avaibleMoney];
//            [VVAlertUtils showAlertViewWithTitle:@"" message:message customView:nil cancelButtonTitle:@"马上提额" otherButtonTitles:@[@"立即提现"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                [defaults setBool:YES forKey:@"firstIncrease"];
//                [defaults synchronize];
//                if (buttonIndex  != kCancelButtonTag) {
//                    //提现push
//                    [alertView hideAlertViewAnimated:YES];
//                    [defaults setBool:YES forKey:[UserModel currentUser].token];
//                    [defaults synchronize];
//                    [[JCRouter shareRouter]pushURL:[NSString stringWithFormat:@"withdrawMoney/%@",avaibleMoney]];
//                }else{
//                    //刷新页面
//                    self.withdrawStatusView.hidden = YES;
//                    self.increaseMoneyView.hidden = NO;
//                    [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:[appStatus integerValue]];
//                    _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
//                }
//            }];
//        }else{
            self.withdrawStatusView.hidden = YES;
            self.increaseMoneyView.hidden = NO;
            [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:[appStatus integerValue]];
            _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
        if (avaibleMoney.intValue == 30000) {
            self.withdrawStatusView.hidden = YES;
            self.increaseMoneyView.hidden = NO;
            [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:33];
            _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
            return;
        }
//        }
    }
    else if (self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 5 || self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 5){
        self.withdrawStatusView.hidden = NO;
        self.increaseMoneyView.hidden = YES;
        [self.withdrawStatusView updateUIWithData:self.homeStatusModel.summary type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.withdrawStatusView.bottom + 20);
        
        if ([appStatus isEqualToString:@"5"]) {
            //审批成功，显示金额
            self.withdrawStatusView.hidden = YES;
            self.increaseMoneyView.hidden = NO;
            [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:33];
            _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
            
            BOOL isFirstIncreaseSuccess = [[defaults objectForKey:@"firstIncreaseSuccess"] boolValue];
            if (!isFirstIncreaseSuccess) {
                [VVAlertUtils showAlertViewWithTitle:@"" message:@"恭喜您，提额成功" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != kCancelButtonTag) {
                        [alertView hideAlertViewAnimated:YES];
                        [defaults setBool:YES forKey:@"firstIncreaseSuccess"];
                        [defaults synchronize];
                    }
                }];
            }
        }
    }
    else if ([avaibleMoney intValue] < 30000 && [appStatus isEqualToString:@"5"] && (self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 4 && self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 4)){
        //提额失败
        NSString *bothTip = [defaults objectForKey:@"bothTip"];
        if (bothTip == nil) {
            [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您暂不满足提额要求，无法提额" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != kCancelButtonTag) {
                    [defaults setObject:@"1" forKey:@"bothTip"];
                    [defaults synchronize];
                    [alertView hideAlertViewAnimated:YES];
                }
            }];
        }
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = NO;
        [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
    }
    else if ([avaibleMoney intValue] < 30000 && [appStatus isEqualToString:@"5"] && ((self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 4 && self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 0) || (self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 0 && self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 4))){
        //提额失败
        NSString *huabeiFailTip = [defaults objectForKey:@"huabeiFailTip"];
        NSString *gongjijinFailTip = [defaults objectForKey:@"gongjijinFailTip"];
        
        if (self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 4) {
            if (gongjijinFailTip == nil) {
                [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您的公积金缴纳情况暂不满足提额要求，无法提额！" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != kCancelButtonTag) {
                        [defaults setObject:@"1" forKey:@"gongjijinFailTip"];
                        [defaults synchronize];
                        [alertView hideAlertViewAnimated:YES];
                    }
                }];
            }
        }
        else if(self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 4)
        {
            if (huabeiFailTip == nil) {
                [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您的花呗额度暂不满足提额要求，无法提额!" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != kCancelButtonTag) {
                        [defaults setObject:@"1" forKey:@"huabeiFailTip"];
                        [defaults synchronize];
                        [alertView hideAlertViewAnimated:YES];
                    }
                }];
            }
        }
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = NO;
        [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
    }
    else if ([appStatus isEqualToString:@"41"]){
        //提额中，详情页
        self.withdrawStatusView.hidden = YES;
        self.increaseMoneyView.hidden = YES;
        self.amoutStatusView.hidden = NO;
        [self.amoutStatusView updateUIWithData:self.homeStatusModel.summary type:41];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
        [self showVipTipView];
    }
    else{
        self.withdrawStatusView.hidden = NO;
        self.increaseMoneyView.hidden = YES;
        [self.withdrawStatusView updateUIWithData:self.homeStatusModel.summary type:[appStatus integerValue]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, self.withdrawStatusView.bottom + 20);
        
        if ([appStatus isEqualToString:@"5"] && ![[defaults objectForKey:[UserModel currentUser].token] boolValue]) {
            //首次提示立即提现
            NSString *avaibleMoney = [NSString stringWithFormat:@"%.f",self.homeStatusModel.summary.vbsCreditMoney-self.homeStatusModel.summary.usedMoney];
            NSString *message = [NSString stringWithFormat:@"您已成功获得%@元额度，快去提现吧！",avaibleMoney];
            [VVAlertUtils showAlertViewWithTitle:@"" message:message customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"立即提现"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex  != kCancelButtonTag) {
                    //提现push
                    [alertView hideAlertViewAnimated:YES];
                    [defaults setBool:YES forKey:[UserModel currentUser].token];
                    [defaults synchronize];
                    [[JCRouter shareRouter]pushURL:[NSString stringWithFormat:@"withdrawMoney/%@",avaibleMoney]];
                }
            }];
        }
        
        if ([appStatus isEqualToString:@"5"]) {
            self.withdrawStatusView.hidden = YES;
            self.increaseMoneyView.hidden = NO;
            [self.increaseMoneyView updateUIWithData:self.homeStatusModel type:33];
            _scrollView.contentSize = CGSizeMake(kScreenWidth, self.increaseMoneyView.bottom + 20);
            return;
        }
        [self showVipTipView];
    }
}


-(void)setNavigation{
    [self setNavigationBarTitle:@""];
    UIImageView *navLogoImg = [[UIImageView alloc]initWithImage:VV_GETIMG(@"img_home_logo")];
    navLogoImg.centerY = _navigationBar.centerY + 5;
    navLogoImg.centerX = _navigationBar.centerX;
    if (iPhoneX)
    {
        navLogoImg.centerY = _navigationBar.centerY + 15;
    }
    [_navigationBar addSubview:navLogoImg];

    [self addRightButtonWithImage:[UIImage imageNamed:@"btn_nav_bar_message"] highlightedImage:[UIImage imageNamed:@""]];
}

/**
 *  添加无限轮播图
 */
-(void)addScrollPic{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,vScreenWidth , iPhoneX?200:150) delegate:self placeholderImage:[UIImage imageNamed:@"img_placeholder"]];
    cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView.imageURLStringsGroup = @[];
    [_scrollView addSubview:cycleScrollView];
    self.scrollPic = cycleScrollView;
    [self getBanner];
}

//-(NSArray *)picUrlArrs{
//                        
//    if (_picUrlArrs == nil) {
//        _picUrlArrs =[VVscrollPicModels mj_objectArrayWithFilename:@"bannerUrl.plist"];
//    }
//    return _picUrlArrs;
//}

#pragma mark  数据request
- (void)getBanner
{
    JJGetBannerRequest *request = [[JJGetBannerRequest alloc] init];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJBannnerModel *model = [(JJGetBannerRequest *)request response];
        if (model.success) {
            strongSelf.bannerModel = model;
            NSMutableArray *array = [NSMutableArray array];
            for (JJBannnerDataModel *data in model.data) {
                if (data.img != nil) {
                    [array addObject:data.img];
                }
            }
            
#ifdef JIELEHUAQUICK
            if ([JJReviewManager reviewManager].reviewing) {
                [array removeAllObjects];
                [array addObject:@"http://jielehua.vcash.cn/appphoto/banner/banner1.png"];
                strongSelf.scrollPic.imageURLStringsGroup = array;
            }else{
                strongSelf.scrollPic.imageURLStringsGroup = array;
            }
#else
            strongSelf.scrollPic.imageURLStringsGroup = array;
#endif
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

- (void)getMainStateRequestWithUserID:(NSString *)userid {
    __weak __typeof(self)weakSelf = self;
    JJHomeStatusRequest *request = [[JJHomeStatusRequest alloc] initWithCustomerId:userid];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc]initWithShowVC:self];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        NSDictionary *result = request.responseJSONObject;
        VVLog(@"成功-- %@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJMainStateModel *statusModel = [JJMainStateModel mj_objectWithKeyValues:result];
        if (statusModel.success) {
            [strongSelf hiddenFailLoadViewView];
#if DEBUG
//            statusModel.data.isMemberShip = @"0";
//            statusModel.summary.reApply = 1;
#endif
            strongSelf.homeStatusModel = statusModel;
            VV_SHDAT.mainStateModel = statusModel;
            JJVersionSourceManager *sourceManager = [JJVersionSourceManager versionSourceManager];
            sourceManager.versionSource = statusModel.summary.versionSource;
            if (weakSelf.homeStatusModel.summary.reApply == 1) {
                //首贷
                if ((statusModel.summary.applyStatus  == 2) || (statusModel.summary.applyStatus== 34)) {
                    [strongSelf getCustomersOrderDetailsWithAccountId];
                }
                [strongSelf setSubView];
            }else {
                //再贷
                if (statusModel.summary.applyStatus== 34) {
                    //再贷决策接口 /apply/468858/reCredit
                    [strongSelf reCredit];
                }
                [strongSelf setSubView];
            }
            
        }else{
            if (nil == strongSelf.homeStatusModel) {
                //全页面显示暂无数据
                [strongSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
            }
            [MBProgressHUD bwm_showTitle:@"系统繁忙，请稍后再试"
                                  toView:strongSelf.view
                               hideAfter:1.0
                                 msgType:BWMMBProgressHUDMsgTypeError];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        VVLog(@"失败-- %@",error);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (nil == strongSelf.homeStatusModel) {
            //全页面显示暂无数据
            [strongSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
        }
    }];
}

#pragma mark - 获取视图关系链
- (void)setupStatusShip {
    //暂定为代码写死逻辑，后面调整为根据json解析跳转对应router
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"statusManager" ofType:@"json"];
    NSString *statusString = [NSString stringWithContentsOfFile:jsonPath  encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *jsonDict = [statusString mj_JSONObject];
    NSDictionary *statusDict = [jsonDict safeObjectForKey:@"status"];
    self.localStatusDict = statusDict;
}

#pragma mark - HomeStatusProtocal
- (void)clickBtnWithStatus:(HomeStatus)status
{
    VVLog(@"根据状态%lu，跳转到对应界面",(unsigned long)status);
    //for test 重复请求
//    [[JJVersionSourceManager versionSourceManager] startFastApplyWithView:self.view];
//    [[JJVersionSourceManager versionSourceManager] startFastApplyWithView:self.view];
//    sleep(1);
//    [[JJVersionSourceManager versionSourceManager] startFastApplyWithView:self.view];
//    [[JJVersionSourceManager versionSourceManager] startFastApplyWithView:self.view];
//
//    return;
    BOOL isLogin = [UserModel isLoggedIn];
    if (!isLogin) {
        [[JCRouter shareRouter] presentURL:@"login" withNavigationClass:[AppNavigationController class] completion:nil];
    }else{
        if (status == HomeStatus_NoAmount || status == HomeStatus_AmountInvalid) {
            [[JJVersionSourceManager versionSourceManager] startFastApplyWithView:self.view];
            return;
        }
        [[JJHomeStatusRouterManager homeStatusRouterManager] dealWithStatus:status data:self.homeStatusModel];
    }
}

- (void)presentIncrease
{
    if (![self.homeStatusModel.data.isMemberShip isEqualToString:@"1"]) {
        VVLog(@"开通会员");
        [[JCRouter shareRouter] pushURL:@"memberArgeement" extraParams:@{@"isDrawWebPage":@"0"}];
        return;
    }
    
    //弹出提额页面
    IncreaseTypeViewController *presentVC = [IncreaseTypeViewController viewController];
    presentVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    // 核心代码
    self.definesPresentationContext = YES;
    // 可以使用的Style
    // UIModalPresentationOverCurrentContext
    // UIModalPresentationOverFullScreen
    // UIModalPresentationCustom
    // 使用其他Style会黑屏
    presentVC.delegate = self;
    presentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:presentVC animated:YES completion:nil];
    
    if (self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 0 && self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 0) {
        [presentVC setupUIWithHuabeiStatus:NO gongjijinStatus:NO];

    }
    else if (self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 4 && self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 4){
        //公积金提额失败
        [presentVC setupUIWithHuabeiStatus:YES gongjijinStatus:YES];

    }
    else if (self.homeStatusModel.improveCreditStatus.gongjijinCreditStatus == 4){
        //公积金提额失败
        [presentVC setupUIWithHuabeiStatus:NO gongjijinStatus:YES];

    }
    else if (self.homeStatusModel.improveCreditStatus.antsChantFlowersCreditStatus == 4){
        //花呗失败
        [presentVC setupUIWithHuabeiStatus:YES gongjijinStatus:NO];

    }
    
}

#pragma mark - 开始申请beginApply
- (void)startApplyWithStatus:(ApplySource)source
{
    BOOL isLogin = [UserModel isLoggedIn];
    if (!isLogin) {
        [[JCRouter shareRouter] presentURL:@"login" withNavigationClass:[AppNavigationController class] completion:nil];
        return;
    }
    if (source == applySource_All) {
        [JJVersionSourceManager versionSourceManager].versionSource = @"0";
        [[JJHomeStatusRouterManager homeStatusRouterManager] dealWithStatus:HomeStatus_NoAmount data:self.homeStatusModel];
        return;//不需要操作
    }
    [[JJVersionSourceManager versionSourceManager] startFastApplyWithView:self.view];
}


#pragma mark - 再贷决策
- (void)reCredit
{
    if (self.homeStatusModel.summary.reApply == 2) {
        if ([self.homeStatusModel.summary.isMemberShip isEqualToString:@"1"]) {
            JJReCreditRequest *request = [[JJReCreditRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
            __weak __typeof(self)weakSelf = self;
            [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                NSDictionary *result = request.responseJSONObject;
                if ([[result safeObjectForKey:@"success"] boolValue]) {
                    NSDictionary * dataDic = [result safeObjectForKey:@"data"];
                    NSInteger applyStep = [[dataDic safeObjectForKey:@"applyStep"] integerValue];
                    NSInteger intervalSecond = [[dataDic safeObjectForKey:@"intervalSecond"] integerValue];
                    if (applyStep == 34) {
                        //切换账号的时候cancel掉定时器
                        if (strongSelf.previewTimer) {
                            [strongSelf.previewTimer invalidate];
                        }
                        strongSelf.previewTimer = [NSTimer scheduledTimerWithTimeInterval:intervalSecond target:self selector:@selector(reCredit) userInfo:nil repeats:NO];
                        
                    }else{
                        if (strongSelf.previewTimer) {
                            [strongSelf.previewTimer invalidate];
                        }
                    }
                    
                }else{
                    
                    if (!VV_IS_NIL(result[@"message"])) {
                        [VLToast showWithText:result[@"message"]];
                    }
                }
                
            } failure:^(__kindof KZBaseRequest *request, NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 用户信息
-(void)getCustomersOrderDetailsWithAccountId{
    [[VVNetWorkUtility netUtility] getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            VVOrderInfoModel *orderInfo = nil;
            NSDictionary *resultData = [result safeObjectForKey:@"data"];
            orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.orderInfo = orderInfo;
             _mobileBillId =  orderInfo.mobileBillId;
            
            
            //2,34调手机账单
            __weak __typeof(self)weakSelf = self;
            if (([orderInfo.applyStatusCode integerValue] == 2) || ([orderInfo.applyStatusCode  integerValue]== 34)) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf crawlerStateTimerRunLoop];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];

}

-(void)crawlerStateTimerRunLoop{
    if(_crawlerStateTimer)[ _crawlerStateTimer invalidate];
    _crawlerStateTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(queryMobileGetCrawlerState:) userInfo:nil repeats:YES];
    [_crawlerStateTimer fire];
}

#pragma mark - 手机账单
//获取手机采集状态抓单http://10.138.60.43:7008/mobile/query/GetCrawlerStateById/Json
- (void)queryMobileGetCrawlerState:(void (^)( BOOL succ))success{
    VVLog(@"查询手机账单");
    
    NSString *mobileBillId = VV_SHDAT.orderInfo.mobileBillId;
    
    if (nil == mobileBillId) {
        [VLToast showWithText:@"未获取手机账单，请重新获取"];
        
        return;
    }
    NSDictionary *dic = @{@"id":mobileBillId
                          };
    
    NSString *str = [dic mj_JSONString];
    NSString *base64 = [str base64EncodedString];
    VVLog(@"base64 ==%@",base64);
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postMobileQueryGetCrawlerStateByIdSoapMessage:base64 success:^(id result)
     {
         
         NSDictionary *rsultDic = (NSDictionary *)result;
         
         if ([rsultDic[@"StatusCode"]integerValue] == 0) {
             NSString *mobileRsult = rsultDic[@"Result"];
             NSDictionary *mobileDic = [mobileRsult mj_JSONObject];
             if([mobileDic[@"Code"]integerValue] ==100){ //采集中
                 
             }else if([mobileDic[@"Code"]integerValue] == 201){//成功
                 [_crawlerStateTimer invalidate];
                
                 __strong __typeof(weakSelf)strongSelf = weakSelf;
                 [strongSelf setMobieBillResultsuccess:^(id result) {
                     
                 } failure:^(NSError *error) {
                     
                 }];
                 
             }else{ //告诉后台去抓账单
//                 [self getAddMobileBillRecord:^(BOOL succ) {
//                     
//                 }];
             }
             
         }else{
             
         }
         
     } failure:^(NSError *error) {
         
     }];
    
}

-(void)setMobieBillRecord:(void(^)(BOOL succ))success{
    
    [[VVNetWorkUtility netUtility ] getApplySetMobileBillRecordCustomerId:[UserModel currentUser].customerId success:^(id result) {
        VVLog(@"特殊跳setMobileBillRecord");
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            if (success) {
                success(YES);
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)setMobieBillResultsuccess:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    
    [[VVNetWorkUtility netUtility] getApplySetMobileBillResultCustomerId:[UserModel currentUser].customerId Result:@"1" success:^(id result) {
        VVLog(@"特殊跳setMobileBillResult");
        if (success) {
            success(result);
        }
        [self postApplyPreview:^(BOOL succ) {
            
        }];
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//-(void)getAddMobileBillRecord:(void (^)( BOOL succ))success{
//    
//    [[VVNetWorkUtility netUtility] getAddMobileBillRecordCustomerId:[UserModel currentUser].customerId success:^(id result) {
//        
//        if ([[result safeObjectForKey:@"success"] boolValue]) {
//            
//            NSDictionary *dic =  [result safeObjectForKey:@"data"];
//            NSInteger applyTimes  = [dic[@"applyTimes"] integerValue] ;
//            NSInteger status = [dic[@"status"] integerValue];
//            
//            
//                if (applyTimes == 0) {
//                    
//                    [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"是否授权获取手机账单" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"是"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                        if (buttonIndex != kCancelButtonTag) {
//                            [MobClick event:@"authorization_preview"];
//                            [alertView hideAnimated:YES];
//
//                            if (status == 1) { //成功  调预审
//                                [self postApplyPreview:^(BOOL succ) {
//                                    
//                                }];
//                            }else if (status == 2){//失败
//                                
//                                [self getAddMobileBillRecord:^(BOOL succ) {
//                                    
//                                }];
//                                
//                            }else if (status == 0){//调取中  不处理
//                                
//                            }
//                        }
//                    }];
//                    
//                }else if (applyTimes > 1){  //成功applyTimes 结束 失败 走过1 所以大于1
//                    
//                            if (status == 1) { //成功  调预审
//                                [self postApplyPreview:^(BOOL succ) {
//                                    
//                                }];
//                                
//                            }else if (status == 2){//失败 不处理
//                                
//                            }else if (status == 0){//调取中  不处理
//                                
//                            }
//                }
//    
//        }else{
//            
//            if (!VV_IS_NIL(result[@"message"])) {
//                [VLToast showWithText:result[@"message"]];
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        [VLToast showWithText:[self strFromErrCode:error]];
//
//    }];
//    
//    
//}
//
-(void)postApplyPreview:(void (^)( BOOL succ))success{
    [MobClick event:@"apply_preview"];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postApplyPreviewCustomerId:[UserModel currentUser].customerId success:^(id result) {
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
           NSDictionary * dataDic = [result safeObjectForKey:@"data"];
            NSInteger applyStep = [[dataDic safeObjectForKey:@"applyStep"] integerValue];
            NSInteger intervalSecond = [[dataDic safeObjectForKey:@"intervalSecond"] integerValue];
            if ((applyStep == 2 )|| (applyStep == 34 ) ) {
                //切换账号的时候cancel掉定时器
                if (strongSelf.previewTimer) {
                    [strongSelf.previewTimer invalidate];
                }
                strongSelf.previewTimer = [NSTimer scheduledTimerWithTimeInterval:intervalSecond target:self selector:@selector(postApplyPreview:) userInfo:nil repeats:NO];
                
            }else{
                if (strongSelf.previewTimer) {
                    [strongSelf.previewTimer invalidate];
                }
            }
            
        }else{
            
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 通知
- (void)updateRightStatus:(NSNotification *)noti
{
    VVLog(@"=====%@",noti.object);
    NSDictionary *dict = noti.object;
    NSString *show = [dict safeObjectForKey:@"showRightCount"];
    if ([show boolValue]) {
        self.countLabel.hidden = NO;
    }else{
        self.countLabel.hidden = YES;
    }
}

- (void)cancelTimer:(NSNotification *)noti
{
    [self.previewTimer invalidate];
    [self.crawlerStateTimer invalidate];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    VVLog(@"---点击了第%ld张图片", (long)index);
#ifdef JIELEHUAQUICK
    if ([JJReviewManager reviewManager].reviewing) {
        return;
    }
#endif

    if (self.bannerModel != nil) {
        if (nil == [self.bannerModel.data objectAtIndex:index].pageUrl) {
            return;
        }
        VVWebAppViewController *webVC = [[VVWebAppViewController alloc] init];
        webVC.startPage = [self.bannerModel.data objectAtIndex:index].pageUrl;
        [self customPushViewController:webVC withType:nil subType:nil];
    }else{
        return;
    }
}

#pragma mark - 首页花花精选
- (void)showWebview
{
    self.navigationBar.hidden = NO;
    if (webview == nil) {
        webview = [[VVWebView alloc] initWithFrame:self.view.frame];
    }
    webview.hidden = NO;
    webview.y = 64;
    webview.height = self.view.frame.size.height - 64 - 49;
    //http://jlhpredeploy.vcash.cn/webapp/market.html?day=***
    NSString *webUrl = [NSString stringWithFormat:@"%@/market.html?day=%@",WEB_BASE_URL,@(self.homeStatusModel.summary.lockDays)];
    webview.delegate = self;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    [_scrollView addSubview:webview];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webview canGoBack])
    {
        self.btnBack.hidden = NO;
    }else{
        self.btnBack.hidden = YES;
    }
}

- (void)backAction:(id)sender
{
    [self goBack];
}


- (void)goBack
{
    if ([webview canGoBack])
    {
        [webview goBack];
    }else{
        self.btnBack.hidden = YES;
    }
}


#pragma mark - 传设备号
- (void)postUniqueId
{
    VVLog(@"%@",[VVDeviceUtils vendorIdentifier]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"uuid"] length] == 0) {
        //调用接口
        JJUniqueIdRequest *request = [[JJUniqueIdRequest alloc] initWithCustomerId:[UserModel currentUser].customerId deviceId:[VVDeviceUtils vendorIdentifier]];
        [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
            JJBaseResponseModel *model = [(JJUniqueIdRequest *)request response];
            if (model.success) {
                [defaults setObject:@"已传" forKey:@"uuid"];
                [defaults synchronize];
            }
        } failure:^(__kindof KZBaseRequest *request, NSError *error) {
            
        }];
    }
}
//提额
#pragma IncreaseTypeDelegate
- (void)chooseType:(IncreaseType)type
{
    if (type == IncreaseType_Huabei) {
        [[JCRouter shareRouter] pushURL:@"huabei/1"];
    }else{
        //
        //        [VVAlertUtils showAlertViewWithTitle:@"" message:@"即将开放，敬请期待" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
        //            [alertView hideAlertViewAnimated:YES];
        //        }];
        [[JCRouter shareRouter] pushURL:@"housing"];
    }
}

#pragma mark - 会员特权弹窗
- (void)showVipTipView
{
    //非会员+需要弹框+生命周期首次(该账号)
    if (![self.homeStatusModel.data.isMemberShip isEqualToString:@"1"] && ![JJHomeVipShowManager homeVipShowManager].isVipShowed && [self.homeStatusModel.data.memberShipFeeReminder isEqualToString:@"1"] && self.homeStatusModel.summary.applyStatus != 5) {
        JJPayVipViewController *payVipVC = [JJPayVipViewController viewController];
        payVipVC.payVipActionBlock = ^{
            VVLog(@"点击开通会员");
            [[JCRouter shareRouter] pushURL:@"memberArgeement" extraParams:@{@"isDrawWebPage":@"0"}];
        };
        payVipVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.definesPresentationContext = YES;
        payVipVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.navigationController presentViewController:payVipVC animated:YES completion:nil];
        [JJHomeVipShowManager homeVipShowManager].isVipShowed = YES;
        return;
    }
}

#pragma mark - 弹出会员开通提示框
#pragma mark 显示弹框
- (void)showPopAnimationWithAnimationStyle:(NSInteger)style money:(NSString *)money
{
    if ([self.homeStatusModel.data.isMemberShip isEqualToString:@"1"] ) {
        return;
    }
    style = 3;
    ZJAnimationPopStyle popStyle = (style == 8) ? ZJAnimationPopStyleCardDropFromLeft : (ZJAnimationPopStyle)style;
    ZJAnimationDismissStyle dismissStyle = (ZJAnimationDismissStyle)style;
    
    _customView = [JJGoToPayView xibView];
    
    if (money.intValue < 30000) {
        NSString *thirdString = @"您可再次提额，最高3万元额度";
        NSMutableAttributedString *thirdAttriString = [[NSMutableAttributedString alloc] initWithString:thirdString];
        [thirdAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 4)];
        [thirdAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9, 3)];
        [thirdAttriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(9, 3)];
        [thirdAttriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(2, 4)];
        _customView.thirdLabel.attributedText = thirdAttriString;
    }else{
        NSString *thirdString = @"再贷无需等待30天";
        NSMutableAttributedString *thirdAttriString = [[NSMutableAttributedString alloc] initWithString:thirdString];
        [thirdAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 2)];
        [thirdAttriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(6, 2)];
        _customView.thirdLabel.attributedText = thirdAttriString;
        
    }
    
    NSString *string = [NSString stringWithFormat:@"成功获得%@元额度",money];
    NSMutableAttributedString *firstAttriString = [[NSMutableAttributedString alloc] initWithString:string];
    [firstAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, money.length+1)];
    [firstAttriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(4, money.length+1)];
    _customView.firstLabel.attributedText = firstAttriString;
    
    NSString *secondString = @"即刻成为优享会员";
    NSMutableAttributedString *secondAttriString = [[NSMutableAttributedString alloc] initWithString:secondString];
    [secondAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, 4)];
    [secondAttriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(4, 4)];
    _customView.secondLabel.attributedText = secondAttriString;
    
    // 1.初始化
    ZJAnimationPopView *popView = [[ZJAnimationPopView alloc] initWithCustomView:_customView popStyle:popStyle dismissStyle:dismissStyle];
    
    // 2.设置属性，可不设置使用默认值，见注解
    // 2.1 显示时点击背景是否移除弹框
    popView.isClickBGDismiss = YES;
    // 2.2 显示时背景的透明度
    popView.popBGAlpha = 0.5f;
    // 2.3 显示时是否监听屏幕旋转
    popView.isObserverOrientationChange = YES;
    // 2.4 显示时动画时长
    //    popView.popAnimationDuration = 0.8f;
    // 2.5 移除时动画时长
    //    popView.dismissAnimationDuration = 0.8f;
    
    // 2.6 显示完成回调
    popView.popComplete = ^{
        NSLog(@"显示完成");
    };
    // 2.7 移除完成回调
    popView.dismissComplete = ^{
        NSLog(@"移除完成");
    };
    
    // 3.处理自定义视图操作事件
    [self handleCustomActionEnvent:popView];
    
    // 4.显示弹框
    [popView pop];
}

#pragma mark 处理自定义视图操作事件
- (void)handleCustomActionEnvent:(ZJAnimationPopView *)popView
{
    // 在监听自定义视图的block操作事件时，要使用弱对象来避免循环引用
    __weak typeof(popView) weakPopView = popView;
    JJGoToPayView *infoPopView = _customView;
    infoPopView.closeActionBlock = ^{
        [weakPopView dismiss];
    };
    infoPopView.payVipActionBlock = ^{
        [weakPopView dismiss];
        VVLog(@"点击开通会员");
        [[JCRouter shareRouter] pushURL:@"memberArgeement" extraParams:@{@"isDrawWebPage":@"0"}];
    };
}

@end
