//
//  JJBillDetailViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBillDetailViewController.h"
#import "IntroduceToolbarView.h"
#import "JJGetBillDetailByIdRequest.h"
#import "JJGetNextPeriodBillRequest.h"
#import "JJReturnedTableViewCell.h"
#import "JJNotRepayBillTableViewCell.h"
#import "JJRepayInfoRequest.h"
#import "JJOverDueListTableViewCell.h"
#import "JJGetNextPeriodBillModel.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"
#import "JJGetTipsRequest.h"

@interface JJBillDetailViewController ()<IntroduceToolbarViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL isOverDue;

@property (nonatomic, strong) IntroduceToolbarView *toolbarView;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAGradientLayer *overDueGradientLayer;


@property (nonatomic, copy) NSString *drawMoneyApplyId;

@property (nonatomic, strong) UITableView *billDetailTableView;

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *whiteDesLabel;

@property (nonatomic, assign) int  selectedIndex;

@property (nonatomic, strong) UIButton *repayBtn;//立即还款按钮
@property (nonatomic, strong) UIButton *advRepayBtn;//提前清贷按钮
@property (nonatomic, strong) UIButton *overDueBtn;//逾期还款按钮

@property (nonatomic, strong) NSMutableArray *overDueBillDetails;
@property (nonatomic, strong) NSMutableArray *payedBillDetails;
@property (nonatomic, strong) JJGetNextPeriodBillModel *nextPeriodModel;
@property (nonatomic, copy) NSString *postLoanPeriod;
@property (nonatomic, assign) BOOL hasOverDue;
@property (nonatomic, assign) BOOL hasRepayed;
@property (nonatomic, copy) NSString *bankAccount;


@property (nonatomic, strong) JJBillDetailModel *detailModel;
@property (nonatomic, strong) JJTipsModel *tipsModel;

@end

@implementation JJBillDetailViewController
+ (id)allocWithRouterParams:(NSDictionary *)params
{
    JJBillDetailViewController *instance = [[JJBillDetailViewController alloc] init];
    instance.drawMoneyApplyId = [params safeObjectForKey:@"drawMoneyApplyId"];
    instance.postLoanPeriod = [params safeObjectForKey:@"postLoanPeriod"];
    instance.selectedIndex = [[params safeObjectForKey:@"status"] intValue];
    return instance;
}

