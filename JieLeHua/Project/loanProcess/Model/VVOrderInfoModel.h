//
//  VVOrderInfoModel.h
//  O2oApp
//
//  Created by chenlei on 16/5/4.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//


enum ApplyType {
    applyTypeBase=16,// 基本信息
    applyTypeMobileVerification=17,// 手机账单和身份认证
    applyTypeCredit=18,// 网络征信 激活码激活
    applyTypeZhimaScore = 15//芝麻信用
};




@interface JJCustomerModel :NSObject

@end

@interface VVOrderInfoModel : NSObject

@property (strong,nonatomic) NSString * orderId;
//@property (strong,nonatomic) NSString * creditType;//判断征信类型
@property (strong,nonatomic) NSString * orderStatus;
@property (strong,nonatomic) NSString * loanKind;//
@property (strong,nonatomic) NSString * displayHandlingRate;//
@property (strong,nonatomic) NSString * loanMoney;//额度
@property (strong,nonatomic) NSString * needFollowApplyStep;//预审  显示提示 还是跳转界面
@property (strong,nonatomic) NSString * customerScore;//积分
@property (strong,nonatomic) NSString * applyStep;//申请中页面步骤

@property (strong,nonatomic) NSString * applyMoney;
@property (strong,nonatomic) NSString * applyTime;
@property (strong,nonatomic) NSString * city;
@property (strong,nonatomic) NSString * closeTime;
@property (strong,nonatomic) NSString * education;
@property (strong,nonatomic) NSString * expireTime;

@property (strong,nonatomic) NSString * loanPeriod;
@property (strong,nonatomic) NSString * handlingRate; //率
@property (strong,nonatomic) NSString * percent; //击败多少人

@property (strong,nonatomic) NSString * orderNum;
@property (strong,nonatomic) NSString * Website;


@property (strong,nonatomic) NSString * creditToken;//申请中页面步骤 征信token
//@property (strong,nonatomic) NSString * creditReportId;//申请中页面步骤 征信id
@property (strong,nonatomic) NSString * creditReportSN;//申请中页面步骤 征信sn
@property (strong,nonatomic) NSString * creditReportDate;//申请中页面步骤 征信date

//@property (strong,nonatomic) NSString * mobileBillId;
@property (strong,nonatomic) NSString * mobileToken;//申请中页面步骤 手机token
@property (strong,nonatomic) NSString * orderMobile;//手机


/*****借乐花*****/
@property (strong,nonatomic) NSString * applyStatusCode;
//基本信息
@property(nonatomic,strong) NSString *educationCode;
@property(nonatomic,strong) NSString *marriageCode;
@property(nonatomic,strong) NSString * industryCode;
@property(nonatomic,strong) NSString *professionCode;
@property(nonatomic,strong) NSString *monthCardSalary;
@property(nonatomic,strong) NSString *monthCashSalary;
@property(nonatomic,assign) NSInteger isPayFundSocial;
@property(nonatomic,strong) NSString * liveCityName;

//身份认证手机账单
//@property(nonatomic,strong) NSString *mobileBillId;
//@property(nonatomic,strong) NSString * householdAddr;
//@property(nonatomic,strong) NSString * applyId;
//@property(nonatomic,strong) NSString *customerId;
//@property(nonatomic,strong) NSString *mobile;
//@property(nonatomic,strong) NSString *mobileAddress;


@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * mobileBillId;
@property(nonatomic,strong) NSString * mobileAddress;
@property(nonatomic,strong) NSString * mobile;
@property(nonatomic,strong) NSString * idcardNo;
@property(nonatomic,strong) NSString * idcardImageReverseBase64;
@property(nonatomic,strong) NSString * idcardImageObverseBase64;
@property(nonatomic,strong) NSString * idcardImageBase64;
@property(nonatomic,strong) NSString * householdAddr;
@property(nonatomic,strong) NSString * faceBase64;
@property(nonatomic,strong) NSString * customerId;
@property(nonatomic,strong) NSString * creditAuthorizationBase64;
@property(nonatomic,strong) NSString * applyId;


