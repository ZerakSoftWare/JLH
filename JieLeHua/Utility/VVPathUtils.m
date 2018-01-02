//
//  VVPathUtils.m
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-22.
//
//

#import "VVPathUtils.h"

@implementation VVPathUtils

//+ (NSString*)myDirectory
//{
//    NSString* uid = [VVCommonFunc md5:[NSString stringWithFormat:@"%@",[VV_SHDAT.userInfo.data.accountId md5]]];
//    NSString* path = [[VVPathUtils documentDirectory] stringByAppendingPathComponent:uid];
//    [self createDirectoryIfNotExist:path];
//    return path;
//}


+ (NSString *)cacheDirctory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths firstObject];
	return cachePath;
}


+ (NSString*)documentDirectory
{
    static NSString *documentPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    });
	return documentPath;
}

+ (void)createDirectoryIfNotExist:(NSString *)fullPath
{
	if (!VV_FILEEXIST(fullPath))
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

+ (void)removeFileProtection:(NSString *)path
{
    if (VV_FILEEXIST(path)) {
        NSError* err = nil;
        [[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey] ofItemAtPath:path error:&err];
        if (err) {
        }
    }
}

//+ (NSString*)packetCachePlist
//{
//    NSString* dbPath = [[VVPathUtils myDirectory] stringByAppendingPathComponent:@"Data/cache/"];
//    [self createDirectoryIfNotExist:dbPath];
//    return [dbPath stringByAppendingPathComponent:@"packet_cache.plist"];
//}
//
//
//+ (NSString*)supportFeatureCachePath
//{
//    NSString* sfPath = [[VVPathUtils myDirectory] stringByAppendingPathComponent:@"Data/cache/"];
//    [self createDirectoryIfNotExist:sfPath];
//    return [sfPath stringByAppendingPathComponent:@"supportFeature.plist"];
//}
//
//
//+ (NSString*)defaultLocalizedPlistPath
//{
//    static NSString *defaultLocalizedPlistPath = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        defaultLocalizedPlistPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"VVDefaultLocalize.plist"];
//    });
//	return defaultLocalizedPlistPath;
//}
//
//
//
//+ (BOOL)createDefaultLocalizedPlistIfNotExist:(NSString*) fullPath
//{
//    NSError* error = nil;
//    BOOL suc = NO;
//    [self removeFileProtection:[self documentDirectory]];
//    [self removeFileProtection:[[NSBundle mainBundle] resourcePath]];
//    if (VV_FILEEXIST(fullPath))
//    {
//        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
//    }
//    suc = [[NSFileManager defaultManager] copyItemAtPath:[self defaultLocalizedPlistPath]
//                                                    toPath:fullPath error:&error];
//    [self removeFileProtection:fullPath];
//    if (!suc || error != nil) {
//    }
//    return suc;
//}
//


//
//+ (NSString*)localizedPlistPath
//{
//    static NSString *localizedPlistPath = nil;
//    static dispatch_once_t onceToken;
//    __block BOOL success = NO;
//    dispatch_once(&onceToken, ^{
//        localizedPlistPath =  [[self documentDirectory] stringByAppendingPathComponent:@"VVLocalstrings.plist"];
//        success = [self createDefaultLocalizedPlistIfNotExist:localizedPlistPath];
//
//    });
//    if (success) {
//        return localizedPlistPath;
//    }
//    return [self defaultLocalizedPlistPath];
//}
//
//
//+ (NSString*)webMsgNotificationPlistPath
//{
//    static NSString *webMsgNotificationPlistPath = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        webMsgNotificationPlistPath =  [[self myDirectory] stringByAppendingPathComponent:@"RscStatMsgMode.ini"];
//        
//    });
//	return webMsgNotificationPlistPath;
//}



////搜集信息path
//+ (NSString*)collectInfoPath
//{
//    NSString* collectInfoPath = [[self documentDirectory] stringByAppendingPathComponent:@"VVCollectInfo.plist"];
//    
//    return collectInfoPath;
//}
//
//+ (NSString*)updateInfoPath
//{
//    NSString* updateInfoPath = [[self documentDirectory] stringByAppendingPathComponent:@"VVUpdateInfo.plist"];
//    
//    return updateInfoPath;
//}



//+ (NSString *)originalImageFilePathForFileId:(NSString *)fileId
//{
//    NSRange appRange = [fileId rangeOfString:@"Applications"];
//    if (appRange.location != NSNotFound) {// 绝对路径
//        return fileId;
//    } else {
//        NSString *dirctoryPath = [NSString stringWithFormat:@"%@",[VVPathUtils chatImageCacheDirctory]];
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirctoryPath,fileId];
//        return filePath;
//    }
//}

