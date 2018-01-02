//
//  XXNetWorkTool.m
//  XXCash
//
//  Created by 胡阳 on 16/3/11.
//  Copyright © 2016年 胡阳. All rights reserved.
//

#import "VVNetWorkTool.h"
#import "VVUploadParams.h"
#import "VVDeviceUtils.h"

#define CreditOrMobileTimeout  180.0
#define OrdersPrereviewTimeout  300.0



@interface VVNetWorkTool ()

@property(nonatomic,assign)BOOL isLogin;
@end


@implementation VVNetWorkTool


+ (NSURLSessionDataTask *)get:(NSString *)URLString parameters:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if ([URLString rangeOfString:@"app/version"].length==0||[URLString rangeOfString:@"/IMToken"].length==0||[URLString rangeOfString:@"common/thirdparty/auth"].length == 0) {
        [[VVNetWorkUtility netUtility] cancelOperations];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
    manager.requestSerializer.timeoutInterval = Timeout;
    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    serializer.removesKeysWithNullValues = YES;
    manager.responseSerializer = serializer;
    
    [self.class setHttpHead:manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.class setCustomerSecurityPolicy:manager];
    
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    VVLog(@" GET \n url %@ \n params:%@",URLString,params);
    [self.class logRequestHeaderFields:URLString];

    NSURLSessionDataTask *task = [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        VVLog(@"成功结果 GET \n url: %@,\n responseObject:%@",URLString,responseObject);
        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
            success(respons);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error) ;
        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error.localizedDescription);
    }];
    
    return task;
}

+ (NSURLSessionDataTask *)post:(NSString *)URLString
                             body:(NSData *)body
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure
{
    [[VVNetWorkUtility netUtility] cancelOperations];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];

    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= Timeout;
    [req setHTTPBody:body];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            VVLog(@"成功结果 POST \n url: %@,\n responseObject:%@",URLString,responseObject);
            
            [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
                success(respons);
            }];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error) ;
            VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error);
        }
    }];
    
    [task resume];

//    NSURLSessionDataTask *task = [manager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFormData:body name:@"body"];
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        VVLog(@"成功结果 POST \n url: %@,\n responseObject:%@",URLString,responseObject);
//        
//        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
//            success(respons);
//        }];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        failure(error) ;
//        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error);
//
//    }];
//    
//    NSURLSessionDataTask *task = [manager POST:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        VVLog(@"成功结果 POST \n url: %@,\n responseObject:%@",URLString,responseObject);
//        
//        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
//            success(respons);
//        }];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        failure(error) ;
//        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error);
//        
//    }];
    return task;

}

+ (NSURLSessionDataTask *)post:(NSString *)URLString parameters:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [[VVNetWorkUtility netUtility] cancelOperations];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([URLString rangeOfString:@"prereview"].length>0) {//预审 超时300s
        manager.requestSerializer.timeoutInterval = OrdersPrereviewTimeout;
    }else{
        manager.requestSerializer.timeoutInterval = Timeout;
    }

    [self.class setHttpHead:manager];
    [self.class setCustomerSecurityPolicy:manager];
    
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    VVLog(@" POST \n url :%@ \n params:%@",URLString,params);
    [self.class logRequestHeaderFields:URLString];

    NSURLSessionDataTask *task = [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        VVLog(@"成功结果 POST \n url: %@,\n responseObject:%@",URLString,responseObject);
        
        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
            success(respons);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error) ;
        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error);

    }];
    return task;
}

+ (NSURLSessionDataTask *)putWithURL:(NSString *)URLString
                              params:(NSDictionary *)params
                             success:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure {
    [[VVNetWorkUtility netUtility] cancelOperations];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = Timeout;
    [manager.requestSerializer setValue:@"PUT" forHTTPHeaderField:@"_method"];
    [self.class setHttpHead:manager];
    [self.class setCustomerSecurityPolicy:manager];

    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    VVLog(@"PUT \n url %@ \n params:%@",URLString,[params mj_JSONString]);
    [self.class logRequestHeaderFields:URLString];

    NSURLSessionDataTask *task = [manager PUT:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        VVLog(@"成功结果 PUT \n url: %@,\n responseObject:%@",URLString,responseObject);
        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
            success(respons);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error) ;
    }];
    
    return task;
}


+ (NSURLSessionDataTask *)delete:(NSString *)URLString parameters:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [[VVNetWorkUtility netUtility] cancelOperations];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = Timeout;

    [self.class setHttpHead:manager];
    [self.class setCustomerSecurityPolicy:manager];

    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    VVLog(@" deleteApi \n url :%@ \n params:%@",URLString,params);
    [self.class logRequestHeaderFields:URLString];

    NSURLSessionDataTask *task = [manager DELETE:URLString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        VVLog(@"成功结果 DELETE \n url: %@,\n responseObject:%@",URLString,responseObject);
        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
            success(respons);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error) ;
        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error.localizedDescription);
        
    }];
    return task;
}

