//
//  JJHomeStatusRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJHomeStatusRequest.h"

@interface JJHomeStatusRequest ()
@property (nonatomic, copy) NSString *customerId;
@end

@implementation JJHomeStatusRequest
- (instancetype)initWithCustomerId:(NSString *)customerId
{
    if (self = [super init] ) {
        self.customerId = customerId;
    }
    return self;
}

- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return  [NSString stringWithFormat:@"%@%@/%@",APP_BASE_URL,JJGetWeChatJlhAccountUrl,self.customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (BOOL)cacheResponse
{
    return YES;
}

@end