//+ (NSString *)thumbImageFilePathForFileId:(NSString *)fileId
//{
//    NSRange appRange = [fileId rangeOfString:@"Applications"];
//    if (appRange.location != NSNotFound) {// 绝对路径
//        return [NSString stringWithFormat:@"%@-%@",fileId,kVVChatImageQualityLow];
//    } else {
//        NSString *dirctoryPath = [NSString stringWithFormat:@"%@",[VVPathUtils chatImageCacheDirctory]];
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@-%@",dirctoryPath,fileId,kVVChatImageQualityLow];
//        return filePath;
//    }
//}

//
//+ (NSString*)backGroundImageDirectory
//{
//    NSString * backGroundImageDirectoryPath = nil;
//    backGroundImageDirectoryPath = [[VVPathUtils myDirectory] stringByAppendingPathComponent:@"BackGroundImage"];
//    [self createDirectoryIfNotExist:backGroundImageDirectoryPath];
//    return backGroundImageDirectoryPath;
//}
//
//
//
//+ (NSString*)backGroundOrgMemberFlagPath
//{
//    NSString * backGroundOrgMemberFlagPath = nil;
//    NSString* path = [[self myDirectory] stringByAppendingPathComponent:@"Data/cache"];
//    [self createDirectoryIfNotExist:path];
//    backGroundOrgMemberFlagPath = [path stringByAppendingPathComponent:@"backGroundOrgMemberDone.ini"];
//    return backGroundOrgMemberFlagPath;
//}

//+ (NSString*)newBackGroundOrgMemberFlagPath
//{
//    NSString * backGroundOrgMemberFlagPath = nil;
//    NSString* path = [[self myDirectory] stringByAppendingPathComponent:@"Data/cache"];
//    [self createDirectoryIfNotExist:path];
//    backGroundOrgMemberFlagPath = [path stringByAppendingPathComponent:@"newBackGroundOrgMemberDone.ini"];
//    return backGroundOrgMemberFlagPath;
//}
//
//
//+ (NSString*)newFixedBackGroundOrgMemberFlagPath
//{
//    NSString * backGroundOrgMemberFlagPath = nil;
//    NSString* path = [[self myDirectory] stringByAppendingPathComponent:@"Data/cache"];
//    [self createDirectoryIfNotExist:path];
//    backGroundOrgMemberFlagPath = [path stringByAppendingPathComponent:@"newFixedBackGroundOrgMemberDone.ini"];
//    return backGroundOrgMemberFlagPath;
//}
//
//
//+ (NSString*)sqlResetKeyFlagPath
//{
//    NSString * sqlResetKeyFlagPath = nil;
//    NSString* path = [[self myDirectory] stringByAppendingPathComponent:@"Data"];
//    [self createDirectoryIfNotExist:path];
//    sqlResetKeyFlagPath = [path stringByAppendingPathComponent:@"sqlResetKeyFlag.ini"];
//    return sqlResetKeyFlagPath;
//}


//+ (NSString*)orgCodePath
//{
//    NSString* orgPath = [VVPathUtils cacheCipherDbDirecory];
//    [VVPathUtils createDirectoryIfNotExist:orgPath];
//    NSString* path = [orgPath stringByAppendingPathComponent:@"orgcode.ini"];
//    return path;
//}

//
//
//+ (NSString*)imageCacheDirectory;
//
//{
//    static NSString *imageCacheDirectory = nil;
//    imageCacheDirectory =  [[self cacheDirctory] stringByAppendingPathComponent:@"imageCache"];
//    return imageCacheDirectory;
//}




@end