#pragma mark - Properties
- (UIButton *)overDueBtn
{
    if (!_overDueBtn) {
        _overDueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _overDueBtn.layer.cornerRadius = 22.5f;
        _overDueBtn.clipsToBounds = YES;
        [_overDueBtn setTitle:@"偿还逾期" forState:UIControlStateNormal];
        [_overDueBtn addTarget:self action:@selector(overDueAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overDueBtn;
}

- (UIButton *)advRepayBtn {
    if (!_advRepayBtn) {
        _advRepayBtn = [VVCommonButton hollowBlueButtonWithTitle:@"提前清贷"];
        _advRepayBtn.layer.cornerRadius = 22.5f;
        _advRepayBtn.clipsToBounds = YES;
        [_advRepayBtn addTarget:self action:@selector(advRepayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _advRepayBtn;
}

- (UIButton *)repayBtn {
    if (!_repayBtn) {
        _repayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _repayBtn.layer.cornerRadius = 22.5f;
        _repayBtn.clipsToBounds = YES;
        [_repayBtn setTitle:@"立即还款" forState:UIControlStateNormal];
        [_repayBtn addTarget:self action:@selector(repayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repayBtn;
}

- (IntroduceToolbarView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [[IntroduceToolbarView alloc] initWithFrame:CGRectMake(0, 76, 282, 32)];
        _toolbarView.delegate = self;
        _toolbarView.lightColor = VVColor(75, 231, 243);
        _toolbarView.deepColor = VVColor(88, 152, 242);
        _toolbarView.backColor = VVColor(232, 236, 239);
        _toolbarView.layer.cornerRadius = 16;
        _toolbarView.clipsToBounds = YES;
    }
    return _toolbarView;
}

- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, vScreenWidth, vScreenHeight- 108)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

- (UITableView *)billDetailTableView
{
    if (!_billDetailTableView) {
        _billDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight - 64) style:UITableViewStylePlain];
        _billDetailTableView.delegate = self;
        _billDetailTableView.dataSource = self;
        _billDetailTableView.tableFooterView = [[UIView alloc] init];
        _billDetailTableView.backgroundColor = VVColor(241, 244, 246);
        [_billDetailTableView registerNib:[UINib nibWithNibName:@"JJReturnedTableViewCell" bundle:nil] forCellReuseIdentifier:@"JJReturnedTableViewCell"];
        [_billDetailTableView registerNib:[UINib nibWithNibName:@"JJNotRepayBillTableViewCell" bundle:nil] forCellReuseIdentifier:@"JJNotRepayBillTableViewCell"];
        
        [_billDetailTableView registerNib:[UINib nibWithNibName:@"JJOverDueListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JJOverDueListTableViewCell"];
    }
    return _billDetailTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nextPeriodModel = nil;
    [self.overDueBillDetails removeAllObjects];
    [self.payedBillDetails removeAllObjects];
    [self.toolbarView setSelectedBtnIndex:self.selectedIndex-1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"账单明细"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackButton];
    self.hasRepayed = self.hasOverDue = YES;
    [self getTips];
    [self initAndLayoutUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.gradientLayer.frame = self.repayBtn.bounds;
    self.overDueGradientLayer.frame = self.repayBtn.bounds;
    
    [self.overDueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.overDueBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [self.repayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repayBtn.titleLabel.font = [UIFont systemFontOfSize:17];
}

- (void)initAndLayoutUI
{
    self.overDueBillDetails = [NSMutableArray array];
    self.payedBillDetails = [NSMutableArray array];

    /***************选项组***************/
    self.toolbarView.centerX = self.view.centerX;
    NSArray *arry = @[@"未出账",@"已逾期",@"已还款"];
    self.toolbarView.productArr = arry;
    [self.view addSubview:self.toolbarView];
    [self.view addSubview:self.billDetailTableView];
    [self.view addSubview:self.repayBtn];
    [self.view addSubview:self.advRepayBtn];
    [self.view addSubview:self.overDueBtn];
    [self.view addSubview:self.whiteView];
    [self addReloadTarget:self action:@selector(reloadData)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"approvalMoneyImg"]];
    imageView.frame = CGRectMake(0, 0, 204, 168);
    //        imageView.center = _whiteView.center;
    [_whiteView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_whiteView);
        make.size.mas_equalTo(CGSizeMake(204, 168));
    }];
    
    _whiteDesLabel = [[UILabel alloc] init];
    _whiteDesLabel.textColor = [UIColor colorWithHexString:@"999999"];
    _whiteDesLabel.font = [UIFont systemFontOfSize:17];
    _whiteDesLabel.textAlignment = NSTextAlignmentCenter;
    _whiteDesLabel.text = @"暂无已还款账单";
    [_whiteView addSubview:_whiteDesLabel];
    [_whiteDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(8);
        make.centerX.mas_equalTo(_whiteView);
        make.height.mas_offset(@24);
    }];
    
    
    [_billDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toolbarView.mas_bottom).with.offset(10);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        
    }];
    
    [self.repayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(83);
        make.right.equalTo(self.view).offset(-83);
        make.bottom.equalTo(self.view).offset(-89.5);
        make.height.equalTo(@45);
    }];
    
    [self.advRepayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(83);
        make.right.equalTo(self.view).offset(-83);
        make.bottom.equalTo(self.view).offset(-24.5);
        make.height.equalTo(@45);
    }];
    
    [self.overDueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(83);
        make.right.equalTo(self.view).offset(-83);
        make.bottom.equalTo(self.view).offset(-24.5);
        make.height.equalTo(@45);
    }];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.locations = @[@0,@1.0f];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5f);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5f);
    [self.repayBtn.layer addSublayer:self.gradientLayer];
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"00D3FE"].CGColor,
                                  (__bridge id)[UIColor colorWithHexString:@"37A1FF"].CGColor];
    
    self.overDueGradientLayer = [CAGradientLayer layer];
    self.overDueGradientLayer.locations = @[@0,@1.0f];
    self.overDueGradientLayer.startPoint = CGPointMake(0, 0.5f);
    self.overDueGradientLayer.endPoint = CGPointMake(1, 0.5f);
    [self.overDueBtn.layer addSublayer:self.overDueGradientLayer];
    self.overDueGradientLayer.colors = @[(__bridge id)RGB(255, 199, 150).CGColor,
                                         (__bridge id)RGB(255, 107, 149).CGColor];
    
