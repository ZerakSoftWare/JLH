//
//  VVPathUtils.h
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-22.
//
//

#import <Foundation/Foundation.h>


@interface VVPathUtils : NSObject


+ (NSString*)myDirectory;

+ (NSString*)documentDirectory;

+ (NSString*)cacheDirctory;

+ (void)createDirectoryIfNotExist:(NSString *)fullPath;
+ (void)removeFileProtection:(NSString *)path;


@end
