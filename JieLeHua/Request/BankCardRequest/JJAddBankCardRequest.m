//
//  JJAddBankCardRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJAddBankCardRequest.h"

@implementation JJAddBankCardRequest
- (instancetype)initWithParam:(NSDictionary *)param;
{
    if (self = [super init]) {
        self.requestArgument = param;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return JJAndBankCardUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodPost;
}

- (KZRequestSerializerType)requestSerializerType
{
    return KZRequestSerializerTypeJSON;
}


@end
