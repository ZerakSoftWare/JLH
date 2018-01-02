//
//  JJReviewStatusViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJReviewStatusViewController.h"
#import "JJGetCustInfoRequest.h"
#import "VVVcreditSignWebViewController.h"
#import "JJH5SignViewController.h"
#import "JJGetAreaCodeRequest.h"
#import "JJGetDrawResultRequest.h"
#import "JJGetApplyInfoByCustomerIdRequest.h"

@interface JJReviewStatusViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *amountReviewingView;
@property (strong, nonatomic) IBOutlet UIView *advanceReviewingView;
@property (strong, nonatomic) IBOutlet UIView *loaningView;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) JJLoanBaseInfoModel *loanBaseInfoModel;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) NSTimer *resultTimer;
@property (nonatomic, assign) BOOL isShowAlert;
@property (nonatomic, copy) NSString *applicantName;
//@property (nonatomic,)
@end

@implementation JJReviewStatusViewController
+ (id)allocWithRouterParams:(NSDictionary *)params {
    JJReviewStatusViewController *instance = [[UIStoryboard storyboardWithName:@"ReviewStatus" bundle:nil] instantiateViewControllerWithIdentifier:@"ReviewStatus"];
    VVLog(@"%@", params);
    instance.status = [params safeObjectForKey:@"status"];
    instance.isSigned = [params safeObjectForKey:@"isSigned"];
    instance.applyId = [params safeObjectForKey:@"appleId"];
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"进度查看"];
    [self addBackButton];
    [self setupUIWithStatus:self.status];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.status isEqualToString:@"2"]) {
        //循环计时器
        self.resultTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getDrawResult) userInfo:nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.resultTimer) {
        [self.resultTimer invalidate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUIWithStatus:(NSString *)status
{
    if ([status isEqualToString:@"1"]) {
        //额度审批中
        self.loaningView.hidden = YES;
        self.tableView.hidden = YES;
        self.advanceReviewingView.hidden = YES;
        self.amountReviewingView.hidden = NO;
        [self.view insertSubview:self.amountReviewingView aboveSubview:_scrollView];
        if (![self.isSigned boolValue]) {
            //征信签名未通过
            [self showAlertWithTitle:@"您的签名未通过，请重新签名" status:status];
        }
    }else if ([status isEqualToString:@"2"]){
        self.amountReviewingView.hidden = YES;
        self.loaningView.hidden = YES;
        self.tableView.hidden = YES;
        self.advanceReviewingView.hidden = NO;
        [self.view insertSubview:self.advanceReviewingView aboveSubview:_scrollView];
        [self getAreaCode];
        //电审
        if (![self.isSigned boolValue]) {
            //电审签名未通过
            [self showAlertWithTitle:@"您的签名未通过，请重新签名" status:status];
        }
    }
    else{
        //放款中
        self.amountReviewingView.hidden = YES;
        self.advanceReviewingView.hidden = YES;
        self.loaningView.hidden = NO;
        [self getCustInfo];
        [self.view insertSubview:self.loaningView aboveSubview:_scrollView];
    }
    [self.view insertSubview:self.bottomBtn aboveSubview:_scrollView];
    if (![status isEqualToString:@"3"]) {
        [self getUserInfo];
    }
}

- (void)updateTipLabelWithAreaCode:(NSString *)areaCode phone:(NSString *)phone
{
    self.areaCode = areaCode;
    if ([areaCode isEqualToString:@"0512"] || areaCode == nil) {
        NSString *string = [NSString stringWithFormat:@"您的提现申请已成功提交啦!\
                            \n花花会在1工作日内致电您的手机号\
                            \n%@\
                            \n核实相关信息，请保持电话畅通\
                            \n请注意接听区号为0512的座机来电",self.phone];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor globalThemeColor] range:NSMakeRange(46, 1)];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor globalThemeColor] range:NSMakeRange(87, 11)];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor globalThemeColor] range:NSMakeRange(string.length-9, 4)];
        self.tipLabel.attributedText = attriString;
    }else{
        NSString *string = [NSString stringWithFormat:@"您的提现申请已成功提交啦!\
                              \n花花会在1个工作日内致电您的手机号\
                              \n%@\
                              \n核实相关信息，请保持电话畅通\
                              \n请注意接听区号为%@的座机来电",self.phone,self.areaCode];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor globalThemeColor] range:NSMakeRange(48, 1)];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor globalThemeColor] range:NSMakeRange(92, 11)];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor globalThemeColor] range:NSMakeRange(string.length-self.areaCode.length-5, self.areaCode.length)];
        self.tipLabel.attributedText = attriString;
    }
}

- (IBAction)goBack:(id)sender {
    [[JCRouter shareRouter] popToRootViewControllerAnimated:YES];
}

