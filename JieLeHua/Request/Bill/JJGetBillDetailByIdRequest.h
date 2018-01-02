//
//  JJGetBillDetailByIdRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJBillDetailModel.h"

@interface JJGetBillDetailByIdRequest : JJBaseRequest
- (instancetype)initWithDrawMoneyApplyId:(NSString *)drawMoneyApplyId;
- (JJBillDetailModel *)response;

@end
