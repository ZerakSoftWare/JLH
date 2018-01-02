//
//  JJGetIncreaseDetailRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/8/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetIncreaseDetailRequest.h"

@interface JJGetIncreaseDetailRequest ()
@property (nonatomic, copy) NSString * customerId;
@end

@implementation JJGetIncreaseDetailRequest

- (instancetype)initWithCustomerId:(NSString *)customerId
{
    if (self = [super init]) {
        self.customerId = customerId;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/%@",JJGetIncreaseDetailUrl,self.customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJIncreaseDetailModel *)response
{
    JJIncreaseDetailModel *model = [JJIncreaseDetailModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}

@end