@property(nonatomic,strong) NSString * customerAgentId;
@property(nonatomic,strong) NSString * isLocalHousehold;
@property(nonatomic,strong) NSString * monthRate;
@property(nonatomic,strong) NSString * fundMonth;
@property(nonatomic,strong) NSString * electronicSignatureTime;
@property(nonatomic,strong) NSString * creditType;
@property(nonatomic,strong) NSString * liveCity;
@property(nonatomic,strong) NSString * offineSaleId;
@property(nonatomic,strong) NSString * modifyTime;
@property(nonatomic,strong) NSString * alipayReportId;
@property(nonatomic,strong) NSString * applyColseTime;
@property(nonatomic,strong) NSString *commercelimitIn3Use;
@property(nonatomic,strong) NSString *creditReportId;
@property(nonatomic,strong) NSString *vbsApplyFailedTime;
@property(nonatomic,strong) NSString *commercelimitIsoverdue;
@property(nonatomic,strong) NSString *vbsSaleStoreName;
@property(nonatomic,strong) NSString *vbsApplyFailedReason;
@property(nonatomic,strong) NSString *creditCardReportId;
@property(nonatomic,strong) NSString *antsChantFlowersMoney;
@property(nonatomic,strong) NSString *vbsSaleAgentId;
@property(nonatomic,strong) NSString *applicantIdcard;
@property(nonatomic,strong) NSString *applicantName;
@property(nonatomic,strong) NSString *vbsCreditCardScore1;
@property(nonatomic,strong) NSString *creditBankCard;
@property(nonatomic,strong) NSString *electronicSignaturePersonId;
@property(nonatomic,strong) NSString *formalitiesRate;
@property(nonatomic,strong) NSString *vbsCustomerScore1;
@property(nonatomic,strong) NSString *creditReportStatus;
@property(nonatomic,strong) NSString *applyColseReson;
@property(nonatomic,strong) NSString *creditReportTime;
@property(nonatomic,strong) NSString *vbsSaleRegionKey;
@property(nonatomic,strong) NSString *vbsSaleTeamFullKey;
@property(nonatomic,strong) NSString *vbsMobileScore1;
@property(nonatomic,strong) NSString *sesameCreditMoney;
@property(nonatomic,strong) NSString *isApplyClose;
@property(nonatomic,strong) NSString *monthlyServiceRate;
@property(nonatomic,strong) NSString *creatorId;
@property(nonatomic,strong) NSString *vbsCustomerScore;
@property(nonatomic,strong) NSString *creditAuthTime;
@property(nonatomic,strong) NSString *remark;
@property(nonatomic,strong) NSString *parentApplyId;
@property(nonatomic,strong) NSString *socialMonth;
@property(nonatomic,strong) NSString *isCreditBankMoible;
@property(nonatomic,strong) NSString *applyColseCode;
@property(nonatomic,strong) NSString *creditTypeCode;
@property(nonatomic,strong) NSString *applyStartTime;
@property(nonatomic,strong) NSString *vbsMobileScore;
@property(nonatomic,strong) NSString *vbsSaleTeamName;
@property(nonatomic,strong) NSString *creditReportSn;
@property(nonatomic,strong) NSString *vbsSaleStoreKey;
@property(nonatomic,strong) NSString *vbsSaleCityName;
@property(nonatomic,strong) NSString *vbsCreditTime;
@property(nonatomic,strong) NSString *idcardAddr;
@property(nonatomic,strong) NSString *creditMoible;
@property(nonatomic,strong) NSString *vbsExpiryDate;
@property(nonatomic,strong) NSString *onlineSaleId;
@property(nonatomic,strong) NSString *vbsCreditCardScore;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,strong) NSString *elecSignatureCode;
@property(nonatomic,strong) NSString *vbsSubmitVbsTime;
@property(nonatomic,strong) JJCustomerModel * jlhCustomer;




