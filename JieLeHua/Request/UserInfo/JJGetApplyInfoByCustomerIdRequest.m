//
//  JJGetApplyInfoByCustomerIdRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/13.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJGetApplyInfoByCustomerIdRequest.h"

@interface JJGetApplyInfoByCustomerIdRequest ()
@property (nonatomic, copy) NSString *customerId;
@end

@implementation JJGetApplyInfoByCustomerIdRequest
- (instancetype)initWithCustomerId:(NSString *)customerId
{
    if (self = [super init]) {
        self.customerId = customerId;
    }
    return self;
}

- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@%@/%@",App_Loan_Url,JJGetApplyInfoByCustomerIdUrl,self.customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}
@end
