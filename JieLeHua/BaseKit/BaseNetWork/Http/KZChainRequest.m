//
//  KZChainRequest.m
//  BubbleGum
//
//  Created by pingyandong on 16/5/7.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "KZChainRequest.h"
#import "KZChainRequestAgent.h"

@interface KZChainRequest ()<KZBaseRequestDelegate>
@property (nonatomic, strong) NSMutableArray *requestArray;
@property (nonatomic, strong) NSMutableArray *requestCallbackArray;
@property (nonatomic, assign) NSUInteger nextRequestIndex;
@property (nonatomic, strong) KZChainCallback emptyCallback;
@end


@implementation KZChainRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
        _requestAccessories = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _emptyCallback = ^(KZChainRequest *chainRequest,KZBaseRequest *baseRequest){
            
        };
    }
    return self;
}

- (void)start {
    if(_nextRequestIndex >0){
        NSLog(@"Error!has already start");
        return;
    }
    if ([_requestArray count] > 0) {
        [self toggleAccessoriesWillStartCallBack];
        [self startNextRequest];
        [[KZChainRequestAgent sharedInstance] addChainRequst:self];
    }else{
        NSLog(@"Empty chainRequest!");
    }
}

- (NSArray *)requestArray
{
    return [self.requestArray copy];
}

- (void)stop
{
    [self toggleAccessoriesWillStopCallBack];
    [self clearRequest];
    [[KZChainRequestAgent sharedInstance] removeChainRequset:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (void)requestDidStop
{
    [self toggleAccessoriesDidStopCallBack];
    [self clearRequest];
    [[KZChainRequestAgent sharedInstance] removeChainRequset:self];
}

- (void)addRequest:(KZBaseRequest *)request callback:(KZChainCallback)callback {
    [_requestArray addObject:request];
    if (callback != nil) {
        [_requestCallbackArray addObject:callback];
    } else {
        [_requestCallbackArray addObject:_emptyCallback];
    }
}

- (BOOL)startNextRequest
{
    if (_nextRequestIndex < [_requestArray count]) {
        KZBaseRequest *request = _requestArray[_nextRequestIndex];
        _nextRequestIndex ++;
        request.delegate = self;
        [request start];
        return YES;
    }else{
        return NO;
    }
}

- (void)dealloc{
    [self clearRequest];
}

#pragma mark - Network Request Delegate

- (void)requestFinished:(KZBaseRequest *)request {
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    KZChainCallback callback = _requestCallbackArray[currentRequestIndex];
    callback(self, request);
    if ([self startNextRequest] == NO) {
        [self toggleAccessoriesWillStopCallBack];
        if ([_delegate respondsToSelector:@selector(chainRequestFinished:)]) {
            [_delegate chainRequestFinished:self];
        }
        [self requestDidStop];
    }
}

- (void)requestFailed:(KZBaseRequest *)request error:(NSError *)error{
    [self toggleAccessoriesWillStopCallBack];
    if ([_delegate respondsToSelector:@selector(chainRequestFailed:failedBaseRequest:)]) {
        [_delegate chainRequestFailed:self failedBaseRequest:request];
    }
    [self requestDidStop];
}

- (void)clearRequest
{
    NSUInteger currentRequestIndex = _nextRequestIndex -1;
    if (currentRequestIndex < [_requestArray count]) {
        KZBaseRequest *req = _requestArray[currentRequestIndex];
        [req stop];
    }
    [_requestArray removeAllObjects];
    [_requestCallbackArray removeAllObjects];
    self.nextRequestIndex = 0;
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<KZRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}
@end


@implementation KZChainRequest (RequestAccessory)

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

