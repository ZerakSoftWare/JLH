//
//  KZAFManager.m
//  JieLeHua
//
//  Created by pingyandong on 2017/5/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "KZAFManager.h"

@implementation KZAFManager
+ (KZAFManager *)sharedManager
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
#if DEBUG
        _manager = [AFHTTPSessionManager manager];
//        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//        conf.connectionProxyDictionary = @{};
//        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:conf];
#else
        //避免抓包
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        conf.connectionProxyDictionary = @{};
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:conf];
#endif
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}
@end
