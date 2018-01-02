//
//  JJBillAndNotiCountManager.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBillAndNotiCountManager.h"
#import "VVTabBarViewController.h"
#import "JJGetRedIsNewRequest.h"

@interface JJBillAndNotiCountManager ()
@property (nonatomic, assign) BOOL showBillRed;
@property (nonatomic, assign) BOOL showMessageRed;
@property (nonatomic, strong) NSMutableDictionary *responseDict;
@end

@implementation JJBillAndNotiCountManager
+ (instancetype)sharedBillAndNotiCountManager
{
    static JJBillAndNotiCountManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)updateNotiCount
{
    if (![UserModel isLoggedIn]) {
        [self clearRedStatus];
        return;
    }
    self.showBillRed = NO;
    self.showMessageRed = NO;
    __block NSString *customerId = [UserModel currentUser].customerId;
    NSString *timeStamp = @"0";
    NSString *plistPath = [VVPathUtils redIsNewPlistPath];
    NSDictionary *isRedDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    JJRedIsNewModel *model = [JJRedIsNewModel mj_objectWithKeyValues:isRedDict];
    if (model.timestamp) {
        timeStamp = model.timestamp;
    }
    
    __block BOOL showDueBill = NO;
    if ([[model.data safeObjectForKey:@"overdueBill"] boolValue]) {
        NSDate *now = [NSDate date];
        NSDate *time = [VVCommonFunc dateformatDateStr:model.timestamp formatter:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval interval = [now timeIntervalSinceDate:time];
        if (interval/3600 < 24) {
            //24小时内有逾期账单
            showDueBill = YES;
        }
    }
    NSString *timeSt = @"";
    if (![timeStamp isEqualToString:@"0"]) {
        timeSt = [NSString stringWithFormat:@"%.f",[[VVCommonFunc dateformatDateStr:timeStamp formatter:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970]*1000];
    }else{
        timeSt = timeStamp;
    }
    JJGetRedIsNewRequest *request = [[JJGetRedIsNewRequest alloc] initWithCustomerId:customerId timeStamp:timeSt];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJRedIsNewModel *model = [(JJGetRedIsNewRequest *)request response];
        if (model.success) {
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:model.data];
            if ([[data safeObjectForKey:@"overdueBill"] boolValue]) {
                [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:1 show:YES];
            }else{
                [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:1 show:NO];
            }
            if ([[data safeObjectForKey:@"notice"] boolValue]) {
                [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:2 show:YES];
                [strongSelf updateHomeRightBtnHidden:NO];
            }else{
                [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:2 show:NO];
                [strongSelf updateHomeRightBtnHidden:YES];
            }
            
            if (showDueBill) {
                [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:1 show:YES];
            }
            //根据customerID保存timestamp和状态
            //保存至沙盒
            strongSelf.responseDict = request.responseJSONObject;
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:request.responseJSONObject];
            [temp setObject:@"" forKey:@"timestamp"];
            [temp writeToFile:plistPath atomically:YES];
        }else{
            [strongSelf clearRedStatus];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf clearRedStatus];
    }];
}

- (void)saveTimeStamp
{
    NSString *plistPath = [VVPathUtils redIsNewPlistPath];
    [self.responseDict writeToFile:plistPath atomically:YES];
}

//更新首页右上角按钮
- (void)updateHomeRightBtnHidden:(BOOL)hidden
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:hidden?@"0":@"1" forKey:@"showRightCount"];
    [[NSNotificationCenter defaultCenter] postNotificationName:JJUpdateHomeRightBtn object:dict];
}

//是否显示账单小红点
- (BOOL)showBillRed
{
    //昨天该账号是否有逾期账单信息
    NSString *plistPath = [VVPathUtils redIsNewPlistPath];
    NSDictionary *isRedDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *data = [isRedDict safeObjectForKey:@"data"];
    _showBillRed = [[data safeObjectForKey:@"overdueBill"] boolValue];
    return _showBillRed;
}

//是否显示消息小红点
- (BOOL)showMessageRed
{
    NSString *plistPath = [VVPathUtils redIsNewPlistPath];
    NSDictionary *isRedDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *data = [isRedDict safeObjectForKey:@"data"];
    _showMessageRed = [[data safeObjectForKey:@"notice"] boolValue];
    return _showMessageRed;
}

///清除小红点状态
- (void)clearRedStatus
{
    _showMessageRed = _showBillRed = NO;
    [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:1 show:NO];
    [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:2 show:NO];
    [self updateHomeRightBtnHidden:YES];
}


///账单已读
- (void)clearBillStatus
{
    if (![UserModel isLoggedIn]) {
        return;
    }
    //重置沙盒内容
    NSString *plistPath = [VVPathUtils redIsNewPlistPath];
    NSMutableDictionary *isRedDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *data = [isRedDict safeObjectForKey:@"data"];
    [data setObject:@"0" forKey:@"overdueBill"];
    [isRedDict writeToFile:plistPath atomically:YES];
    [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:1 show:NO];
}

///消息已读
- (void)clearMessageStatus
{
    if (![UserModel isLoggedIn]) {
        return;
    }
    //重置沙盒内容
    NSString *plistPath = [VVPathUtils redIsNewPlistPath];
    NSMutableDictionary *isRedDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *data = [isRedDict safeObjectForKey:@"data"];
    [data setObject:@"0" forKey:@"notice"];
    [isRedDict writeToFile:plistPath atomically:YES];
    [(VVTabBarViewController *)VV_App.tabBarController showBadgeAtIndex:2 show:NO];
    [self updateHomeRightBtnHidden:YES];
}

@end
