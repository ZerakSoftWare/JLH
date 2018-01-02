//
//  JJBeginApplyRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/5/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"

@interface JJBeginApplyRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId 
                            source:(NSString *)source;
@end
