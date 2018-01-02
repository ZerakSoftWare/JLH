//
//  JJAddBankCardViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJAddBankCardViewController.h"
#import "JJSelectBankTableViewCell.h"
#import "JJBankInfoTableViewCell.h"
#import "JJAddBankCardRequest.h"
#import "JJH5SignViewController.h"
#import "JJGetBankListRequest.h"
#import "JJGetApplyInfoByCustomerIdRequest.h"

@interface JJAddBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *addBankCardTableView;



@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bandId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *mobileNum;

@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, strong) JJBankListModel *listModel;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, copy) NSString *applicantName;

@property (nonatomic, copy) NSString *isModify;

@end

@implementation JJAddBankCardViewController
+ (id)allocWithRouterParams:(NSDictionary *)params {
    JJAddBankCardViewController *instance = [[UIStoryboard storyboardWithName:@"AddBankCard" bundle:nil] instantiateViewControllerWithIdentifier:@"AddBankCard"];
    VVLog(@"%@", params);
    
    instance.isModify = [params objectForKey:@"isModify"];
    
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isModify.length)
    {
        [self setNavigationBarTitle:@"修改银行卡"];
    }
    else
    {
        [self setNavigationBarTitle:@"添加提现银行卡"];
    }
    
    [self addBackButton];
    [self.view insertSubview:self.addBankCardTableView aboveSubview:_scrollView];
//    [self setKvo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCustomerInfo];
}

//- (void)dealloc
//{
//    [self removeObserver:self forKeyPath:@"bankName"];
//    [self removeObserver:self forKeyPath:@"userName"];
//    [self removeObserver:self forKeyPath:@"bankCode"];
//    [self removeObserver:self forKeyPath:@"mobileNum"];
//}
//
//#pragma mark - add kvo
//- (void)setKvo
//{
//    [self addObserver:self forKeyPath:@"bankName" options:NSKeyValueObservingOptionNew context:NULL];
//    [self addObserver:self forKeyPath:@"userName" options:NSKeyValueObservingOptionNew context:NULL];
//    [self addObserver:self forKeyPath:@"bankCode" options:NSKeyValueObservingOptionNew context:NULL];
//    [self addObserver:self forKeyPath:@"mobileNum" options:NSKeyValueObservingOptionNew context:NULL];
//}

#pragma mark - 获取信息
- (void)getCustomerInfo
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
            [strongSelf getBankList];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

