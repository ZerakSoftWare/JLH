//
//  KZBatchRequestAgent.h
//  BubbleGum
//
//  Created by pingyandong on 16/5/7.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KZBatchRequest;
@interface KZBatchRequestAgent : NSObject
+ (KZBatchRequestAgent *)sharedInstance;

- (void)addBatchRequest:(KZBatchRequest *)request;

- (void)removeBatchRequest:(KZBatchRequest *)request;
@end
