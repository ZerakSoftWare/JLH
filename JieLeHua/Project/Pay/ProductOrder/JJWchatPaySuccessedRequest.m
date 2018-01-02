//
//  JJWchatPaySuccessedRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/13.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJWchatPaySuccessedRequest.h"
@interface JJWchatPaySuccessedRequest()
@property(nonatomic,copy)NSString *type;
@end

@implementation JJWchatPaySuccessedRequest
- (instancetype)initWithType:(NSString *)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/draw/paySuccess/%@",APP_BASE_URL,self.type];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

@end
