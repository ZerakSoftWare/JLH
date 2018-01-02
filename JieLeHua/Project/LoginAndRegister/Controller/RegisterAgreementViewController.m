//
//  RegisterAgreementViewController.m
//  JieLeHua
//
//  Created by kuang on 2017/3/13.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "RegisterAgreementViewController.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface RegisterAgreementViewController ()<UIWebViewDelegate>

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation RegisterAgreementViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.title = @"用户协议";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = VVColor(241, 244, 246);
    
    [self initAndLayoutUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
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
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    NSString *url = [NSString stringWithFormat:@"%@/userxy.html",WEB_BASE_URL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
}

@end
