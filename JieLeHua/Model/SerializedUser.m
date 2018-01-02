//
//  SerializedUser.m
//  HuaAnYun
//
//  Created by admin on 17/1/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SerializedUser.h"
#import "SAMKeychain.h"

@implementation SerializedUser

+ (instancetype)currentUser {
    return [self readUserFromDisk];
}

+ (BOOL)isLoggedIn {
    return [self currentUser] != nil;
}

- (void)persist {
    [self persistWithToken:self.token];
    
}

- (void)clear {
    [self persistWithToken:nil];
}

#pragma mark - Priviate Methods

NSString *const DEFAULTS_KEY_USER = @"DeafultsKeyUser";
NSString *const KEYCHAIN_SERVICE  = @"SerializedUser";
NSString *const KEYCHAIN_TOKEN    = @"CurrentUserToken";

+ (instancetype)readUserFromDisk {
    NSString *token = [SAMKeychain passwordForService:KEYCHAIN_SERVICE account:KEYCHAIN_TOKEN];
    
    if (token) {
        SerializedUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_KEY_USER]];
        user.token = token;
        return user;
    } else {
        return nil;
    }
}

- (void)persistWithToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:DEFAULTS_KEY_USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (token) {
        
        if ([SAMKeychain setPassword:token forService:KEYCHAIN_SERVICE account:KEYCHAIN_TOKEN error:nil])
        {
            VVLog(@"保存成功");
        }
        else
        {
            VVLog(@"error");
        }
        
    } else {
        [SAMKeychain deletePasswordForService:KEYCHAIN_SERVICE account:KEYCHAIN_TOKEN];
    }
}

@end
