//
//  JJCityListRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJCityListRequest.h"

@implementation JJCityListRequest
- (NSString *)apiMethodName
{
    return JJGetCityListUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}
@end
