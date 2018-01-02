//
//  IntroduceRootViewController.m
//  JieLeHua
//
//  Created by admin2 on 2017/6/7.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IntroduceRootViewController.h"
#import "IntroduceHomeVC.h"
#import "IntroduceNoticeVC.h"
#import "IntroduceMineVC.h"
#import "JJIntroductionViewController.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface IntroduceRootViewController ()


@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation IntroduceRootViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initControllers];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)initControllers
{
    IntroduceHomeVC *homeVC = [[IntroduceHomeVC alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                      image:kGetImage(@"tab_bar_home.png")
                                              selectedImage:kGetImage(@"tab_bar_home_pre.png")];
    AppNavigationController *homeNav = [[AppNavigationController alloc] initWithRootViewController:homeVC];
    [homeNav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(25, -2)];
    homeNav.navigationBar.translucent = NO;
    
    IntroduceNoticeVC *noticeVC  = [[IntroduceNoticeVC alloc] init];
    noticeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通知"
                                                        image:kGetImage(@"icon_tab_bar_notice.png")
                                                selectedImage:kGetImage(@"icon_tab_bar_notice_pre.png")];
    AppNavigationController *noticeNav = [[AppNavigationController alloc] initWithRootViewController:noticeVC];
    [noticeNav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    noticeNav.navigationBar.translucent = NO;
    
//    IntroduceMineVC *mineVC = [[IntroduceMineVC alloc] init];
    JJIntroductionViewController *mineVc = [[JJIntroductionViewController alloc]init];
    mineVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                      image:kGetImage(@"icon_tab_bar_mine.png")
                                              selectedImage:kGetImage(@"icon_tab_bar_mine_pre.png")];
    AppNavigationController *mineNav = [[AppNavigationController alloc] initWithRootViewController:mineVc];
    [mineNav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-25, -2)];
    
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = kColor_Main_Color;
    self.viewControllers = [NSArray arrayWithObjects:homeNav,noticeNav,mineNav, nil];
    
    self.tabBar.barTintColor = RGB(252, 254, 255);
    self.tabBar.shadowImage = [UIImage new];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName: kColor_TipColor,
                                                        NSFontAttributeName: [UIFont systemFontOfSize:11]
                                                        }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName: kColor_Main_Color,
                                                        NSFontAttributeName: [UIFont systemFontOfSize:11]
                                                        } forState:UIControlStateSelected];
    
}

@end
