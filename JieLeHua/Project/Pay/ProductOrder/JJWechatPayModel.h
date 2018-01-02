//
//  JJWechatPayModel.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/10.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJWechatPayDataModel : NSObject
@property(nonatomic,copy) NSString * appId;
@property(nonatomic,copy) NSString * timeStamp;
@property(nonatomic,copy) NSString * nonceStr;
@property(nonatomic,copy) NSString * packageValue;
@property(nonatomic,copy) NSString * paySign;
@property(nonatomic,copy) NSString * partnerid;
@property(nonatomic,copy) NSString * prepayid;
@end

@interface JJWechatPayModel : JJBaseResponseModel
@property(nonatomic,strong) JJWechatPayDataModel * data;
@end
