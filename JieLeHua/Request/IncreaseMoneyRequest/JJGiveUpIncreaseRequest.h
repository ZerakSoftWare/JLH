//
//  JJGiveUpIncreaseRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/8/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"

@interface JJGiveUpIncreaseRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId busType:(NSString *)busType;
@end
