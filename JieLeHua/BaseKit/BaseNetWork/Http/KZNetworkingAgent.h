//
//  KZNetworkingAgent.h
//  BubbleGum
//
//  Created by pingyandong on 16/5/6.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KZBaseRequest;
@interface KZNetworkingAgent : NSObject
- (void)addRequest:(KZBaseRequest *)request;
- (void)cancelRequest:(KZBaseRequest *)request;

@end
