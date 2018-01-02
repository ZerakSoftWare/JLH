//
//  KZBaseRequest.m
//  BubbleGum
//
//  Created by pingyandong on 16/5/6.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "KZBaseRequest.h"
#import "AFNetworking.h"
#import "KZNetworkingAgent.h"
#import "KZNetworkingConfig.h"

@implementation KZBaseRequest (RequestAccessory)

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

@interface KZBaseRequest ()
@property (nonatomic, strong) id cacheJson;
@property (nonatomic, weak) id<KZApiRequest> child;
@property (nonatomic, strong) NSMutableArray *requestAccessories;
@property (nonatomic, strong) KZNetworkingConfig *config;
@property (nonatomic, strong) KZNetworkingAgent *agent;
@end


@implementation KZBaseRequest
MJExtensionCodingImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(KZApiRequest)]) {
            _child = (id<KZApiRequest>)self;
        }else{
            NSAssert(NO, @"子类必须实现这个KZApiRequest");
        }
        _config = [KZNetworkingConfig sharedInstance];
        _agent = [[KZNetworkingAgent alloc] init];
    }
    return self;
}

- (void)start{
    [self toggleAccessoriesWillStartCallBack];
    [self.agent addRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(KZRequestCompletionBlock)success
                                    failure:(KZRequestFailedBlock)failure{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [self start];
}

- (void)startWithBlockSuccess:(KZRequestCompletionBlock)success
                      failure:(KZRequestFailedBlock)failure{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [self start];
}

- (void)startWithBlockProgress:(void (^)(NSProgress *))progress
                       success:(KZRequestCompletionBlock)success
                       failure:(KZRequestFailedBlock)failure{
    self.progressBlock = progress;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [self start];
}


- (id)responseJSONObject{
    id responseJSONObject = nil;
    // 统一加工response
    if (self.config.processRule && [self.config.processRule respondsToSelector:@selector(processResponseWithRequest:)]) {
        if (([self.child respondsToSelector:@selector(ignoreUnifiedResponseProcess)] && ![self.child ignoreUnifiedResponseProcess]) ||
            ![self.child respondsToSelector:@selector(ignoreUnifiedResponseProcess)]) {
            responseJSONObject = [self.config.processRule processResponseWithRequest:_responseJSONObject];
            if ([self.child respondsToSelector:@selector(responseProcess:)]){
                responseJSONObject = [self.child responseProcess:responseJSONObject];
            }
            return responseJSONObject;
        }
    }
    
    if ([self.child respondsToSelector:@selector(responseProcess:)]){
        responseJSONObject = [self.child responseProcess:_responseJSONObject];
        return responseJSONObject;
    }
    return _responseJSONObject;
}

- (id)rawJSONObject{
    return _responseJSONObject;
}

- (NSString *)urlString{
    NSString *baseUrl = nil;
    if ([self.child respondsToSelector:@selector(useViceUrl)] && [self.child useViceUrl]){
        baseUrl = self.config.viceBaseUrl;
    }
    else{
        baseUrl = self.config.mainBaseUrl;
    }
    if (baseUrl) {
        if ( [self.child respondsToSelector:@selector(useCustomApiMethodName)] && [self.child useCustomApiMethodName]) {
            return [self.child apiMethodName];
        }
        NSString *urlString = [baseUrl stringByAppendingString:[self.child apiMethodName]];
        if (self.queryArgument && [self.queryArgument isKindOfClass:[NSDictionary class]]) {
            return [urlString stringByAppendingString:[self urlStringForQuery]];
        }
        return urlString;
    }
    return [self.child apiMethodName];
}



- (void)stop{
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [self.agent cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (void)clearCompletionBlock {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    self.progressBlock = nil;
}


- (NSString *)urlStringForQuery{
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:@"?"];
    [self.queryArgument enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [urlString appendFormat:@"%@=%@&", key, obj];
    }];
    [urlString deleteCharactersInRange:NSMakeRange(urlString.length - 1, 1)];
    return [urlString copy];
}


#pragma mark - Request Accessoies

- (void)addAccessory:(id<KZRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}
@end

