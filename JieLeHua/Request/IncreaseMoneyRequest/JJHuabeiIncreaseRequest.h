//
//  JJHuabeiIncreaseRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/8/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"

@interface JJHuabeiIncreaseRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId 
                        antsChantFlowers:(NSString *)antsChantFlowers
                                status:(NSString *)status;//1成功 2失败
@end
