//
//  KZNetworkingAgent.m
//  BubbleGum
//
//  Created by pingyandong on 16/5/6.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import "KZNetworkingAgent.h"
#import "KZNetworkingConfig.h"
#import "KZBaseRequest.h"
#import "AFNetworking.h"
#import "KZAFManager.h"
@interface KZNetworkingAgent ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *requestsRecord;
@property (nonatomic, strong) KZNetworkingConfig *config;
@end

@implementation KZNetworkingAgent
- (instancetype)init
{
    self = [super init];
    if (self) {
        _config = [KZNetworkingConfig sharedInstance];
        _requestsRecord = [NSMutableDictionary dictionary];
        KZAFManager *afManager = [KZAFManager sharedManager];
        _manager = afManager.manager;
        _manager.securityPolicy = _config.securityPolicy;
    }
    return self;
}

- (void)addRequest:(KZBaseRequest <KZApiRequest>*)request
{
    NSString *url = request.urlString;
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    serializer.removesKeysWithNullValues = YES;
    if ([request.child respondsToSelector:@selector(removesKeysWithNullValues)]) {
        serializer.removesKeysWithNullValues = [request.child removesKeysWithNullValues];
    }
    self.manager.responseSerializer = serializer;
    
    NSDictionary *argument = request.requestArgument;
    // 检查是否有统一的参数加工
    if (self.config.processRule && [self.config.processRule respondsToSelector:@selector(processArgumentWithRequest:query:)]) {
        argument = [self.config.processRule processArgumentWithRequest:request.requestArgument query:request.queryArgument];
    }
    
    if ([request.child respondsToSelector:@selector(requestSerializerType)]) {
        if ([request.child requestSerializerType] == KZRequestSerializerTypeHTTP) {
            self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
        else{
            self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
    }
    if ([request.child respondsToSelector:@selector(requestHeaderValue)]) {
        NSDictionary<NSString *, NSString *> *headerValue = [request.child requestHeaderValue];
        if ([headerValue isKindOfClass:[NSDictionary class]]){
            [headerValue enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
            }];
        }
    }
    else{
        [self.manager.requestSerializer clearAuthorizationHeader];
    }

    // 是否使用自定义超时时间
    if ([request.child respondsToSelector:@selector(requestTimeoutInterval)]) {
        self.manager.requestSerializer.timeoutInterval = [request.child requestTimeoutInterval];
    }else{
        //采用默认值
        self.manager.requestSerializer.timeoutInterval = Timeout;
    }
    
    if ([request.child respondsToSelector:@selector(isBase64Encode)]) {
        argument = nil;
        NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:argument error:nil];
        req.timeoutInterval= Timeout;
        NSString *body = [request.requestArgument mj_JSONString];
        [req setHTTPBody:[[body base64EncodedString] dataUsingEncoding:NSUTF8StringEncoding] ];
        
        request.sessionDataTask = [self.manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            request.responseJSONObject = responseObject;
           if (!error) {
               VVLog(@"%@",responseObject);
               if (request.delegate != nil) {
                   [request.delegate requestFinished:request];
               }
               if (request.successCompletionBlock) {
                   request.successCompletionBlock(request);
               }
           }else{
               VVLog(@"%@",error);
               if (request.delegate != nil) {
                   [request.delegate requestFailed:request error:error];
               }
               if (request.failureCompletionBlock) {
                   request.failureCompletionBlock(request,error);
               }

           }
        }];
        [self addOperation:request];
        [request.sessionDataTask resume];
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    if ([request.child requestMethod] == KZRequestMethodGet) {
        request.sessionDataTask = [self.manager GET:url parameters:argument progress:^(NSProgress * _Nonnull downloadProgress) {
            [weakSelf handleRequestProgress:downloadProgress request:request];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([[responseObject safeObjectForKey:@"code"] integerValue]== 401)
            {
                NSNotification *notification = [NSNotification notificationWithName:JJToken_Failure object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
            }
            else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeUpdatesMandatory)
            {
                [VVAlertUtils showAlertViewWithTitle:@"发现新版本" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"立即更新" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    [alertView removeAllAlert];
                    if (VV_CANOPENURL(responseObject[@"url"])) {
                        VV_OPENURL(responseObject[@"url"]);
                    }
                }];
                return ;
            }
            else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeServerMaintains)
            {
                NSNotification *notification = [NSNotification notificationWithName:JJServiceOut object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                
//                [VVAlertUtils showAlertViewWithTitle:@"提示" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                    [alertView removeAllAlert];
//                }];
                
                request.responseJSONObject = nil;
                [self handleRequestSuccess:task];
                return ;
            }
            
            request.responseJSONObject = responseObject;
            [weakSelf handleRequestSuccess:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleRequestFailed:task error:error];
        }];
    }
    else if ([request.child requestMethod] == KZRequestMethodPost){
        if ([request.child respondsToSelector:@selector(constructingBodyBlock)] && [request.child constructingBodyBlock]) {
            request.sessionDataTask = [self.manager POST:url parameters:argument constructingBodyWithBlock:[request.child constructingBodyBlock] progress:^(NSProgress * _Nonnull uploadProgress) {
                [self handleRequestProgress:uploadProgress request:request];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([[responseObject safeObjectForKey:@"code"] integerValue]== 401)
                {
                    NSNotification *notification = [NSNotification notificationWithName:JJToken_Failure object:responseObject];
                    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                               postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                }
                else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeUpdatesMandatory)
                {
                    [VVAlertUtils showAlertViewWithTitle:@"发现新版本" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"立即更新" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                        [alertView removeAllAlert];
                        if (VV_CANOPENURL(responseObject[@"url"])) {
                            VV_OPENURL(responseObject[@"url"]);
                        }
                    }];
                }else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeServerMaintains)
                {
                    NSNotification *notification = [NSNotification notificationWithName:JJServiceOut object:responseObject];
                    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                               postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                    
//                    [VVAlertUtils showAlertViewWithTitle:@"提示" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                        [alertView removeAllAlert];
//                    }];
                    request.responseJSONObject = nil;
                    [self handleRequestSuccess:task];
                    return ;
                }
                
                request.responseJSONObject = responseObject;
                [self handleRequestSuccess:task];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestFailed:task error:error];
            }];
        }else{
            request.sessionDataTask = [self.manager POST:url parameters:argument progress:^(NSProgress * _Nonnull uploadProgress) {
                [self handleRequestProgress:uploadProgress request:request];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([[responseObject safeObjectForKey:@"code"] integerValue] == 401)
                {
                    NSNotification *notification = [NSNotification notificationWithName:JJToken_Failure object:responseObject];
                    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                               postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                }
                else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeUpdatesMandatory)
                {
                    [VVAlertUtils showAlertViewWithTitle:@"发现新版本" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"立即更新" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                        [alertView removeAllAlert];
                        if (VV_CANOPENURL(responseObject[@"url"])) {
                            VV_OPENURL(responseObject[@"url"]);
                        }
                    }];
                }
                else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeServerMaintains)
                {
                    NSNotification *notification = [NSNotification notificationWithName:JJServiceOut object:responseObject];
                    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                               postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                    
//                    [VVAlertUtils showAlertViewWithTitle:@"提示" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                        [alertView removeAllAlert];
//                    }];
                    
                    request.responseJSONObject = nil;
                    [self handleRequestSuccess:task];
                    return ;
                }
                request.responseJSONObject = responseObject;
                [self handleRequestSuccess:task];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleRequestFailed:task error:error];
            }];
        }
    }
    else if ([request.child requestMethod] == KZRequestMethodHead){
        request.sessionDataTask = [self.manager HEAD:url parameters:argument success:^(NSURLSessionDataTask * _Nonnull task) {
            [self handleRequestSuccess:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequestFailed:task error:error];
        }];
    }
    else if ([request.child requestMethod] == KZRequestMethodPut){
        request.sessionDataTask = [self.manager PUT:url parameters:argument success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([[responseObject safeObjectForKey:@"code"] integerValue] == 401)
            {
                NSNotification *notification = [NSNotification notificationWithName:JJToken_Failure object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
            }
            else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeUpdatesMandatory)
            {
                [VVAlertUtils showAlertViewWithTitle:@"发现新版本" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"立即更新" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    [alertView removeAllAlert];
                    if (VV_CANOPENURL(responseObject[@"url"])) {
                        VV_OPENURL(responseObject[@"url"]);
                    }
                }];
            }
            else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeServerMaintains)
            {
                NSNotification *notification = [NSNotification notificationWithName:JJServiceOut object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                
//                [VVAlertUtils showAlertViewWithTitle:@"提示" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                    [alertView removeAllAlert];
//                }];
                
                request.responseJSONObject = nil;
                [self handleRequestSuccess:task];
                return ;
            }
            
            request.responseJSONObject = responseObject;
            [self handleRequestSuccess:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequestFailed:task error:error];
        }];
    }
    else if ([request.child requestMethod] == KZRequestMethodDelete){
        request.sessionDataTask = [self.manager DELETE:url parameters:argument success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([[responseObject safeObjectForKey:@"code"] integerValue] == 401)
            {
                NSNotification *notification = [NSNotification notificationWithName:JJToken_Failure object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
            }
            else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeUpdatesMandatory)
            {
                [VVAlertUtils showAlertViewWithTitle:@"发现新版本" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"立即更新" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    [alertView removeAllAlert];
                    if (VV_CANOPENURL(responseObject[@"url"])) {
                        VV_OPENURL(responseObject[@"url"]);
                    }
                }];
            }else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeServerMaintains)
            {
                NSNotification *notification = [NSNotification notificationWithName:JJServiceOut object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                
//                [VVAlertUtils showAlertViewWithTitle:@"提示" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                    [alertView removeAllAlert];
//                }];
                
                request.responseJSONObject = nil;
                [self handleRequestSuccess:task];
                return ;
            }
            
            request.responseJSONObject = responseObject;
            [self handleRequestSuccess:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequestFailed:task error:error];
        }];
    }
    else if ([request.child requestMethod] == KZRequestMethodPatch) {
        request.sessionDataTask = [self.manager PATCH:url parameters:argument success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([[responseObject safeObjectForKey:@"code"] integerValue] == 401)
            {
                NSNotification *notification = [NSNotification notificationWithName:JJToken_Failure object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
            }
            else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeUpdatesMandatory)
            {
                [VVAlertUtils showAlertViewWithTitle:@"发现新版本" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"立即更新" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    [alertView removeAllAlert];
                    if (VV_CANOPENURL(responseObject[@"url"])) {
                        VV_OPENURL(responseObject[@"url"]);
                    }
                }];
            }else if ([[responseObject safeObjectForKey:@"code"] integerValue] == NetErrorTypeServerMaintains)
            {
                NSNotification *notification = [NSNotification notificationWithName:JJServiceOut object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                
//                [VVAlertUtils showAlertViewWithTitle:@"提示" message:responseObject[@"message"] customView:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                    [alertView removeAllAlert];
//                }];
//                
                request.responseJSONObject = nil;
                [self handleRequestSuccess:task];
                return ;
            }
            
            request.responseJSONObject = responseObject;
            [self handleRequestSuccess:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequestFailed:task error:error];
        }];
    }
    [self addOperation:request];
}

