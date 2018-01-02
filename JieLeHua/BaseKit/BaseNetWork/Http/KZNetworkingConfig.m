//
//  KZNetworkingConfig.m
//  BubbleGum
//
//  Created by pingyandong on 16/5/6.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "KZNetworkingConfig.h"
#import "AFSecurityPolicy.h"
@implementation KZNetworkingConfig
+ (KZNetworkingConfig *) sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    return self;
}

@end
