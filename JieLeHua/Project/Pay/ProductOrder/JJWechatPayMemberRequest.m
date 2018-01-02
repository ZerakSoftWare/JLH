//
//  JJWechatPayMemberRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/12/22.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJWechatPayMemberRequest.h"
#import "JJWechatPayModel.h"
@interface JJWechatPayMemberRequest()
@property(strong,nonatomic) NSString*type;
@end

@implementation JJWechatPayMemberRequest


- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/draw/memberWechatPay",APP_BASE_URL];
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
