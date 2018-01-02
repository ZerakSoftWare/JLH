//
//  JJRouterManager.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJRouterManager : NSObject
+ (instancetype)sharedRouterManager;

/**
 *
 *注册管理urlRouter
 *
 */
- (void)setupRouter;
@end
