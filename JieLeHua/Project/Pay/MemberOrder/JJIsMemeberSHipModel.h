//
//  JJIsMemeberSHipModel.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/12/24.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJIsMemeberSHipDataModel : NSObject
@property(nonatomic,copy) NSString *isMemberShip;
@property(nonatomic,copy) NSString *paymentTime;
@property(nonatomic,copy) NSString *validityPeriod;
@end


@interface JJIsMemeberSHipModel : JJBaseResponseModel
@property(nonatomic,strong) JJIsMemeberSHipDataModel *data;

@end
