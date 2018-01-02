//
//  KZChainRequestAgent.h
//  BubbleGum
//
//  Created by pingyandong on 16/5/7.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KZChainRequest;
@interface KZChainRequestAgent : NSObject
+ (KZChainRequestAgent *)sharedInstance;

- (void)addChainRequst:(KZChainRequest *)requset;

- (void)removeChainRequset:(KZChainRequest *)request;
@end
