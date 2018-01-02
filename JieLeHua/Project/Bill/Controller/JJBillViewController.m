//
//  JJBillViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/2/17.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBillViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MJChiBaoZiHeader.h"
#import "JJHomeStatusRouterManager.h"
#import "JJHomeStatusRequest.h"
#import "JJVersionSourceManager.h"
#import "JJBeginApplyRequest.h"
#import "JJBillListTableViewCell.h"
#import "JJBillListRequest.h"

@interface JJBillViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isLogin;

/**
 *  数据为空界面UI
 */
@property (nonatomic, strong) UIImageView *noResultImg;

@property (nonatomic, strong) UILabel *noResultLab;

@property (nonatomic, strong) VVCommonButton *noResultBtn;

@property (nonatomic, strong) JJMainStateModel *homeStatusModel;

@property (nonatomic, strong) NSMutableArray *billlistArray;

@end

@implementation JJBillViewController

- (VVCommonButton *)noResultBtn {
    if (!_noResultBtn) {
        _noResultBtn = [VVCommonButton solidButtonWithTitle:@""];
        _noResultBtn.titleLabel.font  = [UIFont systemFontOfSize:17.0];
        _noResultBtn.layer.cornerRadius = 6.f;
        _noResultBtn.hidden = YES;
        [_noResultBtn setBackgroundColor:[UIColor unableButtonThemeColor]  forState:UIControlStateDisabled];
    }
    return _noResultBtn;
}

- (UILabel *)noResultLab
{
    if (!_noResultLab) {
        _noResultLab = [[UILabel alloc] init];
        _noResultLab.text = @"还没有账单哦，快把钱放进口袋里";
        _noResultLab.textAlignment = NSTextAlignmentCenter;
        _noResultLab.font = [UIFont systemFontOfSize:17];
        _noResultLab.textColor = VVColor(153, 153, 153);
        _noResultLab.hidden = YES;
    }
    return _noResultLab;
}

- (UIImageView *)noResultImg {
    if (!_noResultImg) {
        _noResultImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bill_noResult"]];
        _noResultImg.hidden = YES;
        _noResultImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noResultImg;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = VVColor(241, 244, 246);
        [_tableView registerNib:[UINib nibWithNibName:@"JJBillListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JJBillListTableViewCell"];
    }
    return _tableView;
}

//- (UIWebView *)webView {
//    if (!_webView) {
//        _webView = [[UIWebView alloc] init];
//        _webView.delegate = self;
//        _webView.backgroundColor = VVColor(241, 244, 246);
//    }
//    return _webView;
//}

//#pragma mark - UIWebViewDelegate
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSString *requestString = [[request URL] absoluteString];
//
//    if ([requestString rangeOfString:@"billDetail" options:NSCaseInsensitiveSearch].location != NSNotFound)
//    {
//        NSDictionary *param = @{
//                                @"webUrl":requestString
//                                };
//
//        [[JCRouter shareRouter] pushURL:@"billDetail" extraParams:param];
//
//        return NO;
//    }
//
//    return YES;
//}
//
//- (void)webViewDidFinishLoad:(UIWebView*)webView
//{
//    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//
//    context[@"billDetailClick"] = ^{
//        VVLog(@"cell被点击了!!");
//    };
//}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"账单"];
    
    [self initAndLayoutUI];
    
    _billlistArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBaseView];
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
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.noResultImg];
    [self.view addSubview:self.noResultLab];
    [self.view addSubview:self.noResultBtn];
    
    __weak typeof(self) weakSelf = self;
    
    _tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        [weakSelf getBillingStatusFromService];
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
    }];

    
//    __weak UIScrollView *scrollView = self.webView.scrollView;
    
    // 添加下拉刷新控件
//    scrollView.mj_header= [MJChiBaoZiHeader headerWithRefreshingBlock:^{
//        [weakSelf getBillingStatusFromService];
//    }];
    
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(self.view).with.offset(64);
//    }];
}

- (void)setBaseView
{
    self.isLogin = [UserModel isLoggedIn];
    
    self.tableView.userInteractionEnabled = self.isLogin;
    
    if (!self.isLogin)
    {
        [self setNoResultViewWithStatus:@"noLogin"];
    }
    else
    {
        [self getBillingStatusFromService];
    }
}

- (void)getBillingStatusFromService
{
    JJBillListRequest *request = [[JJBillListRequest alloc] init];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;

    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
         [weakSelf.tableView.mj_header endRefreshing];
        JJBillListModel *model = [(JJBillListRequest *)request response];
        if (model.success) {
            if (model.data.count > 0) {
                [weakSelf.billlistArray removeAllObjects];
                [weakSelf.billlistArray addObjectsFromArray:model.data];
                weakSelf.noResultBtn.hidden = YES;
                weakSelf.noResultImg.hidden = YES;
                weakSelf.noResultLab.hidden = YES;
                weakSelf.tableView.hidden = NO;
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf setNoResultViewWithStatus:model.status];
            }
            
        }else{
            [MBProgressHUD showError:model.message];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:[weakSelf strFromErrCode:error]];
    }];
    
    
