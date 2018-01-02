//
//  JJGetBannerRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetBannerRequest.h"

@implementation JJGetBannerRequest
- (NSString *)apiMethodName
{
    return JJGetBannerUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJBannnerModel *)response
{
    JJBannnerModel *model = [JJBannnerModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}

@end
