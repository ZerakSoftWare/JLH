//
//  VVLoanAplicationProcessViewController.m
//  O2oApp
//
//  Created by chenlei on 16/11/2.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVLoanAplicationProcessViewController.h"
#import "VVLoanAplicationProcessView.h"
#import "VVLoanBaseInfoView.h"
#import "VVLoanMobileView.h"
#import "VVLoanCreditView.h"

#import "VVBasicInfoResultViewController.h"
#import "VVBasePreviewView.h"

#import "JJMobileBillController.h"

#define ktextFieldLeft 20
#define ktextFieldheight 46
@interface VVLoanAplicationProcessViewController ()<VVLoanAplicationProcessViewDelagate,VVLoanBaseInfoViewDelagate,VVLoanMobileViewDelagate,VVLoanCreditViewDelagate>
{
    VVLoanAplicationProcessView *_loanView;
    enum ApplyType _showApplyType;//缓存当前页面步骤
    VVLoanBaseInfoView *_baseView;
    VVLoanMobileView *_mobileView;
    VVLoanCreditView *_creditView;
    UIView * _revisionsView;
    UIView * _remindbackView;
    BOOL _keyboardIsVisible ;
    UIView *_publicView;

}
@property(nonatomic,strong) UIView * remindbackView;
@property(nonatomic,strong)VVLoanBaseInfoView *baseView;
@property(nonatomic,strong) VVLoanMobileView *mobileView;
@property(nonatomic,strong)VVLoanCreditView *creditView;

@end

@implementation VVLoanAplicationProcessViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {

    }
    return self;
}

