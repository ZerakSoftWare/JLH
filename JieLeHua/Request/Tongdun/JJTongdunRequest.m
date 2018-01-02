//
//  JJTongdunRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/12/6.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJTongdunRequest.h"

@implementation JJTongdunRequest
- (instancetype)initWithParam:(NSDictionary *)param
{
    if (self = [super init]) {
        self.requestArgument = param;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return JJGetTongdunUrl;
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