//    --判断已逾期中的数据是否为空.界面显示不一样
    
}


#pragma mark - 请求数据
- (void)getBillDetail
{
    JJGetBillDetailByIdRequest *request = [[JJGetBillDetailByIdRequest alloc] initWithDrawMoneyApplyId:self.drawMoneyApplyId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJBillDetailModel *model = [(JJGetBillDetailByIdRequest *)request response];
//        VVLog(@"%@",[model.data.jlhCustomerBillDetails.firstObject customerBillId]);
//        JJCustomerBillDetailDataModel *test = model.data.jlhCustomerBillDetails.firstObject;
//        VVLog(@"%@",test.customerBillDetaillId);
        weakSelf.bankAccount = model.data.bankAccount;
        if (model.success) {
            weakSelf.detailModel = model;
            [weakSelf hiddenFailLoadViewView];
            weakSelf.whiteView.hidden = YES;
            [weakSelf.overDueBillDetails removeAllObjects];
            [weakSelf.payedBillDetails removeAllObjects];
            /** billStatus——账单状态（1：未还2：部分还3：已还）  */
            NSPredicate *predicate;
            predicate=[NSPredicate predicateWithFormat:@"billStatus == 3"];
            NSArray *payedResults=[model.data.jlhCustomerBillDetails filteredArrayUsingPredicate:predicate];
            [weakSelf.payedBillDetails addObjectsFromArray:payedResults];
            
            
//                NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"age > 25"];
            predicate=[NSPredicate predicateWithFormat:@"billStatus < 3"];
            NSArray *overDueResults=[model.data.jlhCustomerBillDetails filteredArrayUsingPredicate:predicate];
            [weakSelf.overDueBillDetails addObjectsFromArray:overDueResults];
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:weakSelf.payedBillDetails];
            for (JJCustomerBillDetailDataModel *model in weakSelf.payedBillDetails) {
                if ([model.billPeriod isEqualToString:@"0"]) {
                    if ([model.dueSumamt isEqualToString:@"0"]&&[model.reSumAmt isEqualToString:@"0"]) {
                        [temp removeObject:model];
                    }
                }
            }
            weakSelf.payedBillDetails = temp;
            if (weakSelf.payedBillDetails.count > 0) {
                weakSelf.hasRepayed = YES;
            }else{
                weakSelf.hasRepayed = NO;
            }
            
            
            NSMutableArray *overTemp = [NSMutableArray arrayWithArray:weakSelf.overDueBillDetails];
            for (JJCustomerBillDetailDataModel *model in weakSelf.overDueBillDetails) {
                if ([model.billPeriod isEqualToString:@"0"]) {
                    if ([model.dueSumamt isEqualToString:@"0"]&&[model.reSumAmt isEqualToString:@"0"]) {
                        [overTemp removeObject:model];
                    }
                }
            }
            weakSelf.overDueBillDetails = overTemp;

            
            
            
            if (overDueResults.count > 0) {
                weakSelf.hasOverDue = YES;
            }else{
                weakSelf.hasOverDue = NO;
            }
            
            if (!weakSelf.hasOverDue && weakSelf.selectedIndex == 2) {
                weakSelf.whiteView.hidden = NO;
                weakSelf.whiteDesLabel.text = @"暂无逾期帐单";
                return;
            }
            if (!weakSelf.hasRepayed && weakSelf.selectedIndex == 3) {
                weakSelf.whiteView.hidden = NO;
                weakSelf.whiteDesLabel.text = @"暂无已还款帐单";
                return;
            }
            weakSelf.whiteView.hidden = YES;
            [weakSelf.billDetailTableView reloadData];
        }else{
            [weakSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];

        }
        
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [weakSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
    }];
}