- (void)dealloc{
    [VV_NC removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _scrollView.multipleTouchEnabled = NO;//禁止多点触摸

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"贷款申请"];
    [self addBackButton];
    [self setStepView];
    [self headRemindView];
    [self showStepViewType:(enum ApplyType)[VV_SHDAT.orderInfo.applyStatusCode integerValue]];
    [VV_NC addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)headRemindView{
    UIView *remindbackView = [[UIView alloc]init];//    remindbackView.backgroundColor = VV_COL_RGB(0xf1f1f1);
    remindbackView.backgroundColor =  VV_COL_RGB(0xf1f1f1);
    [_scrollView addSubview:remindbackView];
    remindbackView.frame = CGRectMake(0, _loanView.bottom, kScreenWidth, 40);
    _remindbackView = remindbackView;

    UILabel *remindLabel = [[UILabel alloc]init];
    remindLabel.text = @"＊ 请填写真实信息，有利于额度审批成功";
    remindLabel.numberOfLines = 0;
    remindLabel.textColor = [UIColor redColor];
    remindLabel.font = [UIFont systemFontOfSize:14.0];
    [remindLabel sizeToFit];
    remindLabel.frame = CGRectMake(15, 12, kScreenWidth-15, 15);
    [_remindbackView addSubview:remindLabel];
    VVLog(@"_remindbackView height %f",_revisionsView.height);
    
}

//返回修改预览
- (void)revisionsBackView{
    _revisionsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _baseView.nextBtn.hidden = YES;
    if (_showApplyType == applyTypeBase) {
        _baseView.nextBtn.hidden = YES;
        _publicView = _baseView;
        _revisionsView.height = _baseView.height;

    }else if(_showApplyType == applyTypeMobileVerification){
        _mobileView.nextBtn.hidden = YES;
        _revisionsView.height = _mobileView.height;
        _publicView = _mobileView;

    }else{
        _creditView.nextBtn.hidden = NO;
        _revisionsView.height = _creditView.height;
        _publicView = _creditView;

    }
    _revisionsView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [_publicView addSubview:_revisionsView];
    VVCommonButton *changeBtn = [VVCommonButton solidButtonWithTitle:@"修改"];
    changeBtn.frame = CGRectMake(VVleftMargin,_revisionsView.height-56 , kScreenWidth-VVleftMargin*2, VVBtnHeight);
    [changeBtn addTarget:self action:@selector(revisionsViewBtn) forControlEvents:UIControlEventTouchUpInside];
    [changeBtn setUserInteractionEnabled:YES];
    changeBtn.selected = YES;
    [_revisionsView addSubview:changeBtn];
    _publicView.frame = CGRectMake(0, _remindbackView.bottom, kScreenWidth, changeBtn.y+50);
}
//返回修改按钮
- (void)revisionsViewBtn{
    _revisionsView.hidden = YES;
    [_revisionsView removeFromSuperview];
    if (_showApplyType == applyTypeBase) {
//        UIView *customView = [VVBasePreviewView basePreview:[_baseView transforModel]];
//        [VVAlertUtils showAlertViewWithTitle:@"请核对您的基本信息" message:nil customView:customView cancelButtonTitle:@"修改" otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex != kCancelButtonTag) {
//                [alertView hideAlertViewAnimated:YES];
//                NSDictionary *dic = @{@"applyStep":VV_SHDAT.orderInfo.applyStep,@"orderStatus":@"1"};
//                [self orderInfoPush:dic];
//            }else{
//                _baseView.nextBtn.hidden = NO;
//            }
//        }];
         _baseView.nextBtn.hidden = NO;

        [MobClick event:@"back_basic_info"];
        
    }else if(_showApplyType == applyTypeMobileVerification){
        VV_SHDAT.creditBaseInfoModel.idcardImageObverse = nil;
        VV_SHDAT.creditBaseInfoModel.idcardImageReverse = nil;
        _mobileView.nextBtn.hidden = NO;
        [_mobileView showMobileNextView:YES];
        [MobClick event:@"back_authentication"];
    }else{
        _creditView.nextBtn.hidden = NO;
    }
}

- (void)setStepView{
    _loanView = [[VVLoanAplicationProcessView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    _loanView.backgroundColor = VVWhiteColor;
    _loanView.loanAppProcessDelagate = self;
    [_scrollView addSubview:_loanView];
}

- (VVLoanBaseInfoView *)baseView{
    if (!_baseView) {
        _baseView = [[VVLoanBaseInfoView alloc]initWithFrame:CGRectMake(0, 105, kScreenWidth, kScreenHeight-_remindbackView.bottom)];
        _baseView.controller = self;
        _baseView.loanBaseInfoDelagate = self;
        [_scrollView addSubview:_baseView];
    }
    return _baseView;
}

- (VVLoanMobileView *)mobileView{
    if (!_mobileView) {
        _mobileView = [[VVLoanMobileView alloc]initWithFrame:CGRectMake(0, 105, kScreenWidth, kScreenHeight-_remindbackView.bottom)];
        _mobileView.controller = self;
        _mobileView.loanMobileViewDelagate = self;
        [_scrollView addSubview:_mobileView];
    }
    return _mobileView;
}

- (VVLoanCreditView *)creditView{
    if (!_creditView) {
        _creditView = [[VVLoanCreditView alloc]initWithFrame:CGRectMake(0, 105, kScreenWidth, kScreenHeight-_remindbackView.bottom)];
        _creditView.controller = self;
        _creditView.loanCreditDelagate = self;
        [_scrollView addSubview:_creditView];
    }
    return _creditView;
}

//基本信息页
- (void)showBaseView{
//    VVLoanBaseInfoView *view = self.baseView;
    [self.baseView basicInformationView];
}

// 手机账单页
- (void)showMobileView{

//    VVLoanMobileView *view = self.mobileView;
    [self.mobileView showMobileNextView:NO];
    [self.mobileView showBackPreviewShowMobileNextView];
    
}

//征信页
- (void)showCreditLoginView{
//    VVLoanCreditView *view = self.creditView;
    [self.creditView showCreditSubView];
}

#pragma mark  ＝代理 loanAppProcessDelagate
- (void)clickApplicationStep:(enum ApplyType)showViewType {
    if (_keyboardIsVisible) {
        VVLog(@"先隐藏键盘");
        [self hideKeyboard];
        return;
    }
    VVLog(@"点击标题步骤：%d",showViewType);
    [self showStepViewType:showViewType];
    if ((_showApplyType < [VV_SHDAT.orderInfo.applyStatusCode integerValue]&& _showApplyType < applyTypeCredit )|| ([VV_SHDAT.orderInfo.applyStatusCode integerValue] == 15 && _showApplyType == 16)) {
        [self revisionsBackView];
    }
}


-(void)enterLoanCreditView{
    //通知能点18步骤
    VV_SHDAT.orderInfo.applyStatusCode = @"18";
    [self showStepViewType:applyTypeCredit];

}

-(void)enterLoanMobileView{
    //通知能点17步骤
    VV_SHDAT.orderInfo.applyStatusCode = @"17";
    [self showStepViewType:applyTypeMobileVerification];

}

-(void)enterHomeView{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)postCreditInfo:(NSDictionary *)infoDic{
    
    NSString *str = infoDic[@"message"];
    if ([infoDic[@"code"] integerValue] > 700&&[infoDic[@"code"] integerValue] <= 800) {
        [self pushResultVc:infoDic[@"message"] code:infoDic[@"code"]];
    }else if([infoDic[@"code"] integerValue] == 200){

        VVLog(@" 征信 VV_SHDAT.orderInfo.applyStep :%@",VV_SHDAT.orderInfo.applyStep);
        NSDictionary *dic = infoDic[@"data"];
        NSString *message = dic[@"message"];

        if( VV_IS_NIL(message)){
            [self orderInfoPush:dic];
        }else{
            [VVAlertUtils showAlertViewWithMessage:message cancelButtonTitle:@"确定" tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                [self orderInfoPush:dic];
            }];
        }

    }else if([infoDic[@"code"] integerValue] >=600&&[infoDic[@"code"] integerValue] <700){
        [VVAlertUtils showAlertViewWithMessage:str cancelButtonTitle:@"确定" tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            
        }];
    }
}



#pragma mark  根据订单状态 跳转界面
- (void)orderInfoPush:(NSDictionary *)dic{
    VVOrderInfoModel *order;
    if (dic.count>0) {
        order = [VVOrderInfoModel  mj_objectWithKeyValues:[VV_SHDAT.orderInfo mj_keyValues]];
        order.applyStep = dic[@"applyStep"];
        order.orderStatus = dic[@"orderStatus"];
        if (_showApplyType == [order.applyStep integerValue]) {
            return;
        }
        VV_SHDAT.orderInfo = order;
    }else{
        return;
    }
    //跳转到移动账单  初始化移动账单信息
}

- (void)pushResultVc:(NSString *)message code:(NSString*)code{
    VVBasicInfoResultViewController *messageVc = [[VVBasicInfoResultViewController alloc]init];
    messageVc.btnHidden = YES;
    messageVc.qrHidden = YES;
    messageVc.image = VV_GETIMG(@"refuse");
    messageVc.lableTop = 80;
    messageVc.titleStr = message;
    if ([code integerValue]==702) {
        messageVc.noStore = @"702";
    }
    [self customPushViewController:messageVc withType:nil subType:nil];
    
}
#pragma mark  跳转到手机账单控制器
-(void)pushMobileBillController{
//    [[JCRouter shareRouter]pushURL:@"mobileBillController"];
    JJMobileBillController *mobileVc = [[JJMobileBillController alloc]init];
    [self customPushViewController:mobileVc withType:nil subType:nil];
}

#pragma mark  跳转到首页
-(void)returnToHomeViewController{
    [[JCRouter shareRouter]popToRootViewControllerAnimated:YES];
    
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    _keyboardIsVisible = YES;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
    _keyboardIsVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender
{
    [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"您确定返回，不继续填写贷款申请" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != kCancelButtonTag) {
            [alertView hideAlertViewAnimated:YES];
            [[JCRouter shareRouter] popToRootViewControllerAnimated:YES];
        }
    }];
}

