//
//  JJAuthZhimaRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/9.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJAuthZhimaRequest.h"
//
@implementation JJAuthZhimaRequest
- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (NSString *)apiMethodName
{
//#if DEBUG
//    return @"http://10.155.50.107:5080/api/jlh/apply/zmxycreditscore/app";
//#else
//    return @"http://10.155.50.107:5080/api/jlh/apply/zmxycreditscore/app";
//#endif
    return JJZhimaURL;
}
@end