- (void)getNextBill
{
    JJGetNextPeriodBillRequest *request = [[JJGetNextPeriodBillRequest alloc] init];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;

    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJGetNextPeriodBillModel *model = [(JJGetNextPeriodBillRequest *)request response];
        if (model.success) {
            [weakSelf hiddenFailLoadViewView];

            weakSelf.nextPeriodModel = model;
            if (weakSelf.nextPeriodModel.data == nil) {
                //无未出账账单
                weakSelf.whiteView.hidden = NO;
                weakSelf.whiteDesLabel.text = @"暂无未出账帐单";
            }else{
                weakSelf.whiteView.hidden = YES;
                if ([model.data.cloanStatus isEqualToString:@"未出账"]) {
                    weakSelf.repayBtn.hidden = NO;
                    weakSelf.advRepayBtn.hidden = NO;
                    weakSelf.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"00D3FE"].CGColor,
                                                  (__bridge id)[UIColor colorWithHexString:@"37A1FF"].CGColor];
                }
                else if ([model.data.cloanStatus isEqualToString:@"已还款"]) {
                    weakSelf.repayBtn.enabled = NO;
                    weakSelf.repayBtn.hidden = NO;
                    weakSelf.advRepayBtn.hidden = YES;
                    weakSelf.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"CCCCCC"].CGColor,(__bridge id)[UIColor colorWithHexString:@"CCCCCC"].CGColor];
//                    weakSelf.advRepayBtn.hidden = NO;
                }
                else{
                    weakSelf.repayBtn.hidden = YES;
                    weakSelf.advRepayBtn.hidden = YES;
                }
                [weakSelf.billDetailTableView reloadData];
            }
            
            [weakSelf.billDetailTableView reloadData];
        }else{
            [weakSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
        }
        
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [weakSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
    }];
}

- (void)reloadData
{
    [self hiddenFailLoadViewView];
    [self.toolbarView setSelectedBtnIndex:self.selectedIndex-1];
}

