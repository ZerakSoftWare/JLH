//
//  JJRepayInfoRequest.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/10.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJRepayInfoModel.h"
@interface JJRepayInfoRequest : JJBaseRequest
-(instancetype)initWithType:(NSString*)type;
- (JJRepayInfoModel *)response;

@end
