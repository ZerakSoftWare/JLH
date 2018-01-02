//
//  JJFourElementbankRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/7/13.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJFourElementbankRequest.h"

@implementation JJFourElementbankRequest
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(NSString *)apiMethodName{
    return JJFourElementBankCardUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

-(JJFourElementBankCardModel *)response{
    return [JJFourElementBankCardModel mj_objectWithKeyValues:self.responseJSONObject];
}
@end
