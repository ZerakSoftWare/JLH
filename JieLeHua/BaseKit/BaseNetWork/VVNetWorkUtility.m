//
//  VVNetWorkUrl.m
//  O2oApp
//
//  Created by chenlei on 16/11/21.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVNetWorkUtility.h"
#import "JJHomeStatusRequest.h"

@interface VVNetWorkUtility ()
{
    NSMutableArray*  _requestOpertation;//目前发出去并未结束的请求队列
}
@end
@implementation VVNetWorkUtility

+ (VVNetWorkUtility*)netUtility
{
    static VVNetWorkUtility* netUtility = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        netUtility = [[self alloc] init];
    });
    return netUtility;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _requestOpertation = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (NSURLSessionDataTask *)getApi:(NSString *)URLString
                         success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [VVNetWorkTool get:URLString parameters:nil success:success failure:failure];
    if (task) {
        [_requestOpertation addObject:task];
    }
    VVLog(@"get SessionDataTask:%@",task.response);
    return task;
}

- (NSURLSessionDataTask *)postApi:(NSString *)URLString
                       parameters:(id)params
                         success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [VVNetWorkTool post:URLString parameters:params success:success failure:failure];
    if (task) {
        [_requestOpertation addObject:task];
    }
    VVLog(@"post SessionDataTask:%@",task.response);
    return task;
}

- (NSURLSessionDataTask *)postApi:(NSString *)URLString
                       body:(NSString *)body
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [VVNetWorkTool post:URLString body:[[body base64EncodedString] dataUsingEncoding:NSUTF8StringEncoding] success:success failure:failure];
    if (task) {
        [_requestOpertation addObject:task];
    }
    VVLog(@"post SessionDataTask:%@",task.response);
    return task;
}

- (NSURLSessionDataTask *)postUnionpayApi:(NSString *)URLString
                               parameters:(id)params
                                  success:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure
{
    
    NSURLSessionDataTask *task = [VVNetWorkTool postUnionpay:URLString parameters:params success:success failure:failure];
    
    if (task) {
        [_requestOpertation addObject:task];
    }
    VVLog(@"postUnionpay SessionDataTask:%@",task.response);
    
    return task;
}

- (NSURLSessionDataTask *)putApi:(NSString *)URLString
                      parameters:(id)params
                         success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [VVNetWorkTool putWithURL:URLString params:params success:success failure:failure];
    if (task) {
        [_requestOpertation addObject:task];
    }
    VVLog(@"PUT SessionDataTask:%@",task.response);
    return task;
}

- (NSURLSessionDataTask *)deleteApi:(NSString *)URLString
                      parameters:(id)params
                         success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [VVNetWorkTool delete:URLString parameters:params success:success failure:failure];
    if (task) {
        [_requestOpertation addObject:task];
    }
    VVLog(@"deleteApi SessionDataTask:%@",task.response);
    return task;
}

- (NSURLSessionDataTask *)uploadApi:(NSString *)URLString
                         parameters:(id)params
                        uploadParam:(VVUploadParams *)uploadParam
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [VVNetWorkTool upload:URLString parameters:params uploadParam:uploadParam success:success failure:failure];
    if (task) {
        [_requestOpertation addObject:task];
    }
    VVLog(@"uploadApi SessionDataTask:%@",task.response);
    return task;
}

