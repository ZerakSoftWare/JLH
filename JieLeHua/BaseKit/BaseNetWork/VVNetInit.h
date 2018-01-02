//
//  VVNetInit.h
//  O2oApp
//
//  Created by chenlei on 16/4/28.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVNetInit : NSObject
+(void)creditNetInitSuccess:(void (^)(BOOL result))success
                    failure:(void (^)(NSError *error))failure;
+(void)mobileNetInitPhoneNum:(NSString*)phoneNum  Name:(NSString*)name IdCard:(NSString *)idCard
                     success:(void (^)(BOOL result))success
                     failure:(void (^)(NSError *error))failure;


@end
