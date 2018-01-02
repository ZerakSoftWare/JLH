//
//  JJOverdueBillRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJOverDueListModel.h"

@interface JJOverdueBillRequest : JJBaseRequest
- (instancetype)initWithCustomerBillId:(NSString *)billId;
- (JJOverDueListModel *)response;
@end
