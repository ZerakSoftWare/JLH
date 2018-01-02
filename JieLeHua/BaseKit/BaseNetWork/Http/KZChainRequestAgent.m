//
//  KZChainRequestAgent.m
//  BubbleGum
//
//  Created by pingyandong on 16/5/7.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "KZChainRequestAgent.h"

@interface KZChainRequestAgent ()
@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation KZChainRequestAgent
+ (KZChainRequestAgent *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequst:(KZChainRequest *)requset
{
    @synchronized (_requestArray) {
        [_requestArray addObject:requset];
    }
}

- (void)removeChainRequset:(KZChainRequest *)request
{
    @synchronized (_requestArray) {
        [_requestArray removeObject:request];
    }
}

@end
