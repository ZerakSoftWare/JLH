//
//  VVNetWorkUrl.h
//  O2oApp
//
//  Created by chenlei on 16/11/21.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVNetWorkUtility : NSObject
+ (VVNetWorkUtility*)netUtility;
- (void)cancelOperations;


#pragma mark - get


//字典数据
- (void)getCommonDictionariesSuccess:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure;
//根据卡号得知银行名字
- (void)getCommonBankNameWithBankCardNum:(NSString*)bankCardNum
                                 Success:(void (^)(id result))success
                                 failure:(void (^)(NSError *error))failure;


//获取我的客户经理
- (void)getCustomersSaleWithAccountId:(NSString *)accountId
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;
//获取当前客户订单的详细信息
- (void)getCustomersOrderDetailsWithAccountId:(NSString *)accountId
                                      success:(void (^)(id result))success
                                      failure:(void (^)(NSError *error))failure;
//查看我的信用评分
- (void)getCustomersScoreWithAccountId:(NSString *)accountId
                               success:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure;
//消息列表
- (void)getMessagesWithAccountId:(NSString *)accountId
                       pageIndex:(NSInteger)pageIndex
                     detialCount:(NSInteger)count
                         success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure;
//网点查询
- (void)getCommonQueryStoresWithCity:(NSString *)city
                             success:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure;

//短信验证码
- (void)getCommonVerificationMobile:(NSString *)mobile
                             picNum:(NSString *)numCode
                                 st:(NSString *)st
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure;

//查看服务费明细
- (void)getBillDetialWithAccountId:(NSString *)accountId AndYear:(NSString*)year
                           success:(void (^)(id result))success
                           failure:(void (^)(NSError *error))failure;


/**
 *  验证手机短信验证码
 */
- (void)getCheckSmsCodeWithMobile:(NSString *)mobile
                      withSmsCode:(NSString *)smsCode
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure;

/**
 *  APP登出
 */
- (void)getLogoutWithCustomerId:(NSString *)customerId
                        success:(void (^)(id result))success
                        failure:(void (^)(NSError *error))failure;

/**
 *  我的银行卡列表
 */
- (void)getMyBankListWithCustomerId:(NSString *)customerId
                            Success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure;

/**
 *  账单列表状态
 */
- (void)getUserBillListWithAccessToken:(NSString *)accessToken
                               Success:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure;

/**
 *  判断年龄是否合法
 */
- (void)getUserIsAgeWithIdCardNo:(NSString *)idCardNo
                         Success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure;

/**
 *  账号同步 注册判断手机号是否有订单
 */
- (void)getAaccountIsIdCard:(NSString *)mobile
                withSMSCode:(NSString *)smsCode
                    Success:(void (^)(id result))success
                    failure:(void (^)(NSError *error))failure;

/**
 *  员工登录
 */
- (void)getEmployeeAppJlhLogin:(NSString *)userName
                  withPassWord:(NSString *)passWord
                       Success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure;

/**
 *  员工,删除所有消息
 */
- (void)getDeleteNoticeBySaleId:(NSString *)saleId
                        success:(void (^)(id result))success
                        failure:(void (^)(NSError *error))failure;

/**
 *  获取公积金支持城市
 */
- (void)getGjjProvinceSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  获取公积金登录方式
 */
- (void)getGjjLoginFormSettingyCityCode:(NSString *)cityCode
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure;

#pragma mark POST
//用户协议
- (void)postOrdersAgreementParameters:(id)params
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;
//客户申请贷款: 订单预审
- (void)postOrdersPrereviewWithOrderId:(NSString *)orderId
                            parameters:(id)params
                               success:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure;
//客户申请贷款: 订单预审
- (void)postOrdersVerificationBankcardParameters:(id)params
                                          success:(void (^)(id result))success
                                          failure:(void (^)(NSError *error))failure;

//扫描身份证正面
- (void)postOrdersScanIdObverseWithOrderId:(NSString *)orderId
                                parameters:(id)params
                                   success:(void (^)(id result))success
                                   failure:(void (^)(NSError *error))failure;
