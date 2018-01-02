//
//  JJBankCardRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBankCardRequest.h"

@implementation JJBankCardRequest
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)apiMethodName
{
    return JJBankCardUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJBankCardModel *)response
{
    JJBankCardModel *model = [JJBankCardModel mj_objectWithKeyValues:[self responseJSONObject]];
    return model;
}
@end
