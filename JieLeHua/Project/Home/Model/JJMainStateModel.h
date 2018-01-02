//
//  JJMainStateModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JJMainStateSummaryModel : NSObject
@property (nonatomic, copy) NSString *userSource;
@property (nonatomic, copy) NSString *versionSource;
@property (nonatomic, copy) NSString *drawStatus;
@property (nonatomic, copy) NSString *lockTime;
@property (nonatomic, copy) NSString *overAmt;
@property (nonatomic, copy) NSString *overDue;
@property (nonatomic, copy) NSString *reAmt;
@property (nonatomic, copy) NSString *repayStatus;
@property (nonatomic, assign) float vbsCreditMoney;

/** 银行名称  */
@property (nonatomic, copy) NSString *bankName;
/** 贷款期限  */
@property (nonatomic, copy) NSString *postLoanPeriod;
/** 银行帐号  */
@property (nonatomic, copy) NSString *bankPersonAccount;
/** vbs——第x期  */
@property (nonatomic, assign) NSInteger billPeriod;

/** vbs——每月还款日期(yyyy-mm-dd)（账单日）  2017-02-14*/
@property (nonatomic, copy) NSString *repayDate;

@property (nonatomic, copy) NSString *billDate;

/** vbs——应还金额(总额)  */
@property (nonatomic, assign) float dueSumamt;

/** vbs——已还金额(总额)  */
@property (nonatomic, assign) float reSumAmt;

/** 锁单时间  */
@property (nonatomic, assign) NSInteger lockDays;


/** 再贷非会员锁单时间  */
@property (nonatomic, assign) NSInteger lockMemberDays;

/**已用金额  */
@property (nonatomic, assign) float usedMoney;

/**授信金额  */
@property (nonatomic, assign) float availableMoney;

/**申请步骤  */
@property (nonatomic, assign) NSInteger applyStatus;

/**申请是否完成 1 完成 0 未完成 */
@property (nonatomic, assign) NSInteger isApplyClosed;

/**提现是否完成  1 完成 0 未完成  */
@property (nonatomic, assign) NSInteger isDrawClosed;

//是否逾期 true 逾期 false 未逾期
@property (nonatomic, assign) NSInteger isOverDue;
@property (nonatomic, copy) NSString *customerBillId;
@property (nonatomic, assign) NSInteger reApply;//1首贷 2 再贷
@property (nonatomic, copy) NSString *formalitiesFee;//平台推荐费
@property (nonatomic, copy) NSString *overDueAmt; //逾期账单总金额(不包括手续费)
@property (nonatomic, copy) NSString *currentPeriodBillAmt; //当期应还金额
@property (nonatomic, copy) NSString *drawMoneyApplyId;
@property (nonatomic, copy) NSString *isMemberShip;//是否开通了会员，是否会员（0：非会员；1：会员）
@property (nonatomic, copy) NSString *memberShipFeeReminder; /** 首页是否弹框提示交会员费 1,需要 0,不需要 **/
@end

@interface JJMainStateAccountModel : NSObject
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *isActiveSale;
@property (nonatomic, copy) NSString *isEnabled;
@property (nonatomic, assign) BOOL isVirtualAccount;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *loginPassword;
@property (nonatomic, copy) NSString *loginTime;
@property (nonatomic, copy) NSString *logoutTime;
@property (nonatomic, copy) NSString *modifyTime;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *qrcodeUrl;
@property (nonatomic, copy) NSString *registerTime;
@property (nonatomic, copy) NSString *reward;
@property (nonatomic, copy) NSString *roleCode;
@property (nonatomic, copy) NSString *sceneId;
@property (nonatomic, copy) NSString *thirdAccount;
@property (nonatomic, copy) NSString *thirdType;

@end

@interface JJIncreaseModel : NSObject
@property (nonatomic, assign) int antsChantFlowersCreditStatus;//（0：未申请；1：获取中；2：获取失败；3：审批中；4：审批失败；5：审批成功）
@property (nonatomic, assign) int gongjijinCreditStatus;//（0：未申请；1：获取中；2：获取失败；3：审批中；4：审批失败；5：审批成功）
@end

@interface JJMainStateModel : NSObject
@property (nonatomic, strong) JJMainStateAccountModel *account;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) JJMainStateSummaryModel *summary;
@property (nonatomic, strong) JJMainStateSummaryModel *data;
@property (nonatomic, strong) JJIncreaseModel *improveCreditStatus;
@property (nonatomic, copy) NSString *timestamp;
@end
