//
//  JJWKWebViewViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/6/8.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJWKWebViewViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "VVNavigationController.h"

typedef enum{
    loadWebURLString = 0,
    loadWebHTMLString,
    POSTWebURLString,
}wkWebLoadType;

static void *WkwebBrowserContext = &WkwebBrowserContext;
@interface JJWKWebViewViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *wkWebView;
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
//仅当第一次的时候加载本地JS
@property(nonatomic,assign) BOOL needLoadJSPOST;
//网页加载的类型
@property(nonatomic,assign) wkWebLoadType loadType;
//保存的网址链接
@property (nonatomic, copy) NSString *URLString;
//保存POST请求体
@property (nonatomic, copy) NSString *postData;
//保存请求链接
@property (nonatomic)NSMutableArray* snapShotsArray;


@end

@implementation JJWKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载web页面
    [self webViewloadURLType];
    
    //添加到主控制器上
    [self.view addSubview:self.wkWebView];
    
    //添加进度条
    [self.view addSubview:self.progressView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isNavHidden == YES) {
        //创建一个高20的假状态栏
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        //设置成绿色
        statusBarView.backgroundColor=[UIColor blueColor];
        // 添加到 navigationBar 上
        [self.view addSubview:statusBarView];
    }else{
        [self setupNavigationBar];
        _navigationBar.backgroundColor = VVWhiteColor;
    }
}

#pragma mark ================ 加载方式 ================

- (void)webViewloadURLType{
    switch (self.loadType) {
        case loadWebURLString:{
            if( [VVReachabilityTool connectionInternet]){
                //创建一个NSURLRequest 的对象
                NSURLRequest * Request_zsj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                //加载网页
                [self.wkWebView loadRequest:Request_zsj];

            }else{
                VVNoNetworkingView *noNetworkingView = [[VVNoNetworkingView alloc]initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight - 64)];
                [self.view addSubview:noNetworkingView];
            }
            break;
        }
        case loadWebHTMLString:{
            [self loadHostPathURL:self.URLString];
            break;
        }
        case POSTWebURLString:{
            // JS发送POST的Flag，为真的时候会调用JS的POST方法
            self.needLoadJSPOST = YES;
            //POST使用预先加载本地JS方法的html实现，请确认WKJSPOST存在
            [self loadHostPathURL:@"WKJSPOST"];
            break;
        }
    }
}

- (void)loadHostPathURL:(NSString *)url{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
    [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 调用JS发送POST请求
- (void)postRequestWithJS {
    // 拼装成调用JavaScript的字符串
    NSString *jscript = [NSString stringWithFormat:@"post('%@',{%@});", self.URLString, self.postData];
    // 调用JS代码
    [self.wkWebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
    }];
}


- (void)loadWebURLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = loadWebURLString;
}

- (void)loadWebHTMLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = loadWebHTMLString;
}

- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData{
    self.URLString = string;
    self.postData = postData;
    self.loadType = POSTWebURLString;
}

#pragma mark ================ 自定义返回/关闭按钮 ================

-(void)updateNavigationItems{
    if (self.wkWebView.canGoBack) {
        if (!self.btnBack) {
            [self addBackButton];
        }
        if (!_btnClose) {
            [self btnClose];
        }else{
            _btnClose.hidden = NO;
        }
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        if (!self.btnBack) {
            [self addBackButton];
        }
        if (_btnClose) {
            _btnClose.hidden = YES;
        }
    }
}
//请求链接处理
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    //    VVLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        VVLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    UIView* currentSnapShotView = [self.wkWebView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:
     @{@"request":request,@"snapShotView":currentSnapShotView}];
}

#pragma mark ================ WKNavigationDelegate ================

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    // 判断是否需要加载（仅在第一次加载）
    if (self.needLoadJSPOST) {
        // 调用使用JS发送POST请求的方法
        [self postRequestWithJS];
        // 将Flag置为NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    // 获取加载网页的标题
    if (VV_IS_NIL(self.wkWebView.title)) {
        [self setTitleLabelText: _webTitle];
    }else{
        [self setTitleLabelText: self.wkWebView.title];
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
    [self hideHud];
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self showHud];
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{

}

//每次web页面向服务器发送请求时都会调用高频次
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    [self updateNavigationItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    VVLog(@"页面加载超时");
    [self hideHud];
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self hideHud];
}