#pragma mark - 网络请求
- (void)getCustInfo
{
    JJGetCustInfoRequest *request = [[JJGetCustInfoRequest alloc] initWithApplyId:self.applyId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        //刷新tableview
        JJLoanBaseInfoModel *model = [(JJGetCustInfoRequest *)request response];
        self.loanBaseInfoModel = model;
        if (model.success) {
            [self.tableView reloadData];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

//获取区号
- (void)getAreaCode
{
    JJGetAreaCodeRequest *getAreaRequest = [[JJGetAreaCodeRequest alloc] init];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [getAreaRequest addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [getAreaRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJBaseResponseModel *model = [(JJGetAreaCodeRequest *)request response];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (model.success) {
            strongSelf.areaCode = [[request.responseJSONObject safeObjectForKey:@"data"] safeObjectForKey:@"AreaCode"];
            [strongSelf updateTipLabelWithAreaCode:strongSelf.areaCode phone:strongSelf.phone];
        }
        
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

- (void)getUserInfo
{
    JJGetApplyInfoByCustomerIdRequest *infoRequest = [[JJGetApplyInfoByCustomerIdRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [infoRequest addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;

    [infoRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSDictionary *result = request.responseJSONObject;
        if ([result[@"code"] integerValue] == 200) {
            strongSelf.cardId = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantIdcard"];
            strongSelf.applicantName = [[result safeObjectForKey:@"data"] objectForKey:@"applicantName"];
            strongSelf.phone = [[result safeObjectForKey:@"data"] safeObjectForKey:@"mobile"];
            [strongSelf updateTipLabelWithAreaCode:strongSelf.areaCode phone:strongSelf.phone];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

///获取电审结果
- (void)getDrawResult
{
    __weak __typeof(self)weakSelf = self;
    JJGetDrawResultRequest *resultRequest = [[JJGetDrawResultRequest alloc] init];
    [resultRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJBaseResponseModel *model = [(JJGetDrawResultRequest *)request response];
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (model.success) {
            //data 0成功1签名有问题2继续等待
//            NSString *data = [[request.responseJSONObject safeObjectForKey:@"data"] mj_JSONString];
            id dataId = [request.responseJSONObject safeObjectForKey:@"data"];
            //服务器会返回data:{}或者data:"-1","0","1","2"
            if ([dataId isKindOfClass:[NSNumber class]]) {
                NSString *data = [dataId stringValue];
                if ([data isEqualToString:@"0"]) {
                    [MBProgressHUD showSuccess:@"电审已成功"];
                    [[JCRouter shareRouter] popViewControllerAnimated:YES];
                }else if ([data isEqualToString:@"1"]){
                    [strongSelf showAlertWithTitle:@"您的签名未通过，请重新签名" status:@"2"];
                    [strongSelf.resultTimer invalidate];
                }else{
                    
                }
            }
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

#pragma mark - 弹出alert框
- (void)showAlertWithTitle:(NSString *)title status:(NSString *)status
{
    if (self.isShowAlert) {
        return;
    }
    self.isShowAlert = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self)weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"立即重签" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        VVLog(@"页面跳转,重签名");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isShowAlert = NO;
        [strongSelf getCustomerInfoWithstatus:status];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    else if (section == 2){
        return 3;
    }
    else if (section == 3){
        return 2;
    }
    else if (section == 4){
        return 1;
    }
    else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"progressHeaderCell" forIndexPath:indexPath];
        UILabel *label = [cell viewWithTag:1000];
        label.text = [NSString stringWithFormat:@"您已成功申请提现，我们将会在%@个工作日内将现金汇入以下账号",self.loanBaseInfoModel.data.loanDays];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell" forIndexPath:indexPath];
        UILabel *titleLabel = [cell viewWithTag:100];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        UILabel *contentLabel = [cell viewWithTag:101];
        UILabel *yuanLabel = [cell viewWithTag:102];
        yuanLabel.hidden = YES;
        if (section == 1) {
            titleLabel.text = @"放款时间";
            contentLabel.text = self.loanBaseInfoModel.data.loanDays?[NSString stringWithFormat:@"%@个工作日",self.loanBaseInfoModel.data.loanDays]:@"";
            contentLabel.textAlignment = NSTextAlignmentRight;
        }
        
        else if (section == 2) {
            if (row == 0) {
                titleLabel.text = @"姓名";
                contentLabel.text = self.loanBaseInfoModel.data.name?self.loanBaseInfoModel.data.name:@"";
                contentLabel.textAlignment = NSTextAlignmentRight;
            }
            else if (row == 1){
                titleLabel.text = @"银行卡号";
                contentLabel.textAlignment = NSTextAlignmentRight;
                contentLabel.text = self.loanBaseInfoModel.data.bankAccount?self.loanBaseInfoModel.data.bankAccount:@"";
            }else{
                titleLabel.text = @"放款金额";
                contentLabel.textAlignment = NSTextAlignmentRight;
                contentLabel.textColor = [UIColor globalThemeColor];
                yuanLabel.hidden = NO;
                yuanLabel.text = @"元";
                contentLabel.text = [NSString stringWithFormat:@"+%@ ",self.loanBaseInfoModel.data.drawMoney?self.loanBaseInfoModel.data.drawMoney:@""];
            }
        }
        else if (section == 3){
            contentLabel.textAlignment = NSTextAlignmentRight;
            if (row == 0) {
                titleLabel.text = @"还款时间";
                contentLabel.text = [NSString stringWithFormat:@"每月%@日",self.loanBaseInfoModel.data.billDate?self.loanBaseInfoModel.data.billDate:@""];
            }else if (row == 1) {
                titleLabel.text = @"默认还款方式";
                contentLabel.text = self.loanBaseInfoModel.data.repayMehtod;
            }
        }
        else if (section == 4) {
            titleLabel.text = @"乐花优享";
            titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
            contentLabel.text = @"";
        }
        else{
            contentLabel.textAlignment = NSTextAlignmentRight;
            if (row == 0) {
                titleLabel.text = @"缴纳金额";
                yuanLabel.hidden = NO;
                yuanLabel.text = @"元";
                contentLabel.text = self.loanBaseInfoModel.data.memberfee?self.loanBaseInfoModel.data.memberfee:@"";
            }else if (row == 1) {
                titleLabel.text = @"缴纳情况";
                if ([self.loanBaseInfoModel.data.member isEqualToString:@"1"]) {
                    contentLabel.text = @"已缴纳";
                }else{
                    contentLabel.text = @"待缴纳";
                }
            }
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 164.f;
    }
    return 59.f;
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        NSString *content = [NSString stringWithFormat:@"还款：\n建议在还款日前使用微信或银联支付主动还款，我司也会在每期账单日凌晨开始从还款银行卡中自动扣款。\n\n乐花优享：\n若您选择贷款成功后缴费，我司会将在放款成功后从指定缴费银行卡中自动扣款"];
        UIFont *textFont = [UIFont systemFontOfSize:13];
        CGRect rect = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFont} context:nil];

        return rect.size.height+10;
    }else{
        return 10.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth-20, 50)];
        tipLabel.numberOfLines = 0;
        tipLabel.textColor = [UIColor redColor];
        UIFont *textFont = [UIFont systemFontOfSize:13];
        tipLabel.font = textFont;
        NSString *content = [NSString stringWithFormat:@"还款：\n建议在还款日前使用微信或银联支付主动还款，我司也会在每期账单日凌晨开始从还款银行卡中自动扣款。\n\n乐花优享：\n若您选择贷款成功后缴费，我司会将在放款成功后从指定缴费银行卡中自动扣款"];
        tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
        tipLabel.text = content;
        CGRect rect = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFont} context:nil];
        tipLabel.height = rect.size.height;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, rect.size.height+10)];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:tipLabel];
        return footerView;
    }else{
        return nil;
    }
}

#pragma mark - 获取信息
- (void)getCustomerInfoWithstatus:(NSString *)status
{
    if (self.cardId==nil) {
        
    }else{
        if ([status isEqualToString:@"1"]) {
            //征信签名未通过
            [self gotoVcreditSign];
        }else{
            //提现电审签名未通过
            [self gotoSign];
        }
    }
}

#pragma mark - 签名处理
- (void)gotoSign
{
    JJH5SignViewController *signVc = [[JJH5SignViewController alloc]init];
    signVc.webTitle = @"电子合同";
    NSString *url = [NSString stringWithFormat:@"%@/sign2.html?idcard=%@&token=%@&name=%@&customerId=%@",WEB_BASE_URL,self.cardId,[UserModel currentUser].token,self.applicantName,[UserModel currentUser].customerId];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    signVc.startPage = url;
    [self customPushViewController:signVc withType:nil subType:nil];
}

- (void)gotoVcreditSign
{
    VVVcreditSignWebViewController *credictVc = [[VVVcreditSignWebViewController alloc]init];
    credictVc.webTitle = @"电子签名";
    NSString *url = [WEB_BASE_URL stringByAppendingString:@"/sign.html"];
    NSString *urlStarPage = [NSString stringWithFormat:@"%@?name=%@&idcard=%@&customerId=%@&token=%@",url,self.applicantName,self.cardId,[UserModel currentUser].customerId,[UserModel currentUser].token];
    urlStarPage = [urlStarPage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    credictVc.startPage = urlStarPage;
    [self customPushViewController:credictVc withType:nil subType:nil];
}

@end
