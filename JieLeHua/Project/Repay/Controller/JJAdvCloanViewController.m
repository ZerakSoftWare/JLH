//
//  JJAdvCloanViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJAdvCloanViewController.h"
#import "JJAheadTableViewCell.h"
#import "JJQueryAdvCloanRequest.h"
#import "MJChiBaoZiHeader.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"

@interface JJAdvCloanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *advCloanTable;
@property (nonatomic, strong) JJCloanInfoModel *cloanInfoModel;
@end

@implementation JJAdvCloanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.advCloanTable = ({
        UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        tableview.delegate = self;
        tableview.dataSource = self;
        [self.view addSubview:tableview];
        tableview;
    });
    
    __weak __typeof(self)weakSelf = self;
    self.advCloanTable.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        [weakSelf getAdvCloanList];
    }];
    self.advCloanTable.hidden = YES;
    [self getAdvCloanList];
    [self addReloadTarget:self action:@selector(getAdvCloanList)];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [self.advCloanTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJAheadTableViewCell *cell = (JJAheadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"aheadCell"];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JJAheadTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"待还本金总额";
                cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[self.cloanInfoModel.data.CloanInfo firstObject].DueCapitalAmt floatValue]];
            }else{
                cell.titleLabel.text = @"剩余利息";
                cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[self.cloanInfoModel.data.CloanInfo firstObject].AddInterest floatValue] +[[self.cloanInfoModel.data.CloanInfo firstObject].ClearHandFee floatValue]];
            }
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"担保费";
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[self.cloanInfoModel.data.CloanInfo firstObject].AddGuaranteeFee floatValue]];
        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"总计";
            cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[self.cloanInfoModel.data.CloanInfo firstObject].Amt];
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [@[@"待还本金及利息",@"其他费用",@"总计"] objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 80.5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80.5)];
        footerView.backgroundColor = [UIColor whiteColor];
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, kScreenWidth - 24, 17)];
        tipLabel.text = @"＊提前还款，需一次性偿还所有未到期账单";
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.textColor = [UIColor colorWithHexString:@"ff3131"];
        [footerView addSubview:tipLabel];
        return footerView;
    }
    return nil;
}

#pragma mark - 获取列表数据
- (void)getAdvCloanList
{
    JJQueryAdvCloanRequest *request = [[JJQueryAdvCloanRequest alloc] init];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.advCloanTable.mj_header endRefreshing];
        JJCloanInfoModel *model = [(JJQueryAdvCloanRequest *)request response];
        if (model.success) {
            self.cloanInfoModel = model;
            if (self.cloanInfoModel.data.CloanInfo.count == 0) {
                self.advCloanTable.hidden = YES;
                [self showErrorPlaceholdView:kGetImage(@"img_empty_state_1") errorMsg:@"暂无未到期账单，快去提现吧！"];
                [strongSelf setFailY:0];
                if ([strongSelf.delegate respondsToSelector:@selector(updateWithAdvData:isFail:)]) {
                    [strongSelf.delegate updateWithAdvData:self.cloanInfoModel isFail:YES];
                }
            }else{
                if (![self.cloanInfoModel.data.CloanInfo.firstObject IsAllowAdv]) {
                    self.advCloanTable.hidden = YES;
                    [self showErrorPlaceholdView:kGetImage(@"img_empty_state_1") errorMsg:@"很抱歉，暂时无法提前清贷！"];
                    [strongSelf setFailY:0];
                    if ([strongSelf.delegate respondsToSelector:@selector(updateWithAdvData:isFail:)]) {
                        [strongSelf.delegate updateWithAdvData:self.cloanInfoModel isFail:YES];
                    }
                }else{
                    self.advCloanTable.hidden = NO;
                    [self hiddenFailLoadViewView];
                    if ([self.delegate respondsToSelector:@selector(updateWithAdvData:isFail:)]) {
                        [self.delegate updateWithAdvData:self.cloanInfoModel isFail:NO];
                    }
                    [self.advCloanTable reloadData];
                }
            }
        }else{
            self.advCloanTable.hidden = YES;
            [self showErrorPlaceholdView:kGetImage(@"img_empty_state_1") errorMsg:@"暂无未到期账单，快去提现吧！"];
            [strongSelf setFailY:0];
            if ([strongSelf.delegate respondsToSelector:@selector(updateWithAdvData:isFail:)]) {
                [strongSelf.delegate updateWithAdvData:nil isFail:YES];
            }
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.advCloanTable.mj_header endRefreshing];
        strongSelf.advCloanTable.hidden = YES;
        [strongSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
        [strongSelf setFailY:0];
        if ([strongSelf.delegate respondsToSelector:@selector(updateWithAdvData:isFail:)]) {
            [strongSelf.delegate updateWithAdvData:nil isFail:YES];
        }
    }];
}

@end
