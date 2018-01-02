//
//  JJGetNextPeriodBillRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetNextPeriodBillRequest.h"

@implementation JJGetNextPeriodBillRequest
- (NSString *)apiMethodName
{
    return JJGetNextPeriodBillUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJGetNextPeriodBillModel *)response
{
    JJGetNextPeriodBillModel *model = [JJGetNextPeriodBillModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
