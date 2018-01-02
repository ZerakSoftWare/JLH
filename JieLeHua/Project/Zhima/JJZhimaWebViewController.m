//
//  JJZhimaWebViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJZhimaWebViewController.h"
#import "JJAuthZhimaRequest.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JJZhimaWebViewController ()
{
    JSContext *_context;
}
@end

@implementation JJZhimaWebViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
//        if (params.count > 0) {
//            self.identity = params[@"Identity"];
//            self.name = params[@"Name"];
//        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUrl];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpWithUrl:(NSString *)url
{
//    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.startPage = url;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.startPage]]];
    
    _btnClose.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - 请求
- (void)getUrl
{
//#if DEBUG
//    NSDictionary *dict = @{@"Identity":self.identity,
//                           @"Name":self.name,
//                           @"BusType":@"test",
//                           @"Platform":@"app"};
//#else
    NSDictionary *dict = @{@"Identity":self.identity,
                           @"Name":self.name,
                           @"BusType":@"JIELEHUA",
                           @"Platform":@"app"};
//#endif
    JJAuthZhimaRequest *request = [[JJAuthZhimaRequest alloc] init];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        if ([[[request.responseJSONObject objectForKey:@"data"] objectForKey:@"StatusCode"] integerValue] == 2) {
            [self setUpWithUrl:[[request.responseJSONObject objectForKey:@"data"] objectForKey:@"BindUrl"]];
        }else if ([[[request.responseJSONObject objectForKey:@"data"] objectForKey:@"StatusCode"] integerValue] == 0 && [request.responseJSONObject objectForKey:@"data"]!= nil) {
            self.authorizationSuccessBlockSuccBlock([[request.responseJSONObject objectForKey:@"data"] objectForKey:@"Result"]);
            [self customPopViewController];
        }
        else{
            [self hideHud];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    VVLog(@"%@",requestString);
    if ([requestString containsString:@"jlhpredeploy.vcash.cn"]||
        [requestString containsString:@"jielehua.vcash.cn"] || 
        [requestString containsString:@"/zmxycallback.html"]) {
        [self returnBack];
        [webView stopLoading];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
}

#pragma mark - 返回
- (void)backAction:(id)sender
{
    [_webView stopLoading];
    _webView = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self customPopViewController];
}

- (void)returnBack
{
    if (nil == _webView) {
        return;
    }
//#if DEBUG
//    NSDictionary *dict = @{@"Identity":self.identity,
//                           @"Name":self.name,
//                           @"BusType":@"test",
//                           @"Platform":@"app"};
//#else
    NSDictionary *dict = @{@"Identity":self.identity,
                           @"Name":self.name,
                           @"BusType":@"JIELEHUA",
                           @"Platform":@"app"};
//#endif
    JJAuthZhimaRequest *request = [[JJAuthZhimaRequest alloc] init];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        if ([[[request.responseJSONObject objectForKey:@"data"] objectForKey:@"StatusCode"] integerValue] == 0) {
            self.authorizationSuccessBlockSuccBlock([[request.responseJSONObject objectForKey:@"data"] objectForKey:@"Result"]);
            [self customPopViewController];
        }else{
            self.authorizationSuccessBlockSuccBlock(@"0");
            [self customPopViewController];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        self.authorizationSuccessBlockSuccBlock(@"0");
        [self customPopViewController];
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)dealloc
{
    _webView = nil;
}

@end
