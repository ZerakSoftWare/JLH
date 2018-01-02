//
//  JJGetTipsRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/12/4.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJTipsModel.h"
@interface JJGetTipsRequest : JJBaseRequest
- (instancetype)initWithType:(NSString *)type;
- (JJTipsModel *)response;
@end
