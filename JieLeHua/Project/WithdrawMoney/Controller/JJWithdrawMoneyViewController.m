//
//  JJWithdrawMoneyViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJWithdrawMoneyViewController.h"
#import "VVPickerView.h"
#import "IQUIView+Hierarchy.h"
#import "JJGetDrawBaseInfoRequest.h"
#import "JJGetLoanSimBillDetailsRequest.h"
#import "JJSubbmitDrawMoneyRequest.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"

@interface JJWithdrawMoneyViewController ()<UITableViewDelegate, UITableViewDataSource,VVPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UITableView *withdrawMoneyTable;
@property (nonatomic, assign) BOOL isEdited;

@property (nonatomic, strong) JJDrawModel *drawInfoModel;
@property (nonatomic, strong) JJLoanBillDetailModel *detailModel;


//@property (nonatomic, copy) NSString *miniValue;
@property (nonatomic, copy) NSString *drawMoney;
///期数
@property (nonatomic, copy) NSString *period;
///期数选择
@property (nonatomic, copy) NSArray *periodArray;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, copy) NSString *cardId;

@end

@implementation JJWithdrawMoneyViewController
+ (id)allocWithRouterParams:(NSDictionary *)params {
    JJWithdrawMoneyViewController *instance = [[UIStoryboard storyboardWithName:@"WithdrawMoney" bundle:nil] instantiateViewControllerWithIdentifier:@"WithdrawMoney"];
    VVLog(@"%@", params);
    instance.maxMoney = [params safeObjectForKey:@"maxMoney"];
    return instance;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.miniValue = @"3000";
    self.periodArray = @[@"3",@"6",@"12",@"24"];
    [self setNavigationBarTitle:@"额度提现"];
    [self addBackButton];
    [self.view insertSubview:self.withdrawMoneyTable aboveSubview:_scrollView];
    [self.view insertSubview:self.bottomView aboveSubview:_scrollView];
    [self addReloadTarget:self action:@selector(reloadData)];
    [self.submitBtn setBackgroundColor:[UIColor unableButtonThemeColor] forState:UIControlStateDisabled];
    [self.submitBtn setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    self.submitBtn.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark - 网络请求
- (void)reloadData
{
    [self hiddenFailLoadViewView];
    [self getDrawBaseInfo];
}

///获取提现基本信息
- (void)getDrawBaseInfo{
    JJGetDrawBaseInfoRequest *request = [[JJGetDrawBaseInfoRequest alloc] init];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJDrawModel *model = [(JJGetDrawBaseInfoRequest *)request response];
        if (model.success) {
            [strongSelf hiddenFailLoadViewView];
            strongSelf.drawInfoModel = model;
            strongSelf.maxMoney = [NSString stringWithFormat:@"%.f",model.data.creditMoney];
        }else{
            [strongSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
    }];
}

///查询账单信息
- (void)getLoanSimBillDetails
{
    //proceduresRate是手续费
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.drawInfoModel.data.interestRate?self.drawInfoModel.data.interestRate:@"0",@"InterestRate",
                           self.drawMoney,@"LoanCapital",
                           self.period,@"LoanPeriod",
                           self.drawInfoModel.data.loanTime?self.drawInfoModel.data.loanTime:@"",@"LoanTime",
                           self.drawInfoModel.data.proceduresRate?self.drawInfoModel.data.proceduresRate:@"0",@"ProceduresRate",
                           self.drawInfoModel.data.serviceRate?self.drawInfoModel.data.serviceRate:@"0",@"ServiceRate",
                           nil];
    JJGetLoanSimBillDetailsRequest *request = [[JJGetLoanSimBillDetailsRequest alloc] initWithParam:param];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        JJLoanBillDetailModel *model = [(JJGetLoanSimBillDetailsRequest *)request response];
        //刷新页面
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (model.success) {
            strongSelf.detailModel = model;
            strongSelf.submitBtn.enabled = YES;
            [strongSelf.withdrawMoneyTable reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            [strongSelf.withdrawMoneyTable reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            strongSelf.submitBtn.enabled = NO;
        }
        
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.submitBtn.enabled = NO;
    }];
}

//提交提现申请
- (void)subbmitDrawMoney
{
    if (self.period == nil) {
        [MBProgressHUD showError:@"请选择期数" toView:self.view];
        return;
    }
    /** 提现金额  */
//    private Float drawMoney;
    /** 贷款期限  */
//    private String postLoanPeriod;
    /** 每月还款  */
//    private Float monthRepayMoney;
    /** 手续费  */
//    private Float brokerageMoney;
    
    //先判断是否有银行卡，没有即跳转到添加银行卡页面
    NSString *billDate = [self.detailModel.data firstObject].BillDate;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [(JJLoanBillDetailDataModel *)[self.detailModel.data firstObject] Procedures],@"brokerageMoney",
                           [UserModel currentUser].customerId,@"customerId",
                           self.drawMoney,@"drawMoney",
                           [(JJLoanBillDetailDataModel *)[self.detailModel.data objectAtIndex:1] SumFee],@"monthRepayMoney",
                           self.period,@"postLoanPeriod",
                           billDate,@"billDate",
                           nil];
    JJSubbmitDrawMoneyRequest *request = [[JJSubbmitDrawMoneyRequest alloc] initWithParam:param];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJBaseResponseModel *model = [(JJSubbmitDrawMoneyRequest *)request response];
        if (model.success) {
            [MobClick event:@"subbmit_drawMoney"];
//            [[JCRouter shareRouter] popToRootViewControllerAnimated:YES];
            if (strongSelf.drawInfoModel.data.bankCode == nil) {
                //添加银行卡，判断是否有银行卡,有就去重新签名
                [[JCRouter shareRouter]pushURL:@"addBankCard"];
                return;
            }else{
                [MBProgressHUD showSuccess:@"提现申请成功"];
                [strongSelf getCustomerInfo];//重签名
            }
        }else{
            [MBProgressHUD showError:model.message];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}


#pragma mark - 请求提现
- (IBAction)withdrawMoneyAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    [self subbmitDrawMoney];
    btn.enabled = YES;
}

