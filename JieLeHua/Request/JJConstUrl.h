//
//  JJConstUrl.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJRequestAccessory.h"

#define Timeout  50.0


typedef NS_ENUM(NSInteger, ApplySource) {
    applySource_All = 0,//完整版
    applySource_Fast = 2
};

typedef enum : NSUInteger {
    IncreaseType_Huabei = 0,
    IncreaseType_Gongjijin,
} IncreaseType;

//首页的状态
typedef NS_ENUM(NSInteger, HomeStatus) {
    HomeStatus_NoData = 0,//无数据
    HomeStatus_NoAmount=1,//暂无额度
    HomeStatus_AmountApproving=2,//额度审批中
    HomeStatus_AmountInvalid=3,//额度失效
    HomeStatus_CanNotGetAmount=4,//未能获取额度
    HomeStatus_AdvanceIn30Days=5,//30天内提现
    HomeStatus_AdvanceApproving=6,//提现申请中
    HomeStatus_AdvanceApprovedWaitReviewing=7,//提现申请已提交，等待电审中
    HomeStatus_Advancing=8,//提现中，请留意银行卡信息
    HomeStatus_ReviewRefused=9,//电审未通过
    HomeStatus_SignatureRefused=10,//签名未通过
    HomeStatus_NeedRepayIn7Days=11,//7日内需还款
    HomeStatus_DeductFailured=12,//本期扣款失败
    HomeStatus_NeedRepayImmediately=13,//有逾期账单请及时还款
    HomeStatus_Huabei=14,//花呗
    HomeStatus_ZhimaShouxin=15,//芝麻授信
    HomeStatus_BaseInfo=16,//基本信息
    HomeStatus_IdentityAuthentication=17,//身份认证
    HomeStatus_OrganCreditReporting=18,//机构征信
    HomeStatus_InternetCreditReporting=19,//网络征信
    HomeStatus_WithdrawalProcessed=20,//提款申请
    HomeStatus_FillBankCardInfo,//填写银行卡
    HomeStatus_FillContractInfo,//填写提现合同
    HomeStatus_SignaturePassed,//签名通过
    HomeStatus_ReviewPassed,//电审通过
    HomeStatus_Loaded,//已放款,接口已废弃该状态
    HomeStatus_Termination=26,//已解约
    HomeStatus_Loading,//放款中
    HomeStatus_RepayingPleWaiting,//还款中,请耐心等待
    HomeStatus_LoadAndNotRepay=29,//已放款，尚未还款
    HomeStatus_Repaying=30,//还款中
    HomeStatus_RepayDone,//还款完成,
    HomeStatus_LockOrder,//锁定订单
    HomeStatus_LoanAgain,//再次贷款
    HomeStatus_CreditReportingSignPassed,//征信签名通过
    HomeStatus_CreditReportingSignRefused,//征信签名未通过,
    HomeStatus_Repayment_Normal_Doing = 36,//正常还款中,
    HomeStatus_Repayment_Overdate_Not = 37,//逾期未还款
    HomeStatus_Repayment_Overdate_Doing,//逾期还款中,
    HomeStatus_Repayment_Cloan_Doing,//提前清贷中
    HomeStatus_IncreasingMoney = 41,//提额详情
    HomeStatus_LockedForever = 42,//永久锁单
    HomeStatus_Charge = 43, //扣款中
    HomeStatus_FillContractInfoAgain = 44,
    HomeStatus_Freeze = 45 //账单日同步银行扣款状态
};

#pragma mark - 首页请求
extern NSString * const JJGetWeChatJlhAccountUrl;//查询用户信息
extern NSString * const JJGetCustInfoUrl;//放款中信息
extern NSString * const JJGetAreaCodeUrl;//获取区号
extern NSString * const JJGetDrawResulrUrl;//获取电审结果
extern NSString * const JJGetBannerUrl;//获取首页banner图片

#pragma mark - 用户信息
extern NSString * const JJGetApplyInfoByCustomerIdUrl;

#pragma mark - 添加银行卡
extern NSString * const JJBankCardUrl;//获取银行卡列表
extern NSString * const JJAndBankCardUrl;//添加银行卡
extern NSString * const JJGetBankListUrl;//获取我的银行卡列表
extern NSString * const JJFourElementBankCardUrl;//四要素验证卡

#pragma mark - umeng推送
extern NSString * const UMBindDriveTokeUrl;//友盟推送,绑定diverToken

#pragma mark - 版本更新
extern NSString * const CheckUpdateUrl;//检查版本更新

#pragma mark - 提现页面请求
extern NSString * const JJGetDrawBaseInfoUrl;//获取提现基本信息
extern NSString * const JJGetLoanSimBillDetailsUrl;//查询账单信息
extern NSString * const JJSubbmitDrawMoneyUrl;//提交提现申请


#pragma mark - 还款账单
extern NSString * const JJAdvCloanUrl;//查询提前清贷
extern NSString * const JJConfirmAdvCloanUrl;//处理提前清贷
extern NSString * const JJPayOverDateBillUrl;//逾期还款确认
extern NSString * const JJCustomerBillUrl;//账单详情
extern NSString * const JJOverDueBillUrl;//获取用户逾期账单列表

#pragma mark - 首页小红点
extern NSString * const JJRedIsNewUrl;//首页小红点显示

#pragma mark - 芝麻信用分
extern NSString * const JJZhimaUrl;
extern NSString * const JJUpdateZhimaUrl;
extern NSString * const JJZhimaURL;

#pragma mark - 三步走
extern NSString * const JJGetCityListUrl;
extern NSString * const JJGetApplyProgressUrl;

#pragma mark - 极速版+完整版
extern NSString * const JJGetVersionSourceUrl;
extern NSString * const JJUpdateSesameInfoUrl;


#pragma mark - 设备号
extern NSString * const JJPostDeviceIdUrl;

#pragma mark - 提额
extern NSString * const JJIncreaseHuabeiUrl;
extern NSString * const JJGiveUpIncreaseUrl;
extern NSString * const JJGetIncreaseDetailUrl;

#pragma mark - 再贷重新决策
extern NSString * const JJReCreditUrl;

#pragma mark - 高危联系人
extern NSString * const JJSaveRiskCustomerContactsUrl;
extern NSString * const JJcustomerContactsRelationShipUrl;

#pragma mark - 账单URL
extern NSString * const JJUserBillListUrl;
extern NSString * const JJGetBillDetailByIdUrl;
extern NSString * const JJGetNextPeriodBillUrl;

#pragma mark - 提示文字
extern NSString * const JJGetTipsUrl;

#pragma  mark - 同盾
extern NSString * const JJGetTongdunUrl;

#pragma mark - 全局Notification
extern NSString * const JJToken_Failure;
extern NSString * const JJUpdateHomeRightBtn;
extern NSString * const JJLogout;
extern NSString * const JJMobieHasChange ;
extern NSString * const JJServiceOut;

#pragma mark-提额券
extern NSString * const JJGetMyVoucherUrl;
#pragma mark-会员缴费页面
extern NSString * const JJGetMemberFeeValidityPeriod;
#pragma mark-判断是否会员
extern NSString * const  JJGetIsMemberShip ;

@interface JJConstUrl : NSObject

@end
