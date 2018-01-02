//
//  HelpCenterViewController.m
//  JieLeHua
//
//  Created by admin on 17/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"
#import "VVWebAppViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#pragma mark Constants


#pragma mark - Class Extension

@interface HelpCenterViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation HelpCenterViewController


#pragma mark - Properties

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.backgroundColor = VVColor(240, 240, 242);
    }
    return _webView;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    webView.hidden = YES;
    [self showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.hidden = NO;
    [self setNavigationBarTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    
    __weak __typeof(self)weakSelf = self;

    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"feedback"] = ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf jumpFeedbackViewController];
        });
    };
}

- (void)jumpFeedbackViewController
{
    BOOL isLogin = [UserModel isLoggedIn];
    
    if (isLogin)
    {
        [[JCRouter shareRouter] pushURL:@"feedback"];
    }
    else
    {
        [[JCRouter shareRouter] presentURL:@"login" withNavigationClass:[AppNavigationController class] completion:nil];
    }
}

- (void)webReloadData
{
    [self hiddenFailLoadViewView];
    NSString *url = [NSString stringWithFormat:@"%@/help.html",WEB_BASE_URL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - Overridden Methods

+ (id)allocWithRouterParams:(NSDictionary *)params {
    HelpCenterViewController *instance = [[HelpCenterViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"帮助中心"];
    
    [self addBackButton];
    
//    [self addRightButtonWithImage:kGetImage(@"btn_nav_customer_service") highlightedImage:nil];
    
    [self addReloadTarget:self action:@selector(webReloadData)];
    
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

- (void)rightAction:(id)sender
{
    VVWebAppViewController *webVC = [[VVWebAppViewController alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/contact.html",WEB_BASE_URL];
    webVC.startPage = url;
    webVC.webTitle = @"客服中心";
    [self customPushViewController:webVC withType:nil subType:nil];
//    [[JCRouter shareRouter] pushURL:@"serviceCenter"];
}

- (void)initAndLayoutUI
{
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (iPhoneX) {
            make.top.equalTo(self.view).with.offset(88);
        }else{
            make.top.equalTo(self.view).with.offset(64);
        }
    }];
    
    NSString *url = [NSString stringWithFormat:@"%@/help.html",WEB_BASE_URL];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)backAction:(id)sender
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self customPopViewController];
    }
}

@end
