//
//  CouponListViewController.m
//  JieLeHua
//
//  Created by admin on 17/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "CouponListViewController.h"
#import "JJcouponListCell.h"
#import "JJcouponRequest.h"
#pragma mark Constants


#pragma mark - Class Extension

@interface CouponListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray * dataArr;
@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation CouponListViewController

static  NSString * const couponListCellID = @"couponListCell";

#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

+ (id)allocWithRouterParams:(NSDictionary *)params {
    CouponListViewController *instance = [[CouponListViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"我的优惠券"];
    [self addBackButton];
    [self initAndLayoutUI];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
//    [self loadNetData];
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
//    if (self.dataArr.count > 0 ) {
//        [self setupTableView];
//    }else{
        [self setNoResultView];
//    }
}

-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 64, vScreenWidth, vScreenHeight - 64);
    tableView.backgroundColor = VVWhiteColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource  =  self;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"JJcouponListCell" bundle:nil] forCellReuseIdentifier:couponListCellID];
    self.tableView = tableView;
}

- (void)setNoResultView
{
    UIImageView *noResultImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_noBank"]];
    [self.view addSubview:noResultImg];
    UILabel *noResultLab = [[UILabel alloc] init];
    noResultLab.textAlignment = NSTextAlignmentCenter;
    noResultLab.font = [UIFont systemFontOfSize:17];
    noResultLab.textColor = VVColor(153, 153, 153);
    noResultLab.text = @"暂时没有优惠券";
    [self.view addSubview:noResultLab];
    
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
}

#pragma tableviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JJcouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:couponListCellID];
    JJcouponDataModel *dataModel = self.dataArr[indexPath.row];
    NSString *nameTxt ;
    NSString *bgName ;
    NSString *voucherCredit ;
    NSString * tempStr =[VVCommonFunc formatWithTimestamp:dataModel.voucherValidityTime *0.001];

    if ([dataModel.voucherType isEqualToString:@"1"]) {
        nameTxt = @"提额券";
        bgName = @"img_my_bg_Coupons";
        voucherCredit = [NSString stringWithFormat:@"￥%@",dataModel.voucherCredit];
    }else{
        nameTxt = @"抵扣券";
        bgName = @"img_my_bg_Deductible";
        voucherCredit = [NSString stringWithFormat:@"%@%@",dataModel.voucherCredit,@"%"];
    }
    cell.nameLabel.text = nameTxt;
    cell.numberLabel.text = voucherCredit;
    cell.limitedDateLabel.text = [NSString stringWithFormat: @"有效期至%@",tempStr];
    cell.noteLabel.text = dataModel.voucherRemark;
    cell.bgImageView.image = [UIImage imageNamed:bgName];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -----loadData

-(void)loadNetData{
    
    JJcouponRequest *request = [[JJcouponRequest alloc]initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        __weak typeof(self)strongSelf = weakSelf;
     JJcouponModel *model = [(JJcouponRequest *)request response];
        if (model.success && model.data.count >0) {
            strongSelf.dataArr =model.data;
            [strongSelf initAndLayoutUI];
            [strongSelf.tableView reloadData];
        }else{
            [strongSelf setNoResultView];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf setNoResultView];
    }];
    
    
}


@end
