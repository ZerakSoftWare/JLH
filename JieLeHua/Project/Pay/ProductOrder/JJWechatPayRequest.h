//
//  JJWechatPayRequest.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/10.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJWechatPayModel.h"
@interface JJWechatPayRequest : JJBaseRequest
-(instancetype)initWithType:(NSString*)type;
- (JJWechatPayModel *)response;

@end
