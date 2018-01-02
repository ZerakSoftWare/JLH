//
//  JJConfirmAdvCloanRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJConfirmAdvCloanRequest.h"

@interface JJConfirmAdvCloanRequest ()
@property (nonatomic, copy) NSString *customerId;
@end

@implementation JJConfirmAdvCloanRequest
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
    return [NSString stringWithFormat:@"%@%@/%@",App_Loan_Url,JJConfirmAdvCloanUrl,self.customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodPost;
}

- (NSString *)failHudTipString
{
    return @"提前清贷失败";
}
@end
