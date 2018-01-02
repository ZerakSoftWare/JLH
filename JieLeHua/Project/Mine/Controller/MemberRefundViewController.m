//
//  MemberRefundViewController.m
//  JieLeHua
//
//  Created by admin on 2017/12/21.
//Copyright © 2017年 Vcredit. All rights reserved.
//

#import "MemberRefundViewController.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface MemberRefundViewController ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIButton *repayBtn;

@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *bankCardLab;
@property (nonatomic, strong) UILabel *timeLab;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation MemberRefundViewController


#pragma mark - Properties

- (UILabel *)moneyLab {
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.textColor = kColor_TipColor;
        _moneyLab.text = @"299元";
        _moneyLab.font = kFont_NormalTitle;
    }
    return _moneyLab;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentRight;
        _nameLab.textColor = kColor_TipColor;
        _nameLab.text = @"王晓明";
        _nameLab.font = kFont_NormalTitle;
    }
    return _nameLab;
}

- (UILabel *)bankCardLab {
    if (!_bankCardLab) {
        _bankCardLab = [[UILabel alloc] init];
        _bankCardLab.textAlignment = NSTextAlignmentRight;
        _bankCardLab.textColor = kColor_TipColor;
        _bankCardLab.text = @"12345678904612";
        _bankCardLab.font = kFont_NormalTitle;
    }
    return _bankCardLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.textColor = kColor_TipColor;
        _timeLab.text = @"预计1-3个工作日";
        _timeLab.font = kFont_NormalTitle;
    }
    return _timeLab;
}

- (UIButton *)repayBtn {
    if (!_repayBtn) {
        _repayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _repayBtn.layer.cornerRadius = 22.5f;
        _repayBtn.clipsToBounds = YES;
        [_repayBtn addTarget:self action:@selector(repayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repayBtn;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"退款"];
    [self addBackButton];
    
    self.view.backgroundColor = RGB(241, 244, 246);
    
    [self initAndLayoutUI];
    
    [self getRefundMemberInfoRequest];
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
    self.gradientLayer.frame = self.repayBtn.bounds;
    [self.repayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repayBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.repayBtn setTitle:@"立即退款" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)initAndLayoutUI
{
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kScreenWidth, 183)];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    
    NSArray *titlesArry = @[@"退款金额", @"银行卡持卡人", @"收款银行卡", @"到账时间"];
    NSArray *infoLabs = @[self.moneyLab, self.nameLab, self.bankCardLab, self.timeLab];

    for (int i = 0; i < titlesArry.count; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 46*i, 100, 45)];
        lab.textColor = kColor_TitleColor;
        lab.font = kFont_NormalTitle;
        lab.text = titlesArry[i];
        [infoView addSubview:lab];
        
        if (i != 0)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 46*i, kScreenWidth, 0.5f)];
            line.backgroundColor = RGB(230, 230, 230);
            [infoView addSubview:line];
        }
        
        UILabel *infoLab = infoLabs[i];
        infoLab.frame = CGRectMake(kScreenWidth-295, 46*i, 280, 45);
        [infoView addSubview:infoLab];
    }
    
    /*************立即退款*************/
    [self.view addSubview:self.repayBtn];
    [self.repayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(80);
        make.right.equalTo(self.view.mas_right).offset(-80);
        make.bottom.equalTo(self.view.mas_bottom).offset(-21);
        make.height.equalTo(@45);
    }];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.locations = @[@0,@1.0f];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5f);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5f);
    [self.repayBtn.layer addSublayer:self.gradientLayer];
    self.gradientLayer.colors = @[(__bridge id)RGB(255, 199, 150).CGColor,
                                  (__bridge id)RGB(255, 107, 149).CGColor];
}

- (void)repayBtnClick
{
    [self showHud];
    [[VVNetWorkUtility netUtility] memberRefundRequestWithsuccess:^(id result)
     {
        [self hideHud];

         if ([result[@"success"] integerValue] == 1)
         {
             NSNotification *notification = [NSNotification notificationWithName:@"MyMemberVC" object:nil userInfo:nil];
             [[NSNotificationCenter defaultCenter] postNotification:notification];
             
             [MBProgressHUD showSuccess:@"退款申请已提交，我司将在1-3个工作日内审核并退款"];

             [self customPopViewController];
         }
         else
         {
             [MBProgressHUD showError:@"退款失败"];
         }
         
    } failure:^(NSError *error)
     {
         [self hideHud];
         [MBProgressHUD showError:@"网络错误"];
    }];
}

- (void)getRefundMemberInfoRequest
{
    [self showHud];
    
    [[VVNetWorkUtility netUtility] getRefundMemberInfoWithCustomerId:[UserModel currentUser].customerId
                                                             success:^(id result)
     {
         [self hideHud];
         if ([result[@"success"] integerValue] == 1)
         {
             NSDictionary *dataDic = [result safeObjectForKey:@"data"];
             self.moneyLab.text = [NSString stringWithFormat:@"%@元", [dataDic safeObjectForKey:@"memberFee"]];
             self.nameLab.text = [dataDic safeObjectForKey:@"bankPersonName"];
             self.bankCardLab.text = [dataDic safeObjectForKey:@"bankPersonAccount"];
             self.timeLab.text = [dataDic safeObjectForKey:@"toAccountTime"];
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

@end
