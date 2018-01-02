//
//  JJcouponRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJcouponRequest.h"

@interface JJcouponRequest()
@property(nonatomic,copy) NSString *customerId;

@end

@implementation JJcouponRequest
- (instancetype)initWithCustomerId:(NSString *)customerId
                    
{
    if (self = [super init]) {
        self.customerId = customerId;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/%@",JJGetMyVoucherUrl,_customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (KZRequestSerializerType)requestSerializerType
{
    return KZRequestSerializerTypeJSON;
}

- (JJcouponModel *)response
{
    JJcouponModel *model = [JJcouponModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}

@end
