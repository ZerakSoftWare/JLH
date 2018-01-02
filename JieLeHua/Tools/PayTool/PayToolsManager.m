//
//  PayToolsManager.m
//  PayToolsProject
//
//  Created by apple on 2017/3/28.
//  Copyright © 2017年 gupeng. All rights reserved.
//

#import "PayToolsManager.h"

//微信支付
#import "WXApi.h"

//微信创建的 appId
#define kWX_APP_ID @"wxdcb86af17b41faab"

@interface PayToolsManager ()<WXApiDelegate>

/** 是否授权 第三方登录需要授权 */
@property (nonatomic, assign) BOOL isAuth;

@end

@implementation PayToolsManager

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static PayToolsManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[PayToolsManager alloc] init];
    });
    return manager;
}

- (void)RegistWeChatApp {
   _hasRegisteWeChat = [WXApi registerApp:kWX_APP_ID];
}

#pragma mark - =======微信支付============

/**
 *  发起微信支付的方法 本地掉起二次签名等
 *
 */
-(void)startWeChatPayWithAppId:(NSString *)appId timeStamp:(NSString *)timeStamp nonceStr:(NSString *)nonceStr packageValue:(NSString *)packageValue paySign:(NSString*)paySign  partnerid:(NSString*)partnerid  prepayid:(NSString*)prepayid paySuccess:(PaySuccessBlock)success payFaild:(PayFailedBlock)failed{
    self.isAuth = NO;
    self.paySuccessBlock = success;
    self.payfailedBlock = failed;
    if (!_hasRegisteWeChat) {
        _hasRegisteWeChat = [WXApi registerApp:kWX_APP_ID];
    }
   
//    NSString * timeStamp = @"1504832622200";
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = appId;
    req.timeStamp           = (UInt32)[timeStamp intValue];
    req.nonceStr            = nonceStr;
    req.package             = packageValue;
    req.sign                = paySign;
    req.partnerId           = partnerid;
    req.prepayId            = prepayid;
    [WXApi sendReq:req];
}

/**
 发起微信授权
 
 @param success 成功
 @param failed 失败
 */
- (void)startWeChatAuthSuccess:(AuthSuccessBlock)success faild:(AuthFailedBlock)failed {
    self.isAuth = YES;
    self.authSuccessBlock = success;
    self.authfailedBlock = failed;
    if (!_hasRegisteWeChat) {
        _hasRegisteWeChat = [WXApi registerApp:kWX_APP_ID];
    }
    if (![WXApi isWXAppInstalled]) {
        _authfailedBlock?_authfailedBlock(@"您尚未安装微信，请选择其它支付方式"):nil;
        return;
    }
    //开始授权啦
    SendAuthReq *req = [[SendAuthReq alloc] init];
    //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
    req.scope = @"snsapi_userinfo";
    //用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验
    req.state = @"MyApp";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}


//处理微信授权或者登录信息
- (void)dealWithAuthResultWith:(NSDictionary *)resultDic {
    //返回的信息  解析
    /* {
    resultStatus=9000
    memo="处理成功"
    result="success=true&auth_code=d9d1b5acc26e461dbfcb6974c8ff5E64&result_code=200 &user_id=2088003646494707"
     }
    */
    
    NSLog(@"result = %@",resultDic);
    // 解析 auth code
    
    NSString *resultStatus = resultDic[@"resultStatus"];
    NSString *result = resultDic[@"result"];
    
    if ([resultStatus isEqualToString:@"9000"]) {//成功
        //result_code为“200”时，代表授权成功。auth_code表示授权成功的授码
        NSString *authCode = nil;//授权码
        NSArray *resultArr = [result componentsSeparatedByString:@"&"];
        NSString *result_code = nil;//授权结果码result_code
        for (NSString *subResult in resultArr) {
            if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                authCode = [subResult substringFromIndex:10];
            }
            if (subResult.length > 10 && [subResult hasPrefix:@"result_code="]) {
                result_code = [subResult substringFromIndex:10];
            }
        }
        //授权成功啦
        if ([result_code isEqualToString:@"200"] && authCode.length) {
            if (_authSuccessBlock) {
                _authSuccessBlock(authCode);//授权码
            }
        }
        //授权失败啦
        else {
            NSString *errStr = @"系统出现异常";
            if ([result_code isEqualToString:@"200"] ) {
                errStr = @"系统异常，请稍后再试或联系支付宝技术支持";
            }
            else if ([result_code isEqualToString:@"1005"] ) {
                errStr = @"账户已冻结，如有疑问，请联系支付宝技术支持";
            }
            if (_authfailedBlock) {
                _authfailedBlock(errStr);
            }
        }
    }
    else {
        NSString *errStr = @"系统出现异常";
        if ([resultStatus isEqualToString:@"4000"]) {
            errStr = @"系统异常";
        }
        else if ([resultStatus isEqualToString:@"6001"]) {
            errStr = @"用户中途取消";
        }
        else if ([resultStatus isEqualToString:@"6002"]) {
            errStr = @"网络连接出错";
        }
        if (_authfailedBlock) {
            _authfailedBlock(errStr);
        }
    }
}


#pragma mark - =======客户端回调相关的=========

#warning 需要在APPdelegate里调用该方法 处理客户端的回调写在application:(UIApplication *)application openURL:(NSURL *)url sourceApp      |lication:(NSString *)sourceApplication annotation:(id)annotation  方法
- (BOOL)handleOpenURL:(NSURL *)url
{
    //微信
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
        //设置代理 微信结果回调的方法  收到微信的回应  -(void) onResp:(BaseResp*)resp
    }
       return YES;
}

//微信结果回调的方法   收到微信的回应
-(void) onResp:(BaseResp*)resp {
    //支付类型
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        
        switch (resp.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                if (_paySuccessBlock) {
                    _paySuccessBlock();
                }
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                [self wechatCancelMember];
                if (_payfailedBlock) {
                    _payfailedBlock (@"订单支付失败");
                }
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                [self wechatCancelMember];
                if (_payfailedBlock) {
                    _payfailedBlock (@"用户中途取消付款！");
                }
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                [self wechatCancelMember];
                if (_payfailedBlock) {
                    _payfailedBlock (@"微信发送失败");
                }
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                [self wechatCancelMember];
                if (_payfailedBlock) {
                    _payfailedBlock (@"微信不支持");
                }
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                [self wechatCancelMember];
                if (_payfailedBlock) {
                    _payfailedBlock (@"微信授权失败");
                }
            }
                break;
            default:
                break;
        }
    }
    //授权类型的消息
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        /*
         ErrCode	ERR_OK = 0(用户同意)
         ERR_AUTH_DENIED = -4（用户拒绝授权）
         ERR_USER_CANCEL = -2（用户取消）
         code	用户换取access_token的code，仅在ErrCode为0时有效
         state	第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
         lang	微信客户端当前语言
         country	微信用户当前国家信息
         */
        SendAuthResp *authResp = (SendAuthResp *)resp;
        switch (resp.errCode) {
            case 0:
            {
                //用户换取access_token的code，仅在ErrCode为0时有效
                if (_authSuccessBlock) {
                    _authSuccessBlock(authResp.code);
                }
            }
                break;
            case -4:
            {
                if (_authfailedBlock) {
                    _authfailedBlock(@"用户拒绝授权");
                }
            }
                break;
            case -2:
            {
                if (_authfailedBlock) {
                    _authfailedBlock(@"用户取消授权");
                }
            }
                break;
                
            default:
                break;
        }
    }
}


-(void)wechatCancelMember{
    
    [[VVNetWorkUtility netUtility] getcancelMemberSuccess:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