//进度条
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{}

#pragma mark ================ WKUIDelegate ================

// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ================ WKScriptMessageHandler ================

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    VVLog(@"message.body--%@  message.name--%@",message.body,message.name);
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    if ([message.name isEqualToString:@"Native"]) {
        VVLog(@"---%@", message.body);
        [self showAlert:message.body];
    }
    if ([self.URLString containsString:@"unionPayCallback.html"]) {
        if ([message.name isEqualToString:@"unionPay"]) {
            VVLog(@"---%@", message.body);
            if((int) message.body == 1){
                if (_payBlock) {
                    _payBlock();
                }
                [self customPopViewController];
            }else{
                
            }
        }
    }
}


//原生调用JS
-(void)appNativeInvokeJS:(NSString*)jsString{
    [self.wkWebView evaluateJavaScript:jsString  completionHandler:^(id item, NSError * _Nullable error) {
    }];
}

#pragma mark ================ 懒加载 ================

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        //设置网页的配置文件
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        //允许视频播放
//        Configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [UserContentController addScriptMessageHandler:self name:@"Native"];
        [UserContentController addScriptMessageHandler:self name:@"unionPay"];
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        Configuration.userContentController = UserContentController;
        if (_isNavHidden) {
            _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:Configuration];
        }else{
            _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight - 64) configuration:Configuration];

        }

        _wkWebView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        // 设置代理
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        //kvo 添加进度监控
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
        //关闭手势触摸
        _wkWebView.allowsBackForwardNavigationGestures = NO;
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}


- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        if (_isNavHidden == YES) {
            _progressView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 3);
        }else{
            _progressView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 3);
        }
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor globalThemeColor];
    }
    return _progressView;
}

-(UIButton*)btnClose{
    if (!_btnClose) {
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnClose setTitle:@"关闭" forState:UIControlStateNormal];
        [_btnClose setFrame:  CGRectIntegral(CGRectMake(50, _deltaY, 40, 44))];
        [_btnClose setTitleColor:VV_COL_RGB(0x333333) forState:UIControlStateNormal];
        [_btnClose setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateHighlighted];
        [_btnClose setTitleColor:VV_COL_RGB(0x777e81) forState:UIControlStateDisabled];
        _btnClose.titleLabel.font  = [UIFont systemFontOfSize:15];
        
        _btnClose.exclusiveTouch = YES;
        [_navigationBar addSubview:_btnClose];
        
        [_btnClose addTarget:self action:@selector(closeWebApp:) forControlEvents:UIControlEventTouchUpInside];
            
    }
    return _btnClose;
}


-(void)backAction:(id)sender{
    
    if ([_wkWebView canGoBack] && sender == self.btnBack) {
        [_wkWebView goBack];
        if (_btnClose.hidden) {
            [self.btnBack setFrame:CGRectMake(0, _deltaY, 75, 44)];
            [self setTitleLabelText:self.wkWebView.title];
        }
        if (!_btnRight.hidden) {
            _btnRight.hidden = YES;
        }
    }else {
        if([self.URLString containsString:@"unionPay.html"]){
            [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"您没有完成支付，是否确定退出" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex  != kCancelButtonTag) {
                    [alertView hideAlertViewAnimated:YES];
                    [super backAction:sender];
                }
            }];
        }else{
         [super backAction:sender];
        }
    }

}

- (void)closeWebApp:(id)obj
{
    [self customPopViewController];
}

-(NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

-(void)viewWillDisappear:(BOOL)animated{
//    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"WXPay"];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

//注意，观察的移除
-(void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"Native"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"unionPay"];

}

- (void)showAlert:(NSString *)errorStr
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:errorStr
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self quitRequest];
    }];
    
    [alert addAction:updateAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)quitRequest
{
    [self hideHud];
    
    [MBProgressHUD bwm_showTitle:@"退出成功" toView:self.view hideAfter:1.5f];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JJEmployeVbsAccount"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JJEmployeSalesId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JJEmployeSalesToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [VV_App.naviController presentLoginViewController];
}

@end
