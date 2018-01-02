//
//  JJGetApplyInfoByCustomerIdRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/13.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseRequest.h"

@interface JJGetApplyInfoByCustomerIdRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId;
@end
