//
//  JJSubbmitDrawMoneyRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJSubbmitDrawMoneyRequest.h"

@implementation JJSubbmitDrawMoneyRequest
- (instancetype)initWithParam:(NSDictionary *)param
{
    if (self = [super init]) {
        self.requestArgument = param;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return JJSubbmitDrawMoneyUrl;
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
