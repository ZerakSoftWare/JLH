//
//  JJMemberRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/12/22.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJMemberRequest.h"
@interface JJMemberRequest ()
@property(nonatomic,strong) NSString *customerId;
@end

@implementation JJMemberRequest
- (instancetype)initWithCustomerId:(NSString *)customerId
{
    if (self = [super init]) {
        self.customerId = customerId;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return  [NSString stringWithFormat:@"%@/%@",JJGetMemberFeeValidityPeriod,self.customerId];  
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJMemberModel *)response
{
    JJMemberModel *model = [JJMemberModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
