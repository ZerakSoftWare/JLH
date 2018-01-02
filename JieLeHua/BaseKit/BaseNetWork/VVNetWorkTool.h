//
//  XXNetWorkTool.h
//  XXCash
//
//  Created by 胡阳 on 16/3/11.
//  Copyright © 2016年 胡阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VVUploadParams ;

enum NetErrorType {
    NetErrorTypeRetryLogin=401,// 重新登陆
    NetErrorTypeRetryLoginToo=403,// 重新登陆
    NetErrorTypeServerMaintains=602, //服务器维护
    NetErrorTypeUpdatesMandatory=601 //强制更新
    
};

@interface VVNetWorkTool : NSObject

/**
 注册信息
 */
+ (NSURLSessionDataTask *)postRegeditInfo:(NSString *)URLString
                               parameters:(id)params
                                  success:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure;

/**
 *  发送GET请求
 *
 *  @param URLString 请求的url
 *  @param params    请求的参数
 *  @param success   成功的回调(响应结果为 result)
 *  @param failure   失败的回调(返回错误 error)
 */
+ (NSURLSessionDataTask *)get:(NSString *)URLString
 parameters:(id)params
    success:(void (^)(id result))success
    failure:(void (^)(NSError *error))failure ;

/**
 *  发送POST请求
 *
 *  @param URLString 请求的url
 *  @param body    请求数据流
 *  @param success   成功的回调(响应结果为 result)
 *  @param failure   失败的回调(返回错误 error)
 */
+ (NSURLSessionDataTask *)post:(NSString *)URLString
                          body:(NSData *)body
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  发送POST请求
 *
 *  @param URLString 请求的url
 *  @param params    请求的参数
 *  @param success   成功的回调(响应结果为 result)
 *  @param failure   失败的回调(返回错误 error)
 */
+ (NSURLSessionDataTask *)post:(NSString *)URLString
  parameters:(id)params
     success:(void (^)(id result))success
     failure:(void (^)(NSError *error))failure ;
/**
 *  发送DELETE请求
 *
 *  @param URLString 请求的url
 *  @param params    请求的参数
 *  @param success   成功的回调(响应结果为 result)
 *  @param failure   失败的回调(返回错误 error)
 *
 */
+ (NSURLSessionDataTask *)delete:(NSString *)URLString parameters:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (NSURLSessionDataTask *)postUnionpay:(NSString *)URLString
          parameters:(id)params
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure;

/**
 *  采用 "multipart"&"POST" 方式上传图片
 *
 *  @param URLString    请求的url
 *  @param params       非文件参数
 *  @param uploadParam  上传文件的参数
 *  @param success      成功的回调(响应结果为 result)
 *  @param failure      失败的回调(返回错误 error)
 */
+ (NSURLSessionDataTask *)upload:(NSString *)URLString
    parameters:(id)params
   uploadParam:(VVUploadParams *)uploadParam
       success:(void (^)(id result))success
       failure:(void (^)(NSError *error))failure ;


+(NSURLSessionDataTask *)postCreditOrMobileUrlStr:(NSString *)urlStr
                                       soapMessage:(NSString *)soapMessage
                                           success:(void (^)(id result))success
                                           failure:(void (^)(NSError *error))failure;

+ (NSURLSessionDataTask *)putWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void (^)(id result))success
           failure:(void (^)(NSError *error))failure;


@end
