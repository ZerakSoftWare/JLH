//
//  VVTabBar.h
//  VCREDIT
//
//  Created by chenlei on 14-3-27.
//  Copyright (c) 2014年  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVTabBarItem.h"
@interface VVTabBar : UITabBar

@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,readonly) NSArray *customTabBarItems;

@property (nonatomic,readonly) VVTabBarItem *selectedTabBarItem;

@end
