//
//  JJIsMemeberShipRequest.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/12/24.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJIsMemeberSHipModel.h"

@interface JJIsMemeberShipRequest : JJBaseRequest
- (instancetype)initWithCustomerId:(NSString *)customerId;
- (JJIsMemeberSHipModel *)response;
@end
