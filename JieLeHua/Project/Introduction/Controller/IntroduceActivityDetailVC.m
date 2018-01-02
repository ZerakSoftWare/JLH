//
//  IntroduceActivityDetailVC.m
//  JieLeHua
//
//  Created by admin2 on 2017/6/19.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IntroduceActivityDetailVC.h"
#import <WebKit/WebKit.h>
#import "KSShare.h"
#import "JJWKWebViewViewController.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface IntroduceActivityDetailVC ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) MBProgressHUD *hudView;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation IntroduceActivityDetailVC


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"Native"]) {
        NSLog(@"---%@", message.body);
        [self pushShopVC];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.hudView hide:YES];
    
    self.navigationItem.title = self.webView.title;
    
    if ([self.urlString containsString:@"semiAnnual"])
    {
        [self.webView evaluateJavaScript:@"startMp3()"  completionHandler:^(id item, NSError * _Nullable error) {
            
        }];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.hudView hide:YES];
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
    
    self.view.backgroundColor = kColor_ViewBackground_Color;
    
    if (self.isSupportShare)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_bar_share"] style:UIBarButtonItemStylePlain target:self action:@selector(toShare)];
    }
    
    [self initAndLayoutUI];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    if ([self.urlString containsString:@"semiAnnual"])
    {
        [self.webView evaluateJavaScript:@"stopMp3()"  completionHandler:^(id item, NSError * _Nullable error) {
            
        }];
    }
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

- (void)pushShopVC
{
    NSString *salesToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"JJEmployeSalesToken"];

    NSString *salesId = [[NSUserDefaults standardUserDefaults]objectForKey:@"JJEmployeSalesId"];
    
    JJWKWebViewViewController *wkwebVc = [[JJWKWebViewViewController alloc]init];
    wkwebVc.isNavHidden = NO;
    [wkwebVc loadWebURLSring: [NSString stringWithFormat:@"%@/market/index.html?token=%@&saleId=%@",WEB_BASE_URL,salesToken,salesId]];
    [self.navigationController pushViewController:wkwebVc animated:YES];
}

- (void)initAndLayoutUI
{
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象Native，
    // 声明WKScriptMessageHandler 协议
    [config.userContentController addScriptMessageHandler:self name:@"Native"];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - 分享

- (void)toShare
{
    NSString *shareUrl = [self.webView.URL absoluteString];
    
    NSArray *contentArray = @[@{@"name":@"微信",@"icon":@"sns_icon_7",@"platformType":@"wechatsession"},
                              @{@"name":@"朋友圈",@"icon":@"sns_icon_8",@"platformType":@"wechattimeline"},
                              @{@"name":@"QQ空间 ",@"icon":@"sns_icon_5",@"platformType":@"qzone"},
                              @{@"name":@"QQ",@"icon":@"sns_icon_4",@"platformType":@"qq"}];
    
    KSShareMenuView *shareView = [[KSShareMenuView alloc] init];
    shareView.rowNumberItem = 4;
    shareView.cancelButtonText = @"取消分享";
    [shareView addShareItems:self.view.window shareItems:contentArray selectShareItem:^(NSInteger tag, NSString *title, NSString *platformType) {
        [KSShareHelper shareUrlDataWithPlatform:[KSShareTool getPlatformType:platformType]
                                   withShareUrl:shareUrl
                                      withTitle:self.webView.title
                                      withDescr:@"借乐花，简单借，快乐花！有花呗就能申请，额度最高3万元"
                                  withThumImage:[UIImage imageNamed:@"shareIcon"]
                                 withCompletion:^(id result, NSError *error) {
                                     if (error) {
                                         VVLog(@"************Share fail with error %@*********",error);
                                     }else{
                                         if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                                             UMSocialShareResponse *resp = result;
                                             //分享结果消息
                                             VVLog(@"response message is %@",resp.message);
                                             //第三方原始返回的数据
                                             VVLog(@"response originalResponse data is %@",resp.originalResponse);
                                             
                                         }else{
                                             VVLog(@"response data is %@",result);
                                         }
                                     }
                                     [self hudWithError:error];
                                 }];
        
    }];
}

- (void)hudWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            //            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
            result = [NSString stringWithFormat:@"分享失败"];
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    [MBProgressHUD bwm_showTitle:result toView:self.view hideAfter:1.5f];
}

@end
