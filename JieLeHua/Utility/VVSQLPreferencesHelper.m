//
//  VVSQLPreferencesHelper.m
//  VCREDIT
//
//  Created by qcao on 15/3/26.
//  Copyright (c) 2015年 Vcredit Co.,Ltd. All rights reserved.
//

#import "VVSQLPreferencesHelper.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "VVPathUtils.h"
#import "VVPathUtils+Database.h"

@implementation VVSQLPreferencesHelper


+ (BOOL)createPreferencesTable:(FMDatabase*)db
{
    NSString *createStr=@"CREATE TABLE IF NOT EXISTS 'preferences' ('key' VARCHAR PRIMARY KEY NOT NULL UNIQUE , 'value' VARCHAR)";
    BOOL worked = [db executeUpdate:createStr];
    return worked;
}

+ (void)checkPreferencesTableCreated:(FMDatabase*)db
{
    BOOL exist = NO;
    NSString *queryString=@"SELECT count(*) FROM sqlite_master WHERE type = 'table' AND name = ?";
    FMResultSet *rs = [db executeQuery:queryString,@"preferences"];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count(*)"];
        if ((count > 0)) {
            exist = YES;
        }
    }
    [rs close];
    if (exist == NO) {
        [self createPreferencesTable:db];
    }
}



+ (BOOL)setPreference:(NSString*)preference forKey:(NSString*)key
{
    NSString * dbPath = [VVPathUtils preferenceCipherDbPath];
    VVLog(@"preferenceCipherDbPath%@",dbPath);
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    [db open];
//    [db setKey:SQL_CIPHER_HEX_KEY];

    [self checkPreferencesTableCreated:db];
    BOOL worked = NO;
    NSString * insertStr = [NSString stringWithFormat:@"INSERT OR REPLACE INTO 'preferences' ('key','value') VALUES (?,?)"];
    NSError* err = nil;
    worked = [db executeUpdate:insertStr withErrorAndBindings:&err,
              key,
              preference];
    if (!worked) {
    }
    [db close];
    
    return worked;
}

+ (BOOL)removePreferencesKey:(NSString*)key
{
    NSString * dbPath = [VVPathUtils preferenceCipherDbPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    [db open];
//    [db setKey:SQL_CIPHER_HEX_KEY];

    [self checkPreferencesTableCreated:db];
    
    NSString *deleteString = @"DELETE FROM 'preferences' WHERE 'key' = ?";
    BOOL worked = NO;

    NSError* err = nil;
    worked = [db executeUpdate:deleteString withErrorAndBindings:&err,key];
    if (!worked) {
    }
    [db close];

    return worked;
}



+ (NSString*)preferenceForKey:(NSString*)key
{
    NSString * dbPath = [VVPathUtils preferenceCipherDbPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    [db open];
//    [db setKey:SQL_CIPHER_HEX_KEY];

    [self checkPreferencesTableCreated:db];
    NSString* result = nil;
    FMResultSet * rs = [db executeQuery:@"SELECT * FROM 'preferences' WHERE key = ?",key];
    while ([rs next]) {
        result = [rs stringForColumn:@"value"];
    }
    [db close];
    return result;
}


@end
