//
//  ChoosePayMethodViewController.m
//  JieLeHua
//
//  Created by admin on 2017/12/24.
//Copyright © 2017年 Vcredit. All rights reserved.
//

#import "ChoosePayMethodViewController.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface ChoosePayMethodViewController ()

@property (nonatomic, strong) NSMutableArray *groupButtons;

@property (nonatomic, assign) NSInteger payTag;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation ChoosePayMethodViewController


#pragma mark - Properties

- (NSMutableArray *)groupButtons {
    if (!_groupButtons) {
        _groupButtons = [[NSMutableArray alloc] init];
    }
    return _groupButtons;
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
    
    [self setNavigationBarTitle:@"缴纳方式"];
    [self addBackButton];
    
    self.view.backgroundColor = RGB(241, 244, 246);
    
    self.payTag = 993;
    
    [self initAndLayoutUI];
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

- (void)initAndLayoutUI
{
    UIView *payInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kScreenWidth, 91)];
    payInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payInfoView];
    
    NSArray *payInfoArry = @[@"立即缴纳",@"贷款成功后缴纳"];
    
    for(int i = 0; i < payInfoArry.count; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 46*i, 100, 45)];
        lab.textColor = kColor_TitleColor;
        lab.font = kFont_NormalTitle;
        lab.text = payInfoArry[i];
        [payInfoView addSubview:lab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth-45, 46*i, 45, 45);
        [btn setImage:kGetImage(@"btn_round_grey") forState:UIControlStateNormal];
        [btn setImage:kGetImage(@"btn_round_check") forState:UIControlStateSelected];
        btn.tag = 933+i;
        [btn addTarget:self action:@selector(selectPayWay:) forControlEvents:UIControlEventTouchUpInside];
        [payInfoView addSubview:btn];
        if (i == 0)
        {
            btn.selected = YES;
        }
        [self.groupButtons addObject:btn];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 46, kScreenWidth, 0.5f)];
    line.backgroundColor = RGB(230, 230, 230);
    [payInfoView addSubview:line];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:VVColor(13, 136, 255) forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 6;
    nextBtn.clipsToBounds = YES;
    [nextBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).with.offset(-41);
        make.left.mas_equalTo(self.view).with.offset(20);
        make.right.mas_equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    
}

- (void)selectPayWay:(UIButton *)sender
{
    //--tag:933立即缴纳，934成功后缴纳
    if (sender.selected) return;
    
    for (UIButton *btn in self.groupButtons)
    {
        btn.selected = NO;
    }
    sender.selected = !sender.selected;
    
    self.payTag = sender.tag;
}

- (void)applyAction
{
    if (self.payTag == 993)
    {        
        [[JCRouter shareRouter] pushURL:@"memberArgeement" extraParams:@{@"isDrawWebPage":@"1"}];
    }
    else
    {
        NSDictionary  *dict = @{
                                @"isMemberShip":@"2"
                                };
        
        NSNotification *notification = [NSNotification notificationWithName:@"DrawChoosePayMethod" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self customPopViewController];
    }
}

- (void)backAction:(id)sender
{
    NSDictionary  *dict = @{
                            @"isMemberShip":@"0"
                            };
    
    NSNotification *notification = [NSNotification notificationWithName:@"DrawChoosePayMethod" object:nil userInfo:dict];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self customPopViewController];
}

@end