//征信  移动账单
+ (NSURLSessionDataTask *)postCreditOrMobileUrlStr:(NSString *)URLString
                                       soapMessage:(NSString *)soapMessage
                                           success:(void (^)(id result))success
                                           failure:(void (^)(NSError *error))failure{
    [[VVNetWorkUtility netUtility] cancelOperations];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc]init];
    if ([URLString rangeOfString:@"vbs/mobile"].length>0) {
        manager.requestSerializer.timeoutInterval = CreditOrMobileTimeout;
    }else{
        manager.requestSerializer.timeoutInterval = Timeout;
    }
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ;
    
    [manager.requestSerializer setValue:API_Version forHTTPHeaderField:@"apiVersion"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"JIELEHUA" forHTTPHeaderField:@"product"];
#ifdef JIELEHUA
    [manager.requestSerializer setValue:@"normal" forHTTPHeaderField:@"source"];
#else
    [manager.requestSerializer setValue:@"fastLoan" forHTTPHeaderField:@"source"];
#endif
    [manager.requestSerializer setValue:[VVUtils appVersion] forHTTPHeaderField:@"apiClientVersion"];

    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", @"text/javascript", nil];
    
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        
        return soapMessage;
        
    }];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    VVLog(@" 征信  移动账单 POST \n url %@ \n params:%@",URLString,[[soapMessage base64DecodedString] mj_JSONObject]);

    NSURLSessionDataTask *task = [manager POST:URLString parameters:soapMessage progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData *da = (NSData *)responseObject;
        NSString *result = [[NSString alloc] initWithData:da  encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [result mj_JSONObject];
        VVLog(@"成功结果  征信 移动 POST \n url: %@,\n responseObject:%@",URLString,dic);
        [VVNetWorkTool responseObjectResult:dic url:URLString success:^(id  _Nullable respons ) {
            success(respons);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error) ;
    }];
    
    return task;
}


/**
 注册信息
 */
+ (NSURLSessionDataTask *)postRegeditInfo:(NSString *)URLString
                               parameters:(id)params
                                  success:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure
{
    [[VVNetWorkUtility netUtility] cancelOperations];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = Timeout;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ;
    [manager.requestSerializer setValue:API_Version forHTTPHeaderField:@"apiVersion"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"JIELEHUA" forHTTPHeaderField:@"product"];
#ifdef JIELEHUA
    [manager.requestSerializer setValue:@"normal" forHTTPHeaderField:@"source"];
#else
    [manager.requestSerializer setValue:@"fastLoan" forHTTPHeaderField:@"source"];
#endif
    NSArray * versionCompatibility = [[VVUtils appVersion] componentsSeparatedByString:@"."];
    float total = 0;
    int pot = (int)versionCompatibility.count - 1;
    for (NSNumber * number in versionCompatibility)
    {
        total += number.intValue * powf(10, pot);
        pot--;
    }
    
    NSString *apiClientVersion = [NSString stringWithFormat:@"%f",total];
    
    [manager.requestSerializer setValue:apiClientVersion forHTTPHeaderField:@"apiClientVersion"];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8"forHTTPHeaderField:@"Content-Type"];//delete没有这个
    
    [manager.requestSerializer setValue:@"app_store" forHTTPHeaderField:@"appChannel"];
    
    NSString *postStr = @"";
    postStr = [VVDeviceUtils machineTypeMap];
    
    [manager.requestSerializer setValue:postStr forHTTPHeaderField:@"brand"];
    
    [manager.requestSerializer setValue:VV_IS_NIL([UserModel currentUser].token)?@"":[UserModel currentUser].token  forHTTPHeaderField:@"accessToken"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", @"text/javascript", nil];
    
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLSessionDataTask *task = [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
            success(respons);
        } ];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error) ;
        
    }];
    return task;
}

+ (NSURLSessionDataTask *)postUnionpay:(NSString *)URLString parameters:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [[VVNetWorkUtility netUtility] cancelOperations];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = Timeout;
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ;
    [manager.requestSerializer setValue:API_Version forHTTPHeaderField:@"apiVersion"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"JIELEHUA" forHTTPHeaderField:@"product"];
#ifdef JIELEHUA
    [manager.requestSerializer setValue:@"normal" forHTTPHeaderField:@"source"];
#else
    [manager.requestSerializer setValue:@"fastLoan" forHTTPHeaderField:@"source"];
#endif
    [manager.requestSerializer setValue:[VVUtils appVersion] forHTTPHeaderField:@"apiClientVersion"];

    [manager.requestSerializer setValue:VV_IS_NIL([UserModel currentUser].token)?@"":[UserModel currentUser].token  forHTTPHeaderField:@"accessToken"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", @"text/javascript", nil];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    VVLog(@"https 银联 POST \n url %@ \n params:%@",URLString,params);

    NSURLSessionDataTask *task = [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        VVLog(@"成功结果 postUnionpay \n url: %@,\n responseObject:%@",URLString,responseObject);
        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
            success(respons);
        } ];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error) ;
        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error);
        
    }];
    return task;
}