//扫描身份证背面
- (void)postOrdersScanIdReverseWithOrderId:(NSString *)orderId
                                parameters:(id)params
                                   success:(void (^)(id result))success
                                   failure:(void (^)(NSError *error))failure;
/**
 极速版--活体识别
 type活体：100，手持：200
 */
- (void)postApplySpeedFaceRecognitionWithparameters:(id)params
                                            success:(void (^)(id result))success
                                            failure:(void (^)(NSError *error))failure;

//登录app
- (void)postSecurityLoginParameters:(id)params
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure;


/**
 *  APP端提交注册信息
 */
- (void)postRegeditSubmitParameters:(id)params
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure;

/**
 *  重置密码
 */
- (void)postResetPasswordParameters:(id)params
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure;

/**
 *  用户问题反馈
 */
- (void)postFeedBackParameters:(id)params
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure;
/**
 *  账号同步
 */
- (void)postSyncCustomerParameters:(id)params
                           success:(void (^)(id result))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  修改银行卡
 */
- (void)postChangeMyBankCardParameters:(id)params
                              withType:(int)type
                               success:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure;

- (void)getApplyInfoByCustomerBillWithAccountId:(NSString *)accountId
                                        success:(void (^)(id result))success
                                        failure:(void (^)(NSError *error))failure;


/**
 *  公积金获取验证码
 */
- (void)postGetGjjVercodeParameters:(id)params
                            success:(void (^)(id result))success
                            failure:(void (^)(NSError *error))failure;
/**
 *  公积金登录
 */
- (void)postGjjLoginParameters:(id)params
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure;
/**
 *  公积金获取状态
 */
- (void)postGjjgetStatusParameters:(id)params
                           success:(void (^)(id result))success
                           failure:(void (^)(NSError *error))failure;
/**
 *  公积金获取状态传值
 */
- (void)setGjjCrawlerStatusParameters:(id)params
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;


#pragma  mark PUT


//客户申请贷款: 保存或修改订单申请基本信息
-(void)postApplyUpdateCustomerBaseInfoParameters:(id)params
                                         success:(void(^)(id result))sucess
                                         failure:(void(^)(NSError *error))failure;

-(void)postApplyUpdateCustomerCreditInfoParameters:(id)params
                                           success:(void(^)(id result))sucess
                                           failure:(void(^)(NSError *error))failure;

//客户申请贷款: 验证身份证是否在黑名单或者已经被锁定
- (void)putOrdersVerificationIdcardWithOrderId:(NSString *)orderId
                                    parameters:(id)params
                                       success:(void (^)(id result))success
                                       failure:(void (^)(NSError *error))failure;

-(void)getOrdersVerificationIdcardWithIDcard:(NSString *) idcard andName:(NSString *) name
                                     success:(void (^)(id result))success
                                     failure:(void (^)(NSError *error))failure;



#pragma ---------------------------征信---------------------------------
//征信初始化
- (void)getCreditInitSuccess:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure;
//获取reportsn
- (void)postCreditReportSnSoapMessage:(NSString *)soapMessage
                              success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure;
//根据reportsn获取reportid
- (void)getCreditReportIdWithReportSn:(NSString *)reportSn
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;
//初始化获取认证页面 得到 html  vercode
- (void)postCreditApplyResultSoapMessage:(NSString *)soapMessage
                                 success:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure;
//发送手机验证码
- (void)postCreditRegisterSendsmsSoapMessage:(NSString *)soapMessage
                                     success:(void (^)(id result))success
                                 failure:(void (^)(NSError *error))failure;
//补充注册
- (void)postCreditRegisterSuppinfoSoapMessage:(NSString *)soapMessage
                                      success:(void (^)(id result))success
                                  failure:(void (^)(NSError *error))failure;
//注册
- (void)postCreditRegisterInitSoapMessage:(NSString *)soapMessage
                                  success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;
//获取积分
- (void)postCreditScoreCalculateSoapMessage:(NSString *)soapMessage
                                    success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure;
