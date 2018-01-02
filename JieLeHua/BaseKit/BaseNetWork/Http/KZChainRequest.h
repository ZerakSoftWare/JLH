//
//  KZChainRequest.h
//  BubbleGum
//
//  Created by pingyandong on 16/5/7.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZBaseRequest.h"

@class KZChainRequest;
@protocol KZChainRequestDelegate <NSObject>

- (void)chainRequestFinished:(KZChainRequest *)chainRequest;

- (void)chainRequestFailed:(KZChainRequest *)chainRequest failedBaseRequest:(KZBaseRequest*)request;;

@end

typedef void(^KZChainCallback)(KZChainRequest *chainRequest, __kindof KZBaseRequest *request);

@interface KZChainRequest : NSObject
/**
 *  是否不执行插件，默认是 NO, 也就是说当添加了插件默认是执行，比如有时候需要隐藏HUD
 */
@property (nonatomic, assign) BOOL invalidAccessory;
@property (nonatomic, weak) id<KZChainRequestDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *requestAccessories;

/**
 *  开始Chain请求
 */
- (void)start;

/**
 *  暂停Chain请求
 */
- (void)stop;

- (void)addRequest:(KZBaseRequest<KZApiRequest> *)request callback:(KZChainCallback)callback;

- (NSArray *)requestArray;

- (void)addAccessory:(id<KZRequestAccessory>)accessory;

@end


@interface KZChainRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end
