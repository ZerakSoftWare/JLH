//
//  VVUserInfoModel.m
//  O2oApp
//
//  Created by chenlei on 16/4/30.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVUserInfoModel.h"
#import "VVPathUtils.h"
//用户信息
@implementation VVUserInfoModel


- (id)initWithDisk
{
    //如果有老版本的userinfo(未加密), 则先把老的读出来加密保存到新路径后删除老文件
    NSString* jsonStr = [VVUserInfoModel newFileContent];
    
    NSError* error = nil;
    if (VV_IS_NIL(jsonStr)) {
        return nil;
    }
    VVUserInfoModel* info = [VVUserInfoModel mj_objectWithKeyValues:jsonStr ];
    
    if (error) {
        VVLog(@"VVUserInfoModel initWithDisk error! %@",error);
        return nil;
    }
    return info;
}

+ (NSString*)newFileContent
{
    NSString* path = [VVPathUtils userInfoPath];
    if (!VV_FILEEXIST(path)) {
        return nil;
    }
    
    NSError* error = nil;
    NSString* encryptStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        VVLog(@"VVUserInfoModel initWithDisk new error! %@",error);
        return nil;
    }
    NSString* decryptStr = [VVUtils aesDecryptString:encryptStr byPwd:AES_PASSWORD];
    
    return decryptStr;
}

- (void)clear
{
    NSError* error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[VVPathUtils userInfoPath] error:&error];
    if (error) {
        VVLog(@"VVUserInfoModel clear error! %@",error);
    }
}

- (void)synchronize
{
    NSString* str = [self mj_JSONString];
    NSString* encryptStr = [VVUtils aesEncryptStr:str byPwd:AES_PASSWORD];
    NSError* error = nil;
  BOOL insert =  [encryptStr writeToFile:[VVPathUtils userInfoPath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        VVLog(@"VVModelUserInfo synchronize error! %@",error);
    }
    
    VVLog(@"insert: %d",insert);
}


@end

@implementation VVModelUSerInfoData

@end

@implementation VVModelUSerInfoRole

@end

