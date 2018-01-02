//
//  JJGetIncreaseDetailRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/8/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJIncreaseDetailModel.h"

@interface JJGetIncreaseDetailRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId;
- (JJIncreaseDetailModel *)response;
@end
