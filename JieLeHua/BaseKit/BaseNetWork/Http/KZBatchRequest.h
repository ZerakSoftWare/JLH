//
//  KZBatchRequest.h
//  BubbleGum
//
//  Created by pingyandong on 16/5/7.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZBaseRequest.h"

@class KZBatchRequest;
@protocol KZBatchRequestDelegate <NSObject>

- (void)batchRequestFinished:(KZBatchRequest *)batchRequest;

- (void)batchRequestFailed:(KZBatchRequest *)batchRequest;

@end
@interface KZBatchRequest : NSObject
/**
 *  是否不执行插件，默认是 NO, 也就是说当添加了插件默认是执行，比如有时候需要隐藏HUD
 */
@property (nonatomic, assign) BOOL invalidAccessory;
@property (nonatomic, strong, readonly) NSArray *requestArray;
@property (nonatomic, copy) void (^successCompletionBlock)(KZBatchRequest *);
@property (nonatomic, copy) void (^failureCompletionBlock)(KZBatchRequest *);
@property (nonatomic, weak) id<KZBatchRequestDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *requestAccessories;

- (id)initWithRequestArray:(NSArray<KZBaseRequest *> *)requestArray;

/*
 * 开始batch请求
 */
- (void)start;

/**
 *  暂停
 */
- (void)stop;

/**
 *  block回调方式
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)startWithBlockSuccess:(void (^)(KZBatchRequest *request))success
                      failure:(void (^)(KZBatchRequest *request))failure;



- (void)clearCompletionBlock;

- (void)addAccessory:(id<KZRequestAccessory>)accessory;

@end


@interface KZBatchRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end


