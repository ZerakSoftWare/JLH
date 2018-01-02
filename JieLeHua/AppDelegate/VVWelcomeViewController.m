//
//  VVWelcomeViewController.m
//  VCREDIT
//
//  Created by chenlei on 14-3-28.
//  Copyright (c) 2014年  vcredit. All rights reserved.
//

#import "VVWelcomeViewController.h"
#import "VVTabBarViewController.h"
#import "VVNavigationController.h"
#import "GuideViewController.h"
#import "EmployeeWebViewController.h"
#ifdef JIELEHUA
#import "IntroduceRootViewController.h"
#endif
//#include <CoreGraphics/CoreGraphics.h>
//#include "CGImageMetadata.h"

@interface VVWelcomeViewController ()
{
    UIImageView* _welcomeImageView;
    GuideViewController *_guideVC;
}
@end

@implementation VVWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //判断是不是第一次启动应用
    BOOL showGuideVC = [GuideViewController shouldShowGuide];
    
    if (showGuideVC)
    {
        [self showGuideScrollView];
    }
    else
    {
        _welcomeImageView.image = [VVUtils image568H:@"LaunchImage"];

        [self toHomeVC];
    }
}

- (void)showGuideScrollView
{
    UIButton *enterBtn = [[UIButton alloc] init];
    [enterBtn setBackgroundColor:[UIColor clearColor]];
    [enterBtn setFrame:(CGRect){0.0, 0, vScreenWidth, vScreenHeight}];
    [enterBtn addTarget:self action:@selector(didClickedBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    __weak typeof(self) weakSelf = self;
#if JIELEHUA
    GuideViewController *guideVC = [GuideViewController guidewithImageName:@"guide"
                                                                imageCount:3
                                                           showPageControl:YES
                                                               enterButton:enterBtn pointOtherColor:[UIColor grayColor]
                                                         pointCurrentColor:[UIColor whiteColor]
                                                               finishBlock:^
                                    {
                                        [weakSelf enterMainVC];
                                    }];
    
#else
    GuideViewController *guideVC = [GuideViewController guidewithImageName:@"guide"
                                                                imageCount:3
                                                           showPageControl:YES
                                                               enterButton:enterBtn pointOtherColor:[UIColor clearColor]
                                                         pointCurrentColor:[UIColor clearColor]
                                                               finishBlock:^
                                    {
                                        [weakSelf enterMainVC];
                                    }];

#endif
    
    guideVC.statusBarStyle = GuideStatusBarStyleWhite;
    
    _guideVC = guideVC;
    
    [self.view addSubview:_guideVC.view];
}

- (void)didClickedBtn
{
    [self enterMainVC];
}

#pragma mark - 进入主界面

- (void)enterMainVC
{
    [self toHomeVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toHomeVC{
      /**
     根据NSUserDefaults中是否有值来判断员工是否登录
     */
    NSString *salesId = [[NSUserDefaults standardUserDefaults] objectForKey:@"JJEmployeSalesId"];
    if (salesId.length > 0)
    {
#if JIELEHUA
        IntroduceRootViewController *rootVC = [[IntroduceRootViewController alloc] init];
//        rootVC.url = url;
        [VV_App.naviController presentViewC:rootVC animated:YES completion:nil];
#endif
//        [VV_App.naviController pushViewController:rootVC animated:YES];
    }
    else{
        [VV_App.naviController initControllers];
        [VV_App.naviController addTabBarController];
    }
}

//比较版本号大小
- (BOOL )compareString:(NSString *)version str:(NSString *)str{
    
    NSArray *strArray = [version componentsSeparatedByString:@"."];
    NSArray *strArray1 = [str componentsSeparatedByString:@"."];

    if ([strArray count] > 1) {
      version  = [strArray[0] stringByAppendingString:strArray[1]];
    }
    if ([strArray1 count] >1) {
        str = [strArray1[0] stringByAppendingString:strArray1[1]];
    }
     BOOL result = [version compare:str] == NSOrderedDescending;
    return result;
}









@end
