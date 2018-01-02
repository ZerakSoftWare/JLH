//
//  EmployeeWebViewController.m
//  JieLeHua
//
//  Created by kuang on 2017/4/12.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "EmployeeWebViewController.h"
#import <WebKit/WebKit.h>
#import "NoNavWebViewViewController.h"
#import "KSShare.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface EmployeeWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) MBProgressHUD *hudView;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation EmployeeWebViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}

#pragma mark - Public Methods

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.hudView hide:YES];
    
    self.navigationItem.title = self.webView.title;
    
    if (self.webView.canGoBack)
    {
        self.navigationItem.leftBarButtonItem = nil;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:VV_GETIMG(@"btn_nav_bar_return")
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(toBack)];
        
        self.navigationItem.leftBarButtonItem = backItem;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_bar_share"] style:UIBarButtonItemStylePlain target:self action:@selector(toShare)];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        
        NSDictionary *logoutbarButtonAppearanceDict = @{
                                                        NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                        NSForegroundColorAttributeName: kColor_NormalColor
                                                        };
        
        UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"退出登录"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(goOut)];
        [logoutItem setTitleTextAttributes:logoutbarButtonAppearanceDict forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = logoutItem;
        
        
        NSDictionary *barButtonAppearanceDict = @{
                                                  NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                  NSForegroundColorAttributeName: kColor_Main_Color
                                                  };

        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"我的转介绍" style:UIBarButtonItemStylePlain target:self action:@selector(toNoNavVC)];
        [rightItem setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];

        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
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

- (id)initWithRouterParams:(NSDictionary *)params {
    
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
        
    VVLog(@"the url is %@",self.url);
    
    self.view.backgroundColor = VVColor(241, 244, 246);
    
    [self initAndLayoutUI];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = RGB(249, 249, 249);
//    }
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
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    [self.view addSubview:self.webView];
}

- (void)toBack
{
    [self.webView goBack];
}

- (void)toShare
{
    NSArray *contentArray = @[@{@"name":@"微信",@"icon":@"sns_icon_7",@"platformType":@"wechatsession"},
                              @{@"name":@"朋友圈",@"icon":@"sns_icon_8",@"platformType":@"wechattimeline"},
                              @{@"name":@"QQ空间 ",@"icon":@"sns_icon_5",@"platformType":@"qzone"},
                              @{@"name":@"QQ",@"icon":@"sns_icon_4",@"platformType":@"qq"}];
    KSShareMenuView *shareView = [[KSShareMenuView alloc] init];
    shareView.rowNumberItem=4;
    shareView.cancelButtonText=@"取消分享";
    [shareView addShareItems:self.view.window shareItems:contentArray selectShareItem:^(NSInteger tag, NSString *title, NSString *platformType) {
        [KSShareHelper shareUrlDataWithPlatform:[KSShareTool getPlatformType:platformType] withShareUrl:[self.webView.URL absoluteString] withTitle:self.webView.title withDescr:@"借乐花，简单借，快乐花！有花呗就能申请，额度最高3万元" withThumImage:[UIImage imageNamed:@"shareIcon"] withCompletion:^(id result, NSError *error) {
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

- (void)toNoNavVC
{
    NSArray *arry = [self.url componentsSeparatedByString:@"="];
    
    NSString *salesId = [arry lastObject];
    
    NoNavWebViewViewController *vc = [[NoNavWebViewViewController alloc] init];
    
#if DEBUG
    //http://10.155.50.248:8020/jlh-webapp
    vc.url = [NSString stringWithFormat:@"%@/transferInfor.html?salesId=%@&from=app",@"http://10.155.50.248:8020/jlh-webapp",salesId];
#else
    vc.url = [NSString stringWithFormat:@"%@/transferInfor.html?salesId=%@&from=app",WEB_BASE_URL,salesId];
#endif

    [self.navigationController pushViewController:vc animated:YES];
}


/**
 退出登录
 */
- (void)goOut
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定要退出登录吗！" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self quit];
    }];
    
    [alert addAction:updateAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)quit
{
    [MBProgressHUD bwm_showTitle:@"退出成功" toView:self.view hideAfter:1.5f];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JJEmployeVbsAccount"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JJEmployeSalesId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JJEmployeSalesToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
