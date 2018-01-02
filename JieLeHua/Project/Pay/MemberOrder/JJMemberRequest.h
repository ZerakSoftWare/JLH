//
//  JJMemberRequest.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/12/22.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJMemberModel.h"
@interface JJMemberRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId;
- (JJMemberModel *)response;
@end