//征信登录
- (void)postCreditLoginSoapMessage:(NSString *)soapMessage
                           success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure;
//五个问题初始化
- (void)postCreditQuestionInitSoapMessage:(NSString *)soapMessage
                                  success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;
//提交五个问题
- (void)postCreditQuestionSubmitSoapMessage:(NSString *)soapMessage
                                    success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure;
//银行卡初始化
- (void)postCreditBankcardInitSoapMessage:(NSString *)soapMessage
                                  success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;
//获取银联验证码
- (void)postCreditBankcardSubmitSoapMessage:(NSString *)soapMessage
                                    success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure;

//手机
//手机初始化
- (void)postMobileInitSoapMessage:(NSString *)soapMessage
                          success:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure;
//手机登录
- (void)postMobileLoginSoapMessage:(NSString *)soapMessage
                           success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure;

//手机发送手机验证吗
- (void)postMobileSendsmsSoapMessage:(NSString *)soapMessage
                             success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure;
//验证手机验证码
- (void)postMobileChecksmsSoapMessage:(NSString *)soapMessage
                              success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure;
//查询手机账单
- (void)postMobileQuerySummaryByIdSoapMessage:(NSString *)soapMessage
                                      success:(void (^)(id result))success
                                  failure:(void (^)(NSError *error))failure;
//手机通话详单
- (void)postMobileQueryCallsByIdSoapMessage:(NSString *)soapMessage
                                    success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure;
//手机采集状态
- (void)postMobileQueryGetCrawlerStateByIdSoapMessage:(NSString *)soapMessage
                                              success:(void (^)(id result))success
                                          failure:(void (^)(NSError *error))failure;

/*---------------------------------------------*/
//首页
- (void)getMainUserStateWithAccountId:(NSString*)accountId vc:(UIViewController *)vc
                                         success:(void (^)(id result))success
                                         failure:(void (^)(NSError *error))failure;

#pragma mark - 蚂蚁花呗
/**
 *获取花呗二维码图片和token
 *
 */
- (void)getHuabeiImage:(NSString *)loginType
               success:(void (^)(id result))success
               failure:(void (^)(NSError *error))failure;

/**
 *校验二维码图片
 *
 */
- (void)checkQRCodeWithToken:(NSString *)token
                     success:(void (^)(id result))success
                     failure:(void (^)(NSError *error))failure;

/**
 * 采集状态查询,post请求
 *
 */
- (void)getCrawlstatusWithToken:(NSString *)token
                        success:(void (^)(id result))success
                        failure:(void (^)(NSError *error))failure;

/**
 * 查询基本信息
 *
 */
- (void)getBaicWithToken:(NSString *)token
                        success:(void (^)(id result))success
                        failure:(void (^)(NSError *error))failure;

/**
 * 查询花呗统计信息
 *
 */
- (void)summaryWithToken:(NSString *)token
                 success:(void (^)(id result))success
                 failure:(void (^)(NSError *error))failure;

/**
 * POST /apply/beginApply/{antsToken}/{customerId} 根据客户Id和蚂蚁花呗额度新增信息
 *
 **/
- (void)beginApplyWithToken:(NSString *)token customerId:(NSString *)customerId
                    success:(void (^)(id result))success
                    failure:(void (^)(NSError *error))failure;

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
                                    failure:(void (^)(NSError *error))failure;

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
                            failure:(void (^)(NSError *error))failure;

/**
 * POST /apply/antsToken/{antsToken}/{customerId} 
 *
 */
- (void)updateTokenWithCustomerId:(NSString *)customerId token:(NSString *)token
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure;



/**
 * POST /apply/AntsToken/{customerId} 获取蚂蚁花呗token
 *
 */
- (void)getHuebeiTokenWithCustomerId:(NSString *)customerId
                             success:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure;


//传给服务器签名图片
-(void)postRecordOrgSignImageParameters:(id)params
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure;
//告诉服务器去拉去手机账单
-(void)getAddMobileBillRecordCustomerId:(NSString *)customerid
                             success:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure;

