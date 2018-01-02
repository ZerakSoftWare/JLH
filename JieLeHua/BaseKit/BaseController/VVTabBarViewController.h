//
//  VVTabBarViewController.h
//  VCREDIT
//
//  Created by chenlei on 14-3-28.
//  Copyright (c) 2014年  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVTabBar.h"
@interface VVTabBarViewController : UITabBarController<UITabBarControllerDelegate>

@property (nonatomic, strong) VVTabBar *customTabBar;

- (void)setBadgeValue:(NSString *)badgeValue forItemAtIndex:(NSInteger )index;


- (void)showBadgeAtIndex:(NSInteger)index show:(BOOL)showed;
// 选择到第几个controller，直接设置 tabbarViewController.selectedIndex 可以选择controller，但是下面的图片更新不到，所以用下面的方法
- (void)selectViewControllerAtIndex:(NSInteger )index;

@end
