//
//  VVPathUtils+Database.h
//  VCREDIT
//
//  Created by qcao on 15/3/19.
//  Copyright (c) 2015年 Vcredit Co.,Ltd. All rights reserved.
//

#import "VVPathUtils.h"

@interface VVPathUtils (Database)

//用户信息
+ (NSString*)userInfoPath;
+ (NSString*)basicPlistPath;
+ (NSString *)bankCardPlistPath;
+ (NSString *)redIsNewPlistPath;
+ (NSString *)cacheResponsePlist;
+ (NSString *)contactAuthorizationTimePlistPath;

#pragma mark - preference.db

+ (NSString*)preferenceCipherDbPath;

#pragma mark - crash

+ (NSString *)crashPathDocument;

+ (NSString *)crashLogPath;

+ (NSString*)crashLogPlistPath;

+ (NSString*)crashLogFilePath:(NSDate *)date;

@end
