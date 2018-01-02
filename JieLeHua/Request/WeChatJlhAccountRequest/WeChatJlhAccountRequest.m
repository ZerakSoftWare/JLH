//
//  WeChatJlhAccountRequest.m
//  JieLeHua
//
//  Created by kuang on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "WeChatJlhAccountRequest.h"

@implementation WeChatJlhAccountRequest

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/%@",JJGetWeChatJlhAccountUrl,[UserModel currentUser].customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

@end
