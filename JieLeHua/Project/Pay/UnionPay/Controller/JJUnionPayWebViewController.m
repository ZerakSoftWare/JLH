//
//  JJUnionPayWebViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/11/10.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJUnionPayWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JJUnionPayWebViewController ()
{
    JSContext *_context;
}
@end

@implementation JJUnionPayWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    _btnClose.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    // Do any additional setup after loading the view.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
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
            [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"您没有完成支付，是否确定退出" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex  != kCancelButtonTag) {
                    [super backAction:sender];
                    [alertView hideAlertViewAnimated:YES];
                    
                }
            }];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self hideHud];
    NSString *currentUrl = webView.request.URL.absoluteString;
    VVLog(@"webView location  webViewDidStartLoad= '%@'", currentUrl);
    if (_context) {
        _context = nil;
    }
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak __typeof(self)weakSelf = self;
    _context[@"unionPay"] = ^(int code,NSString *message) {
        VVLog(@"webViewDidStartLoad====%d====%@====",code,message);
        if (code == 1) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (strongSelf.paySuccess) {
                    [strongSelf customPopViewController];
                    strongSelf.paySuccess(YES);
                }
            });
        }else if (code == 2) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [VVAlertUtils showAlertViewWithTitle:@"提示" message:message customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex  != kCancelButtonTag) {
                        [strongSelf customPopViewController];
                        [alertView hideAlertViewAnimated:YES];
                        if (strongSelf.paySuccess) {
                            strongSelf.paySuccess(NO);
                        }
                    }
                }];
            });
        }
    };
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    VVLog(@"%@",requestString);
    if ([requestString containsString:@"/unionPayCallback.html"]) {
        [self returnBack];
        [webView stopLoading];
    }
    return YES;
}

- (void)returnBack
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.paySuccess) {
            [strongSelf customPopViewController];
            strongSelf.paySuccess(YES);
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