- (NSURLSessionDataTask *)postCreditOrMobileUrlStr:(NSString *)URLString
                                       soapMessage:(NSString *)soapMessage
                                           success:(void (^)(id result))success
                                           failure:(void (^)(NSError *error))failure{
    NSURLSessionDataTask *task = [VVNetWorkTool postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:^(id result) {
        NSDictionary *rsultDic = (NSDictionary *)result;
        if (success) {
            success(rsultDic);
        }
        if ([rsultDic[@"StatusCode"]integerValue] != 0)  {//征信 手机上传错误信息
//            NSDictionary *errorDic = @{
//                                       @"userId": VV_SHDAT.userInfo.data.accountId,
//                                       @"accessUrl": URLString,
//                                       @"content": VV_IS_NIL(soapMessage)?@"":soapMessage,
//                                       @"result": VV_IS_NIL([rsultDic mj_JSONString])?@"":[rsultDic mj_JSONString],
//                                       @"comment": @"征信 移动账单错误统计",
//                                       @"orderId":VV_SHDAT.orderInfo.orderId
//                                       };
            
//            [self uploadVreditErrorList:nil];
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
//        NSDictionary *errorDic = @{
//                                   @"userId": VV_SHDAT.userInfo.data.accountId,
//                                   @"accessUrl": URLString,
//                                   @"content": VV_IS_NIL(soapMessage)?@"":soapMessage,
//                                   @"result": VV_IS_NIL([error localizedDescription])?@"":[error localizedDescription],
//                                   @"comment": @"征信 移动账单错误统计"
//                                   };
        
//        [self uploadVreditErrorList:nil];
    }];
    
    if (task) {
        [_requestOpertation addObject:task];
    }
    VVLog(@"postCreditOrMobile SessionDataTask:%@",task.response);
    return task;
}

- (void)uploadVreditErrorList:(NSDictionary *)dic{
    NSString *Url = [APP_BASE_URL stringByAppendingString:@"/common/ios/log"];
    NSURLSessionDataTask *task = [self postApi:Url parameters:dic success:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}


//字典数据
- (void)getCommonDictionariesSuccess:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure{
    NSString *URLString = [APP_BASE_URL stringByAppendingString:@"/common/dictionaries/all"];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }}
//根据卡号得知银行名字
- (void)getCommonBankNameWithBankCardNum:(NSString*)bankCardNum
                                 Success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/getBankInfoByCardNO/%@",APP_BASE_URL,bankCardNum];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }}

/**
 *  我的银行卡列表
 */
- (void)getMyBankListWithCustomerId:(NSString*)customerId
                           Success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/getMyBankList/%@",APP_BASE_URL,customerId];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
}}

/**
 *  账单列表状态
 */
- (void)getUserBillListWithAccessToken:(NSString *)accessToken
                               Success:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/draw/userBillList?accessToken=%@",APP_BASE_URL,accessToken];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

/**
 *  判断年龄是否合法
 */
- (void)getUserIsAgeWithIdCardNo:(NSString *)idCardNo
                         Success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/isAge/%@",APP_BASE_URL,idCardNo];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

/**
 *  账号同步 注册判断手机号是否有订单
 */
- (void)getAaccountIsIdCard:(NSString *)mobile
                withSMSCode:(NSString *)smsCode
                    Success:(void (^)(id result))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/isIdCard/%@/%@",APP_BASE_URL,mobile,smsCode];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

/**
 *  员工登录
 */
- (void)getEmployeeAppJlhLogin:(NSString *)userName
                  withPassWord:(NSString *)passWord
                       Success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/appJlhLogin/%@/%@",APP_BASE_URL,userName,passWord];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

/**
 *  员工,删除所有消息
 */
- (void)getDeleteNoticeBySaleId:(NSString *)saleId
                        success:(void (^)(id result))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/introduce/deleteAll/%@",APP_BASE_URL,saleId];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

/**
 *  获取公积金支持城市
 */
- (void)getGjjProvinceSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getGjjProvince",APP_BASE_URL];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

/**
 *  获取公积金登录方式
 */
- (void)getGjjLoginFormSettingyCityCode:(NSString *)cityCode
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/formsetting/%@",APP_BASE_URL,cityCode];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

//获取当前客户订单的详细信息
- (void)getCustomersOrderDetailsWithAccountId:(NSString *)accountId
                                      success:(void (^)(id result))success
                                      failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getApplyInfoByCustomerId/%@",APP_BASE_URL,accountId];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

//获取用户信息
- (void)getApplyInfoByCustomerBillWithAccountId:(NSString *)accountId
                                        success:(void (^)(id result))success
                                        failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getApplyInfoByCustomerBill/%@",APP_BASE_URL,accountId];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

