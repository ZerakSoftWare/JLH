//
//  JJBaseRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "KZBaseRequest.h"
#import "JJBaseResponseModel.h"

@interface JJBaseRequest : KZBaseRequest<KZApiRequest>
@property (nonatomic, strong) NSDictionary *parameters;

//dict 传参 url地址  method方法，默认POST
- (instancetype)initWithParamDic:(NSDictionary *)dict url:(NSString *)url method:(KZRequestMethod)method;
- (id)responseToClass:(NSString *)className;

- (JJBaseResponseModel *)response;
@end
