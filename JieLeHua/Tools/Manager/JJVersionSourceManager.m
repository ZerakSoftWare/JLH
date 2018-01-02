//
//  JJVersionSourceManager.m
//  JieLeHua
//
//  Created by pingyandong on 2017/5/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJVersionSourceManager.h"
#import "JJHomeStatusRouterManager.h"
#import "JJBeginApplyRequest.h"

@interface JJVersionSourceManager ()
@property (nonatomic) NSTimeInterval startTime;
@end

@implementation JJVersionSourceManager
+ (JJVersionSourceManager *)versionSourceManager
{
    static dispatch_once_t onceToken;
    static JJVersionSourceManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.startTime = 0;
    }
    return self;
}

#pragma mark - 开始极速申请beginApply
- (void)startFastApplyWithView:(UIView *)view
{
    ///1s内禁止发多次请求
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    if (self.startTime == 0) {
        self.startTime = now;
    }
    VVLog(@"%f",now);
    if (now - self.startTime < 1 && now - self.startTime > 0) {
        VVLog(@"======================");
        return;//拒绝重复请求
    }

    VVLog(@"======================快速申请调用次数");
    self.versionSource = @"2";
    JJBeginApplyRequest *request = [[JJBeginApplyRequest alloc] initWithCustomerId:[UserModel currentUser].customerId source:@"2"];
//    MBProgressHUD *hud = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:view];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
//        [hud hide:YES];
        if ([[request.responseJSONObject safeObjectForKey:@"success"] boolValue]) {
            [[JJHomeStatusRouterManager homeStatusRouterManager] dealWithStatus:HomeStatus_BaseInfo data:nil];
        }else{
            [MBProgressHUD showError:[request.responseJSONObject safeKeyForValue:@"message"]];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
//        [hud hide:YES];
        [MBProgressHUD showError:@"请求失败"];
    }];
}


@end