//网点查询
- (void)getCommonQueryStoresWithCity:(NSString *)city
                             success:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/query/%@/stores",APP_BASE_URL,city];
    [self getApi:URLString success:success failure:failure];
}

//短信验证码
- (void)getCommonVerificationMobile:(NSString *)mobile
                             picNum:(NSString *)numCode
                                 st:(NSString *)st
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/app/verification/mobile/%@/%@/%@",APP_BASE_URL,mobile,numCode,st];
    [self getApi:URLString success:success failure:failure];
}

//获取征信的短信验证码
- (void)postCommonVerificationMobile:(NSDictionary *)parmas
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/verification/mobile",APP_BASE_URL];
    [self postApi:URLString parameters:parmas success:success failure:failure];
}

/**
 *  验证手机短信验证码
 */
- (void)getCheckSmsCodeWithMobile:(NSString *)mobile
                      withSmsCode:(NSString *)smsCode
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/checkSmsCode/%@/%@",APP_BASE_URL,mobile,smsCode];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}


/**
 *  获取征信验证手机短信验证码
 */
- (void)postCommonCheckSmsCode:(NSDictionary*)params
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/checkSmsCode",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  APP登出
 */
- (void)getLogoutWithCustomerId:(NSString *)customerId
                        success:(void (^)(id result))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/app/logout/%@",APP_BASE_URL,customerId];
    NSURLSessionDataTask *task = [self getApi:URLString success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
}

//POST


//银行卡四要素实名认证 -- 贷贷看app
- (void)postOrdersVerificationBankcardParameters:(id)params
                                          success:(void (^)(id result))success
                                          failure:(void (^)(NSError *error))failure{
    NSString *URLString =  [NSString stringWithFormat:@"%@/apply/bankcardAuthorization",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}


//拍摄身份证正面
- (void)postOrdersScanIdObverseWithOrderId:(NSString *)orderId
                                parameters:(id)params
                                   success:(void (^)(id result))success
                                   failure:(void (^)(NSError *error))failure{
    NSString *URLString =  [NSString stringWithFormat:@"%@/common/ios/commonVbs/idcard/parsing",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}
//拍摄身份证背面
- (void)postOrdersScanIdReverseWithOrderId:(NSString *)orderId
                                parameters:(id)params
                                   success:(void (^)(id result))success
                                   failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/ios/commonVbs/idcard/reverse/parsing",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 极速版--活体识别
 type活体：100，手持：200
 */
- (void)postApplySpeedFaceRecognitionWithparameters:(id)params
                                            success:(void (^)(id result))success
                                            failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/speedFaceRecognition",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

//登录app
- (void)postSecurityLoginParameters:(id)params
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/customerLogin",APP_BASE_URL];
    NSURLSessionDataTask *task = [self postApi:URLString parameters:params success:success failure:failure];
    if ([_requestOpertation containsObject:task]) {
        [_requestOpertation removeObject:task];
    }
    
}

/**
 *  APP端提交注册信息
 */
- (void)postRegeditSubmitParameters:(id)params
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/app/regedit/submit",APP_BASE_URL];
    
    NSURLSessionDataTask *task = [VVNetWorkTool postRegeditInfo:URLString parameters:params success:success failure:failure];
    if (task) {
        [_requestOpertation addObject:task];
    }
}

/**
 *  重置密码
 */
- (void)postResetPasswordParameters:(id)params
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/forgetPassword",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  用户问题反馈
 */
- (void)postFeedBackParameters:(id)params
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/feedBack",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  账号同步
 */
- (void)postSyncCustomerParameters:(id)params
                           success:(void (^)(id result))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/syncCustomer",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  修改银行卡
 *  增加入参:type(int) 0,未放款修改银行卡 3,还款中修改银行卡
 */
