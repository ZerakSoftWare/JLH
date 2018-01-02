//
//  IntroduceHomeVC.m
//  JieLeHua
//
//  Created by admin2 on 2017/6/7.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IntroduceHomeVC.h"
#import <WebKit/WebKit.h>
#import "IntroduceToolbarView.h"
#import "KSShare.h"
#import "IntroduceActivityDetailVC.h"
#import "SVGA.h"

#pragma mark Constants

static const NSTimeInterval KLongGestureInterval = 0.6f;

static SVGAParser *parser;

#pragma mark - Class Extension

@interface IntroduceHomeVC ()<WKNavigationDelegate,WKScriptMessageHandler,UIGestureRecognizerDelegate,UIActionSheetDelegate,IntroduceToolbarViewDelegate,SVGAPlayerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) MBProgressHUD *hudView;

@property (nonatomic, strong) NSString *qrCodeString;

@property (nonatomic, strong) UIImage *saveimage;

@property (nonatomic, strong) IntroduceToolbarView *toolbarView;

@property (nonatomic, copy) NSString *salesId;

@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, strong) SVGAPlayer *aPlayer;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation IntroduceHomeVC


#pragma mark - Properties

- (SVGAPlayer *)aPlayer {
    if (_aPlayer == nil) {
        _aPlayer = [[SVGAPlayer alloc] init];
    }
    return _aPlayer;
}

- (IntroduceToolbarView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [[IntroduceToolbarView alloc] initWithFrame:CGRectMake(0, 16, 188, 32)];
        _toolbarView.delegate = self;
        _toolbarView.lightColor = VVColor(75, 231, 243);
        _toolbarView.deepColor = VVColor(88, 152, 242);
        _toolbarView.backColor = [UIColor whiteColor];
        _toolbarView.layer.cornerRadius = 16;
        _toolbarView.clipsToBounds = YES;
    }
    return _toolbarView;
}

- (WKWebView *)webView
{
    if (_webView == nil) {
        
        //I don't know why? When I add this code snip, it works fine! Otherwise, it works bad.
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:view];
        // end
        
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.userContentController = [[WKUserContentController alloc] init];
        // 注入JS对象Native，
        // 声明WKScriptMessageHandler 协议
        [config.userContentController addScriptMessageHandler:self name:@"Native"];

        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate = self;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = KLongGestureInterval;
        longPress.allowableMovement = 20.f;
        longPress.delegate = self;
        [_webView addGestureRecognizer:longPress];
    }
    return _webView;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc
{
    
}


#pragma mark - Public Methods

- (void)topToolbar:(IntroduceToolbarView *)topToolbar didSelectedTag:(int)tag
{
    switch (tag) {
            case 1:
        {
            //--二维码
            NSString *url = [NSString stringWithFormat:@"%@/transferList.html?salesId=%@&from=app&type=ewm",WEB_BASE_URL,self.salesId];
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
            break;
            case 2:
        {
            //--活动
            NSString *url = [NSString stringWithFormat:@"%@/transferList.html?salesId=%@&from=app&type=activity",WEB_BASE_URL,self.salesId];
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex){
            case 0:
        {
            UIImageWriteToSavedPhotosAlbum(self.saveimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
            break;
            
            case 1:
        {
            NSURL *qrUrl = [NSURL URLWithString:self.qrCodeString];
            //--open with safari
            if ([[UIApplication sharedApplication] canOpenURL:qrUrl]) {
                [[UIApplication sharedApplication] openURL:qrUrl];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"Native"]) {
        NSLog(@"---%@", message.body);
        //--如果是自己定义的协议, 再截取协议中的方法和参数, 判断无误后在这里手动调用oc方法
        self.shareUrl = message.body;
        
        NSString *tempString2 = @"document.getElementById('shareLogo').src";
        [self.webView evaluateJavaScript:tempString2  completionHandler:^(id item, NSError * _Nullable error) {
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item]];
            UIImage *image = [UIImage imageWithData:data];
            
            if (!image) {
                VVLog(@"read fail");
                return;
            }
            
            [self toShareWithImage:image];
        }];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.hudView hide:YES];
    
    self.navigationItem.title = self.webView.title;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSString *requestString = [webView.URL absoluteString];
    
    if ([requestString rangeOfString:@"index_share" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        //--检测是否含有index_share。如有则跳转下一个界面，无不做处理
        decisionHandler(WKNavigationResponsePolicyCancel);
        
        IntroduceActivityDetailVC *detailvc = [[IntroduceActivityDetailVC alloc] init];
        detailvc.urlString = requestString;
        detailvc.isSupportShare = YES;
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
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.hudView hide:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.view.backgroundColor = kColor_ViewBackground_Color;
    
    self.salesId = [[NSUserDefaults standardUserDefaults]objectForKey:@"JJEmployeSalesId"];
    
    [self initAndLayoutUI];
    
    [self getShowHuahuaPageStatus];
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
    /***************选项组***************/
    
    self.toolbarView.centerX = self.view.centerX;
    NSArray *arry = @[@"我的二维码",@"活动"];
    self.toolbarView.productArr = arry;
    [self.view addSubview:self.toolbarView];
    
    [self.toolbarView setSelectedBtnIndex:0];
    
    
    /***************wkwebview***************/
    
    NSString *url = [NSString stringWithFormat:@"%@/transferList.html?salesId=%@&from=app&type=ewm",WEB_BASE_URL,self.salesId];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.toolbarView.mas_bottom);
    }];
    
    
    //--播放名人堂icon
    [self.view addSubview:self.aPlayer];

    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.aPlayer addGestureRecognizer:singleTap];
    
    self.aPlayer.delegate = self;
    self.aPlayer.frame = CGRectMake(kScreenWidth-110, kScreenHeight-250, 110, 110);
    self.aPlayer.loops = 0;
    self.aPlayer.clearsAfterStop = YES;

    parser = [[SVGAParser alloc] init];

    [parser parseWithNamed:@"mingrentang"
                  inBundle:[NSBundle mainBundle]
           completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
               self.aPlayer.videoItem = videoItem;
               [self.aPlayer startAnimation];
           } failureBlock:^(NSError * _Nonnull error) {

           }];
}

