//
//  JJConnectionRelationshipViewController.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/8/30.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "VVBaseViewController.h"
typedef void (^connectionBlock)(NSString*text);
@interface JJConnectionRelationshipViewController : VVBaseViewController
@property(nonatomic,copy) connectionBlock  connectionblock;
@property(nonatomic,strong) NSArray * relationShipArr;
@end
