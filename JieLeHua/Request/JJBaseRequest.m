//
//  JJBaseRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseRequest.h"
@interface JJBaseRequest()
@property (nonatomic, copy) NSString *url;
@property (nonatomic) KZRequestMethod method;
@end
@implementation JJBaseRequest
//dict 传参 url地址  method方法，默认POST
- (instancetype)initWithParamDic:(NSDictionary *)dict url:(NSString *)url method:(KZRequestMethod)method
{
    if (self == [super init]) {
        _parameters = dict ?: @{};
        _url = url;
        _method = method;
        self.requestArgument = _parameters;
    }
    return self;
}

- (NSString *)apiMethodName
{
    if (_url) {
        return _url;
    }
    return @"";
}

- (KZRequestMethod)requestMethod
{
    if (_method == KZRequestMethodGet) {
        return KZRequestMethodGet;
    }
    return KZRequestMethodPost;
}

- (NSDictionary *)requestHeaderValue
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
    [dict setObject:API_Version forKey:@"apiVersion"];
    [dict setObject:@"ios" forKey:@"deviceType"];
    [dict setObject:@"jielehua" forKey:@"product"];
#ifdef JIELEHUA
    [dict setObject:@"normal" forKey:@"source"];
#else
    [dict setObject:@"fastLoan" forKey:@"source"];
#endif
    [dict setObject:[VVUtils appVersion] forKey:@"apiClientVersion"];
    [dict setObject:VV_IS_NIL([UserModel currentUser].token)?@"":[UserModel currentUser].token forKey:@"accessToken"];
    return dict;
}

- (JJBaseResponseModel *)response
{
    JJBaseResponseModel *model = [JJBaseResponseModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}

- (id)responseToClass:(NSString *)className
{
    id class = [NSClassFromString(className) mj_objectWithKeyValues:self.responseJSONObject];
    return class;
}
@end
