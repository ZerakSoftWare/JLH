//
//  JJBeginApplyRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/5/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBeginApplyRequest.h"

@interface JJBeginApplyRequest ()
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *source;
@end

@implementation JJBeginApplyRequest
//versionSource:0 普通版 1 h5 2 急速';
- (instancetype)initWithCustomerId:(NSString *)customerId
                            source:(NSString *)source
{
    if (self = [super init]) {
        self.customerId = customerId;
        self.source = source;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return  [NSString stringWithFormat:@"%@/%@/%@",JJGetVersionSourceUrl,self.customerId,self.source];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

@end
