//
//  JJOverDueViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJOverDueViewController.h"
#import "JJOverdueBillRequest.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"
#import "JJOverDueTableViewCell.h"
#import "MJChiBaoZiHeader.h"
#import "JJHomeStatusRequest.h"

@interface JJOverDueViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) JJOverDueListModel *overDueListModel;
@property (nonatomic, strong) UITableView *overdueListTable;

@end

@implementation JJOverDueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.overdueListTable = ({
        UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableview];
        tableview;
    });
    __weak __typeof(self)weakSelf = self;
    self.overdueListTable.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        if (nil == weakSelf.customerBillId) {
            [self getBillCustomerId];
            return ;
        }
        [weakSelf getOverdueBillList];
    }];
    self.overdueListTable.hidden = YES;
    [self getBillCustomerId];
    [self addReloadTarget:self action:@selector(getOverdueBillList)];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [self.overdueListTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(0);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.overDueListModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJOverDueTableViewCell *cell = (JJOverDueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"overdueCell"];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JJOverDueTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    [cell setupOverdueCellWithData:[self.overDueListModel.data objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //暂时没有详情
    return;
//    JJOverDueListDataModel *model = [self.overDueListModel.data objectAtIndex:indexPath.row];
//    [[JCRouter shareRouter] pushURL:[NSString stringWithFormat:@"overdueDetail/%@",@(model.customerBillId)]];
}

#pragma mark - 网络请求
//刷新
-(void)refreashOverDueView{
    [self getOverdueBillList];
}

- (void)getBillCustomerId
{
    JJHomeStatusRequest *request = [[JJHomeStatusRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc]initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJMainStateModel *statusModel = [JJMainStateModel mj_objectWithKeyValues:request.responseJSONObject];
        if (statusModel.success) {
            [strongSelf hiddenFailLoadViewView];
            strongSelf.customerBillId = statusModel.summary.customerBillId;
            [strongSelf getOverdueBillList];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {

    }];
}

///获取逾期账单列表
- (void)getOverdueBillList
{
    if (nil == self.customerBillId) {
        [self setFailY:0];
        self.overdueListTable.hidden = YES;
        [self showErrorPlaceholdView:kGetImage(@"img_empty_state_1") errorMsg:@"恭喜您，没有逾期账单，请继续保持"];
        if ([self.delegate respondsToSelector:@selector(updateWithData:isFail:)]) {
            [self.delegate updateWithData:self.overDueListModel isFail:YES];
        }
        return;
    }
    JJOverdueBillRequest *request = [[JJOverdueBillRequest alloc] initWithCustomerBillId:self.customerBillId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.overdueListTable.mj_header endRefreshing];
        JJOverDueListModel *model = [(JJOverdueBillRequest *)request response];
        if (model.success) {
            strongSelf.overDueListModel = model;
            if (strongSelf.overDueListModel.data.count == 0) {
                strongSelf.overdueListTable.hidden = YES;
                [strongSelf showErrorPlaceholdView:kGetImage(@"img_empty_state_1") errorMsg:@"恭喜您，没有逾期账单，请继续保持"];
                [strongSelf setFailY:0];
                if ([strongSelf.delegate respondsToSelector:@selector(updateWithData:isFail:)]) {
                    [strongSelf.delegate updateWithData:strongSelf.overDueListModel isFail:YES];
                }
            }else{
                strongSelf.overdueListTable.hidden = NO;
                [strongSelf hiddenFailLoadViewView];
                if ([strongSelf.delegate respondsToSelector:@selector(updateWithData:isFail:)]) {
                    [strongSelf.delegate updateWithData:strongSelf.overDueListModel isFail:NO];
                }
                [strongSelf.overdueListTable reloadData];
            }
        }else{
            [strongSelf setFailY:0];
            strongSelf.overdueListTable.hidden = YES;
            [strongSelf showErrorPlaceholdView:kGetImage(@"img_empty_state_1") errorMsg:@"恭喜您，没有逾期账单，请继续保持"];
            if ([strongSelf.delegate respondsToSelector:@selector(updateWithData:isFail:)]) {
                [strongSelf.delegate updateWithData:strongSelf.overDueListModel isFail:YES];
            }
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.overdueListTable.mj_header endRefreshing];
        strongSelf.overdueListTable.hidden = YES;
        [strongSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
        [strongSelf setFailY:0];
        if ([strongSelf.delegate respondsToSelector:@selector(updateWithData:isFail:)]) {
            [strongSelf.delegate updateWithData:strongSelf.overDueListModel isFail:YES];
        }
    }];
}

@end
