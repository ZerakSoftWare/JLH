//
//  NoNavWebViewViewController.m
//  JieLeHua
//
//  Created by kuang on 2017/4/12.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "NoNavWebViewViewController.h"
#import <WebKit/WebKit.h>

#pragma mark Constants


#pragma mark - Class Extension

@interface NoNavWebViewViewController ()<WKScriptMessageHandler,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) MBProgressHUD *hudView;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation NoNavWebViewViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"Native"])
    {
        [self goBack];
    }
}
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.hudView hide:YES];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.hudView = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.hudView hide:YES];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.hudView hide:YES];
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = RGB(33, 108, 187);
//    }
    
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
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象Native，
    // 声明WKScriptMessageHandler 协议
    [config.userContentController addScriptMessageHandler:self name:@"Native"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    
//    self.webView.scrollView.backgroundColor = RGB(33, 108, 187);
//    self.webView.navigationDelegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    [self.view addSubview:self.webView];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
