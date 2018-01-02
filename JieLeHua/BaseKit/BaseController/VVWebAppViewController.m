//
//  VVBaseWebViewController.m
//  O2oApp
//
//  Created by chenlei on 16/6/14.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVWebAppViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

#define kViewTagNavigationBarLabel 0x0000600B

@interface VVWebAppViewController ()<UIWebViewDelegate,VVWebViewNavDelegate>
{
    JSContext *_context;
    
}
@end

@implementation VVWebAppViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        if (params.count > 0) {
            self.webTitle = params[@"webTitle"];
            self.startPage = params[@"startPage"];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:_webTitle];
    [self addBackButton];
    VVLog(@"_webTitle: %@    _startPage:%@",_webTitle,_startPage);
    if( [VVReachabilityTool connectionInternet]){
        _webView = [[VVWebView alloc]init];
        _webView.frame = CGRectMake(0, 64, vScreenWidth,vScreenHeight - 64);
        [_webView setEnablePanGesture:YES];
        [_webView setNavDelegate:self];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.bounces = YES;
        [self goBack];
        [self goForward];
        if (_startPage != nil) {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_startPage]]];
        }
        [self.view addSubview:_webView];
        [self showHud];
    }else{
        VVNoNetworkingView *noNetworkingView = [[VVNoNetworkingView alloc]initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight - 64)];
        [self.view addSubview:noNetworkingView];
        _btnRight.hidden = YES;
    }
    [self addCloseButton];
    
    if ([_webTitle isEqualToString:@"忘记征信密码"]||[_webTitle isEqualToString:@"银联用户服务协议"]||[_webTitle isEqualToString:@"银联支付"]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (void)closeWebApp:(id)obj
{
   [self customPopViewController];

}

- (void)backAction:(id)sender
{
    if ([_webView canGoBack] && sender == self.btnBack) {
        [_webView goBack];
        if (_btnClose.hidden) {
            [self.btnBack setFrame:CGRectMake(0, _deltaY, 75, 44)];
            [self setTitleLabelText:_newWebTitle];
        }
        if (!_btnRight.hidden) {
            _btnRight.hidden = YES;
        }
    }else {
        [super backAction:sender];
    }
}

-(void)addCloseButton
{
    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [_btnClose setFrame:  CGRectIntegral(CGRectMake(50, _deltaY, 40, 44))];
    [_btnClose setTitleColor:VV_COL_RGB(0x333333) forState:UIControlStateNormal];
    [_btnClose setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateHighlighted];
    [_btnClose setTitleColor:VV_COL_RGB(0x777e81) forState:UIControlStateDisabled];
    _btnClose.titleLabel.font  = [UIFont systemFontOfSize:15];
    
    _btnClose.exclusiveTouch = YES;
    [_navigationBar addSubview:_btnClose];
    
    [_btnClose addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnClose.hidden = YES;

}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([_webView canGoBack]){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    return NO;
    }
    
    if ([_webTitle isEqualToString:@"忘记征信密码"]||[_webTitle isEqualToString:@"银联用户服务协议"]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        return NO;
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}


#pragma mark - webView delegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//        VVWebAppViewController *webApp = [[VVWebAppViewController alloc]init];
//        webApp.startPage = [NSString stringWithFormat:@"%@",url];
//        [self customPushViewController:webApp withType:nil subType:nil];
//        return NO;
    }
    
    return  YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    NSURL *url = [webView.request URL];
    NSString *webUrl = [NSString stringWithFormat:@"%@",url];
    VVLog(@"weburl :%@",webUrl);
    _newWebTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    _webView.scrollView.scrollEnabled = YES;
    _webView.scalesPageToFit = YES;

    if (VV_IS_NIL(_newWebTitle)) {
//       [self setNavigationBarTitle:_webTitle];
        _newWebTitle = _webTitle;
        [self setTitleLabelText:_newWebTitle];
    }else{
//        [self setNavigationBarTitle:_newWebTitle];
        [self setTitleLabelText:_newWebTitle];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    VVLog(@"web arr :%@",_webView.historyArray);
    if (_webView.historyArray.count>0) {
        _btnClose.hidden = NO;
    }else{
        _btnClose.hidden = YES;
    }
    [self webViewDidGoBackWithGesture:_webView];
    VVLog(@"webtitle :%@",_webTitle);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
    [self hideHud];
    [VLToast showWithText:[self strFromErrCode:error]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

#pragma mark -
- (void)reload
{
    [_webView reload];
}

- (void)goBack
{
    if ([_webView canGoBack])
    {
        [_webView goBack];
        _webView.delegate = self;
    }
}

- (void)goForward
{
    if ([_webView canGoForward])
    {
        [_webView goForward];
        _webView.delegate = self;
    }
}

- (void)webViewDidGoBackWithGesture:(VVWebView *)webView
{
    VVLog(@"web pan delegate ====");
    [self.btnBack setFrame:CGRectMake(0, _deltaY, 70, 44)];
    [self setTitleLabelText:_newWebTitle];
}

- (void)setTitleLabelText:(NSString*)text
{
    UILabel* labelTitle = (UILabel*)[_navigationBar viewWithTag:kViewTagNavigationBarLabel];
    [labelTitle removeFromSuperview];
    
    UIFont* naviFont = [UIFont boldSystemFontOfSize:18];
    CGSize sz = [text sizeWithFont:naviFont constrainedToSize:CGSizeMake(kScreenWidth - 150, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat x = (kScreenWidth - sz.width)/2;
    if (x < 70) {
        x = 70;
    }
    if (!_btnClose.hidden) {
        if (x<100) {
            x = 100;
        }
    }
    CGFloat y = (kNavigationBarHeight - sz.height)/2 + _deltaY;
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, sz.width, sz.height)];
    labelTitle.font = [UIFont systemFontOfSize:16];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    [labelTitle setText:text];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    labelTitle.tag = kViewTagNavigationBarLabel;
    [_navigationBar addSubview:labelTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
