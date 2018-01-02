//
//  JJWechatPayRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/10.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJWechatPayRequest.h"

@interface JJWechatPayRequest()
@property(strong,nonatomic) NSString*type;
@end

@implementation JJWechatPayRequest
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
    return [NSString stringWithFormat:@"%@/draw/confirmPay/%@",APP_BASE_URL,self.type];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJWechatPayModel *)response
{
    JJWechatPayModel *model = [JJWechatPayModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
