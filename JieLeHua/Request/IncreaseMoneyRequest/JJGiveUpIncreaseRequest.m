//
//  JJGiveUpIncreaseRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/8/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGiveUpIncreaseRequest.h"

@interface JJGiveUpIncreaseRequest ()
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *busType;
@end

@implementation JJGiveUpIncreaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId busType:(NSString *)busType
{
    if (self = [super init]) {
        self.customerId = customerId;
        self.busType = busType;
    }
    return self;
}


- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/%@/%@",JJGiveUpIncreaseUrl,self.customerId,self.busType];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

@end
