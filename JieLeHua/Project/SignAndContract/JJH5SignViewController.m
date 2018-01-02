//
//  JJH5SignViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJH5SignViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JJH5SignViewController ()
{
    JSContext *_context;
}
@end

@implementation JJH5SignViewController
//如果是代码 xib 创建ViewController 则JCRouter会调用此方法
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        VVLog(@"%@", params);
        self.webTitle = [params safeObjectForKey:@"title"];
        self.cardId = [params safeObjectForKey:@"cardId"];
        self.token = [params safeObjectForKey:@"token"];
        self.name = [params safeObjectForKey:@"name"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _btnClose.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.cardId) {
        NSString *url = [NSString stringWithFormat:@"%@/sign2.html?idcard=%@&token=%@&name=%@&customerId=%@",WEB_BASE_URL,self.cardId,[UserModel currentUser].token,self.name,[UserModel currentUser].customerId];
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        self.startPage = url;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.startPage] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:Timeout];
        [_webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    __weak __typeof(self)weakSelf = self;
    if (_context) {
        _context = nil;
    }
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"saveSignImage"] = ^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VVLog(@"-sign---%@",dic);
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf customPopToRootViewController];
        });
    };
    
    _context[@"goPayment"] = ^{
        //--加入会员
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf joinMember];
        });
    };
    
    if (self.isModifyBank)
    {
        //--修改银行卡
        _context[@"saveBankCard"] = ^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                VVLog(@"-sign---%@",dic);
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (strongSelf.signSuccBlock) {
                    strongSelf.signSuccBlock();
                }
            });
        };
    }
}

- (void)joinMember
{
    [[JCRouter shareRouter] pushURL:@"memberArgeement" extraParams:@{@"isDrawWebPage":@"0"}];
}

- (void)backAction:(id)sender{
    if ([_webView canGoBack] && sender == self.btnBack) {
        [_webView goBack];
        if (_btnClose.hidden) {
            [self.btnBack setFrame:CGRectMake(0, _deltaY, 75, 44)];
            [self setTitleLabelText:self.webTitle];
        }
        if (!_btnRight.hidden) {
            _btnRight.hidden = YES;
        }
    }else {
        [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"您还没有保存，是否放弃本次签名" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex  != kCancelButtonTag) {
                [alertView hideAlertViewAnimated:YES];
                [self hideHud];
                
                if (self.isModifyBank)
                {
                    //--修改银行卡
                    [self customPopViewController];
                }
                else
                {
                    [self customPopToRootViewController];
                }
            }
        }];
    }
}
@end
