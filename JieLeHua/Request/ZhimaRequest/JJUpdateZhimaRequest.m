//
//  JJUpdateZhimaRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJUpdateZhimaRequest.h"
#import "JJVersionSourceManager.h"

@implementation JJUpdateZhimaRequest
- (instancetype)initWithParam:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.requestArgument = dict;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return JJUpdateZhimaUrl;
//    if ([[JJVersionSourceManager versionSourceManager].versionSource isEqualToString:@"0"]) {
//        return JJUpdateZhimaUrl;
//    }else{
//        return JJUpdateSesameInfoUrl;
//    }
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