/*
 "customerAgentId": null,
 "isLocalHousehold": null,
 "monthRate": null,
 "vbsCreditMoney": null,
 "fundMonth": null,
 "householdAddr": "江苏省如皋市栅经镇肖马村六组6号",
 "electronicSignatureTime": null,
 "creditType": 0,
 "industryCode": "房地产/建筑",
 "liveCity": "320500",
 "offineSaleId": null,
 "applyId": 60113,
 "jlhCustomer": {
 "passWord": null,
 "vbsSaleRegionKey": null,
 "vbsSaleTeamFullKey": null,
 "customerAgentId": null,
 "weixinNickname": null,
 "customerIdcard": null,
 "userSource": null,
 "customerSex": null,
 "vbsSaleSaleAgentId": null,
 "onlineSaleId": 11002,
 "customerName": null,
 "departmentSaleId": null,
 "onlineSaleLoginName": null,
 "recomTime": null,
 "vbsSaleTeamName": null,
 "modifyTime": 1487754638000,
 "createTime": 1487748953000,
 "customerEmail": null,
 "customerId": 20071,
 "vbsSaleStoreKey": null,
 "vbsSaleStoreName": null,
 "vbsSaleCityName": null,
 "customerMobile": null
 },
 "modifyTime": 1487754638000,
 "liveCityName": "苏州",
 "alipayReportId": "ac1ca33f8b474c559332ba060657b6ee",
 "applyStatusCode": 18,
 "applyColseTime": null,
 "commercelimitIn3Use": "否",
 "creditReportId": null,
 "vbsApplyFailedTime": null,
 "commercelimitIsoverdue": "否",
 "vbsSaleStoreName": null,
 "vbsApplyFailedReason": null,
 "creditCardReportId": null,
 "antsChantFlowersMoney": 9500,
 "isPayFundSocial": 1,
 "vbsSaleAgentId": 0,
 "applicantIdcard": "320682199107046803",
 "applicantName": "朱红霞",
 "vbsCreditCardScore1": null,
 "creditBankCard": null,
 "electronicSignaturePersonId": null,
 "mobileBillId": "vcredit_67169",
 "formalitiesRate": null,
 "monthCashSalary": 0,
 "vbsCustomerScore1": null,
 "creditReportStatus": null,
 "applyColseReson": null,
 "creditReportTime": null,
 "vbsSaleRegionKey": null,
 "vbsSaleTeamFullKey": null,
 "vbsMobileScore1": null,
 "sesameCreditMoney": null,
 "isApplyClose": 0,
 "monthlyServiceRate": null,
 "monthCardSalary": 1000,
 "creatorId": 0,
 "vbsCustomerScore": null,
 "educationCode": "NEWEDUCATION/BK",
 "creditAuthTime": null,
 "remark": null,
 "parentApplyId": null,
 "socialMonth": null,
 "isCreditBankMoible": null,
 "applyColseCode": null,
 "creditTypeCode": 1,
 "applyStartTime": 1487748953000,
 "vbsMobileScore": null,
 "vbsSaleTeamName": null,
 "marriageCode": "NEWMARRIAGE/WH",
 "customerId": 20071,
 "creditReportSn": null,
 "vbsSaleStoreKey": null,
 "vbsSaleCityName": null,
 "vbsCreditTime": null,
 "mobile": "13218833587",
 "idcardAddr": "江苏省南通市如皋市",
 "creditMoible": null,
 "vbsExpiryDate": null,
 "onlineSaleId": 11002,
 "vbsCreditCardScore": null,
 "mobileAddress": "江苏省南通市",
 "createTime": 1487748953000,
 "elecSignatureCode": 0,
 "vbsSubmitVbsTime": null
*/

@end
