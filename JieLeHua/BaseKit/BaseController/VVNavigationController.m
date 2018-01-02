//
//  UPNavigationController.m
//  CHSP
//
//  Created by wxzhao on 12-11-30.
//
//

#import "VVNavigationController.h"

#import "JJBillViewController.h"
#import "JJHomeViewController.h"
#import "JJFindViewController.h"
#import "JJMineViewController.h"


#import "VVTabBarViewController.h"
#import "JJBillAndNotiCountManager.h"
#import "LoginViewController.h"
@interface VVNavigationController ()
{
     //NSMutableArray* _alertArray;//对话框
    NSMutableArray* _toastArray;//toast
    NSMutableArray *_presentVcArray;
}
@property (assign, nonatomic) BOOL isSwitching;

@end

@implementation VVNavigationController
- (void)dealloc
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _addVCs=[[NSMutableArray alloc] init];
        _removeVCs = [[NSMutableArray alloc] init];
        //_alertArray = [[NSMutableArray alloc] initWithCapacity:0];
        _toastArray = [[NSMutableArray alloc] initWithCapacity:0];
        _presentVcArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

// pre-iOS 6 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (_addVCs.count > 0 || _removeVCs.count > 0) {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.viewControllers];
        
        [viewControllers addObjectsFromArray:_addVCs];
        [viewControllers removeObjectsInArray:_removeVCs];
        [self setViewControllers: viewControllers animated: animated];
        
        [_addVCs removeAllObjects];
        [_removeVCs removeAllObjects];
    }
    self.isSwitching = NO; // 3. 还原状态
}

- (void)initControllers {
//    if (VV_App.naviController.viewControllers.count > 0) {
//        [VV_App.naviController popToRootViewControllerAnimated:NO];
//        VV_App.naviController.viewControllers = @[];
//    }
    
    VVTabBarViewController *tabVC = [[VVTabBarViewController alloc] init];
    tabVC.view.backgroundColor = [UIColor whiteColor];
    VV_App.tabBarController = tabVC;

    //替换root controller
    [VV_App.naviController setViewControllers:@[VV_App.tabBarController] animated: NO];
}

- (void)addTabBarController
{
    JJHomeViewController *vc1 = [[JJHomeViewController alloc] init];
    JJBillViewController *vc2 = [[JJBillViewController alloc] init];
    JJFindViewController *vc3 = [[JJFindViewController alloc] init];
    JJMineViewController *vc4 = [[JJMineViewController alloc] init];
    
    [VV_App.tabBarController setViewControllers:@[vc1,vc2,vc3,vc4] animated:NO];
    [self getRedStatus];
}

#pragma mark - 获取小红点状态
- (void)getRedStatus
{
    if ([UserModel isLoggedIn]) {
        [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] updateNotiCount];
    }else{
        [[JJBillAndNotiCountManager sharedBillAndNotiCountManager] clearRedStatus];
    }
}


// 重载 push 方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        if (self.isSwitching) {
            return; // 1. 如果是动画，并且正在切换，直接忽略
        }
        self.isSwitching = YES; // 2. 否则修改状态
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 弹出登录界面
- (void)presentLoginViewController {
   __block double delayInSeconds = 0.1f;
    UIViewController *na = [self activityViewController];
    [na dismissViewControllerAnimated:NO completion:nil];
    
    [_presentVcArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UINavigationController *nav = (UINavigationController *)obj;
        [nav dismissViewControllerAnimated:NO completion:nil];
    }];
    [_presentVcArray removeAllObjects];
    //解决Unbalanced calls to begin/end appearance transitions for UITabBarController
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoginViewController *login = [[LoginViewController alloc] init];
        VVNavigationController *nav = [[VVNavigationController alloc] initWithRootViewController:login];
        [VV_App.naviController initControllers];
        [VV_App.naviController addTabBarController];
        
        [VV_App.naviController presentViewController:nav animated:YES completion:^{
            
        }];
    });
}

- (void)presentViewC:(id )VC animated:(BOOL)flag completion:(void (^)(void))completion{
    [_presentVcArray addObject:VC];
    [self presentViewController:VC animated:flag completion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)dismissViewC:(id )VC  Animated:(BOOL)flag completion:(void (^)(void))completion{
    [_presentVcArray removeObject:VC];
    [VC dismissViewControllerAnimated:flag completion:^{
        if (completion) {
            completion();
        }
    }];    
    
}
// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}



#pragma mark - 
- (void)hideFlashInfo
{
    [_toastArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    }];
    [_toastArray removeAllObjects];
}

- (void)showFlashInfo:(NSString*)info
{
    
    [self hideFlashInfo];
    if (!VV_IS_NIL(info)) {
//        CGSize size = kCommonToastSize;
//        VVToast* toast = [[[[VVToast makeText:info]
//                             setGravity:kToastGravityCenter]
//                            setDuration:kToastDurationNormal]
//                           setSize:size];
//        [toast show];
//        [_toastArray addObject:toast];
    }
}

@end
