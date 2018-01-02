//
//  JJUniqueIdRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"

@interface JJUniqueIdRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId deviceId:(NSString *)deviceId;

@end
