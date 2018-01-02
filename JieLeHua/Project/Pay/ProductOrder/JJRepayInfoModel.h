//
//  JJRepayInfoModel.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/10.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJRepayInfoDataModel : NSObject
@property(nonatomic,assign) int  lastBillIndex;//账单期数
@property(nonatomic,assign) int  sumBillIndex;//总期数
@property(nonatomic,assign) float  nextBillAmt;//下一期金额
@property(nonatomic,assign) float  dueAmt;//逾期金额
@property(nonatomic,assign) float dueProceduresAmt;
@property(nonatomic,assign) float payAmt;//还款金额
@property(nonatomic,copy) NSString * bankAccount;//银行卡卡号
@property(nonatomic,assign) BOOL isPay;  
@end

@interface JJRepayInfoModel : JJBaseResponseModel
@property(nonatomic,strong) JJRepayInfoDataModel * data;
@end
