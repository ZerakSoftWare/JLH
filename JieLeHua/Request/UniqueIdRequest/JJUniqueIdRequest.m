//
//  JJUniqueIdRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJUniqueIdRequest.h"
#import <AdSupport/AdSupport.h>

@interface JJUniqueIdRequest ()

@end

@implementation JJUniqueIdRequest
- (instancetype)initWithCustomerId:(NSString *)customerId deviceId:(NSString *)deviceId
{
    if (self = [super init]) {
        NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        self.requestArgument = @{@"customerId":customerId,@"uuid":deviceId,@"idfa":advertisingId};
    }
    return self;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@",JJPostDeviceIdUrl];
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
