//
//  JJCloanInfoModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/11.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJCloanInfoDetailModel : NSObject
@property (nonatomic, assign) NSInteger BusinessId;
@property (nonatomic, assign) float Amt;//应还总金额
@property (nonatomic,copy) NSString *BankFullKey;
@property (nonatomic,copy) NSString *BankCard;
@property (nonatomic,assign) BOOL IsExemption;//是否免息
@property (nonatomic,copy) NSString *DueCapitalAmt;//应还欠费本金
@property (nonatomic,copy) NSString *AddInterest;//加收利息
@property (nonatomic,copy) NSString *AddServiceFee;//加收服务费
@property (nonatomic,copy) NSString *AddGuaranteeFee;//加收担保费
@property (nonatomic,copy) NSString *ClearHandFee;//提前清贷手续费
@property (nonatomic,assign) BOOL IsAllowAdv;//是否允许提前清贷
@property (nonatomic, copy) NSString *Explain;
@end

@interface JJCloanInfoDataModel : NSObject
@property (nonatomic, strong) NSArray <JJCloanInfoDetailModel *> *CloanInfo;

@end

@interface JJCloanInfoModel : JJBaseResponseModel
@property (nonatomic, strong) JJCloanInfoDataModel *data;
@end
