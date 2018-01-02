//
//  JJReviewManager.m
//  JieLeHua
//
//  Created by pingyandong on 2017/6/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJReviewManager.h"

@implementation JJReviewManager
+ (JJReviewManager *)reviewManager
{
    static dispatch_once_t onceToken;
    static JJReviewManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;

}
@end
