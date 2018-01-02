//
//  BankListViewController.m
//  JieLeHua
//
//  Created by admin on 17/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "BankListViewController.h"
#import "BankListTableViewCell.h"
#import "BankListDTO.h"
#import "JJHomeStatusRouterManager.h"
#import "JJHomeStatusRequest.h"

#import "JJVersionSourceManager.h"
#import "JJBeginApplyRequest.h"

#import "JJH5SignViewController.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface BankListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *bankListAry;
@property (nonatomic, strong) JJMainStateModel *homeStatusModel;

//submitVbs  0，还没提交到VBS 1，已经提交到VBS, 2,还款中,不可以修改银行卡(此时返回changeBankCardDay(int)为账单日后第一天) 3,还款中-可以修改银行
@property (nonatomic, copy) NSString *isSubmit;

@property (nonatomic, copy) NSString *changeBankCardDay;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation BankListViewController


#pragma mark - Properties

- (NSArray *)bankListAry {
    if (!_bankListAry) {
        _bankListAry = [[NSArray alloc] init];
    }
    return _bankListAry;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = VVColor(241,244,246);
        _tableView.rowHeight = 152;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankListAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BankListTableViewCell *cell = [BankListTableViewCell  cellWithTableView:tableView];
    cell.item = self.bankListAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Overridden Methods

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    BankListViewController *instance = [[BankListViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"我的银行卡"];
    
    [self addBackButton];
    
    [self getBankListFromServies];
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

- (void)getBankListFromServies
{
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] getMyBankListWithCustomerId:[UserModel currentUser].customerId
                                                       Success:^(id result)
    {
        if ([result[@"success"] integerValue] == 1)
        {
            [HUD hide:YES];
            
            NSArray *tempAry = [result safeObjectForKey:@"data"];
            
            if (tempAry.count)
            {
                self.bankListAry = [BankListDTO mj_objectArrayWithKeyValuesArray:tempAry];
                
                self.isSubmit = [result safeObjectForKey:@"submitVbs"];
                
                if ([self.isSubmit isEqualToString:@"2"])
                {
                    self.changeBankCardDay = [result safeObjectForKey:@"changeBankCardDay"];
                }
                
                [self initAndLayoutUI];
            }
            else
            {
                [self setNoResultViewWithStatus:result[@"status"]];
            }
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

- (void)setNoResultViewWithStatus:(NSString *)status
{
    UIImageView *noResultImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_noBank"]];
    [self.view addSubview:noResultImg];
    
    UILabel *noResultLab = [[UILabel alloc] init];
    noResultLab.textAlignment = NSTextAlignmentCenter;
    noResultLab.font = [UIFont systemFontOfSize:17];
    noResultLab.textColor = VVColor(153, 153, 153);
    
//    "noApply":没有出额度的订单，
//    "apply":有出额度的订单,但是还没提现,
//    "draw":已经提现了
    NSString *btnStr;
    status = @"noView";
    if([status isEqualToString:@"noApply"] || [status isEqualToString:@"applyNoClick"] || [status isEqualToString:@"drawNoClick"])
    {
        noResultLab.text = @"你暂未获得额度，无法添加银行卡";
        btnStr = @"立即申请";
    }
    else if ([status isEqualToString:@"apply"])
    {
        noResultLab.text = @"你还没有提现哦，无法添加银行卡";
        btnStr = @"立即提现";
    }
    [self.view addSubview:noResultLab];
    
    VVCommonButton *noResultBtn = [VVCommonButton solidButtonWithTitle:btnStr];
    noResultBtn.enabled = YES;
    [noResultBtn setBackgroundColor:[UIColor unableButtonThemeColor]  forState:UIControlStateDisabled];
    noResultBtn.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    noResultBtn.layer.cornerRadius = 6.f;
    [self.view addSubview:noResultBtn];
    
    if ([status isEqualToString:@"apply"])
    {
        [noResultBtn addTarget:self action:@selector(proposeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([status isEqualToString:@"noApply"])
    {
        [noResultBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([status isEqualToString:@"applyNoClick"] || [status isEqualToString:@"drawNoClick"])
    {
        noResultBtn.enabled = NO;
    }
    else if ([status isEqualToString:@"noView"] )
    {
        noResultBtn.hidden = YES;
    }
    
    
    [noResultImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(78+64);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(203, 168.5f));
    }];
    
    [noResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noResultImg.mas_bottom).with.offset(18);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    [noResultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
        make.top.mas_equalTo(noResultLab.mas_bottom).with.offset(40);
    }];
}

- (void)initAndLayoutUI
{
    [self.view insertSubview:self.tableView aboveSubview:_scrollView];
    self.tableView.tableFooterView = [self footerView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(64-7);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
}

- (void)modifyBtnClick
{
//    0. 未交单VBS或已解约时，可修改银行卡(页面跳转至“重新添加银行卡”)
//    1. 已交单VBS未放款时，不可修改银行卡（按钮置灰，不可点击）
//    2. 已放款未结清，不可修改银行卡（按钮可点击，但不跳转界面，弹窗提示）此时返回changeBankCardDay(int)为账单日后第一天
//    3. 已放款未结清，可修改银行卡（页面跳转至“替换银行卡合同列表）
//    4. 提前清贷中不能修改银行卡（按钮可点击，但不跳转界面，弹窗提示
    
    if ([self.isSubmit isEqualToString:@"0"])
    {
        NSDictionary *param = @{
                                @"isModify":self.isSubmit
                                };

        [[JCRouter shareRouter] pushURL:@"addBankCard" extraParams:param];
    }
    else if ([self.isSubmit isEqualToString:@"2"])
    {
        NSString *mesStr = [NSString stringWithFormat:@"很抱歉，当前无法修改银行卡信息，请于%@日重新尝试！",[self.changeBankCardDay substringToIndex:10]];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:mesStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {

        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([self.isSubmit isEqualToString:@"4"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"很抱歉，当前处于提前清贷中请勿修改还款银行卡！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                 {

                                 }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([self.isSubmit isEqualToString:@"3"])
    {
        [self getApplyInfoByCustomerBillWithAccountId];
    }
}

- (void)getApplyInfoByCustomerBillWithAccountId
{
    [[VVNetWorkUtility netUtility] getApplyInfoByCustomerBillWithAccountId:[UserModel currentUser].customerId
                                                                   success:^(id result)
     {
         if ([[result safeObjectForKey:@"success"] boolValue])
         {
             NSString *cardId, *name;
             
             cardId = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantIdcard"];
             name = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantName"];
             
             JJH5SignViewController *signVc = [[JJH5SignViewController alloc]init];
             signVc.webTitle = @"电子合同";
             NSString *url = [NSString stringWithFormat:@"%@/sign3.html?idcard=%@&token=%@&name=%@&customerId=%@",WEB_BASE_URL,cardId,[UserModel currentUser].token,name,[UserModel currentUser].customerId];
             url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
             signVc.startPage = url;
             signVc.isModifyBank = YES;
             signVc.signSuccBlock = ^(){
                 
                 NSDictionary *param = @{
                                         @"isModify":self.isSubmit
                                         };
                 [[JCRouter shareRouter] pushURL:@"addBankCard" extraParams:param];

             };
             [self customPushViewController:signVc withType:nil subType:nil];
         }
         else
         {
             [MBProgressHUD bwm_showTitle:result[@"message"]
                                   toView:self.view
                                hideAfter:1.2f];
         }
         
     } failure:^(NSError *error)
     {
         [MBProgressHUD bwm_showTitle:@"获取身份证姓名错误"
                               toView:self.view
                            hideAfter:1.2f];
     }];
}

- (UIView *)footerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, kScreenWidth-24, 34)];
    lab.numberOfLines = 0;
    lab.textColor = VVColor(255, 49, 49);
    lab.font = [UIFont systemFontOfSize:12];
    lab.text = @"如果您的银行卡遗失或无法正常使用，请及时联系客服，避免出现逾期账单，产生不必要的费用";
    
    [view addSubview:lab];
    
    VVCommonButton *modifyBtn = [VVCommonButton solidButtonWithTitle:@"修改"];
    modifyBtn.titleLabel.font  = [UIFont systemFontOfSize:16.0];
    modifyBtn.layer.cornerRadius = 6.f;
    [modifyBtn addTarget:self action:@selector(modifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:modifyBtn];
    
    [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(lab.mas_bottom).offset(13);
        make.height.mas_equalTo(44);
    }];
    
    if ([self.isSubmit isEqualToString:@"1"])
    {
        [modifyBtn setBackgroundColor:[UIColor unableButtonThemeColor] forState:UIControlStateNormal];
        modifyBtn.userInteractionEnabled = NO;
    }
    else
    {
        [modifyBtn setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
        modifyBtn.userInteractionEnabled = YES;
    }
    
    return view;
}

/**
 *  立即提现，走额度提现流程
 */
- (void)proposeAction
{
    [self getMainStateRequestIsApply:NO];
}

/**
 *  立即申请，走支付宝花呗额度授权流程
 */
- (void)applyAction
{
    [self getMainStateRequestIsApply:YES];
}


#pragma mark  数据request
- (void)getMainStateRequestIsApply:(BOOL)apply{
    JJHomeStatusRequest *request = [[JJHomeStatusRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc]initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJMainStateModel *statusModel = [JJMainStateModel mj_objectWithKeyValues:request.responseJSONObject];
        if (statusModel.success) {
            JJVersionSourceManager *sourceManager = [JJVersionSourceManager versionSourceManager];
            sourceManager.versionSource = statusModel.summary.versionSource;
            
            if ([statusModel.summary.versionSource isEqualToString:@"4"]) {
//#ifdef JIELEHUA
//                [VVAlertUtils showAlertViewWithTitle:nil message:@"花花为你提供了全额申请和极速申请！想选啥？你说了算！" customView:nil cancelButtonTitle:@"极速流程" otherButtonTitles:@[@"全额申请"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                    if (buttonIndex  != kCancelButtonTag) {
//                        [alertView hideAlertViewAnimated:YES];
//                        [JJVersionSourceManager versionSourceManager].versionSource = @"0";
//                        [[JJHomeStatusRouterManager homeStatusRouterManager] dealWithStatus:HomeStatus_NoAmount data:self.homeStatusModel];
//                    }else{
//                        //极速+调用beginapply
//                        [alertView hideAlertViewAnimated:YES];
//                        [[JJVersionSourceManager versionSourceManager] startFastApply];
//                    }
//                }];
//#elif JIELEHUAQUICK
                [[JJVersionSourceManager versionSourceManager] startFastApplyWithView:self.view];
//#endif
            }else{
                strongSelf.homeStatusModel = statusModel;
                [[JJHomeStatusRouterManager homeStatusRouterManager] dealWithStatus:strongSelf.homeStatusModel.summary.applyStatus data:statusModel];
            }
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {

    }];
}

@end
