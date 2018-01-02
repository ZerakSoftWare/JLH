//
//  UserModel.h
//  HuaAnYun
//
//  Created by admin on 17/1/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SerializedUser.h"

@interface UserModel : SerializedUser

@property (nonatomic, copy) NSString *customerId;

@property (nonatomic, copy) NSString *phone;

@end
