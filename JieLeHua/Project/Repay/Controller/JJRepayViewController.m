//
//  JJRepayViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJRepayViewController.h"
#import "JJOverDueViewController.h"
#import "JJAdvCloanViewController.h"
#import "JJPayOverDateBillRequest.h"
#import "JJOverDueListModel.h"
#import "JJConfirmAdvCloanRequest.h"
#import "JJCloanInfoModel.h"
#import "JJRepayInfoRequest.h"
#import "IntroduceToolbarView.h"


@interface JJRepayViewController ()<IntroduceToolbarViewDelegate,JJOverDueViewControllerUpdateDelegate,JJAdvCloanViewControllerUpdateDelegate>
@property (nonatomic, strong) IntroduceToolbarView *toolbarView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBtn;
@property (weak, nonatomic) IBOutlet UILabel *repayMoneyLabel;
@property (nonatomic, strong) JJOverDueViewController *overdueVC;
@property (nonatomic, strong) JJAdvCloanViewController *advCloanVC;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, assign) BOOL showBottomInOverdue;
@property (nonatomic, assign) BOOL showBottomInAdv;

@property (nonatomic, assign) float overdueMoney;
@property (nonatomic, assign) float advMoney;

@end

@implementation JJRepayViewController
+ (id)allocWithRouterParams:(NSDictionary *)params {
    JJRepayViewController *instance = [[UIStoryboard storyboardWithName:@"RepayView" bundle:nil] instantiateViewControllerWithIdentifier:@"RepayView"];
    instance.status = [params objectForKey:@"status"];
    return instance;
}

-(void)dealloc{
    [VV_NC removeObserver:self name:@"overdueNotifcation" object:nil];
}

- (IntroduceToolbarView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [[IntroduceToolbarView alloc] initWithFrame:CGRectMake(0, 17, 188, 32)];
        _toolbarView.delegate = self;
        _toolbarView.lightColor = VVColor(75, 231, 243);
        _toolbarView.deepColor = VVColor(88, 152, 242);
        _toolbarView.backColor = VVColor(232, 236, 239);
        _toolbarView.layer.cornerRadius = 16;
        _toolbarView.clipsToBounds = YES;
    }
    return _toolbarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"账单选择"];
    [self addBackButton];
   
    [self.view addSubview:self.overdueVC.view];
    [self.view addSubview:self.advCloanVC.view];
//    [self.view insertSubview:self.topView aboveSubview:_scrollView];
    [self.view insertSubview:self.bottomView aboveSubview:_scrollView];
    [self.view insertSubview:self.overdueVC.view aboveSubview:_scrollView];
    [self.view insertSubview:self.advCloanVC.view aboveSubview:_scrollView];
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_top).offset(64);
//        make.left.mas_equalTo(self.view.mas_left).offset(0);
//        make.right.mas_equalTo(self.view.mas_right).offset(0);
//        make.height.mas_equalTo(@55);
//    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(@48);
    }];
    
    /***************选项组***************/
    
    self.toolbarView.centerX = self.view.centerX;
    NSArray *arry = @[@"逾期还款",@"提前清贷"];
    self.toolbarView.productArr = arry;
    [self.view addSubview:self.toolbarView];
    [self.toolbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (iPhoneX)
        {
            make.top.mas_equalTo(self.view.mas_top).offset(94);
        }else{
            make.top.mas_equalTo(self.view.mas_top).offset(84);
        }
        make.width.mas_offset(@188);
        make.left.mas_equalTo(self.view.mas_left).offset((self.view.size.width-188)/2);
        make.height.mas_equalTo(@0);
    }];

    [self.view insertSubview:self.toolbarView aboveSubview:_scrollView];
    [self.toolbarView setSelectedBtnIndex:0];
    
    
//    [self.segmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.topView);
//        make.centerX.mas_equalTo(self.view);
//        make.width.mas_equalTo(@179);
//        make.height.mas_equalTo(@28);
//    }];
    [_overdueVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toolbarView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
    [_advCloanVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toolbarView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
    [_overdueVC.view layoutIfNeeded];
    [_advCloanVC.view layoutIfNeeded];
    [_repayMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(-12);
    }];
    if ([self.status boolValue]) {
        //提前
        self.overdueVC.view.hidden = YES;
        [self.toolbarView setSelectedBtnIndex:1];
    }else{
        //逾期
        self.advCloanVC.view.hidden = YES;
    }
    // Do any additional setup after loading the view.
    _scrollView.backgroundColor = [UIColor whiteColor];
    [VV_NC addObserver:self selector:@selector(refreashWeb) name:@"overdueNotifcation" object:nil];
}

