//
//  VVPathUtils+Database.m
//  VCREDIT
//
//  Created by qcao on 15/3/19.
//  Copyright (c) 2015年 Vcredit Co.,Ltd. All rights reserved.
//

#import "VVPathUtils+Database.h"

@implementation VVPathUtils (Database)


+ (NSString*)dataCipherDbPath
{
    NSString* path = [[self myDirectory] stringByAppendingPathComponent:@"Data"];
    [self createDirectoryIfNotExist:path];
    [self removeFileProtection:path];
    return path;
}

+ (NSString *)basicPathDocument{
    NSString* path = [[self documentDirectory] stringByAppendingPathComponent:@"basicinfo"];
    [VVPathUtils createDirectoryIfNotExist:path];
    return path;
}

+ (NSString *)bankDocument{
    NSString* path = [[self documentDirectory] stringByAppendingPathComponent:@"bank"];
    [VVPathUtils createDirectoryIfNotExist:path];
    return path;
}

+ (NSString *)isRedDocument{
    NSString* path = [[self documentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_isRed",[UserModel currentUser].customerId]];
    [VVPathUtils createDirectoryIfNotExist:path];
    return path;
}

+ (NSString *)contactAuthorizationDocument{
    NSString* path = [[self documentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_contactAuthorization",[UserModel currentUser].customerId]];
    [VVPathUtils createDirectoryIfNotExist:path];
    return path;
}

+ (NSString *)cacheResponseDocument
{
    NSString* path = [[self documentDirectory] stringByAppendingPathComponent:@"cacheResponse"];
    [VVPathUtils createDirectoryIfNotExist:path];
    return path;
}

+ (NSString*)basicPlistPath
{
    static NSString *crashPlistPath = nil;
    crashPlistPath =  [[self basicPathDocument] stringByAppendingPathComponent:@"basicinfo.plist"];
    VVLog(@"======basicPlistPath%@",crashPlistPath);

    return crashPlistPath;
}

+ (NSString*)userInfoPath
{
    static NSString *userInfoPlistPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoPlistPath =  [[self documentDirectory] stringByAppendingPathComponent:@"data.ini"];
    });
    return userInfoPlistPath;
}

+ (NSString *)bankCardPlistPath
{
    static NSString *bankCardPlistPath = nil;
    bankCardPlistPath =  [[self bankDocument] stringByAppendingPathComponent:@"bankCardPlistPath.plist"];
    VVLog(@"======basicPlistPath%@",bankCardPlistPath);
    
    return bankCardPlistPath;
}

+ (NSString *)redIsNewPlistPath
{
    static NSString *redIsNewPlistPath = nil;
    redIsNewPlistPath =  [[self isRedDocument] stringByAppendingPathComponent:@"redIsNewPlistPath.plist"];
    VVLog(@"======redIsNewPlistPath%@",redIsNewPlistPath);
    
    return redIsNewPlistPath;
}

+ (NSString *)contactAuthorizationTimePlistPath
{
    static NSString *contactAuthorizationTimePath = nil;
    contactAuthorizationTimePath =  [[self contactAuthorizationDocument] stringByAppendingPathComponent:@"contactAuthorizationTime.plist"];
    VVLog(@"======contactAuthorizationTimePath%@",contactAuthorizationTimePath);
    return contactAuthorizationTimePath;
}

+ (NSString *)cacheResponsePlist
{
    static NSString *cacheResponsePlist = nil;
    cacheResponsePlist =  [self cacheResponseDocument];
    VVLog(@"======redIsNewPlistPath%@",cacheResponsePlist);
    
    return cacheResponsePlist;
}

#pragma mark - preference.db

+ (NSString*)preferenceCipherDbPath
{
    NSString* path = [[self documentDirectory] stringByAppendingPathComponent:@"preference.db"];
    [self removeFileProtection:path];
    return path;
}

+ (NSString *)crashPathDocument{
    NSString* path = [[self documentDirectory] stringByAppendingPathComponent:@"crash"];
    [VVPathUtils createDirectoryIfNotExist:path];
    return path;
}

+ (NSString *)crashLogPath
{
    NSString* crashLogPath = [[self crashPathDocument] stringByAppendingPathComponent:@"crashlog"];
    [VVPathUtils createDirectoryIfNotExist:crashLogPath];
    return crashLogPath;
}

+ (NSString*)crashLogPlistPath
{
    static NSString *crashPlistPath = nil;
    crashPlistPath =  [[self crashPathDocument] stringByAppendingPathComponent:@"crash.plist"];
    return crashPlistPath;
}

+ (NSString*)crashLogFilePath:(NSDate *)date
{
    static NSString *crashLogFilePath = nil;
//    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd"];
//
//    NSString *time = [dateFormat stringFromDate: date];
    crashLogFilePath =  [[self crashLogPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"iOS_crash_%@_DDK.log",[VVUtils appVersion]]];
    return crashLogFilePath;
}

@end