- (void)handleRequestProgress:(NSProgress *)progress request:(KZBaseRequest *)request
{
    if ([request.delegate respondsToSelector:@selector(requsetProgress:)]) {
        [request.delegate requsetProgress:progress];
    }
    if (request.progressBlock) {
        request.progressBlock(progress);
    }
}

- (void)handleRequestSuccess:(NSURLSessionDataTask *)sessionDataTask
{
    NSString *key = [self keyForRequest:sessionDataTask];
    KZBaseRequest *request = _requestsRecord[key];
    if (request) {
        [request toggleAccessoriesWillStopCallBack];
        // 更新缓存
        if (([request.child respondsToSelector:@selector(cacheResponse)] && [request.child cacheResponse])) {
            //根据method parameters account来缓存数据
            NSString *customerId = [UserModel currentUser].customerId;
            NSString *method = [request.child apiMethodName];
            NSString *fileName = [NSString stringWithFormat:@"%@_%@.plist",customerId,[method md5]];
            
            NSString *responsePath = [[VVPathUtils cacheResponsePlist] stringByAppendingPathComponent:fileName];
            NSDictionary *response = request.responseJSONObject;
            [response writeToFile:responsePath atomically:YES];
        }
        
        if (request.delegate != nil) {
            [request.delegate requestFinished:request];
        }
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
        [request toggleAccessoriesDidStopCallBack];
        
    }
    
    [self removeOperation:sessionDataTask];
    [request clearCompletionBlock];
}

