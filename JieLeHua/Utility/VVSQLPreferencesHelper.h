//
//  VVSQLPreferencesHelper.h
//  VCREDIT
//
//  Created by qcao on 15/3/26.
//  Copyright (c) 2015年 Vcredit Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVSQLPreferencesHelper : NSObject

+ (BOOL)setPreference:(NSString*)preference forKey:(NSString*)key;

+ (BOOL)removePreferencesKey:(NSString*)key;

+ (NSString*)preferenceForKey:(NSString*)key;

@end