- (void)postChangeMyBankCardParameters:(id)params
                              withType:(int)type
                               success:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/changeMyBankCard/%d",APP_BASE_URL,type];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  公积金获取验证码
 */
- (void)postGetGjjVercodeParameters:(id)params
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getGjjVercode",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  公积金登录
 */
- (void)postGjjLoginParameters:(id)params
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/gjjLogin",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  公积金获取状态
 */
- (void)postGjjgetStatusParameters:(id)params
                           success:(void (^)(id result))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getStatus",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  公积金获取状态传值
 */
- (void)setGjjCrawlerStatusParameters:(id)params
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/setGjjCrawlerStatus",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/**
 *  4要素添加银行卡
 */
- (void)postAddCreditBankCardParameters:(id)params
                               success:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/addCreditBankCard",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}


//PUT

//客户申请贷款: 保存或修改订单申请基本信息
-(void)postApplyUpdateCustomerBaseInfoParameters:(id)params
                                         success:(void(^)(id result))sucess
                                         failure:(void(^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/UpdateCustomerBaseInfo",APP_BASE_URL];
    [self postApi:URLString parameters:params success:sucess failure:failure];
}

-(void)postApplyUpdateCustomerCreditInfoParameters:(id)params
                                         success:(void(^)(id result))sucess
                                         failure:(void(^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/speedUpdateCreditInfo",APP_BASE_URL];
    [self postApi:URLString parameters:params success:sucess failure:failure];
}

//客户申请贷款: 验证身份证是否在黑名单或者已经被锁定
-(void)getOrdersVerificationIdcardWithIDcard:(NSString *) idcard andName:(NSString *) name
                                     success:(void (^)(id result))success
                                     failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/blackUser?idCardNo=%@&name=%@",APP_BASE_URL,idcard,name];
    [self getApi:URLString success:success failure:failure];
}

// 验证支付宝黑名单
-(void)postQueryAlipaySummaryWithParameters:(id)params
                                   success:(void (^)(id result))success
                                   failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/query/alipay/summary",APP_HUABEI_BASE_URL];
    NSString *body = [params mj_JSONString];
    [self postApi:URLString body:body success:success failure:failure];
}

//征信
//征信初始化
- (void)getCreditInitSuccess:(void (^)(id result))success
                     failure:(void (^)(NSError *error))failure{
    NSString *URLString = [CREDIT_BASE_URL stringByAppendingString:@"/credit/crawler/init"];
    [self getApi:URLString success:success failure:failure];
}
//获取reportsn
- (void)postCreditReportSnSoapMessage:(NSString *)soapMessage
                              success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/report",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//根据reportsn获取reportid
- (void)getCreditReportIdWithReportSn:(NSString *)reportSn
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/query/report/%@",CREDIT_BASE_URL,reportSn];
    [self getApi:URLString success:success failure:failure];
}
//初始化获取认证页面 得到 html  vercode
- (void)postCreditApplyResultSoapMessage:(NSString *)soapMessage
                                 success:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/apply/result",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//发送手机验证码
- (void)postCreditRegisterSendsmsSoapMessage:(NSString *)soapMessage
                                     success:(void (^)(id result))success
                                 failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/register/sendsms",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//补充注册
- (void)postCreditRegisterSuppinfoSoapMessage:(NSString *)soapMessage
                                      success:(void (^)(id result))success
                                  failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/register/suppinfo",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//注册
- (void)postCreditRegisterInitSoapMessage:(NSString *)soapMessage
                                  success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/register/init",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//获取积分
- (void)postCreditScoreCalculateSoapMessage:(NSString *)soapMessage
                                    success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/score/calculate",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//征信登录
- (void)postCreditLoginSoapMessage:(NSString *)soapMessage
                           success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/login",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}

//五个问题初始化
- (void)postCreditQuestionInitSoapMessage:(NSString *)soapMessage
                                  success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/apply/question/init",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//提交五个问题
- (void)postCreditQuestionSubmitSoapMessage:(NSString *)soapMessage
                                    success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/apply/question/submit",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//银行卡初始化
