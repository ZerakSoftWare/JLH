//
//  AboutUsViewController.m
//  JieLeHua
//
//  Created by admin on 17/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "AboutUsViewController.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface AboutUsViewController ()


@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation AboutUsViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

+ (id)allocWithRouterParams:(NSDictionary *)params {
    AboutUsViewController *instance = [[AboutUsViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"关于我们"];
    
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
    UIImageView *iconImg = [[UIImageView alloc] initWithImage:kGetImage(@"img_default_portrait")];
    [self.view addSubview:iconImg];
    
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(87+64);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(118, 118));
    }];
    
    
    UILabel *lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:17];
    lab.textColor = [UIColor whiteColor];
    lab.backgroundColor = VVColor(49, 154, 255);
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    lab.text = [NSString stringWithFormat:@"V%@",appVersion];
    [self.view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImg.mas_bottom).with.offset(88);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(106, 48));
    }];
}

@end
