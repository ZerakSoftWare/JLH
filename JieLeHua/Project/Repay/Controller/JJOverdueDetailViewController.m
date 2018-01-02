//
//  JJOverdueDetailViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/11.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJOverdueDetailViewController.h"
#import "JJCustomerBillDetailRequest.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"
static NSString *overdueDetailCell = @"overdueDetailCell";
@interface JJOverdueDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) JJOverDueListModel *detailModel;
@end

@implementation JJOverdueDetailViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        self.customerBillId = [params safeObjectForKey:@"billid"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"账单选择"];
    [self addBackButton];
    
    self.detailTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.view insertSubview:self.detailTableView aboveSubview:_scrollView];
    self.detailTableView.y = 64;
    [self getBillDetail];
    [self addReloadTarget:self action:@selector(reloadDetailData)];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:overdueDetailCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:overdueDetailCell];
    }
    cell.textLabel.text = @"1";
    cell.detailTextLabel.text = @"2";
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [@[@"本金与利息",@"其他费用"] objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

#pragma mark - 获取数据
- (void)reloadDetailData
{
    [self hiddenFailLoadViewView];
    [self getBillDetail];
}

- (void)getBillDetail
{
    JJCustomerBillDetailRequest *request = [[JJCustomerBillDetailRequest alloc] initWithCustomerBillId:self.customerBillId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        JJOverDueListModel *model = [(JJCustomerBillDetailRequest*)request response];
        if (model.success) {
            self.detailModel = model;
            self.detailTableView.hidden = NO;
            [self.detailTableView reloadData];
        }else{
            self.detailTableView.hidden = YES;
            [self showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}
@end
