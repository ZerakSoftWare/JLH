//
//  JJHomeVipShowManager.h
//  JieLeHua
//
//  Created by pingyandong on 2017/12/22.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJHomeVipShowManager : NSObject
+ (JJHomeVipShowManager *)homeVipShowManager;
@property (nonatomic, assign) BOOL isVipShowed;
@property (nonatomic, assign) BOOL isVipShowedWithdrawing;

@end
