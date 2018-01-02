//
//  FeedbackViewController.m
//  JieLeHua
//
//  Created by admin on 17/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LimitTextView.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface FeedbackViewController ()

@property (nonatomic, strong) LimitTextView *textview;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FeedbackViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

+ (id)allocWithRouterParams:(NSDictionary *)params {
    FeedbackViewController *instance = [[FeedbackViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"问题反馈"];
    
    [self addBackButton];
    
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
    self.textview = [[LimitTextView alloc]initWithFrame:CGRectMake(12, 64+12, kScreenWidth-24, 195)];
    if (iPhoneX)
    {
        self.textview.y = self.textview.y + 20;
    }
    
    self.textview.backgroundColor = [UIColor whiteColor];
    self.textview.layer.borderWidth = 1.0;//边宽
    self.textview.layer.cornerRadius = 6.0;//设置圆角
    self.textview.layer.borderColor = VVColor(205, 205, 205).CGColor;
    [self.view addSubview:self.textview];
    
    VVCommonButton *noResultBtn = [VVCommonButton solidButtonWithTitle:@"提交"];
    noResultBtn.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    noResultBtn.layer.cornerRadius = 6.f;
    [noResultBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noResultBtn];
    
    [noResultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
        make.top.mas_equalTo(self.textview.mas_bottom).with.offset(40);
    }];
}

- (void)submitAction
{
    [self.view endEditing:YES];
    NSString *content = self.textview.textView.text;
    
    if (!content.length)
    {
        [MBProgressHUD bwm_showTitle:@"提交内容不能为空"
                              toView:self.view
                           hideAfter:1.0];
        return;
    }
    
    NSDictionary *dic = @{
                          @"customerId":[UserModel currentUser].customerId,
                          @"content":content
                          };
    
    __block MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在提交中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] postFeedBackParameters:dic
                                                  success:^(id result)
     {
         if ([result[@"success"] integerValue] == 1)
         {
             [HUD bwm_hideWithTitle:@"提交成功！"
                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
             
             dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DEFAULT_DISPLAY_DURATION * NSEC_PER_SEC));
             dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                 [self turnBack];
             });
             
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

- (void)turnBack
{
    [[JCRouter shareRouter] popViewControllerAnimated:YES];
}

@end
