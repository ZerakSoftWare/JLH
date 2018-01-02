//
//  AppNavigationController.m
//  JieLeHua
//
//  Created by admin2 on 2017/6/7.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "AppNavigationController.h"

@interface AppNavigationController ()

@end

@implementation AppNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName:[UIColor blackColor],
                                                           NSFontAttributeName:kFont_ImportantTitle
                                                           }];
    [UINavigationBar appearance].tintColor = kColor_Main_Color;
    
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