- (void)postCreditBankcardInitSoapMessage:(NSString *)soapMessage
                                  success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/apply/bankcard/init",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//获取银联验证码
- (void)postCreditBankcardSubmitSoapMessage:(NSString *)soapMessage
                                    success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/credit/crawler/apply/bankcard/submit",CREDIT_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//手机
//手机初始化
- (void)postMobileInitSoapMessage:(NSString *)soapMessage
                          success:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/mobile/crawler/init/Json",MOBILE_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//手机登录
- (void)postMobileLoginSoapMessage:(NSString *)soapMessage
                           success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/mobile/crawler/login/Json",MOBILE_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//手机发送手机验证吗
- (void)postMobileSendsmsSoapMessage:(NSString *)soapMessage
                             success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    NSString *URLString =  [NSString stringWithFormat:@"%@/mobile/crawler/sendsms/Json",MOBILE_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//验证手机验证码
- (void)postMobileChecksmsSoapMessage:(NSString *)soapMessage
                              success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure{
    NSString *URLString =  [NSString stringWithFormat:@"%@/mobile/crawler/checksms/Json",MOBILE_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//查询手机账单
- (void)postMobileQuerySummaryByIdSoapMessage:(NSString *)soapMessage
                                      success:(void (^)(id result))success
                                  failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/mobile/query/summaryById/Json",MOBILE_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//手机通话详单
- (void)postMobileQueryCallsByIdSoapMessage:(NSString *)soapMessage
                                    success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/mobile/query/callsById/Json",MOBILE_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}
//手机采集状态
- (void)postMobileQueryGetCrawlerStateByIdSoapMessage:(NSString *)soapMessage
                                              success:(void (^)(id result))success
                                          failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/mobile/query/GetCrawlerStateById/Json",MOBILE_BASE_URL];
    [self postCreditOrMobileUrlStr:URLString soapMessage:soapMessage success:success failure:failure];
}


- (void)cancelOperations
{
    // 返回时，取消所有未完成的任务和网络操作，防止Crash
    [_requestOpertation enumerateObjectsUsingBlock:
     ^(id obj, NSUInteger idx, BOOL *stop) {
         NSURLSessionDataTask*op = (NSURLSessionDataTask*) obj;
         VVLog(@"cancel task:%@",op.currentRequest);
         [op cancel];
     }];
    [_requestOpertation removeAllObjects];
}

/*--------------------------*/
//首页 状态
- (void)getMainUserStateWithAccountId:(NSString*)accountId vc:(UIViewController *)vc
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure {
    JJHomeStatusRequest *request = [[JJHomeStatusRequest alloc] initWithCustomerId:accountId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc]initWithShowVC:vc];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        success(request.responseJSONObject);
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        failure(error);
    }];

}

- (void)getHuabeiImage:(NSString *)loginType
               success:(void (^)(id result))success
               failure:(void (^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/init",APP_HUABEI_URL];
    NSDictionary *dict = @{
                           @"LoginType":loginType,
                           @"BusType":@"JIELEHUA"//固定
                           };
    NSString *body = [dict mj_JSONString];
    [self postApi:urlString body:body success:success failure:failure];
}

/**
 *校验二维码图片
 *
 */
- (void)checkQRCodeWithToken:(NSString *)token
                     success:(void (^)(id result))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/checkqrcode",APP_HUABEI_URL];
    NSDictionary *dict = @{
                           @"Token":token,
                           @"BusType":@"JIELEHUA"//固定
                           };
    NSString *body = [dict mj_JSONString];
    [self postApi:urlString body:body success:success failure:failure];
}

/**
 * 采集状态查询,post请求
 *
 */
- (void)getCrawlstatusWithToken:(NSString *)token
                        success:(void (^)(id result))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/crawlstatus",APP_HUABEI_QUERY_URL];
    NSDictionary *dict = @{
                           @"Token":token
                           };
    NSString *body = [dict mj_JSONString];
    [self postApi:urlString body:body success:success failure:failure];
}