- (void)handleSingleTap
{
    IntroduceActivityDetailVC *detailvc = [[IntroduceActivityDetailVC alloc] init];
    detailvc.urlString = [NSString stringWithFormat:@"%@/article/20171120/index.html",WEB_BASE_URL];
    detailvc.isSupportShare = NO;
    detailvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailvc animated:YES];
}

#pragma mark - Save image callback

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil)
    {
        [MBProgressHUD bwm_showTitle:@"已成功保存至相册" toView:self.view hideAfter:1.2f msgType:BWMMBProgressHUDMsgTypeSuccessful];
    }
    else
    {
        [MBProgressHUD bwm_showTitle:@"保存失败,请确认打开相册权限" toView:self.view hideAfter:1.2f msgType:BWMMBProgressHUDMsgTypeError];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [sender locationInView:self.webView];
    // get image url where pressed.
    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    
    [self.webView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imageUrl, NSError * _Nullable error) {
        
        if (imageUrl) {
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *image = [UIImage imageWithData:data];
            
            if (!image) {
                VVLog(@"read fail");
                return;
            }
            
            self.saveimage = image;
            
            if ([self isAvailableQRcodeIn:image])
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"保存", @"识别二维码", nil];
                [actionSheet showInView:self.view.window];
            }
            
        }
    }];
}

- (BOOL)isAvailableQRcodeIn:(UIImage *)img
{
    //Extract QR code by screenshot
    //UIImage *image = [self snapshot:self.view];
    
    UIImage *image = [self imageByInsetEdge:UIEdgeInsetsMake(-20, -20, -20, -20) withColor:[UIColor lightGrayColor] withImage:img];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{}];
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (features.count >= 1)
    {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        
        self.qrCodeString = [feature.messageString copy];
        
        VVLog(@"QR result :%@", self.qrCodeString);
        return YES;
    }
    else
    {
        VVLog(@"No QR");
        return NO;
    }
}

// you can also implement by UIView category
- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.window.screen.scale);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
    {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// you can also implement by UIImage category
- (UIImage *)imageByInsetEdge:(UIEdgeInsets)insets withColor:(UIColor *)color withImage:(UIImage *)image
{
    CGSize size = image.size;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    
    if (size.width <= 0 || size.height <= 0)
    {
        return nil;
    }
    
    CGRect rect = CGRectMake(-insets.left, -insets.top, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (color)
    {
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CGPathAddRect(path, NULL, rect);
        CGContextAddPath(context, path);
        CGContextEOFillPath(context);
        CGPathRelease(path);
    }
    
    [image drawInRect:rect];
    UIImage *insetEdgedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return insetEdgedImage;
}

#pragma mark - 分享

- (void)toShareWithImage:(UIImage *)img
{
    NSArray *contentArray = @[@{@"name":@"微信",@"icon":@"sns_icon_7",@"platformType":@"wechatsession"},
                              @{@"name":@"朋友圈",@"icon":@"sns_icon_8",@"platformType":@"wechattimeline"},
                              @{@"name":@"QQ空间 ",@"icon":@"sns_icon_5",@"platformType":@"qzone"},
                              @{@"name":@"QQ",@"icon":@"sns_icon_4",@"platformType":@"qq"}];
    
    KSShareMenuView *shareView = [[KSShareMenuView alloc] init];
    shareView.rowNumberItem = 4;
    shareView.cancelButtonText = @"取消分享";
    [shareView addShareItems:self.view.window shareItems:contentArray selectShareItem:^(NSInteger tag, NSString *title, NSString *platformType) {
        [KSShareHelper shareUrlDataWithPlatform:[KSShareTool getPlatformType:platformType]
                                   withShareUrl:self.shareUrl
                                      withTitle:self.webView.title
                                      withDescr:@"借乐花，简单借，快乐花！有花呗就能申请，额度最高3万元"
                                  withThumImage:img
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

- (void)getShowHuahuaPageStatus
{
    NSString *vbsAccount = [[NSUserDefaults standardUserDefaults]objectForKey:@"JJEmployeVbsAccount"];
    
    [[VVNetWorkUtility netUtility] getNeedShowHuahuaPageWithVbsAccount:vbsAccount
                                                               success:^(id result)
     {
         if ([result[@"success"] integerValue] == 1)
         {
             //--isShowHuahuaFame：0（展示）、1（不展示）
             NSString *showStr = [NSString stringWithFormat:@"%@",[[result safeObjectForKey:@"data"] safeObjectForKey:@"isShowHuahuaFame"]];
             
             if ([showStr isEqualToString:@"0"])
             {
                 [self handleSingleTap];
             }
         }
         else
         {
             [MBProgressHUD bwm_showTitle:result[@"message"] toView:self.view hideAfter:1.5f];
         }
         
     }failure:^(NSError *error)
     {
         [MBProgressHUD bwm_showTitle:@"网络不给力" toView:self.view hideAfter:1.5f];
     }];
}

@end
