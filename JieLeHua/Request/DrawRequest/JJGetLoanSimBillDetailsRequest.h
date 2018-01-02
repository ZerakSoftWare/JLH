//
//  JJGetLoanSimBillDetailsRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJLoanBillDetailModel.h"


@interface JJGetLoanSimBillDetailsRequest : JJBaseRequest
- (instancetype)initWithParam:(NSDictionary *)param;
- (JJLoanBillDetailModel *)response;
@end