/**
 * 查询基本信息
 *
 */
- (void)getBaicWithToken:(NSString *)token
                 success:(void (^)(id result))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/baic",APP_HUABEI_QUERY_URL];
    NSDictionary *dict = @{
                           @"Token":token
                           };
    NSString *body = [dict mj_JSONString];
    [self postApi:urlString body:body success:success failure:failure];
}

/**
 * 查询花呗统计信息
 *
 */
- (void)summaryWithToken:(NSString *)token
                 success:(void (^)(id result))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/flower/summary",APP_HUABEI_QUERY_URL];
    NSDictionary *dict = @{
                           @"Token":token
                           };
    NSString *body = [dict mj_JSONString];
    [self postApi:urlString body:body success:success failure:failure];
}


/**
 * POST /apply/beginApply/{antsToken}/{customerId} 根据客户Id和蚂蚁花呗额度新增信息
 *
 **/
- (void)beginApplyWithToken:(NSString *)token customerId:(NSString *)customerId
                    success:(void (^)(id result))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/beginApply/%@/%@",APP_BASE_URL,token,customerId];
    [self postApi:URLString parameters:nil success:success failure:failure];
}

/**
 * POST /apply/AntsChantFlowersMoney 根据客户Id和蚂蚁花呗额度新增信息
 *{
 "antsChantFlowersMoney": 0,
 "commercelimitIn3Use": "string",
 "commercelimitIsoverdue": "string",
 "customerId": 0
 }
 **/
- (void)applyAntsChantFlowersMoneyWithParam:(NSDictionary *)param
                                    success:(void (^)(id result))success
                                    failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/AntsChantFlowersMoney",APP_BASE_URL];
    [self postApi:URLString parameters:param success:success failure:failure];
}

/**
 * POST /apply/AntsChantBill 根据客户Id更新花呗账单信息
 *{
 "antsChantFlowersMoney": 0,
 "commercelimitIn3Use": "string",
 "commercelimitIsoverdue": "string",
 "customerId": 0
 }
 **/
- (void)applyAntsChantBillWithParam:(NSDictionary *)param
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/AntsChantBill",APP_BASE_URL];
    [self postApi:URLString parameters:param success:success failure:failure];
}

/**
 * Post /apply/antsToken/{antsToken}/{customerId} 更新蚂蚁花呗token
 *
 */
- (void)updateTokenWithCustomerId:(NSString *)customerId token:(NSString *)token
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/antsToken/%@/%@",APP_BASE_URL,token,customerId];
    [self postApi:URLString parameters:nil success:success failure:failure];
}


/**
 * POST /apply/AntsToken/{customerId} 获取蚂蚁花呗token
 *
 */
- (void)getHuebeiTokenWithCustomerId:(NSString *)customerId
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/AntsToken/%@",APP_BASE_URL,customerId];
    [self postApi:URLString parameters:nil success:success failure:failure];
}



/***
 
 签名图片
 ***/
-(void)postRecordOrgSignImageParameters:(id)params
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/common/recordOrgSignImage/",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}

/***
 
 更新手机号手机账单ID
 ***/
-(void)postUpdateMobileBillParameters:(id)params
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/updateMobileBill",APP_BASE_URL];
    [self postApi:URLString parameters:params success:success failure:failure];
}


-(void)getAddMobileBillRecordCustomerId:(NSString *)customerid
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/addMobileBillRecord/%@",APP_BASE_URL,customerid];
    [self getApi:URLString success:success failure:failure];
}


-(void)postApplyPreviewCustomerId:(NSString *)customerid
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/%@/prereview",APP_BASE_URL,customerid];
    [self postApi:URLString parameters:nil success:success failure:failure];
}

-(void)getAppCustInfoByWechatCustomerId:(NSString*)customerId idCardNo:(NSString*)idcaedNo mobile:(NSString*)mobile
                      success:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getAppCustInfoByWechat/%@/%@/%@",APP_BASE_URL,customerId,idcaedNo,mobile];
    [self postApi:URLString parameters:nil success:success failure:failure];
    
}

