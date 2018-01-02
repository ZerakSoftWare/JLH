//
//  JJcouponRequest.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJcouponModel.h"
@interface JJcouponRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId;

- (JJcouponModel *)response;
@end
