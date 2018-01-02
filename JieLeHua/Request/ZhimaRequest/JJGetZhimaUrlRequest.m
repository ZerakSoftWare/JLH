//
//  JJGetZhimaUrlRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/25.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetZhimaUrlRequest.h"

@implementation JJGetZhimaUrlRequest
- (instancetype)initWithParam:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.requestArgument = dict;
    }
    return self;
}

- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
//    10.155.50.107
    return [NSString stringWithFormat:@"%@%@",APP_ZHIMA_URL,JJZhimaUrl];
}

- (BOOL)isBase64Encode
{
    return YES;
}

@end
