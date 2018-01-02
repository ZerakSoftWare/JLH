//
//  JJBillListModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJBillListDataModel: NSObject

@property (nonatomic, copy) NSString *loanStartTime;//提现日期
@property (nonatomic, copy) NSString *postLoanPeriod;//贷款周期
@property (nonatomic, copy) NSString *dueSumamt; //逾期
@property (nonatomic, copy) NSString *billPeriod;//第几期
@property (nonatomic, copy) NSString *repayDate;//还款日期
@property (nonatomic, assign) NSInteger isOverDue;//是否逾期
@property (nonatomic, assign) NSInteger cloanStatus;//还款状态，1是还款中 0：已还
@property (nonatomic, copy) NSString *drawMoneyApplyId;//账单ID
@property (nonatomic, copy) NSString *drawMoney;//提现金额
@end

@interface JJBillListModel : JJBaseResponseModel
@property (nonatomic, strong) NSArray <JJBillListDataModel *> *data;
@property (nonatomic, copy) NSString *status;//状态 draw

@end
