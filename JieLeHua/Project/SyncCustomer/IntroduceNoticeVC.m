//
//  IntroduceNoticeVC.m
//  JieLeHua
//
//  Created by admin2 on 2017/6/8.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IntroduceNoticeVC.h"
#import <WebKit/WebKit.h>
#import "IntroduceActivityDetailVC.h"
#import "MJChiBaoZiHeader.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface IntroduceNoticeVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) MBProgressHUD *hudView;

@property (nonatomic, copy) NSString *salesId;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation IntroduceNoticeVC


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
    [self.webView.scrollView.mj_header endRefreshing];
    
    self.navigationItem.title = self.webView.title;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSString *requestString = [webView.URL absoluteString];
    
    if ([requestString rangeOfString:@"zjs_notice_details" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        //--检测是否含有index_share。如有则跳转下一个界面，无不做处理
        decisionHandler(WKNavigationResponsePolicyCancel);
        
        IntroduceActivityDetailVC *detailvc = [[IntroduceActivityDetailVC alloc] init];
        detailvc.urlString = requestString;
        detailvc.isSupportShare = NO;
        detailvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailvc animated:YES];
    }
    else
    {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.hudView hide:YES];
    self.hudView = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.hudView hide:YES];
    [self.webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.hudView hide:YES];
    [self.webView.scrollView.mj_header endRefreshing];
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.view.backgroundColor = kColor_ViewBackground_Color;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.salesId = [[NSUserDefaults standardUserDefaults]objectForKey:@"JJEmployeSalesId"];
    
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
    NSDictionary *barButtonAppearanceDict = @{
                                              NSFontAttributeName : [UIFont systemFontOfSize:14],
                                              NSForegroundColorAttributeName: kColor_Main_Color
                                              };
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"全部删除"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(deleteAllNotice)];
    [rightItem setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.navigationDelegate = self;
    
    NSString *url = [NSString stringWithFormat:@"%@/transferList.html?salesId=%@&from=app&type=notice",WEB_BASE_URL,self.salesId];
    NSURLRequest *requrest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                               timeoutInterval:Timeout];
    [self.webView loadRequest:requrest];
    
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self addRefreshHead];
}

- (void)addRefreshHead
{
    __weak WKWebView *webView = self.webView;
    __weak UIScrollView *scrollView = self.webView.scrollView;
    
    // 添加下拉刷新控件
    scrollView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        [webView reload];
    }];
}

- (void)deleteAllNotice
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"即将删除全部通知"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       [self sendDeleteNoticeRequest];
                                   }];
    
    [alert addAction:updateAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendDeleteNoticeRequest
{
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在删除中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] getDeleteNoticeBySaleId:self.salesId success:^(id result)
     {
        if ([[result safeObjectForKey:@"success"] boolValue])
        {
            [HUD hide:NO];
            [self.webView reload];
        }
        else
        {
            [HUD bwm_hideWithTitle:[result safeObjectForKey:@"message"]
                         hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }
        
    } failure:^(NSError *error)
    {
        [HUD bwm_hideWithTitle:@"连接不上服务器，请稍后再试!"
                     hideAfter:kBWMMBProgressHUDHideTimeInterval];
    }];
}

@end
