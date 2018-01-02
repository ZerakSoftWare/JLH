//
//  JJBillDetailModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJCustomerBillDetailDataModel: NSObject
@property (nonatomic, copy) NSString *customerBillDetaillId;
@property (nonatomic, copy) NSString *customerBillId;
@property (nonatomic, copy) NSString *billPeriod;/** vbs——第x期  */
@property (nonatomic, copy) NSString *repayDate;/** vbs——每月还款日期(yyyy-mm-dd)（账单日）  2017-02-14*/
@property (nonatomic, copy) NSString *dueSumamt;/** vbs——应还金额(总额)  */
@property (nonatomic, copy) NSString *reSumAmt;/** vbs——已还金额(总额)  */
@property (nonatomic, assign) NSInteger billStatus;
@property (nonatomic, copy) NSString *fullPayDate;
@property (nonatomic, copy) NSString *nowDate;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *modifyTime;
@property (nonatomic, copy) NSString *postLoanPeriod;/** 贷款期限  */
@property (nonatomic, copy) NSString *billType;
@property (nonatomic, copy) NSString *periodOverdue; //期数是否逾期
@end

@interface JJBillDetailDataModel: NSObject
@property (nonatomic, copy) NSString *bankAccount;
@property (nonatomic, strong) NSArray <JJCustomerBillDetailDataModel *> *jlhCustomerBillDetails;
@property (nonatomic, assign) BOOL advCloan;//是否逾期，貌似没用
@end

@interface JJBillDetailModel : JJBaseResponseModel
@property (nonatomic, strong) JJBillDetailDataModel *data;
@property (nonatomic, copy) NSString * billTips;//当billTips不为空时,billTips的值是"很抱歉,当前为公司对账期,暂时无法主动还款,您可将款项存入尾号({0})的银行卡中等待自动扣款,
@property (nonatomic, copy) NSString *billNextDay;//当billTips为空时，返回billNextDay(Date类型)，其值为账单日下一天
@end
