//
//  JJPayOverDateBillRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJPayOverDateBillRequest.h"

@interface JJPayOverDateBillRequest ()
@property (nonatomic, copy) NSString *customerId;
@end

@implementation JJPayOverDateBillRequest
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
    return [NSString stringWithFormat:@"%@%@/%@",App_Loan_Url,JJPayOverDateBillUrl,self.customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}


@end
