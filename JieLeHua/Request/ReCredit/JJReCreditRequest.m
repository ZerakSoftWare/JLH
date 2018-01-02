//
//  JJReCreditRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/9/4.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJReCreditRequest.h"

@interface JJReCreditRequest ()
@property (nonatomic, copy) NSString *customerId;
@end

@implementation JJReCreditRequest
- (instancetype)initWithCustomerId:(NSString *)customerId
{
    if (self = [super init]) {
        self.customerId = customerId;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:JJReCreditUrl,self.customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodPost;
}

- (KZRequestSerializerType)requestSerializerType
{
    return KZRequestSerializerTypeJSON;
}

@end
