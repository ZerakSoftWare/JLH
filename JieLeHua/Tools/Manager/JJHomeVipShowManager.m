//
//  JJHomeVipShowManager.m
//  JieLeHua
//
//  Created by pingyandong on 2017/12/22.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJHomeVipShowManager.h"

@implementation JJHomeVipShowManager
+ (JJHomeVipShowManager *)homeVipShowManager
{
    static dispatch_once_t onceToken;
    static JJHomeVipShowManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
@end
