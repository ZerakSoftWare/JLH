//
//  JJMemberModel.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/12/22.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJMemberDataModel: NSObject

@property(nonatomic,assign) int memberFee;
@property(nonatomic,copy) NSString *paymentTime;
@property(nonatomic,copy) NSString *validityPeriod;
@property(nonatomic,assign) BOOL isPayEnable;

@end

@interface JJMemberModel : JJBaseResponseModel

@property (nonatomic, strong) JJMemberDataModel *data;

@end
