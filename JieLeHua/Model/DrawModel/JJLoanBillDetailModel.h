//
//  JJLoanBillDetailModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJLoanBillDetailDataModel : NSObject
@property (nonatomic, assign) int BillPeriod;//当前账单期数
@property (nonatomic, copy) NSString *Capital;//本金
@property (nonatomic, copy) NSString *Interest;//利息
@property (nonatomic, copy) NSString *ServiceFee;//服务费
@property (nonatomic, copy) NSString *GuaranteeFee;//担保费
@property (nonatomic, copy) NSString *Procedures;//手续费
@property (nonatomic, copy) NSString *SumFee;//本期账单总金额
@property (nonatomic, copy) NSString *BillDate;//账单日期

@end

@interface JJLoanBillDetailModel : JJBaseResponseModel
@property (nonatomic, strong) NSArray <JJLoanBillDetailDataModel *> *data;
@end
