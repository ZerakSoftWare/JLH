//
//  JJGetRedIsNewRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJRedIsNewModel.h"
@interface JJGetRedIsNewRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId timeStamp:(NSString *)timeStamp;
- (JJRedIsNewModel *)response;
@end