- (void)getBankList
{
    JJGetBankListRequest *banklistRequest = [[JJGetBankListRequest alloc] init];
//    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
//    [banklistRequest addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [banklistRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJBankListModel *model = [(JJGetBankListRequest *)request response];
        if (model.success) {
            strongSelf.listModel = model;
            [strongSelf.addBankCardTableView reloadData];
            strongSelf.nextBtn.enabled = YES;
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        JJSelectBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankInfoCell" forIndexPath:indexPath];
        cell.viewController = self;
        __weak __typeof(self)weakSelf = self;
        cell.endSelectBlock = ^(NSString *bankName,NSString *bandId){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.bankName = bankName;
            strongSelf.bandId = bandId;
        };
        if (self.listModel.data.count > 0) {
            JJBankListDataModel *model = [self.listModel.data firstObject];
            cell.bankNameField.text = model.bankName;
            cell.bankNameField.enabled = self.isModify?YES:NO;
            
            self.bandId = model.bankCode;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(row == 4){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bottomCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.nextBtn = (UIButton *)[cell viewWithTag:101];
        
        if (self.isModify.length)
        {
            [self.nextBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
        else
        {
             [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
        
        return cell;
    }else{
        JJBankInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankCommonCell" forIndexPath:indexPath];
        switch (row) {
            case 1:
            {
                cell.titleLabel.text = @"开户人姓名";
                cell.contentField.placeholder = @"请填写开户人姓名";
                if (self.listModel.data.count > 0) {
                    JJBankListDataModel *model = [self.listModel.data firstObject];
                    cell.contentField.text = model.bankPersonName;
                    cell.contentField.enabled = self.isModify?YES:NO;
                    self.userName = model.bankPersonName;
                }
            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"银行账户";
                cell.contentField.placeholder = @"请填写银行帐号";
                cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
                cell.contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
                if (self.listModel.data.count > 0) {
                    JJBankListDataModel *model = [self.listModel.data firstObject];
                    cell.contentField.text = model.bankPersonAccount;
                    cell.contentField.enabled = self.isModify?YES:NO;
                    self.bankCode = model.bankPersonAccount;
                }

            }
                break;
            case 3:
            {
                cell.titleLabel.text = @"手机号";
                cell.contentField.placeholder = @"请填写银行预留手机号";
                cell.contentField.keyboardType = UIKeyboardTypeNumberPad;
                cell.contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
                if (self.listModel.data.count > 0) {
                    JJBankListDataModel *model = [self.listModel.data firstObject];
                    cell.contentField.text = model.bankPersonMobile;
                    cell.contentField.enabled = self.isModify?YES:NO;
                    self.mobileNum = model.bankPersonMobile;
                }
            }
                break;
            default:
                break;
        }
        __weak __typeof(self)weakSelf = self;
        cell.endEditBlock = ^(NSString *content){
            VVLog(@"%@",content);
             __strong __typeof(weakSelf)strongSelf = weakSelf;
            switch (row) {
                case 1:
                    strongSelf.userName = content;
                    break;
                case 2:
                    strongSelf.bankCode = content;
                    break;
                case 3:
                    strongSelf.mobileNum = content;
                    break;
                default:
                    break;
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 109.f;
    }
    return 44.f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 109.f;
//}
//
//#pragma mark - UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 109)];
//    
//    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, kScreenWidth-24, 17)];
//    tipLabel.text = @"＊本次添加的银行卡将作为提现及还款银行卡";
//    tipLabel.textColor = [UIColor colorWithHexString:@"ff3131"];
//    tipLabel.font = [UIFont systemFontOfSize:12];
//    [footerView addSubview:tipLabel];
//    
//    VVCommonButton *nextBtn = [VVCommonButton solidButtonWithTitle:@"下一步"];
//    nextBtn.layer.cornerRadius = 6;
//    nextBtn.clipsToBounds = YES;
//    nextBtn.frame = CGRectMake(20, 12+17+36, kScreenWidth-40, 44);
//    [nextBtn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:nextBtn];
//    
//    return footerView;
//}

#pragma mark - addBankCard
- (IBAction)addBankCard:(id)sender
{
    if (self.isModify.length)
    {
        [self modifyBankAction];
    }
    else
    {
        [self addBankAction];
    }
}

#pragma mark - 修改银行卡

- (void)modifyBankAction
{
    [self.view endEditing:YES];
    
    NSNumber *type = ([self.isModify isEqualToString:@"0"] ? @(0) : @(3));
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.bandId forKey:@"bankCode"];
    [param setObject:self.bankCode forKey:@"bankPersonAccount"];
    [param setObject:self.mobileNum forKey:@"bankPersonMobile"];
    [param setObject:self.userName forKey:@"bankPersonName"];
    [param setObject:[UserModel currentUser].customerId forKey:@"customerId"];
    
    if ( [self.bankCode length] == 0 || [self.mobileNum length] == 0 || [self.userName length] == 0) {
        [MBProgressHUD showError:@"请先输入内容"];
        return;
    }
    if (![self.mobileNum isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    [self showHud];
    __weak __typeof(self) weakSelf = self;
    
    [[VVNetWorkUtility netUtility] postChangeMyBankCardParameters:param
                                                         withType:[type intValue]
                                                          success:^(id result)
    {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideHud];
        
        if ([result[@"success"] integerValue] == 1) {
            
            [MBProgressHUD showSuccess:@"修改成功"];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DEFAULT_DISPLAY_DURATION * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self customPopToRootViewController];
            });
        }
        else
        {
            [MBProgressHUD showError:[result safeObjectForKey:@"message"]];
        }
        
    } failure:^(NSError *error)
     {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
         [strongSelf hideHud];
         [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];
    }];
}

- (void)addBankAction
{
    //添加银行卡
    //** 客户银行卡id */
    //    private Long customerBankId;
    //    /** 银行字典代码  */
    //    private String bankCode;
    //    /** 客户id  */
    //    private Long customerId;
    //    /** 开户人姓名（若此名称与申请人名称不一致允许吗？）  */
    //    private String bankPersonName;
    //    /** 银行帐号  */
    //    private String bankPersonAccount;
    //    /** 手机号（此手机号可能不与申请人名称手机号码一致）  */
    //    private String bankPersonMobile;
    //    /** 是否提现银行卡（1：提现银行卡；0：还款银行卡）  */
    //    private Integer isDrawMoneyBankcard;
    //    /** 是否启用（0：未启用；1：已启用）  */
    //    private Integer isEnabled;
    //    /** 启用时间  */
    //    private Date enabledTime;
    //    /** 禁用时间  */
    //    private Date unenabledTime;
    //    /** 创建时间  */
    //    private Date createTime;
    //    /** 更新时间  */
    //    private Date modifyTime;
    //    /** 银行图标url  */
    //    private String url;
    //    private String bankName;
    if (self.listModel.data.count > 0) {
        if (self.cardId) {
            [self gotoSign];
        }else{
            [self getCustomerInfo];
        }
        return;
    }
    [self.view endEditing:YES];
    if ([self.bankName length] == 0 || [self.bankCode length] == 0||
        [self.mobileNum length] == 0 || [self.userName length] == 0) {
        [MBProgressHUD showError:@"请先输入内容"];
        return;
    }
    if (![self.mobileNum isMobileNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    __block NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.bandId forKey:@"bankCode"];
    [param setObject:self.bankName forKey:@"bankName"];
    [param setObject:self.bankCode forKey:@"bankPersonAccount"];
    [param setObject:self.mobileNum forKey:@"bankPersonMobile"];
    [param setObject:self.userName forKey:@"bankPersonName"];
    [param setObject:@"" forKey:@"createTime"];
    [param setObject:@"" forKey:@"customerBankId"];
    [param setObject:[UserModel currentUser].customerId forKey:@"customerId"];
    [param setObject:@"" forKey:@"enabledTime"];
    [param setObject:@"1" forKey:@"isDrawMoneyBankcard"];
    [param setObject:@"1" forKey:@"isEnabled"];
    [param setObject:@"" forKey:@"modifyTime"];
    [param setObject:@"" forKey:@"unenabledTime"];
    [param setObject:@"" forKey:@"url"];
    
    JJAddBankCardRequest *addCardRequest = [[JJAddBankCardRequest alloc] initWithParam:param];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    //    [addCardRequest addAccessory:accessory];
    //    [addCardRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
    //        VVLog(@"%@",request.responseJSONObject);
    //
    //    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
    //
    //    }];
    
    KZChainRequest *chainRequest = [[KZChainRequest alloc] init];
    [chainRequest addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [chainRequest addRequest:addCardRequest callback:^(KZChainRequest *chainRequest, __kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJBaseResponseModel *model = [(JJAddBankCardRequest *)request response];
        if (model.success) {
            //继续添加还款银行卡
            [param setObject:@"0" forKey:@"isDrawMoneyBankcard"];
            JJAddBankCardRequest *addRepayRequest = [[JJAddBankCardRequest alloc] initWithParam:param];
            [addRepayRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
                JJBaseResponseModel *model = [(JJAddBankCardRequest *)request response];
                if (model.success) {
                    [strongSelf isNeedAddCustomerContacts:^{
                        if (strongSelf.cardId) {
                            [strongSelf gotoSign];
                        }else{
                            [strongSelf getCustomerInfo];
                        }
                    }];
                    
                }else{
                    [MBProgressHUD showError:model.message];
                }
            } failure:^(__kindof KZBaseRequest *request, NSError *error) {
                [MBProgressHUD showError:@"添加银行卡失败"];
            }];
            
        }else{
            [MBProgressHUD showError:model.message];
        }
    }];
    [chainRequest start];
}

//添加还款银行卡
- (void)addRepayBankCard
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"" forKey:@"bankCode"];
    [param setObject:self.bankName forKey:@"bankName"];
    [param setObject:self.bankCode forKey:@"bankPersonAccount"];
    [param setObject:self.mobileNum forKey:@"bankPersonMobile"];
    [param setObject:self.userName forKey:@"bankPersonName"];
    [param setObject:@"" forKey:@"createTime"];
    [param setObject:@"" forKey:@"customerBankId"];
    [param setObject:[UserModel currentUser].customerId forKey:@"customerId"];
    [param setObject:@"" forKey:@"enabledTime"];
    [param setObject:@"0" forKey:@"isDrawMoneyBankcard"];
    [param setObject:@"" forKey:@"isEnabled"];
    [param setObject:@"" forKey:@"modifyTime"];    [param setObject:@"" forKey:@"unenabledTime"];
    [param setObject:@"" forKey:@"url"];
    
    JJAddBankCardRequest *addCardRequest = [[JJAddBankCardRequest alloc] initWithParam:param];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [addCardRequest addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [addCardRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJBaseResponseModel *model = [(JJAddBankCardRequest *)request response];
        if (model.success) {
            if (strongSelf.cardId) {
                [strongSelf gotoSign];
            }else{
                [strongSelf getCustomerInfo];
            }
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

- (void)gotoSign
{
    if ([self.cardId length] > 10) {
        JJH5SignViewController *signVc = [[JJH5SignViewController alloc]init];
        signVc.webTitle = @"电子合同";
        NSString *url = [NSString stringWithFormat:@"%@/sign2.html?idcard=%@&token=%@&name=%@&customerId=%@",WEB_BASE_URL,self.cardId,[UserModel currentUser].token,self.applicantName,[UserModel currentUser].customerId];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        signVc.startPage = url;
        [self customPushViewController:signVc withType:nil subType:nil];
    }
}

- (void)backAction:(id)sender
{
    if (self.isModify.length)
    {
        [self customPopViewController];
    }
    else
    {
        [self customPopToRootViewController];
    }
}


-(void)isNeedAddCustomerContacts:(void (^)())finish{
    [self showHud];
    __weak __typeof(self) weakSelf = self;
    //返回1,需要 0,不需要
    [[VVNetWorkUtility netUtility]getNeedAddCustomerContactsParameters:nil success:^(id result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideHud];
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            if ([[result safeObjectForKey:@"data"] isEqualToString:@"1"]) {
                [[JCRouter shareRouter]pushURL:@"addLinkman"];
            }else {
                [strongSelf hideHud];
                if (finish) {
                    finish();
                }
            }
        }else{
            [MBProgressHUD showError:[result safeObjectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideHud];
        [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];
    }];
}


//#pragma mark - KVO
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if (self.bankName&&self.userName&&self.bankCode&&self.mobileNum) {
//        self.nextBtn.enabled = YES;
//    }else{
//        self.nextBtn.enabled = NO;
//    }
//}

@end
