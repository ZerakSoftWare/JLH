//
//  JJOverDueListModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJOverDueListDataModel : NSObject
@property (nonatomic, assign) NSInteger billPeriod;
@property (nonatomic, assign) NSInteger billStatus;
@property (nonatomic, assign) NSInteger customerBillDetaillId;
@property (nonatomic, assign) NSInteger customerBillId;
@property (nonatomic, assign) float dueSumamt;
@property (nonatomic, assign) NSInteger postLoanPeriod;
@property (nonatomic, assign) NSInteger reSumAmt;
@property (nonatomic, assign) double repayDate;

@end

@interface JJOverDueListModel : JJBaseResponseModel
@property (nonatomic, strong) NSArray <JJOverDueListDataModel *> *data;
@end
