//
//  KZBatchRequestAgent.m
//  BubbleGum
//
//  Created by pingyandong on 16/5/7.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "KZBatchRequestAgent.h"

@interface KZBatchRequestAgent ()
@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation KZBatchRequestAgent

+ (KZBatchRequestAgent *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addBatchRequest:(KZBatchRequest *)request
{
    @synchronized (_requestArray) {
        [_requestArray addObject:request];
    }
}

- (void)removeBatchRequest:(KZBatchRequest *)request
{
    @synchronized (_requestArray) {
        [_requestArray removeObject:request];
    }
}
@end