//显示某个页面
- (void)showStepViewType:(enum ApplyType)showViewType {
    if (_baseView) {
        [self.baseView removeFromSuperview];
        self.baseView = nil;
    }
    if (_mobileView) {
        [self.mobileView removeFromSuperview];
        self.mobileView = nil;
    }
    if (_creditView) {
        [self.creditView removeFromSuperview];
        self.creditView = nil;
    }
    
    [self hideKeyboard];
    [_loanView changeStepViewStatus:showViewType];
    _showApplyType = showViewType;
    switch (showViewType) {
        case applyTypeBase:{
            VVLog(@"申请流程：基本信息");
            [self showBaseView];
        }
            break;
        case applyTypeMobileVerification :{
            VVLog(@"申请流程：授权 手机账单");
            [self showMobileView];
        }
            break;
        case applyTypeCredit:{
            VVLog(@"申请流程： 手机账单不可点击");
            [self showCreditLoginView];
        }
            break;
        case applyTypeZhimaScore:{
            [self showMobileView];
            VVLog(@"申请流程： 芝麻信用");
            
        }
        default:
            break;
    }
}

-(void)postBaseInfoNextStep:(NSString *)step{
    [self showStepViewType: (enum ApplyType)[step integerValue]];
}

-(void)postMobileNextStep:(NSString *)step{
    [self showStepViewType: (enum ApplyType)[step integerValue]];
}

@end
