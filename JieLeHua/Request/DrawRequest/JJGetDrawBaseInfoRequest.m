//
//  JJGetDrawBaseInfoRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJGetDrawBaseInfoRequest.h"

@implementation JJGetDrawBaseInfoRequest
- (NSString *)apiMethodName
{
    return JJGetDrawBaseInfoUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJDrawModel *)response
{
    JJDrawModel *model = [JJDrawModel mj_objectWithKeyValues:[self responseJSONObject]];
    return model;
}

@end