#pragma mark - 去签名
- (void)getCustomerInfo
{
    [self showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
        [self hideHud];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[result safeObjectForKey:@"success"]boolValue]) {
            strongSelf.cardId = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantIdcard"];
            if (strongSelf.cardId == nil) {
                [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
                return ;
            }
            [[JCRouter shareRouter] pushURL:[NSString stringWithFormat:@"signForhtml/cardId/token/%@/%@/%@",@"电子合同",strongSelf.cardId,[UserModel currentUser].token]];
        }else{
            [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moneyCell" forIndexPath:indexPath];
//        UITextField *fromField = [cell viewWithTag:100];
        UITextField *toField = [cell viewWithTag:101];
        if (!self.isEdited) {
//            fromField.text = @"3000";
            toField.placeholder = [NSString stringWithFormat:@"3000-%@",self.maxMoney];
        }
        return cell;
    }
    else if (section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
        return cell;
    }else if (section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repayMoneyCell" forIndexPath:indexPath];
        UILabel *titleLabel = [cell viewWithTag:100];
        titleLabel.text = @"每月还款";
        UILabel *moneyLabel = [cell viewWithTag:101];
        moneyLabel.text = [NSString stringWithFormat:@"%@元",self.detailModel.data[1].SumFee?self.detailModel.data[1].SumFee:@"0"];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repayMoneyCell" forIndexPath:indexPath];
        UILabel *titleLabel = [cell viewWithTag:100];
        titleLabel.text = @"手续费";
        UILabel *moneyLabel = [cell viewWithTag:101];
        moneyLabel.text = [NSString stringWithFormat:@"%@元",self.detailModel.data[0].Procedures?self.detailModel.data[0].Procedures:@"0"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != 3) {
        return 0.f;
    }
    return 72.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [@[@"提现金额",@"贷款期限",@"每月还款",@"手续费"] objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 3) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 72.f)];
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 12, kScreenWidth-24, 60)];
//    webView.backgroundColor = [UIColor clearColor];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    [webView loadRequest:request];
//    webView.scalesPageToFit = YES;
//    webView.scrollView.scrollEnabled = NO;
//    [footerView addSubview:webView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, kScreenWidth-24, 50)];
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = [UIColor colorWithHexString:@"ff3131"];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.text = @"＊手续费将在放款后自动扣除\n＊本产品承诺不收取任何其他中介费用\n＊若您对费用有任何疑问，可致电400-616-3018";
    [footerView addSubview:tipLabel];
    return footerView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 111) {
//        if (textField.canBecomeFirstResponder == NO) {
            [self.view endEditing:YES];
            //选择期限
            textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
            VVPickerView *vvPickerView = [[VVPickerView alloc]initWithFrame:self.view.bounds];
            vvPickerView.upViewColor = [UIColor colorWithHexString:@"f1f4f6"];
            vvPickerView.title = @"请选择贷款期限";
            vvPickerView.rightBtnColor = [UIColor globalThemeColor];
//            if ([self.drawMoney integerValue] > 20000) {
//                vvPickerView.showDataArr = @[@"3个月",@"6个月",@"12个月",@"24个月"];
//            }else{
                vvPickerView.showDataArr = @[@"3个月",@"6个月",@"12个月"];
//            }
            vvPickerView.myTextField = textField;
            vvPickerView.delegate = self;
            [self.view addSubview:vvPickerView];
            return NO;
//        }
        return NO;
    }else{
        self.isEdited = YES;
        if ([textField.text containsString:@"-"]) {
            textField.text = @"";
        }
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField.tag == 100) {
//        //最低额度
//        self.miniValue = textField.text;
//        int value = [textField.text intValue];
//        if (value < 3000) {
//            [MBProgressHUD bwm_showTitle:@"提现不能少于3000元，请重新填写" toView:self.view hideAfter:1 msgType:BWMMBProgressHUDMsgTypeWarning];
//            self.miniValue = textField.text = @"3000";
//            return;
//        }
//    }else if (textField.tag == 101){
        //最高额度
        int value = [textField.text intValue];
        self.drawMoney = textField.text;
        if (value > [self.maxMoney intValue]) {
            [MBProgressHUD bwm_showTitle:@"超出额度啦！" toView:self.view hideAfter:1 msgType:BWMMBProgressHUDMsgTypeWarning];
            self.drawMoney = textField.text = self.maxMoney;
            return;
        }
//        if (value < [self.miniValue intValue]) {
//            [MBProgressHUD bwm_showTitle:@"提现不能少于3000元，请重新填写！" toView:self.view hideAfter:1 msgType:BWMMBProgressHUDMsgTypeWarning];
//            self.drawMoney = textField.text = self.maxMoney;
//            return;
//        }
        if (value < 3000) {
            [MBProgressHUD bwm_showTitle:@"提现不能少于3000元，请重新填写" toView:self.view hideAfter:1 msgType:BWMMBProgressHUDMsgTypeWarning];
            self.drawMoney = textField.text = @"3000";
            return;
        }
        if (value <= 20000 && [self.period isEqualToString:@"24"]) {
            //判断是否小于2w，小于2w的情况没有24期
            UITableViewCell *timeCell = [self.withdrawMoneyTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            UITextField *textField = [timeCell viewWithTag:111];
            [MBProgressHUD bwm_showTitle:@"提现金额少于20000元，最多分期12期！" toView:self.view hideAfter:1 msgType:BWMMBProgressHUDMsgTypeWarning];
            textField.text = @"12期";
            self.period = @"12";
        }
    //取100的整数
    if (value % 100 != 0) {
        self.drawMoney = textField.text = [NSString stringWithFormat:@"%d",value/100*100];
    }
//    }
    if (self.period) {
        [self getLoanSimBillDetails];
    }
}


#pragma mark - VVPickerViewDelegate
- (void)didFinishPickViewWithTextField:(UITextField *)myTextField text:(NSString *)text row:(NSInteger)row
{
    if (nil == self.drawMoney) {
        [MBProgressHUD showError:@"请先输入金额"];
        return;
    }
    myTextField.text = text;
    self.period = self.periodArray[row];
    [self getLoanSimBillDetails];
}
@end
