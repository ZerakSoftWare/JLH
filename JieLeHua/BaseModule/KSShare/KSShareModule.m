//
//  KSShareModule.m
//  KSKit
//
//  Created by pingyandong on 2016/11/29.
//  Copyright © 2016年 Kingsum. All rights reserved.
//

#import "KSShareModule.h"
#import <UMSocialCore/UMSocialCore.h>
#import "KSShareConfigManager.h"

#import "UPPaymentControl.h"
#import "JJUnionPayViewController.h"
#import <CommonCrypto/CommonDigest.h>

#import "PayToolsManager.h"

@implementation KSShareModule
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@  Timeline", NSStringFromSelector(_cmd));
    //友盟分享
    KSShareConfigManager *KSShareConfig=[KSShareConfigManager sharedInstance];
    KSShareConfig.shareAppKey=kUM_ClickAppKey;
    KSShareConfig.shareLogEnabled=NO;
    //设置平台
    [KSShareConfig setPlaform:KSSocialPlatConfigType_Tencent appKey:@"1106020795" appSecret:@"Vtgw1OCUe43ZZ8U2" redirectURL:@"http://www.umeng.com/social"];
    [KSShareConfig setPlaform:KSSocialPlatConfigType_Wechat appKey:@"wxdcb86af17b41faab" appSecret:@"41ba7f2ce5c29b58d3b7c15d5f886371" redirectURL:@"http://www.umeng.com/social"];
//    [KSShareConfig setPlaform:KSSocialPlatConfigType_Sina appKey:@"3921700954" appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    
    //打开日志
    if (KSShareConfigManagerInstance.isLogEnabled) {
        [[UMSocialManager defaultManager]
#if DEBUG
         openLog:YES];
#else
        openLog:NO];
#endif
    }
    
    //设置Key
    NSAssert(KSShareConfigManagerInstance.shareAppKey, @"umeng分享的key不能为空");
    if (KSShareConfigManagerInstance.shareAppKey) {
        //设置友盟appkey
        [[UMSocialManager defaultManager] setUmSocialAppkey:KSShareConfigManagerInstance.shareAppKey];
    }
    //各平台的详细配置
    if(KSShareConfigManagerInstance.KSSocialPlatConfigType_Wechat_AppKey&&KSShareConfigManagerInstance.KSSocialPlatConfigType_Wechat_AppSecret)
    {
        NSLog(@"分享-微信平台已经配置");
        //设置微信的appId和appKey
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:KSShareConfigManagerInstance.KSSocialPlatConfigType_Wechat_AppKey appSecret:KSShareConfigManagerInstance.KSSocialPlatConfigType_Wechat_AppSecret redirectURL:KSShareConfigManagerInstance.KSSocialPlatConfigType_Wechat_RedirectURL];
    }
    
    if(KSShareConfigManagerInstance.KSSocialPlatConfigType_Tencent_AppKey&&KSShareConfigManagerInstance.KSSocialPlatConfigType_Tencent_AppSecret)
    {
        NSLog(@"分享-腾讯平台已经配置");
        //设置分享到QQ互联的appId和appKey
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:KSShareConfigManagerInstance.KSSocialPlatConfigType_Tencent_AppKey  appSecret:KSShareConfigManagerInstance.KSSocialPlatConfigType_Tencent_AppSecret redirectURL:KSShareConfigManagerInstance.KSSocialPlatConfigType_Tencent_RedirectURL];
    }
    
    if(KSShareConfigManagerInstance.KSSocialPlatConfigType_Sina_AppKey&&KSShareConfigManagerInstance.KSSocialPlatConfigType_Sina_AppSecret)
    {
        NSLog(@"分享-新浪平台已经配置");
        //设置新浪的appId和appKey
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:KSShareConfigManagerInstance.KSSocialPlatConfigType_Sina_AppKey  appSecret:KSShareConfigManagerInstance.KSSocialPlatConfigType_Sina_AppSecret redirectURL:KSShareConfigManagerInstance.KSSocialPlatConfigType_Sina_RedirectURL];
    }

    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"%@  Timeline", NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%@  Timeline", NSStringFromSelector(_cmd));
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%@  Timeline", NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%@  Timeline", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%@  Timeline", NSStringFromSelector(_cmd));
}



