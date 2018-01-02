//
//  JJRiskCusomerRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/27.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJRiskCusomerRequest.h"

@implementation JJRiskCusomerRequest
- (instancetype)initWithParam:(NSDictionary *)param
{
    if (self = [super init]) {
        self.requestArgument = param;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return JJSaveRiskCustomerContactsUrl;
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