-(void)refreashWeb{
    [self.overdueVC refreashOverDueView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IntroduceToolbarViewDelegate
- (void)topToolbar:(IntroduceToolbarView *)topToolbar didSelectedTag:(int)tag{
    if (tag == 1) {
        self.advCloanVC.view.hidden = YES;
        self.overdueVC.view.hidden = NO;
        [self updateMoney:self.overdueMoney];
        if (_showBottomInOverdue) {
            self.bottomView.hidden = NO;
        }else{
            self.bottomView.hidden = YES;
        }
    }else{
        self.overdueVC.view.hidden = YES;
        self.advCloanVC.view.hidden = NO;
        [self updateMoney:self.advMoney];
        if (_showBottomInAdv) {
            self.bottomView.hidden = NO;
        }else{
            self.bottomView.hidden = YES;
        }
    }
}


#pragma mark - getter
- (JJOverDueViewController *)overdueVC
{
    if (_overdueVC == nil) {
        _overdueVC = [[JJOverDueViewController alloc] init];
        _overdueVC.delegate = self;
        _overdueVC.customerBillId = self.customerBillId;
    }
    return _overdueVC;
}

- (JJAdvCloanViewController *)advCloanVC
{
    if (_advCloanVC == nil) {
        _advCloanVC = [[JJAdvCloanViewController alloc] init];
        _advCloanVC.delegate = self;
    }
    return _advCloanVC;
}

#pragma mark - Setter
- (void)setShowBottomInAdv:(BOOL)showBottomInAdv
{
    _showBottomInAdv = showBottomInAdv;
    int payTag = (int)self.toolbarView.selectedButton.tag-1989;
    if (payTag == 1){
        if (showBottomInAdv) {
            self.bottomView.hidden = NO;
        }else{
            self.bottomView.hidden = YES;
        }
    }
}

- (void)setShowBottomInOverdue:(BOOL)showBottomInOverdue
{
    _showBottomInOverdue = showBottomInOverdue;
    int payTag = (int)self.toolbarView.selectedButton.tag-1989;
    if (payTag == 0){
        if (showBottomInOverdue) {
            self.bottomView.hidden = NO;
        }else{
            self.bottomView.hidden = YES;
        }
    }
}

#pragma mark - 确认提交
- (IBAction)confirmAction:(id)sender {
    int payTag = (int)self.toolbarView.selectedButton.tag-1989;
    if (payTag == 0)
    {
        [self payOverdue];
    }else{
        [VVAlertUtils showAlertViewWithTitle:@"" message:@"请确认还款银行卡中有足够余额" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex  != kCancelButtonTag) {
                [alertView hideAlertViewAnimated:YES];
                [self payAdvCloan];
            }
        }];
    }
}

#pragma mark - 还款
//逾期还款
- (void)payOverdue
{
    NSString *urlType = @"1";
    JJRepayInfoRequest *request = [[JJRepayInfoRequest alloc]initWithType:urlType];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        JJRepayInfoModel *model = [(JJRepayInfoRequest *)request response];
        if (model.success) {
            
            JJRepayInfoDataModel *data = model.data;
//            NSString *billDate = [NSString stringWithFormat:@"%d/%d期",data.lastBillIndex,data.sumBillIndex];
            NSString *billDate = @"逾期账单";
            NSString *undueBill = [NSString stringWithFormat:@"%.2f元",data.nextBillAmt];
            NSString *dueBill = [NSString stringWithFormat:@"%.2f元",data.dueAmt];
            NSString *payBill = [NSString stringWithFormat:@"%.2f元",data.payAmt];
            NSString *dueProceduresAmt = [NSString stringWithFormat:@"%.2f元",data.dueProceduresAmt];
            NSString *bankAccount = data.bankAccount;
            NSString *showAlert;
            if (!data.isPay) {
                showAlert = @"show";
            }else{
                showAlert = @"";
            }
            NSDictionary *dic = @{@"source":@"homeView",
                                  @"urlType":urlType,
                                  @"billDate":billDate,
                                  @"undueBill":undueBill,
                                  @"dueBill":dueBill,
                                  @"payBill":payBill,
                                  @"dueProceduresAmt":dueProceduresAmt,
                                  @"bankAccount":bankAccount,
                                  @"showAlert":showAlert
                                  };
            [[JCRouter shareRouter]pushURL:@"JJRepaymentOrder" extraParams:dic animated:YES];
        }else{
            [MBProgressHUD showError:model.message];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"调用微信失败，请稍后再试"];
    }];
   
}

//提前清贷
- (void)payAdvCloan
{
    JJConfirmAdvCloanRequest *payReuqest = [[JJConfirmAdvCloanRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [payReuqest addAccessory:accessory];
    [payReuqest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        JJBaseResponseModel *model = [(JJConfirmAdvCloanRequest *)request response];
        if (model.success) {
            [MobClick event:@"confirm_advClean"];
            [MBProgressHUD showSuccess:@"提前清贷中" toView:self.view];
            [self performSelector:@selector(goBack) withObject:nil afterDelay:1.f];
        }else{
            [MBProgressHUD showError:@"操作失败" toView:self.view];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {

    }];
}

#pragma mark - JJOverDueViewControllerUpdateDelegate
- (void)updateWithData:(JJOverDueListModel *)data isFail:(BOOL)failed
{
    if (failed) {
        self.showBottomInOverdue = NO;
        return;
    }else{
        self.showBottomInOverdue = YES;
    }
    float dueMoney = 0.00;
    for (JJOverDueListDataModel *model in data.data) {
        dueMoney = dueMoney + model.dueSumamt;
    }
    self.overdueMoney = dueMoney;
    int payTag = (int)self.toolbarView.selectedButton.tag-1989;
    if (payTag == 0) {
        [self updateMoney:self.overdueMoney];
    }
}

#pragma mark - JJAdvCloanViewControllerUpdateDelegate
- (void)updateWithAdvData:(JJCloanInfoModel *)data isFail:(BOOL)failed
{
    if (failed) {
        self.showBottomInAdv = NO;
        return;
    }else{
        self.showBottomInAdv = YES;
    }
    float dueMoney = 0;
    for (JJCloanInfoDetailModel *model in data.data.CloanInfo) {
        dueMoney = dueMoney + model.Amt;
    }
    self.advMoney = dueMoney;
    int payTag = (int)self.toolbarView.selectedButton.tag-1989;
    if (payTag == 1) {
        [self updateMoney:self.advMoney];
    }
}

- (void)updateMoney:(float)dueMoney
{
    NSString *string = [NSString stringWithFormat:@"待支付%.2f元",dueMoney];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff3131"] range:NSMakeRange(3, string.length-4)];
    self.repayMoneyLabel.attributedText = attriString;
}

#pragma mark - 返回
- (void)goBack
{
    [[JCRouter shareRouter] popToRootViewControllerAnimated:YES];
}

@end