-(void)postApplyPreviewCustomerId:(NSString *)customerid
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure;

// 验证支付宝黑名单
-(void)postQueryAlipaySummaryWithParameters:(id)params
                                    success:(void (^)(id result))success
                                    failure:(void (^)(NSError *error))failure;

//获取征信的短信验证码
- (void)postCommonVerificationMobile:(NSDictionary *)parmas
                             success:(void (^)(id result))success
                             failure:(void (^)(NSError *error))failure;

/**
 *  获取征信验证手机短信验证码
 */
- (void)postCommonCheckSmsCode:(NSDictionary*)params
                       success:(void (^)(id result))success
                       failure:(void (^)(NSError *error))failure;

/***
 
 更新手机号手机账单ID
 ***/
-(void)postUpdateMobileBillParameters:(id)params
                              success:(void (^)(id result))success
                              failure:(void (^)(NSError *error))failure;
//账号同步
-(void)getAppCustInfoByWechatCustomerId:(NSString*)customerId idCardNo:(NSString*)idcaedNo mobile:(NSString*)mobile
                      success:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure;
//更新微信信息
-(void)syncWechatCustInfoAppCustomerId:(NSString*)appCustomerId wechatCustomerId:(NSString*)wechatCustomerId
                  success:(void (^)(id result))success
                  failure:(void (^)(NSError *error))failure;

//记录界面‘获取手机账单’的结果
-(void)getApplySetMobileBillResultCustomerId:(NSString*)customerId Result:(NSString*)result
                                     success:(void (^)(id result))success
                                     failure:(void (^)(NSError *error))failure;
//记录界面‘获取手机账单’的操作
-(void)getApplySetMobileBillRecordCustomerId:(NSString*)customerId
                                     success:(void (^)(id result))success
                                     failure:(void (^)(NSError *error))failure;

-(void)getApplyProgressCustomerId:(NSString *)customerId
                          success:(void (^)(id result))success
                          failure:(void (^)(NSError *error))failure;
//获取销售我的界面数据
-(void)getSaleNumBySaleId:(NSString *)saleId
                  success:(void (^)(id result))success
                  failure:(void (^)(NSError *error))failure;
//4要素添加银行卡
- (void)postAddCreditBankCardParameters:(id)params
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure;
//客户联系人关系
- (void)getCustomerContactsRelationShipParameters:(id)params
                                success:(void (^)(id result))success
                                failure:(void (^)(NSError *error))failure;
//是否需要添加风险联系人
- (void)getNeedAddCustomerContactsParameters:(id)params
                                          success:(void (^)(id result))success
                                          failure:(void (^)(NSError *error))failure;
//--是否是会员
- (void)getIsMemberRequestWithCustomerId:(NSString *)customerId
                                 success:(void (^)(id result))success
                                 failure:(void (^)(NSError *error))failure;

//--获取会员账单
- (void)getMemberFeeBillListWithCustomerId:(NSString *)customerId
                                   success:(void (^)(id result))success
                                   failure:(void (^)(NSError *error))failure;

//--获取会员退款信息
- (void)getRefundMemberInfoWithCustomerId:(NSString *)customerId
                                  success:(void (^)(id result))success
                                  failure:(void (^)(NSError *error))failure;

//--判断会员是否提现电审被拒
- (void)getisMemberDrawPhoneFailedWithCustomerId:(NSString *)customerId
                                         success:(void (^)(id result))success
                                         failure:(void (^)(NSError *error))failure;

//--会员退款
- (void)memberRefundRequestWithsuccess:(void (^)(id result))success
                               failure:(void (^)(NSError *error))failure;

//--获取花花名人堂页面是否展示
- (void)getNeedShowHuahuaPageWithVbsAccount:(NSString *)vbsAccount
                                    success:(void (^)(id result))success
                                    failure:(void (^)(NSError *error))failure;

//--微信支付失败调用
- (void)getcancelMemberSuccess:(void (^)(id result))success
                                    failure:(void (^)(NSError *error))failure;


@end
