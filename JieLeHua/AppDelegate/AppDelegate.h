//
//  AppDelegate.h
//  JieLeHua
//
//  Created by YuZhongqi on 16/12/21.
//  Copyright © 2016年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VVNavigationController,VVTabBarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) VVTabBarViewController *tabBarController;

@property (strong, nonatomic) VVNavigationController *naviController;

@end

