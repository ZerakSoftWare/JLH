//
//  JJMessageViewController.m
//  JieLeHua
//
//  Created by 维信金科 on 17/2/27.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJMessageViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JJH5DetailViewController.h"
#import "MJChiBaoZiHeader.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"

@implementation JJMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([UserModel isLoggedIn])
    {
        NSString *url = [NSString stringWithFormat:@"%@/find_news.html?customerId=%@",WEB_BASE_URL,[UserModel currentUser].customerId];
        [self.messageWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Timeout]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self addReloadTarget:self action:@selector(webReloadData)];
}

- (void)initView
{    
    self.messageWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, vScreenWidth, vScreenHeight-114) ];
    [self.messageWeb setDelegate:self];
    
    __weak UIWebView *webView = self.messageWeb;
    __weak UIScrollView *scrollView = self.messageWeb.scrollView;
    
    // 添加下拉刷新控件
    scrollView.mj_header= [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        [webView reload];
    }];
    
    [self.messageWeb setBackgroundColor:VVColor(241, 244, 246)];
    [self.view addSubview:self.messageWeb];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *str = request.URL.absoluteString;;
    VVLog(@"url --- %@",str);
    
    if (str != nil) {
        NSRange range = [str rangeOfString:@"find_details"];
        if (range.location != NSNotFound)
        {
            JJH5DetailViewController * vc = [[JJH5DetailViewController alloc]init];
            vc.strUrl = str;
            vc.h5Title = self.messageTitle;
            [self.navigationController pushViewController:vc animated:YES];
            
            return false;
        }
    }
    return YES;
}

//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [self showHud];
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [self hideHud];
    [self hiddenFailLoadViewView];
    
    [self.messageWeb.scrollView.mj_header endRefreshing];
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    __block JJMessageViewController *messageSelf = self;
    self.context[@"details"] = ^{
        
        NSArray *arg = [JSContext currentArguments];
        
        for (JSValue *jsVal in arg) {
            messageSelf.messageTitle = jsVal.toString;
        }
        
    };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [self hideHud];
    [self.messageWeb.scrollView.mj_header endRefreshing];
    [self setFailY:0];
    [self showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
}

- (void)webReloadData
{
    [self hiddenFailLoadViewView];
//    [self.messageWeb reload];
    
    NSString *url = [NSString stringWithFormat:@"%@/find_news.html?customerId=%@",WEB_BASE_URL,[UserModel currentUser].customerId];
    [self.messageWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
