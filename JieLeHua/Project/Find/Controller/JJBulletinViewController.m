//
//  JJBulletinViewController.m
//  JieLeHua
//
//  Created by 维信金科 on 17/2/27.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBulletinViewController.h"
#import "JJMessageViewController.h"
#import "JJH5DetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MJChiBaoZiHeader.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"

#ifdef JIELEHUAQUICK
#import "JJReviewManager.h"
#endif

@interface JJBulletinViewController ()<UIWebViewDelegate>
{
    UIWebView *bulletinWeb;
}

@end

@implementation JJBulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self addReloadTarget:self action:@selector(webReloadData)];
}

-(void)initView
{
#ifdef JIELEHUAQUICK
    if ([JJReviewManager reviewManager].reviewing) {
        [self setFailY:0];
        [self showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"暂无公告"];
        return;
    }
#endif
    NSString *requestUrl = [NSString stringWithFormat:@"%@/find_notice.html",WEB_BASE_URL];
    bulletinWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, vScreenWidth, vScreenHeight-114) ];
    [bulletinWeb setDelegate:self];
    bulletinWeb.scalesPageToFit = YES;
    __weak UIWebView *webView = bulletinWeb;
    __weak UIScrollView *scrollView = bulletinWeb.scrollView;
    
    // 添加下拉刷新控件
    scrollView.mj_header= [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        [webView reload];
    }];
    
    [bulletinWeb setBackgroundColor:VVColor(241, 244, 246)];
    [self.view addSubview:bulletinWeb];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLRequest *requrest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Timeout];
    [bulletinWeb loadRequest:requrest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *str = request.URL.absoluteString;;
    
    if (str != nil) {
        NSRange range = [str rangeOfString:@"find_details"];
        if (range.location != NSNotFound)
        {
            JJH5DetailViewController * vc = [[JJH5DetailViewController alloc]init];
            vc.strUrl = str;
            vc.h5Title = self.bulletinTitle;
            [MobClick event:@"query_notice_details"];
            [self.navigationController pushViewController:vc animated:YES];
            
            return false;
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHud];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self hideHud];
    
    [self hiddenFailLoadViewView];
    
    [bulletinWeb.scrollView.mj_header endRefreshing];
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"details"] = ^{
        
        NSArray *arg = [JSContext currentArguments];
        
        for (JSValue *jsVal in arg) {
            VVLog(@"%@", jsVal.toString);
            self.bulletinTitle = jsVal.toString;
        }
    };
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
    [bulletinWeb.scrollView.mj_header endRefreshing];
    [self setFailY:0];
    [self showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
}

- (void)webReloadData
{
    [self hiddenFailLoadViewView];
//    [bulletinWeb reload];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/find_notice.html",WEB_BASE_URL];
    [bulletinWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
