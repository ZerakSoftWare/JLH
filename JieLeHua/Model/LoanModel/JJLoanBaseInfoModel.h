//
//  JJLoanBaseInfoModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseResponseModel.h"
/*"{
 ""code"": 200,
 ""data"": {
 ""bankAccount"": ""6225210881700000"",
 ""loanDays"": ""5-7"",
 ""memberfeePaymentTime"": null,
 ""drawMoney"": 4800,
 ""formalitiesFee"": 0,
 ""repayMehtod"": ""微信/银联主动还款"", --建议还款方式
 ""monthRepayMoney"": 1720,
 ""memberfeeStatus"": 2,
 ""name"": ""测试0505"",
 ""member"": 0, --缴纳情况 1 已缴纳 0 未缴纳
 ""billDate"": 5,
 ""memberfee"": 299 缴纳金额
 },
 ""success"": true,
 ""error"": false,
 ""timestamp"": ""2017-12-21 15:16:09""
 }"*/
@interface JJLoanBaseInfoDataModel : NSObject
@property (nonatomic, copy) NSString *bankAccount;
@property (nonatomic, copy) NSString *billDate;
@property (nonatomic, copy) NSString *drawMoney;
@property (nonatomic, copy) NSString *monthRepayMoney;
@property (nonatomic, copy) NSString *formalitiesFee;//手续费
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *loanDays;

@property (nonatomic, copy) NSString *memberfeePaymentTime;
@property (nonatomic, copy) NSString *repayMehtod;//微信/银联主动还款"", --建议还款方式
@property (nonatomic, copy) NSString *memberfeeStatus;
@property (nonatomic, copy) NSString *member;//--缴纳情况 1 已缴纳 0 未缴纳
@property (nonatomic, copy) NSString *memberfee; //缴纳金额
@end

@interface JJLoanBaseInfoModel : JJBaseResponseModel
@property (nonatomic, strong) JJLoanBaseInfoDataModel *data;
@end
