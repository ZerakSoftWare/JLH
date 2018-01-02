//
//  JJConstUrl.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJConstUrl.h"

#pragma mark - 首页请求
NSString * const JJGetWeChatJlhAccountUrl = @"/apply/getCustomerApplyInfo";//查询用户信息
NSString * const JJGetCustInfoUrl = @"/apply/getCustInfo";
NSString * const JJGetAreaCodeUrl = @"/draw/getAreaCode";//获取区号
NSString * const JJGetDrawResulrUrl = @"/draw/getDrawResult";//获取电审结果
NSString * const JJGetBannerUrl = @"/account/app/firstPageImgs";//获取首页banner图片

#pragma mark - 用户信息
NSString * const JJGetApplyInfoByCustomerIdUrl = @"/apply/getApplyInfoByCustomerId";

#pragma mark - 添加银行卡
NSString * const JJBankCardUrl = @"/common/deduct/bankList";
NSString * const JJAndBankCardUrl = @"/common/addMyBankCard";
NSString * const JJGetBankListUrl = @"/common/getMyBankList";//获取我的银行卡列表
NSString * const JJFourElementBankCardUrl = @"/common/check/bankList";


#pragma mark - umeng推送
NSString * const UMBindDriveTokeUrl = @"/umeng/bindDriveToken";

#pragma mark - 提现页面请求
NSString * const JJGetDrawBaseInfoUrl = @"/draw/getDrawBaseInfo";//获取提现基本信息
NSString * const JJGetLoanSimBillDetailsUrl = @"/draw/GetLoanSimBillDetails";//查询账单信息
NSString * const JJSubbmitDrawMoneyUrl = @"/draw/SubbmitDrawMoney";//提交提现申请

#pragma mark - 检查版本更新
NSString * const CheckUpdateUrl = @"/account/app/version";

#pragma mark - 还款账单
NSString * const JJAdvCloanUrl = @"/draw/advCloan";//查询提前清贷
NSString * const JJConfirmAdvCloanUrl = @"/draw/confirmAdvCloan";//处理提前清贷
NSString * const JJPayOverDateBillUrl = @"/draw/payOverDateBill";//逾期还款确认
NSString * const JJCustomerBillUrl = @"/draw/customerBill";//账单详情
NSString * const JJOverDueBillUrl = @"/draw/overdueBill";//获取用户逾期账单列表

#pragma mark - 首页小红点
NSString * const JJRedIsNewUrl = @"/home/isNew";//首页小红点显示

#pragma mark - 芝麻信用分
NSString * const JJZhimaUrl = @"/zmxy/creditscore/query/json";
NSString * const JJUpdateZhimaUrl = @"/apply/sesame/info";//上报芝麻
NSString * const JJZhimaURL = @"/apply/zmxycreditscore/app";

#pragma mark - 三步走
NSString * const JJGetCityListUrl = @"/common/cityList";
NSString * const JJGetApplyProgressUrl = @"/apply/getApplyProgress";


#pragma mark - 极速版+完整版
NSString * const JJGetVersionSourceUrl = @"/apply/no/normal/beginApply";
NSString * const JJUpdateSesameInfoUrl = @"/apply/no/normal/updateSesameInfo";//废弃


#pragma mark - 设备号
NSString * const JJPostDeviceIdUrl = @"/apply/saveDeviceId";

#pragma mark - 提额
NSString * const JJIncreaseHuabeiUrl = @"/apply/setAntChantFlowers";
NSString * const JJGiveUpIncreaseUrl = @"/apply/giveupImproveCredit";
NSString * const JJGetIncreaseDetailUrl = @"/apply/getDetails";


#pragma mark - 再贷重新决策
NSString * const JJReCreditUrl = @"/apply/%@/reCredit";

#pragma mark - 高危联系人
NSString * const JJSaveRiskCustomerContactsUrl = @"/draw/saveRiskCustomerContacts";
NSString * const JJcustomerContactsRelationShipUrl = @"/draw/customerContactsRelationShip";


#pragma mark - 账单URL
NSString * const JJUserBillListUrl = @"/draw/userBillList";
NSString * const JJGetBillDetailByIdUrl = @"/draw/customerBill/%@";
NSString * const JJGetNextPeriodBillUrl = @"/draw/getNextPeriodBill";

#pragma mark - 提示文字
NSString * const JJGetTipsUrl = @"/account/getTips/%@";

#pragma  mark - 同盾
NSString * const JJGetTongdunUrl = @"/apply/getFingerPrint";

#pragma mark - 全局Notification
NSString * const JJToken_Failure = @"tokenFailure";
NSString * const JJUpdateHomeRightBtn = @"updateHomeRightBtn";
NSString * const JJLogout = @"logout";
NSString * const JJMobieHasChange = @"mobieHasChange";
NSString * const JJServiceOut = @"serviceOut";

#pragma mark-提额券
NSString * const JJGetMyVoucherUrl = @"/voucher/findMyVoucher";
#pragma mark-会员缴费页面
NSString * const JJGetMemberFeeValidityPeriod = @"/apply/getMemberFeeValidityPeriod";
#pragma mark-判断是否会员
NSString * const JJGetIsMemberShip = @"/apply/isMemberShip";

@implementation JJConstUrl

@end