//    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
//
//    [[VVNetWorkUtility netUtility] getUserBillListWithAccessToken:[UserModel currentUser].token
//                                                          Success:^(id result)
//     {
//
//         [self.tableView.mj_header endRefreshing];
//
//         if ([result[@"success"] integerValue] == 1)
//         {
//             [HUD hide:YES];
//
//             NSArray *list = result[@"data"];
//
//             if (list.count > 0)
//             {
//                 self.noResultBtn.hidden = YES;
//                 self.noResultImg.hidden = YES;
//                 self.noResultLab.hidden = YES;
//
//                 self.tableView.hidden = NO;
//             }
//             else
//             {
//                 [self setNoResultViewWithStatus:result[@"status"]];
//             }
//         }
//         else
//         {
//             [HUD bwm_hideWithTitle:result[@"message"]
//                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
//         }
//
//     } failure:^(NSError *error)
//     {
//         [self.tableView.mj_header endRefreshing];
//         [HUD bwm_hideWithTitle:[self strFromErrCode:error]
//                      hideAfter:kBWMMBProgressHUDHideTimeInterval];
//     }];
}

- (void)setNoResultViewWithStatus:(NSString *)status
{
    self.tableView.hidden = YES;
    
    self.noResultBtn.hidden = NO;
    self.noResultImg.hidden = NO;
    self.noResultLab.hidden = NO;
    
    self.noResultBtn.enabled = YES;
    
    self.noResultLab.text = @"还没有账单哦，快把钱放进口袋里";
    self.noResultImg.image = kGetImage(@"bill_noResult");
    
    CGFloat offSet = -10;
    if([status isEqualToString:@"noApply"] || [status isEqualToString:@"noLogin"])
    {
        [self.noResultBtn setTitle:@"去申请" forState:UIControlStateNormal];
        [self.noResultBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([status isEqualToString:@"apply"])
    {
        [self.noResultBtn setTitle:@"去提现" forState:UIControlStateNormal];
        [self.noResultBtn addTarget:self action:@selector(proposeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([status isEqualToString:@"applyNoClick"] || [status isEqualToString:@"drawNoClick"])
    {
        //"去申请"按钮置灰
        [self.noResultBtn setTitle:@"去申请" forState:UIControlStateNormal];
        self.noResultBtn.enabled = NO;
    }
    else if ([status isEqualToString:@"29"])
    {
        //账单生成中，请耐心等待！
        self.noResultBtn.hidden = YES;
        self.noResultLab.text = @"账单生成中，请耐心等待！";
        self.noResultImg.image = kGetImage(@"img_EDuShenPiZhong");
        offSet = 18;
    }
    else if ([status isEqualToString:@"noView"] )
    {
        self.noResultBtn.hidden = YES;
    }
    
    [self.noResultImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(78+64);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(210, 193));
    }];
    
    [self.noResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noResultImg.mas_bottom).with.offset(offSet);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    [self.noResultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
        make.top.equalTo(self.noResultLab.mas_bottom).offset(40);
    }];
    
}

/**
 *  立即提现
 */
- (void)proposeAction
{
    [self getMainStateRequestIsApply:NO];
}

/**
 *  立即申请
 */
- (void)applyAction
{
    if (!self.isLogin)
    {
        [self loginAndRegisterBtnClck];
        return;
    }
    
    [self getMainStateRequestIsApply:YES];
}

- (void)loginAndRegisterBtnClck
{
    [[JCRouter shareRouter] presentURL:@"login" withNavigationClass:[AppNavigationController class] completion:nil];
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.billlistArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJBillListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJBillListTableViewCell"];
    JJBillListDataModel *model = self.billlistArray[indexPath.section];
    [cell setupUIWithData:model];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  @"  ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 149.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JJBillListDataModel *model = self.billlistArray[indexPath.section];
    if (model.cloanStatus == 0) {
        //已还清，不跳转
        return;
    }
    
    if (model.isOverDue) {
        //status: 未出账:1 已逾期:2 已还款:3
        //postLoanPeriod 总期数
        NSDictionary *param = @{
                                @"drawMoneyApplyId":model.drawMoneyApplyId,
                                @"status":@"2",
                                @"postLoanPeriod":model.postLoanPeriod
                                };
        [[JCRouter shareRouter] pushURL:@"billDetailById" extraParams:param];
    }else{
        //status: 未出账:1 已逾期:2 已还款:3
        NSDictionary *param = @{
                            @"drawMoneyApplyId":model.drawMoneyApplyId,
                                @"status":@"1",
                            @"postLoanPeriod":model.postLoanPeriod
                                };
        [[JCRouter shareRouter] pushURL:@"billDetailById" extraParams:param];
    }
}

@end