- (void)handleRequestFailed:(NSURLSessionDataTask *)sessionDataTask error:(NSError *)error
{
    NSString *key = [self keyForRequest:sessionDataTask];
    KZBaseRequest *request = _requestsRecord[key];
    if (request) {
        NSLog(@"网络异常================%@",request.urlString);
//        [MBProgressHUD showError:@"网络连接失败"];
        if ([request.child respondsToSelector:@selector(failHudTipString)]) {
            [MBProgressHUD showError:[request.child failHudTipString]];
        }else{
            //默认
             [MBProgressHUD showError:@"操作失败,请稍后重试"];
        }
        if ([request.child respondsToSelector:@selector(cacheRequest)] && [request.child cacheRequest]) {
            
        }
        if ([request.child respondsToSelector:@selector(constructingBodyBlock)] && [request.child constructingBodyBlock]) {

        }
        
        [request toggleAccessoriesWillStopCallBack];
        if (request.delegate != nil) {
            [request.delegate requestFailed:request error:error];
        }
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request, error);
        }
        [request toggleAccessoriesDidStopCallBack];
    }
    [self removeOperation:sessionDataTask];
    [request clearCompletionBlock];

}


- (void)cancelRequest:(KZBaseRequest *)request {
    [request.sessionDataTask cancel];
    [self removeOperation:request.sessionDataTask];
    [request clearCompletionBlock];
}


- (void)removeOperation:(NSURLSessionDataTask *)operation {
    NSString *key = [self keyForRequest:operation];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
    }
}

- (void)addOperation:(KZBaseRequest *)request {
    if (request.sessionDataTask != nil) {
        NSString *key = [self keyForRequest:request.sessionDataTask];
        @synchronized(self) {
            self.requestsRecord[key] = request;
        }
    }
}

- (NSString *)keyForRequest:(NSURLSessionDataTask *)object {
    NSString *key = [@(object.taskIdentifier) stringValue];
    return key;
}
@end
