//
//  KZBaseRequest.h
//  BubbleGum
//
//  Created by pingyandong on 16/5/6.
//  Copyright © 2016年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

@class KZBaseRequest;
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void(^KZRequestCompletionBlock)(__kindof KZBaseRequest *request);
typedef void(^KZRequestFailedBlock)(__kindof KZBaseRequest *request,NSError *error);

typedef NS_ENUM(NSInteger, KZRequestMethod)  {
    KZRequestMethodGet = 0,
    KZRequestMethodPost,
    KZRequestMethodHead,
    KZRequestMethodPut,
    KZRequestMethodDelete,
    KZRequestMethodPatch
};

typedef NS_ENUM (NSInteger, KZRequestSerializerType) {
    KZRequestSerializerTypeHTTP = 0,
    KZRequestSerializerTypeJSON,
};


@protocol KZApiRequest <NSObject>

@required

/**
 *  接口地址
 *
 *  @return 接口地址
 */
- (NSString *)apiMethodName;
/**
 *  请求方式，包括Get、Post、Head、Put、Delete、Patch，具体查看 KZRequestMethod
 *
 *  @return 请求方式
 */
- (KZRequestMethod)requestMethod;

@optional
/**
 *  可以使用两个根地址，比如可能会用到 CDN 地址、https之类的
 *
 *  @return 是否使用副Url
 */
- (BOOL)useViceUrl;

/**
 *  是否缓存数据 response 数据
 *
 *  @return 是否缓存数据 response 数据
 */
- (BOOL)cacheResponse;

/**
 *  是否缓存请求数据
 *
 *  @return 是否缓存数据 request 数据
 */
- (BOOL)cacheRequest;

/**
 *  自定义超时时间
 *
 *  @return 超时时间
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 *  multipart 数据,如果需要保存上传图片数据，可以在此写入本地
 *
 *  @return 用于 multipart 的数据block
 */
- (AFConstructingBlock)constructingBodyBlock;

/**
 *  上传图片的数组
 *
 *  @return 上传图片的数组，保存本地路径下的图片数组
 */
- (NSArray *)uploadImages;

/**
 *  处理responseJSONObject，当外部访问 self.responseJSONObject 的时候就会返回这个方法处理后的数据
 *
 *  @param responseObject 输入的 responseObject ，在方法内切勿使用 self.responseJSONObject
 *
 *  @return 处理后的responseJSONObject
 */
- (id)responseProcess:(id)responseObject;

/**
 *  是否忽略统一的参数加工
 *
 *  @return 返回 YES，那么 self.responseJSONObject 将返回原始的数据
 */
- (BOOL)ignoreUnifiedResponseProcess;

/**
 *  是否使用自定义的接口地址，也就是不会使用 mainBaseUrl 或 viceBaseUrl，这时候在 apiMethodName 就可以是用自定义的接口地址了
 *
 *  @return 是否使用自定义的接口地址
 */
- (BOOL)useCustomApiMethodName;

/**
 *  服务端数据接收类型，比如 KZRequestSerializerTypeJSON 用于 post json 数据
 *
 *  @return 服务端数据接收类型
 */
- (KZRequestSerializerType)requestSerializerType;


/**
 *  当数据返回 null 时是否删除这个字段的值，也就是为 nil，默认YES，具体查看http://honglu.me/2015/04/11/json%E4%B8%AD%E5%A4%B4%E7%96%BC%E7%9A%84null/
 *
 *  @return YES/NO
 */
- (BOOL)removesKeysWithNullValues;


/**
 *  添加请求 Header，比如返回@{@"Accept" : @"application/json"}，那么 application/json 对应的是 Value，Accept对应的是 HTTPHeaderField
 *
 *  @return NSDictionary
 */
- (NSDictionary *)requestHeaderValue;

/**
 * 失败提示语句
 * return NSString;
 */
- (NSString *)failHudTipString;

///参数是否base64加密
- (BOOL)isBase64Encode;
@end

@class KZBaseRequest;
@protocol KZBaseRequestDelegate <NSObject>

@optional
- (void)requestFinished:(KZBaseRequest *)request;
- (void)requestFailed:(KZBaseRequest *)request error:(NSError *)error;
- (void)requsetProgress:(NSProgress *)progress;

@end

@protocol KZRequestAccessory <NSObject>

@optional
- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

@interface KZBaseRequest : NSObject<NSCoding>

@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;
@property (nonatomic, strong) id requestArgument;

/**
 *  需要上传的图片数据
 */
@property (nonatomic, copy) NSArray *uploadImageDataArray;

/**
 *  用于 POST 情况下，拼接参数请求，而不是放在body里面
 */
@property (nonatomic, strong) NSDictionary<NSString *,NSString *> *queryArgument;

@property (nonatomic, weak) id<KZBaseRequestDelegate> delegate;
@property (nonatomic, weak, readonly) id<KZApiRequest> child;

/**
 *  当通过get方式访问 responseJSONObject 时就会得到加工后的数据
 */
@property (nonatomic, strong) id responseJSONObject;
/**
 *  接口返回的原始数据
 */
@property (nonatomic, strong, readonly) id rawJSONObject;
/**
 *  是否不执行插件，默认是 NO, 也就是说当添加了插件默认是执行，比如有时候需要隐藏HUD
 */
@property (nonatomic, assign) BOOL invalidAccessory;
@property (nonatomic, strong, readonly) id cacheJson;
@property (nonatomic, strong, readonly) NSString *urlString;
@property (nonatomic, strong, readonly) NSMutableArray *requestAccessories;
@property (nonatomic, copy) void (^successCompletionBlock)(KZBaseRequest *);
@property (nonatomic, copy) void (^failureCompletionBlock)(KZBaseRequest *, NSError *error);
@property (nonatomic, copy) void (^progressBlock)(NSProgress * progress);

/**
 *  开始请求，使用 detegate 方式使用这个方法
 */
- (void)start;

/**
 *  停止请求
 */
- (void)stop;


/**
 *  block回调方式
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)startWithBlockSuccess:(KZRequestCompletionBlock)success
                      failure:(KZRequestFailedBlock)failure;


/**
 *  block回调方式
 *
 *  @param progress 进度回调
 *  @param success  成功回调
 *  @param failure  失败回调
 */
- (void)startWithBlockProgress:(void (^)(NSProgress *progress))progress
                       success:(KZRequestCompletionBlock)success
                       failure:(KZRequestFailedBlock)failure;

/**
 *  一般用于显示和隐藏 HUD
 *
 *  @param accessory 插件
 */
- (void)addAccessory:(id<KZRequestAccessory>)accessory;
- (void)clearCompletionBlock;

@end
@interface KZBaseRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end
