//
//  KZBatchRequest.m
//  BubbleGum
//
//  Created by pingyandong on 16/5/7.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "KZBatchRequest.h"
#import "KZBaseRequest.h"
#import "KZBatchRequestAgent.h"

@interface KZBatchRequest ()<KZBaseRequestDelegate>
@property (nonatomic) NSInteger finishedCount;
@property (nonatomic, copy) NSArray *requestArray;
@end

@implementation KZBatchRequest
- (id)initWithRequestArray:(NSArray *)requestArray;
{
    self = [super init];
    if (self) {
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        for (KZBatchRequest *req in _requestArray) {
            if (![req isKindOfClass:[KZBatchRequest class]]) {
                NSLog(@"Error,request must be KZBatchRequest class");
                return nil;
            }
        }
    }
    return self;
}

- (void)start
{
    if (_finishedCount > 0) {
        NSLog(@"Error! Batch request has already started.");
        return;
    }
    [[KZBatchRequestAgent sharedInstance] addBatchRequest:self];
    [self toggleAccessoriesWillStartCallBack];
    for (KZBaseRequest *req in _requestArray) {
        req.delegate = self;
        [req start];
    }
}

- (void)stop
{
    [self toggleAccessoriesWillStopCallBack];
    _delegate = nil;
    [self clearRequest];
    [self toggleAccessoriesDidStopCallBack];
    self.requestArray = nil;
    [[KZBatchRequestAgent sharedInstance] removeBatchRequest:self];
}

- (void)requestDidStop{
    [self clearCompletionBlock];
    [self toggleAccessoriesDidStopCallBack];
    self.finishedCount = 0;
    self.requestArray = nil;
    [[KZBatchRequestAgent sharedInstance] removeBatchRequest:self];
}

- (void)startWithBlockSuccess:(void (^)(KZBatchRequest *request))success
                      failure:(void (^)(KZBatchRequest *request))failure{
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(KZBatchRequest *batchRequest))success
                              failure:(void (^)(KZBatchRequest *batchRequest))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (void)dealloc
{
    [self clearCompletionBlock];
}

- (void)clearRequest {
    for (KZBaseRequest * req in _requestArray) {
        [req stop];
    }
    [self clearCompletionBlock];
    self.finishedCount = 0;
}

#pragma mark - Network Request Delegate
- (void)requestFinished:(KZBaseRequest *)request {
    _finishedCount++;
    if (_finishedCount == _requestArray.count) {
        [self toggleAccessoriesWillStopCallBack];
        if ([_delegate respondsToSelector:@selector(batchRequestFinished:)]) {
            [_delegate batchRequestFinished:self];
        }
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [self requestDidStop];
    }
}

- (void)requestFailed:(KZBaseRequest *)request error:(NSError *)error{
    [self toggleAccessoriesWillStopCallBack];
    for (KZBaseRequest *req in _requestArray) {
        [req stop];
    }
    if ([_delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        [_delegate batchRequestFailed:self];
    }
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self);
    }
    [self requestDidStop];
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<KZRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}


@end

@implementation KZBatchRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack {
    if (self.invalidAccessory == NO) {
        for (id<KZRequestAccessory> accessory in self.requestAccessories) {
            if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
                [accessory requestWillStart:self];
            }
        }
    }
}

- (void)toggleAccessoriesWillStopCallBack {
    if (self.invalidAccessory == NO) {
        for (id<KZRequestAccessory> accessory in self.requestAccessories) {
            if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
                [accessory requestWillStop:self];
            }
        }
    }
}

- (void)toggleAccessoriesDidStopCallBack {
    if (self.invalidAccessory == NO) {
        for (id<KZRequestAccessory> accessory in self.requestAccessories) {
            if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
                [accessory requestDidStop:self];
            }
        }
    }
}

@end

