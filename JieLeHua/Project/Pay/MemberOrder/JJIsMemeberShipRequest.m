//
//  JJIsMemeberShipRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/12/24.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJIsMemeberShipRequest.h"
@interface JJIsMemeberShipRequest ()
@property(nonatomic,strong) NSString *customerId;
@end

@implementation JJIsMemeberShipRequest
- (instancetype)initWithCustomerId:(NSString *)customerId
{
    if (self = [super init]) {
        self.customerId = customerId;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return  [NSString stringWithFormat:@"%@/%@",JJGetIsMemberShip,self.customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJIsMemeberSHipModel *)response
{
    JJIsMemeberSHipModel *model = [JJIsMemeberSHipModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end

