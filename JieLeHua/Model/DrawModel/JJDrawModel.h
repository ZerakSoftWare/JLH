//
//  JJDrawModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJDrawDataModel : NSObject
@property (nonatomic, copy) NSString *interestRate;//月利率
@property (nonatomic, copy) NSString *bankCode;//银行卡号
@property (nonatomic, copy) NSString *proceduresRate;//手续费
@property (nonatomic, copy) NSString *loanTime;//贷款时间
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) float creditMoney;
@property (nonatomic, copy) NSString *serviceRate;//月服务费率
@property (nonatomic, assign) float loanCapital;//本金
@property (nonatomic, copy) NSString *loanPeriod;//期数

@end

@interface JJDrawModel : JJBaseResponseModel
@property (nonatomic, strong) JJDrawDataModel *data;
@end
