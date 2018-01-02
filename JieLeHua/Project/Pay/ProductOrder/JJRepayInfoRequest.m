//
//  JJRepayInfoRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/10.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJRepayInfoRequest.h"

@interface JJRepayInfoRequest()
@property(strong,nonatomic) NSString*type;
@end

@implementation JJRepayInfoRequest
- (instancetype)initWithType:(NSString *)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/draw/businessAmtInfo/%@/app",APP_BASE_URL,self.type];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJRepayInfoModel *)response
{
    JJRepayInfoModel *model = [JJRepayInfoModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
