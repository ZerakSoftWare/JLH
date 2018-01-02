//
//  KZNetworkingConfig.h
//  BubbleGum
//
//  Created by pingyandong on 16/5/6.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KZBaseRequest;
@class AFSecurityPolicy;
@protocol KZProcessProtocol <NSObject>

@optional

/**
 *  用于统一加工参数，返回处理后的参数值
 *
 *  @param argument 参数
 *  @param queryArgument query 信息，详情查看
 *
 *  @return 处理后的参数
 */
- (NSDictionary *)processArgumentWithRequest:(NSDictionary *)argument query:(NSDictionary *)queryArgument;
/**
 *  用于统一加工response，返回处理后response
 *
 *  @param response response
 *
 *  @return 处理后的response
 */
- (id)processResponseWithRequest:(id)response;
@end

@interface KZNetworkingConfig : NSObject
+ (KZNetworkingConfig *)sharedInstance;

@property (nonatomic, strong) NSString *mainBaseUrl;
@property (nonatomic, strong) NSString *viceBaseUrl;
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
@property (nonatomic, strong) id <KZProcessProtocol> processRule;


@end
