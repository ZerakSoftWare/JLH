//
//  SerializedUser.h
//  HuaAnYun
//
//  Created by admin on 17/1/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerializedUser : NSObject

@property (nonatomic, strong) NSString *token;

+ (instancetype)currentUser;
+ (BOOL)isLoggedIn;

- (void)persist;
- (void)clear;

@end
