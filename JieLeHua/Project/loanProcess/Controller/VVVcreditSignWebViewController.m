//
//  VVVcreditSignWebViewController.m
//  O2oApp
//
//  Created by chenlei on 16/7/11.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVVcreditSignWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIImage+GIF.h"

@interface VVVcreditSignWebViewController ()
{
    UIImage *_signImage;
    JSContext *_context;
//    BOOL _isSign;
}
@end

@implementation VVVcreditSignWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _btnClose.hidden = YES;
//    _isSign = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!_context) {
        __weak VVVcreditSignWebViewController *wself = self;
        _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            _context[@"saveSignImage"] = ^(NSDictionary *dic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    VVLog(@"-sign---%@",dic);
//                    NSString *signImage = dic[@"signImage"];
                    NSString *personalImage = dic[@"personalImage"];

                    [wself backSuccrssPersonalImage:personalImage];
                });

            };

       //        _context[@"saveAllPic"] = ^(NSDictionary *dic) {
//            _isSign = YES;
//        };
    }
}

- (void)backAction:(id)sender{
//    if (_isSign) {
        [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"您还没有保存，是否放弃本次签名" customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex  != kCancelButtonTag) {
                [alertView hideAlertViewAnimated:YES];
                [self customPopViewController];
            }
        }];
//    }else{
//        [super backAction:sender];
//    }
   
}
- (void)backSuccrssPersonalImage:(NSString *)personalImage{
    if (_signSuccBlock&&!VV_IS_NIL(personalImage)) {
        _signSuccBlock(personalImage);
        [self customPopViewController];
    }
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
