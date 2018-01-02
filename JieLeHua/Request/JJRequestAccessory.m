//
//  JJRequestAccessory.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJRequestAccessory.h"

@interface JJRequestAccessory ()
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIViewController *viewController;
@end

@implementation JJRequestAccessory
- (instancetype) initWithShowVC:(UIViewController *)vc{
    self = [super init];
    if (self) {

        if (vc.view == nil) {
            _hud = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:[UIApplication sharedApplication].keyWindow];
        }else{
            _hud = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:vc.view];
        }
        
        [vc.view addSubview:_hud];
        _viewController = vc;
    }
    return self;
}
- (instancetype) initWithShowView:(UIView *)view{
    self = [super init];
    if (self) {
        if (view == nil) {
            view = [UIApplication sharedApplication].keyWindow;
        }
        _hud = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:view];
        [view addSubview:_hud];
    }
    return self;
}

- (void)changeHudText:(NSString *)string
{
    _hud.label.text = string;
}

- (void)requestWillStart:(id)request {
    [self.hud showAnimated:YES];
}

//- (void)requestWillStop:(id)request {
//    [self.hud hideAnimated:NO];
//}

- (void)requestDidStop:(id)request{
    [self.hud hideAnimated:YES afterDelay:0.5];
}

@end