- (void)getTips
{
    JJGetTipsRequest *request = [[JJGetTipsRequest alloc] initWithType:@"8"];
    __weak __typeof(self)weakSelf = self;
    
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJTipsModel *model = [(JJGetTipsRequest *)request response];
        if (model.success) {
            weakSelf.tipsModel = model;
            [weakSelf.billDetailTableView reloadData];
        }else{
            
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

#pragma mark - IntroduceToolbarViewDelegate

- (void)topToolbar:(IntroduceToolbarView *)topToolbar didSelectedTag:(int)tag
{
//    self.repayBtn.hidden = YES;
    self.overDueBtn.hidden = YES;
    CGFloat offset = 0.0;
    self.selectedIndex = tag;
    switch (tag) {
        case 1:
        {
            //--未出账
            self.overDueBtn.hidden = YES;
            self.repayBtn.hidden = self.advRepayBtn.hidden = NO;
            offset = -76;
            if (self.nextPeriodModel == nil) {
                self.whiteView.hidden = NO;
                [self getNextBill];
            }else{
                if (self.nextPeriodModel.data == nil) {
                    //无未出账章党
                    self.whiteView.hidden = NO;
                    self.whiteDesLabel.text = @"暂无未出账帐单";
                }else{
                    self.whiteView.hidden = YES;
                    
                        if ([self.nextPeriodModel.data.cloanStatus isEqualToString:@"未出账"]) {
                        self.repayBtn.hidden = NO;
                        self.advRepayBtn.hidden = NO;
                        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"00D3FE"].CGColor,
                                                      (__bridge id)[UIColor colorWithHexString:@"37A1FF"].CGColor];
                    }
                    else if ([self.nextPeriodModel.data.cloanStatus isEqualToString:@"已还款"]) {
                        self.repayBtn.enabled = NO;
                        self.repayBtn.hidden = NO;
                        self.advRepayBtn.hidden = YES;
                        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"CCCCCC"].CGColor,(__bridge id)[UIColor colorWithHexString:@"CCCCCC"].CGColor];
                        //                    weakSelf.advRepayBtn.hidden = NO;
                    }
                    else{
                        self.repayBtn.hidden = YES;
                        self.advRepayBtn.hidden = YES;
                    }
                    
                    [self.billDetailTableView reloadData];
                }
            }
        }
            break;
        case 2:
        {
            //--已逾期
            self.overDueBtn.hidden = NO;
            self.repayBtn.hidden = self.advRepayBtn.hidden = YES;
            offset = -76;
            if (self.overDueBillDetails.count == 0) {
                if (!self.hasOverDue) {
                    self.whiteView.hidden = NO;
                    self.whiteDesLabel.text = @"暂无逾期帐单";
                    return;
                }
                self.whiteView.hidden = YES;
                [self getBillDetail];
            }else{
                self.whiteView.hidden = YES;
                [self.billDetailTableView reloadData];
            }
        }
            break;
        case 3:
        {
            offset = 0;
            self.overDueBtn.hidden = YES;
            self.repayBtn.hidden = self.advRepayBtn.hidden = YES;
            if (self.payedBillDetails.count == 0) {
                if (!self.hasRepayed) {
                    self.whiteView.hidden = NO;
                    self.whiteDesLabel.text = @"暂无已还款帐单";
                    return;
                }
                self.whiteView.hidden = YES;
                [self getBillDetail];
            }else{
                self.whiteView.hidden = YES;
                [self.billDetailTableView reloadData];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.selectedIndex == 1) {
        JJNotRepayBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJNotRepayBillTableViewCell"];
        if (indexPath.row == 0) {
            cell.titleContentLabel.text = @"账单期数";
            cell.periodLabel.text = [NSString stringWithFormat:@"%@/%@期",self.nextPeriodModel.data.billPeriod,self.nextPeriodModel.data.postLoanPeriod];;
            cell.statusLabel.text = self.nextPeriodModel.data.cloanStatus;
            if ([self.nextPeriodModel.data.cloanStatus isEqualToString:@"未出账"]) {
                cell.statusLabel.textColor = [UIColor colorWithHexString:@"999999"];
            }else if ([self.nextPeriodModel.data.cloanStatus isEqualToString:@"还款中"]){
                cell.statusLabel.textColor = [UIColor colorWithHexString:@"0D88FF"];
            }else{
                cell.statusLabel.textColor = [UIColor colorWithHexString:@"77C627"];
            }
        }
        else if (indexPath.row == 1) {
            cell.titleContentLabel.text = @"账单金额";
            cell.periodLabel.text = [NSString stringWithFormat:@"%@元",self.nextPeriodModel.data.dueSumamt];
            cell.statusLabel.text = @"";
        }
        else{
            cell.titleContentLabel.text = @"还款日";
            cell.periodLabel.text = [NSString stringWithFormat:@"%@月%@号",self.nextPeriodModel.data.month,self.nextPeriodModel.data.day];
            cell.statusLabel.text = @"";
        }
        return cell;
    }
    else if (self.selectedIndex == 3) {
        JJReturnedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJReturnedTableViewCell"];
        JJCustomerBillDetailDataModel *data = self.payedBillDetails[indexPath.row];
        data.postLoanPeriod = self.postLoanPeriod;
        [cell setUpWithData:data];
        return cell;
    }
    JJOverDueListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JJOverDueListTableViewCell"];
    JJCustomerBillDetailDataModel *data = self.overDueBillDetails[indexPath.row];
    data.postLoanPeriod = self.postLoanPeriod;
    
    [cell setUpWithData:data];
//    if ([data.billPeriod isEqualToString:@"0"]) {
//        cell.desLabel.text = [NSString stringWithFormat:@"请存入尾号(%@)银行卡等待自动扣款",self.bankAccount];
//    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedIndex == 1) {
        return 3;
    }
    if (self.selectedIndex == 2) {
        return self.overDueBillDetails.count;
    }
    return self.payedBillDetails.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  @"  ";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.selectedIndex == 1) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = [UIColor colorWithHexString:@"FB4F4F"];
        NSMutableString *tips = [NSMutableString string];
        [tips appendString:@"注：\n"];
        for (int i = 0; i < self.tipsModel.data.count; i++) {
            [tips appendString:[self.tipsModel.data objectAtIndex:i].remark];
            [tips appendString:@"\n"];
        }
        contentLabel.text = tips?tips:@"注：\n1、银行自动扣款时，请于还款日17:00前存入款项，直至扣款成功请勿取出。\n2、主动还款时，请于还款日17:00前完成还款，还款日17:00起至第二天24:00为公司对账期，暂时无法主动还款";
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        [footerView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView).offset(12);
            make.right.equalTo(footerView).offset(-12);
            make.bottom.equalTo(footerView).offset(-10);
            make.top.equalTo(footerView).offset(10);
        }];
        
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.selectedIndex == 1) {
        NSMutableString *tips = [NSMutableString string];
        [tips appendString:@"注：\n"];
        for (int i = 0; i < self.tipsModel.data.count; i++) {
            [tips appendString:[self.tipsModel.data objectAtIndex:i].remark];
            [tips appendString:@"\n"];
        }
        
        NSString *string = tips?tips:@"注：\n1、银行自动扣款时，请于还款日17:00前存入款项，直至扣款成功请勿取出。\n2、主动还款时，请于还款日17:00前完成还款，还款日17:00起至第二天24:00为公司对账期，暂时无法主动还款";
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(vScreenWidth - 30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height + 25;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 2) {
        return 42.f;
    }
    return 46.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

#pragma mark - 按钮事件
- (void)overDueAction
{
    if ([self.detailModel.billTips length] > 0) {
        [VVAlertUtils showAlertViewWithMessage:self.detailModel.billTips cancelButtonTitle:@"确定" tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
    [self gotoPayWithType:@"1"];
}

- (void)advRepayAction
{
    if ([self.nextPeriodModel.billTips length] > 0) {
        [VVAlertUtils showAlertViewWithMessage:self.nextPeriodModel.billTips cancelButtonTitle:@"确定" tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
    NSString *string = @"repay/1";
    [[JCRouter shareRouter] pushURL:string];
}

- (void)repayAction
{
    NSString *urlType;
    int payTag = (int)self.toolbarView.selectedButton.tag-1989;
    if (payTag == 0)
    {
        //--提前还款
        urlType = @"2";
    }
    else
    {
        urlType = @"1";
    }
    
    if ([self.nextPeriodModel.billTips length] > 0) {
        [VVAlertUtils showAlertViewWithMessage:self.nextPeriodModel.billTips cancelButtonTitle:@"确定" tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
    if (self.nextPeriodModel.billNextDay) {
        NSString *day = [NSString stringWithFormat:@"%@月%@日",[[self.nextPeriodModel.billNextDay substringFromIndex:5] substringToIndex:2],[[self.nextPeriodModel.billNextDay substringFromIndex:8] substringToIndex:2]];
        NSString *message = [NSString stringWithFormat:@"成功偿还本期未到期账单后，为保证对账准确，您于%@前将无法提前清贷",day];
        [VVAlertUtils showAlertViewWithTitle:@"提示" message:message customView:nil cancelButtonTitle:@"暂不还款" otherButtonTitles:@[@"继续还款"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex  != kCancelButtonTag) {
                [alertView hideAlertViewAnimated:YES];
                [self gotoPayWithType:urlType];
            }
        }];
    }
}

- (void)gotoPayWithType:(NSString *)type
{
    JJRepayInfoRequest *request = [[JJRepayInfoRequest alloc]initWithType:type];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        JJRepayInfoModel *model = [(JJRepayInfoRequest *)request response];
        if (model.success) {
            JJRepayInfoDataModel *data = model.data;
            NSString *billDate;
            if ([type isEqualToString:@"1"]) {
                billDate = @"逾期账单";
            }else{
                billDate  = [NSString stringWithFormat:@"%d/%d期",data.lastBillIndex,data.sumBillIndex];
            }
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
            NSDictionary *dic = @{@"source":@"billWeb",
                                  @"urlType":type,
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

@end