#pragma mark - scheme url
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        if([code isEqualToString:@"success"]) {
            
            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
            if(data != nil){
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
                if([self verify:sign]) {
                    //验签成功
                }
                else {
                    //验签失败
                }
            }
            
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    BOOL result2 = [[PayToolsManager defaultManager] handleOpenURL:url];
    
    return (result || result2);

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        if([code isEqualToString:@"success"]) {
            
            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
            if(data != nil){
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
                if([self verify:sign]) {
                    //验签成功
                }
                else {
                    //验签失败
                }
            }
            
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    BOOL result2 = [[PayToolsManager defaultManager] handleOpenURL:url];
    
    return (result || result2);
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        if([code isEqualToString:@"success"]) {
            
            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
            if(data != nil){
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
                if([self verify:sign]) {
                    //验签成功
                }
                else {
                    //验签失败
                }
            }
            
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
        }
    }];

    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    BOOL result2 = [[PayToolsManager defaultManager] handleOpenURL:url];
    
    return (result || result2);
}

- (NSString*)sha1:(NSString *)string
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_CTX context;
    NSString *description;
    
    CC_SHA1_Init(&context);
    
    memset(digest, 0, sizeof(digest));
    
    description = @"";
    
    
    if (string == nil)
    {
        return nil;
    }
    
    // Convert the given 'NSString *' to 'const char *'.
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Check if the conversion has succeeded.
    if (str == NULL)
    {
        return nil;
    }
    
    // Get the length of the C-string.
    int len = (int)strlen(str);
    
    if (len == 0)
    {
        return nil;
    }
    
    
    if (str == NULL)
    {
        return nil;
    }
    
    CC_SHA1_Update(&context, str, len);
    
    CC_SHA1_Final(digest, &context);
    
    description = [NSString stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[ 0], digest[ 1], digest[ 2], digest[ 3],
                   digest[ 4], digest[ 5], digest[ 6], digest[ 7],
                   digest[ 8], digest[ 9], digest[10], digest[11],
                   digest[12], digest[13], digest[14], digest[15],
                   digest[16], digest[17], digest[18], digest[19]];
    
    return description;
}

- (NSString *) readPublicKey:(NSString *) keyName
{
    if (keyName == nil || [keyName isEqualToString:@""]) return nil;
    
    NSMutableArray *filenameChunks = [[keyName componentsSeparatedByString:@"."] mutableCopy];
    NSString *extension = filenameChunks[[filenameChunks count] - 1];
    [filenameChunks removeLastObject]; // remove the extension
    NSString *filename = [filenameChunks componentsJoinedByString:@"."]; // reconstruct the filename with no extension
    
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    
    NSString *keyStr = [NSString stringWithContentsOfFile:keyPath encoding:NSUTF8StringEncoding error:nil];
    
    return keyStr;
}

-(BOOL) verify:(NSString *) resultStr {
    
    //此处的verify，商户需送去商户后台做验签
    return NO;
}

//-(BOOL) verifyLocal:(NSString *) resultStr {
//
//    //从NSString转化为NSDictionary
//    NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
//
//    //获取生成签名的数据
//    NSString *sign = data[@"sign"];
//    NSString *signElements = data[@"data"];
//    //NSString *pay_result = signElements[@"pay_result"];
//    //NSString *tn = signElements[@"tn"];
//    //转换服务器签名数据
//    NSData *nsdataFromBase64String = [[NSData alloc]
//                                      initWithBase64EncodedString:sign options:0];
//    //生成本地签名数据，并生成摘要
////    NSString *mySignBlock = [NSString stringWithFormat:@"pay_result=%@tn=%@",pay_result,tn];
//    NSData *dataOriginal = [[self sha1:signElements] dataUsingEncoding:NSUTF8StringEncoding];
//    //验证签名
//    //TODO：此处如果是正式环境需要换成public_product.key
//    NSString *pubkey =[self readPublicKey:@"public_test.key"];
//    OSStatus result=[RSA verifyData:dataOriginal sig:nsdataFromBase64String publicKey:pubkey];
//
//
//
//    //签名验证成功，商户app做后续处理
//    if(result == 0) {
//        //支付成功且验签成功，展示支付成功提示
//        return YES;
//    }
//    else {
//        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
//        return NO;
//    }
//
//    return NO;
//}

@end
