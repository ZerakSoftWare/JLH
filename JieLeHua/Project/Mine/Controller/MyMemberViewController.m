//
//  MyMemberViewController.m
//  JieLeHua
//
//  Created by admin on 2017/12/21.
//Copyright © 2017年 Vcredit. All rights reserved.
//

#import "MyMemberViewController.h"
#import "MemberTableViewCell.h"
#import "JJMemberFeeBillModel.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface MyMemberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArry;

@property (nonatomic, assign) BOOL drawPhoneFailed;

/*退款成功后移除*/
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *phoneLab;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation MyMemberViewController


#pragma mark - Properties

- (UILabel *)phoneLab {
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        _phoneLab.font = kFont_NormalTitle;
        _phoneLab.textAlignment = NSTextAlignmentCenter;
        _phoneLab.textColor = VVWhiteColor;
    }
    return _phoneLab;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.image = kGetImage(@"img_user_head_protrait_m");
    }
    return _headImg;
}

- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 6;
        _whiteView.clipsToBounds = YES;
    }
    return _whiteView;
}

- (NSMutableArray *)listArry {
    if (!_listArry) {
        _listArry = [[NSMutableArray alloc] init];
    }
    return _listArry;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.rowHeight = 88;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyMemberVC" object:nil];
}


#pragma mark - Public Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTableViewCell *cell = [MemberTableViewCell  cellWithTableView:tableView];
    
    JJMemberFeeBillModel *item = self.listArry[indexPath.row];
    cell.item = item;
    
    if (indexPath.row == 0 && [item.memberfeeStatus isEqualToString:@"1"])
    {
        cell.applyRefundBtn.hidden = self.drawPhoneFailed;
    }
    else
    {
        cell.applyRefundBtn.hidden = YES;
    }
        
    cell.clickOperation = ^{
        [[JCRouter shareRouter] pushURL:@"refund"];
    };
    
    return cell;
}

#pragma mark - Overridden Methods

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    MyMemberViewController *instance = [[MyMemberViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"乐花优享"];
    self.view.backgroundColor = RGB(30, 139, 251);

    [self addBackButton];
    
    self.drawPhoneFailed = NO;
    
    [self getIsMemberShipRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refundSuccess) name:@"MyMemberVC" object:nil];
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

- (void)getIsMemberShipRequest
{
    [[VVNetWorkUtility netUtility] getIsMemberRequestWithCustomerId:[UserModel currentUser].customerId
                                                            success:^(id result)
     {
         if ([result[@"success"] integerValue] == 1)
         {
             //isMemberShip    String    是否会员（0：非会员；1：会员）
             NSString *str = [[result safeObjectForKey:@"data"] safeObjectForKey:@"isMemberShip"];
             if ([str isEqualToString:@"0"])
             {
                 [self initAndLayoutUIWithIsMember:NO];
             }
             else
             {
                 [self initAndLayoutUIWithIsMember:YES];
                 
                 [self getIsMemberDrawPhoneFailed];
             }
         }
     } failure:^(NSError *error)
     {
         
     }];
}

- (void)getIsMemberDrawPhoneFailed
{
    [[VVNetWorkUtility netUtility] getisMemberDrawPhoneFailedWithCustomerId:[UserModel currentUser].customerId
                                                                    success:^(id result)
    {
        if ([result[@"success"] integerValue] == 1)
        {
            //是否提现电审被拒（0：非；1：是）
            NSString *str = [[result safeObjectForKey:@"data"] safeObjectForKey:@"isMemberDrawPhoneFailed"];
            if ([str isEqualToString:@"0"])
            {
                self.drawPhoneFailed = YES;
            }
        }
        
        [self getMemberFeeBillList];

    } failure:^(NSError *error)
    {
        [self getMemberFeeBillList];
    }];
}

- (void)getMemberFeeBillList
{
    [self showHud];
    
    [[VVNetWorkUtility netUtility] getMemberFeeBillListWithCustomerId:[UserModel currentUser].customerId
                                                              success:^(id result)
     {
         [self hideHud];
         if ([result[@"success"] integerValue] == 1)
         {
             NSArray *resultAry = [result safeObjectForKey:@"data"];
             
             [self.listArry addObjectsFromArray:[JJMemberFeeBillModel mj_objectArrayWithKeyValuesArray:resultAry]];
             
             [self.tableView reloadData];
         }
         else
         {
             [MBProgressHUD bwm_showTitle:result[@"message"]
                                   toView:self.view
                                hideAfter:1.0f];
         }
         
     } failure:^(NSError *error)
    {
        [self hideHud];
        [MBProgressHUD bwm_showTitle:[self strFromErrCode:error]
                              toView:self.view
                           hideAfter:1.0f];
    }];
}

- (void)initAndLayoutUIWithIsMember:(BOOL)isMember
{
    /*****************头像********************/
    [self.view addSubview:self.headImg];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(94);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    NSString *str = [NSString stringWithFormat:@"\t%@",[VVUtils formatPhoneNumber:[UserModel currentUser].phone]];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = kGetImage(@"icon_user_head_VIP");
    textAttachment.bounds = CGRectMake(0, -3, 22, 20);
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString insertAttributedString:attrStringWithImage atIndex:0];
    self.phoneLab.attributedText = attributedString;
    [self.view addSubview:self.phoneLab];
    
    /****************会员信息********************/
    [self.view addSubview:self.whiteView];
    
    /****************缴费记录********************/
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor whiteColor];
    lab.text = @"缴费记录";
    lab.textColor = kColor_NormalColor;
    lab.font = kFont_NormalTitle;
    [self.whiteView addSubview:lab];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(241, 244, 246);
    [self.whiteView addSubview:line];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(130+64);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-12);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(40);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    if (isMember)
    {
        [self.whiteView addSubview:self.tableView];

        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(line.mas_bottom);
        }];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    }
    else
    {
        /****************img********************/
        UIImageView *placeholderImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_22")];
        [self.whiteView addSubview:placeholderImg];
        
        [placeholderImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.whiteView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(220, 168));
            make.top.mas_equalTo(line.mas_bottom).offset(20);
        }];
        
        UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [joinBtn setTitle:@"立即加入，优享乐花" forState:UIControlStateNormal];
        [joinBtn setBackgroundColor:RGB(30, 139, 251) forState:UIControlStateNormal];
        joinBtn.titleLabel.font  = [UIFont systemFontOfSize:17.0];
        joinBtn.layer.cornerRadius = 6;
        joinBtn.clipsToBounds = YES;
        [joinBtn addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:joinBtn];
        
        [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(placeholderImg.mas_bottom).offset(35);
            make.left.mas_equalTo(self.whiteView).offset(20);
            make.right.mas_equalTo(self.whiteView).offset(-20);
            make.height.equalTo(@44);
        }];
    }
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.headImg.mas_bottom);
        make.bottom.mas_equalTo(self.whiteView.mas_top);
    }];
}

- (void)joinAction
{
    [[JCRouter shareRouter] pushURL:@"memberArgeement" extraParams:@{@"isDrawWebPage":@"0"}];
}

- (void)refundSuccess
{
    NSArray *subviews = [[NSArray alloc]initWithArray:self.whiteView.subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:@YES];
    
    [self getIsMemberShipRequest];
}

@end
