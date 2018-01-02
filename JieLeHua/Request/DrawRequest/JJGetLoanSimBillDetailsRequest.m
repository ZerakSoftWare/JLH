//
//  JJGetLoanSimBillDetailsRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJGetLoanSimBillDetailsRequest.h"

@implementation JJGetLoanSimBillDetailsRequest
- (instancetype)initWithParam:(NSDictionary *)param
{
    if (self = [super init]) {
        self.requestArgument = param;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return JJGetLoanSimBillDetailsUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodPost;
}

- (KZRequestSerializerType)requestSerializerType
{
    return KZRequestSerializerTypeJSON;
}

- (JJLoanBillDetailModel *)response
{
    JJLoanBillDetailModel *model = [JJLoanBillDetailModel mj_objectWithKeyValues:[self responseJSONObject]];
    return model;
}
@end