+ (NSURLSessionDataTask *)upload:(NSString *)URLString parameters:(id)params uploadParam:(VVUploadParams *)uploadParam success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [[VVNetWorkUtility netUtility] cancelOperations];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [self getHTTPRequestManager] ;
    manager.requestSerializer.timeoutInterval = CreditOrMobileTimeout;
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    VVLog(@" UPLOAD \n url %@ \n params:%@",URLString,params);
    
    NSURLSessionDataTask *task = [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data
                                    name:uploadParam.name
                                fileName:uploadParam.fileName
                                mimeType:uploadParam.mineType];
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        VVLog(@"成功结果 UPLOAD  \n url: %@,\n responseObject:%@",URLString,responseObject);
        [VVNetWorkTool responseObjectResult:responseObject url:URLString success:^(id  _Nullable respons ) {
            success(respons);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        VVLog(@"错误结果 URL：%@ \n ERROR:%@",URLString,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failure(error) ;
    }];

    return task;
}


+ (void)responseObjectResult:(NSDictionary *)responseObject url:(NSString*)URLString success:(void (^)(id))success{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    switch ([[responseObject safeObjectForKey:@"code"] integerValue]) {
        case NetErrorTypeRetryLogin:
        case NetErrorTypeRetryLoginToo:
        {
            if ([URLString rangeOfString:@"security/login"].length>0) {
                success(responseObject) ;
            }else{
//                [VV_NC postNotificationName:JJToken_Failure object:responseObject];
                NSNotification *notification = [NSNotification notificationWithName:JJToken_Failure object:responseObject];
                [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                           postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
                success(nil) ;
            }
        }
            break;
        case NetErrorTypeServerMaintains:
        {
            NSNotification *notification = [NSNotification notificationWithName:JJServiceOut object:responseObject];
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                       postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
//            NSDictionary *infoDic = responseObject;
//            [VVAlertUtils showAlertViewWithTitle:@"提示" message:infoDic[@"message"] customView:nil cancelButtonTitle:@"好的" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                [alertView removeAllAlert];
//            }];
            success(nil) ;
        }
            break;
        case NetErrorTypeUpdatesMandatory:
        {
            NSDictionary *infoDic = responseObject;
            [VVAlertUtils showAlertViewWithTitle:@"发现新版本" message:infoDic[@"message"] customView:nil cancelButtonTitle:@"立即更新" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                [alertView removeAllAlert];
                if (VV_CANOPENURL(infoDic[@"url"])) {
                    VV_OPENURL(infoDic[@"url"]);
                }
            }];

            success(nil) ;
        }
            break;
            
        default:{
            success(responseObject) ;
        }
            break;
    }
}

+ (AFHTTPSessionManager *)getHTTPRequestManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
    manager.requestSerializer.timeoutInterval = Timeout;
    
    [self.class setHttpHead:manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self.class setCustomerSecurityPolicy:manager];
    
    return manager ;
}

+ (void)setHttpHead:(AFHTTPSessionManager*)manager{
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;application/json; charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:API_Version forHTTPHeaderField:@"apiVersion"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"deviceType"];
    [manager.requestSerializer setValue:@"JIELEHUA" forHTTPHeaderField:@"product"];
#ifdef JIELEHUA
    [manager.requestSerializer setValue:@"normal" forHTTPHeaderField:@"source"];
#else
    [manager.requestSerializer setValue:@"fastLoan" forHTTPHeaderField:@"source"];
#endif
    [manager.requestSerializer setValue:[VVUtils appVersion] forHTTPHeaderField:@"apiClientVersion"];

    [manager.requestSerializer setValue:VV_IS_NIL([UserModel currentUser].token)?@"":[UserModel currentUser].token  forHTTPHeaderField:@"accessToken"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json",@"application/json", @"text/javascript", nil];//delete没有这个
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8"forHTTPHeaderField:@"Content-Type"];//delete没有这个
    
    VVLog(@"accessToken===%@",[UserModel currentUser].token);

}

+ (void)setCustomerSecurityPolicy:(AFHTTPSessionManager*)manager{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone] ;
}
//查看http header
+ (void)logRequestHeaderFields:(NSString*)URLString{
    
//#ifdef  VV_BUILD_FOR_DEVELOP
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
//    NSHTTPURLResponse *response;
//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
//    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        //          VVLog(@"NSURLConnection = %@",data);
//    }];
//    
//    NSDictionary *headers = [response allHeaderFields];
//    VVLog(@"headers = %@",headers);
//#endif
    
    }
@end