-(void)syncWechatCustInfoAppCustomerId:(NSString*)appCustomerId wechatCustomerId:(NSString*)wechatCustomerId
                  success:(void (^)(id result))success
                  failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/syncWechatCustInfo/%@/%@",APP_BASE_URL,appCustomerId,wechatCustomerId];
    [self getApi:URLString success:success failure:failure];
}

-(void)getApplySetMobileBillResultCustomerId:(NSString*)customerId Result:(NSString*)result
                                     success:(void (^)(id result))success
                                     failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/setMobileBillResult/%@/%@",APP_BASE_URL,customerId,@"1"];
    [self getApi:URLString success:success failure:failure];
}

-(void)getApplySetMobileBillRecordCustomerId:(NSString*)customerId
                                     success:(void (^)(id result))success
                                     failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/setMobileBillRecord/%@",APP_BASE_URL,customerId];
    [self getApi:URLString success:success failure:failure];
}

-(void)getApplyProgressCustomerId:(NSString *)customerId
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getApplyProgress/%@",APP_BASE_URL,customerId];
    [self getApi:URLString success:success failure:failure];

}

-(void)getSaleNumBySaleId:(NSString *)saleId
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/getSaleNumBySaleId/%@",APP_BASE_URL,saleId];
    [self getApi:URLString success:success failure:failure];
    
}

- (void)getCustomerContactsRelationShipParameters:(id)params
                                          success:(void (^)(id result))success
                                          failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/draw/customerContactsRelationShip",APP_BASE_URL];
    [self getApi:URLString success:success failure:failure];
    
}

//是否需要添加风险联系人
- (void)getNeedAddCustomerContactsParameters:(id)params
                                     success:(void (^)(id result))success
                                     failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/draw/needAddCustomerContacts",APP_BASE_URL];
    [self getApi:URLString success:success failure:failure];
}


//--获取花花名人堂页面是否展示
- (void)getNeedShowHuahuaPageWithVbsAccount:(NSString *)vbsAccount
                                    success:(void (^)(id result))success
                                    failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/account/isShowHuahuaPage/vbsAccount?vbsAccount=%@",APP_BASE_URL,vbsAccount];
    [self getApi:URLString success:success failure:failure];
}

- (void)getIsMemberRequestWithCustomerId:(NSString*)customerId
                                 success:(void (^)(id result))success
                                 failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/isMemberShip/%@",APP_BASE_URL,customerId];
    [self getApi:URLString success:success failure:failure];
}

- (void)getRefundMemberInfoWithCustomerId:(NSString *)customerId
                                  success:(void (^)(id result))success
                                  failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getRefundMemberInfo/%@",APP_BASE_URL,customerId];
    [self getApi:URLString success:success failure:failure];
}

//--获取会员账单
- (void)getMemberFeeBillListWithCustomerId:(NSString *)customerId
                                   success:(void (^)(id result))success
                                   failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/getMemberFeeBill/%@",APP_BASE_URL,customerId];
    [self getApi:URLString success:success failure:failure];
}

//--判断会员是否提现电审被拒
- (void)getisMemberDrawPhoneFailedWithCustomerId:(NSString *)customerId
                                         success:(void (^)(id result))success
                                         failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/apply/isMemberDrawPhoneFailed/%@",APP_BASE_URL,customerId];
    [self getApi:URLString success:success failure:failure];
}

//--会员退款
- (void)memberRefundRequestWithsuccess:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@/draw/memberRefund",APP_BASE_URL];
    [self getApi:URLString success:success failure:failure];
}

//--微信支付失败调用
- (void)getcancelMemberSuccess:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure{
    NSString *URLString = [NSString stringWithFormat:@"%@/draw/cancelMember",APP_BASE_URL];
    [self getApi:URLString success:success failure:failure];
}

@end
