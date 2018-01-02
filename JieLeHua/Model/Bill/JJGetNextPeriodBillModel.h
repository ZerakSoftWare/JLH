//
//  JJGetNextPeriodBillModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJGetNextPeriodDataBillModel: NSObject
@property (nonatomic, copy) NSString *postLoanPeriod;
@property (nonatomic, copy) NSString *drawMoney;
@property (nonatomic, copy) NSString *dueSumamt;
@property (nonatomic, copy) NSString *monthRate;
@property (nonatomic, copy) NSString *formalitiesRate;
@property (nonatomic, copy) NSString *monthServiceRate;
@property (nonatomic, copy) NSString *billPeriod;
@property (nonatomic, copy) NSString *cloanStatus;
@property (nonatomic, copy) NSString *loanDate;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *year;

@end

@interface JJGetNextPeriodBillModel : JJBaseResponseModel
@property (nonatomic, strong) JJGetNextPeriodDataBillModel *data;
@property (nonatomic, copy) NSString * billTips;//当billTips不为空时,billTips的值是"很抱歉,当前为公司对账期,暂时无法主动还款,您可将款项存入尾号({0})的银行卡中等待自动扣款,
@property (nonatomic, copy) NSString *billNextDay;//当billTips为空时，返回billNextDay(Date类型)，其值为账单日下一天
@end
