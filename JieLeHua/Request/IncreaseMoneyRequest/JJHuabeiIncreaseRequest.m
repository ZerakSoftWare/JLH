//
//  JJHuabeiIncreaseRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/8/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJHuabeiIncreaseRequest.h"

@implementation JJHuabeiIncreaseRequest

- (instancetype)initWithCustomerId:(NSString *)customerId
                  antsChantFlowers:(NSString *)antsChantFlowers
                            status:(NSString *)status
{
    if (self = [super init]) {
        self.requestArgument = @{
                                 @"customerId":customerId,
                                 @"antsChantFlowers":antsChantFlowers,
                                 @"antsChantFlowersCrawlerStatus":status
                                 };
        VVLog(@"%@",self.requestArgument);
    }
    return self;
}

- (NSString *)apiMethodName
{
    return JJIncreaseHuabeiUrl;
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
