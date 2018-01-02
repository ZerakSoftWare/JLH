//
//  VVTabBarViewController.m
//  VCREDIT
//
//  Created by chenlei on 14-3-28.
//  Copyright (c) 2014年  All rights reserved.
//

#import "VVTabBarViewController.h"
#import "JJBillAndNotiCountManager.h"

@interface VVTabBarViewController ()

@end

@implementation VVTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    VVTabBar *tabBarImageView = [[VVTabBar alloc] init];
    tabBarImageView.frame = kLayoutTabbarFrame;
    [self.tabBar insertSubview:tabBarImageView atIndex:4];
    
    [self.tabBar setClipsToBounds:YES];    
    // 设置item位置的样式
    self.tabBar.itemPositioning = UITabBarItemPositioningCentered;
    self.tabBar.itemSpacing = 0;
    self.tabBar.itemWidth = kScreenWidth/4;
    self.customTabBar = tabBarImageView;
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setBadgeValue:(NSString *)badgeValue forItemAtIndex:(NSInteger)index
{
    if (index < self.customTabBar.customTabBarItems.count) {
        VVTabBarItem *item = self.customTabBar.customTabBarItems[index];
        item.badgeValue = badgeValue;
    }
}

- (void)selectViewControllerAtIndex:(NSInteger )index
{
    if (index < self.viewControllers.count) {
        self.selectedIndex =  index;
        self.customTabBar.selectedIndex = index;
    }
}

- (void)showBadgeAtIndex:(NSInteger)index show:(BOOL)showed;
{
    if (index < self.customTabBar.customTabBarItems.count) {
        VVTabBarItem *item = self.customTabBar.customTabBarItems[index];
        item.showRed = showed;
    }
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    self.customTabBar.selectedIndex = index;
    if (index == 1) {
        [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] clearBillStatus];
    }
    if (index == 2) {
        [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] saveTimeStamp];
        [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] clearMessageStatus];
    }
       return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   
}

@end
