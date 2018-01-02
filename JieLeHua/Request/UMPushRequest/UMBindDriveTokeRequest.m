//
//  UMBindDriveTokeRequest.m
//  JieLeHua
//
//  Created by kuang on 2017/3/8.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "UMBindDriveTokeRequest.h"

@implementation UMBindDriveTokeRequest
- (instancetype)initWithParam:(NSDictionary *)param
{
    if (self = [super init]) {
        self.requestArgument = param;
    }
    return self;
}

- (KZRequestSerializerType)requestSerializerType
{
    return KZRequestSerializerTypeJSON;
}

- (NSString *)apiMethodName
{
    return UMBindDriveTokeUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodPost;
}

@end
