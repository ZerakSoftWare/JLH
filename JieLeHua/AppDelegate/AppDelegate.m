//
//  AppDelegate.m
//  JieLeHua
//
//  Created by YuZhongqi on 16/12/21.
//  Copyright © 2016年 Vcredict. All rights reserved.
//

#import "AppDelegate.h"
#import "CheckUpdateCommand.h"
#import "CommandManage.h"
//第三方引入


#import "VVWelcomeViewController.h"
#import "VVNavigationController.h"
#import "VVTabBarViewController.h"
#import "JJRouterManager.h"
#import "KSKit.h"

//友盟推送
#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

//#if DEBUG
//#import "JLHHotE.h"
//#endif
#ifdef JIELEHUAQUICK
#import "JJReviewManager.h"
#endif
#import "JJServiceTipView.h"

#import "AppDelegate+HelpDesk.h"
#import <FMDeviceManagerFramework/FMDeviceManager.h>
#import "JJHomeVipShowManager.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) JJServiceTipView *tipView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//#if DEBUG
//    [JLHHotE startHot];
//    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
//    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
//    [JLHHotE evaluateScript:script];
//#endif
//#if DEBUG
//        [[FLEXManager sharedManager] showExplorer];
//#endif

    //--初始化环信客服SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];

    //--添加自定义小表情
#pragma mark smallpngface
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapePattern:@"\\[[^\\[\\]]{1,3}\\]"];
    [[HDEmotionEscape sharedInstance] setEaseEmotionEscapeDictionary:[HDConvertToCommonEmoticonsHelper emotionsDictionary]];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"ModulesRegister" ofType:@"plist"];

    KSAppDelegateManager *manager = [KSAppDelegateManager sharedInstance];
    [manager loadModulesWithPlistFile:plistPath];
    
    [manager application:application didFinishLaunchingWithOptions:launchOptions];
    //推送
    [self initUMPushWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    VVWelcomeViewController *welcomeVc = [[VVWelcomeViewController alloc]init];
    self.naviController = [[VVNavigationController alloc] initWithRootViewController:welcomeVc];
    self.window.rootViewController = self.naviController;
    VV_SHDAT.navi = self.naviController;

    [self.window makeKeyAndVisible];
    
    [[JJRouterManager sharedRouterManager] setupRouter];
    [self configGlobalNavigation];
    [self systemInformationHandle];
    [self setupNetwork];
    [self setupTongdun];
//    [self setupBaidu];
    /*  检查版本更新
     */
    [self checkUpdate];
    //请求基本信息
    [self getBasicDictionaries];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithToken:) name:JJToken_Failure object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithServiceOut:) name:JJServiceOut object:nil];

 
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [self addSkipBackupAttributeToItemAtPath:documentPath];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    VVLog(@"%@",documentPath);
    
    
#ifdef JIELEHUAQUICK
    JJReviewManager *reviewManager = [JJReviewManager reviewManager];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    if (time < 1498838400) {
        reviewManager.reviewing = YES;
    }
#endif
    return YES;
}

//- (void)setupBaidu
//{
//    [[BDRimSDKMainManager shareInstance] configWithParams:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"3100253001",@"rimid", nil]];
//}

- (void)setupTongdun
{
    //
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    // SDK
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    /*
     * SDK *
     *
     */
   
    // Appstore
    //
    //
#if DEBUG
    [options setValue:@"allowd" forKey:@"allowd"]; // TODO
    [options setValue:@"sandbox" forKey:@"env"]; // TODO
    [options setValue:@"doudouhua" forKey:@"partner"];
#else
    [options setValue:@"vcredit" forKey:@"partner"];
#endif
    // SDK
    manager->initWithOptions(options);
}

- (void)setupNetwork{
#if DEBUG
    KZNetworkingConfig *config = [KZNetworkingConfig sharedInstance];
    config.mainBaseUrl = APP_BASE_URL;
#else
    KZNetworkingConfig *config = [KZNetworkingConfig sharedInstance];
    config.mainBaseUrl = APP_BASE_URL;
#endif
}

-(void)systemInformationHandle{

}

//全局navigationBar返回样式
- (void)configGlobalNavigation {
    UIImage *image = [UIImage imageNamed:@"btn_nav_bar_return"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UINavigationBar appearance].backIndicatorImage = image;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    UIOffset offset;
    offset.horizontal = -vScreenWidth;
    [buttonItem setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [[KSAppDelegateManager sharedInstance] applicationWillResignActive:application];
    //hook array的方法导致崩溃解决方案 1.加no-arc标志2或者加下句 ios8 9 崩溃
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[KSAppDelegateManager sharedInstance] applicationDidEnterBackground:application];
    [self.tipView removeFromSuperview];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[KSAppDelegateManager sharedInstance] applicationWillEnterForeground:application];
    /*  检查版本更新+检测服务器是否维护中code=602
     */
    [self checkUpdate];
}

- (void)checkUpdate
{
    CheckUpdateCommand *checkUpdateCmd = [CheckUpdateCommand command];
    [CommandManage excuteCommand:checkUpdateCmd completeBlock:^(id<Command> cmd) {
        
        switch (checkUpdateCmd.updateType) {
            case NoUpdate:  //没有更新
                break;
            case MustUpdate: //强制更新
            {
                
            }
                break;
            case UpdatePrompt:   //不强更，提示更新
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新版本更新" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:checkUpdateCmd.updateUrl]];
                }];
                [alert addAction:updateAction];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
                break;
            case UnKnownUpadte: //未知状态
            default:
                break;
        }
        
    }];
}

/**
 * 请求基本信息
 */
- (void)getBasicDictionaries{
    
    NSString *plistPath = [VVPathUtils basicPlistPath];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [[VVNetWorkUtility netUtility] getCommonDictionariesSuccess:^(id result) {
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            NSArray *dataDic = [result safeObjectForKey:@"data"];
            [fileMgr removeItemAtPath:plistPath error:nil];
            BOOL isWrited  =   [dataDic writeToFile:plistPath atomically:YES];
            VVLog(@"dataDicwriteToFile:%d",isWrited);
        }
    } failure:^(NSError *error) {
        //        [VLToast showWithText:[self strFromErrCode:error]];
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[KSAppDelegateManager sharedInstance] applicationDidBecomeActive:application];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[KSAppDelegateManager sharedInstance] applicationWillTerminate:application];
}


#pragma mark - UMPush

- (void)initUMPushWithOptions:(NSDictionary *)launchOptions
{
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:kUM_PushAppKey launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    
    [UMessage setAutoAlert:NO];
    
    //友盟统计
    UMConfigInstance.appKey = kUM_ClickAppKey;
    [MobClick startWithConfigure:UMConfigInstance];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许

        } else {
            //点击不允许
            
        }
    }];
}

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[KSAppDelegateManager sharedInstance] application:application didRegisterUserNotificationSettings:notificationSettings];
}

//注册devicetoken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[KSAppDelegateManager sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    NSString *deviceTokenStr = [self stringDevicetoken:deviceToken];
    
    VVLog(@"deviceToken----%@", deviceTokenStr);
    
    VV_SHDAT.deviceToken = deviceTokenStr;
}

//注册devicetoken不成功
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[KSAppDelegateManager sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
     //如果注册不成功，打印错误信息
     VVLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[KSAppDelegateManager sharedInstance] application:application didReceiveRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    //关闭友盟自带的弹出框
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS7及以上系统
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[KSAppDelegateManager sharedInstance] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[KSAppDelegateManager sharedInstance] application:application performFetchWithCompletionHandler:completionHandler];
}

#pragma mark - 推送ios10新增
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    [[KSAppDelegateManager sharedInstance] userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    else
    {
        //应用处于前台时的本地推送接受
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    [[KSAppDelegateManager sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    else
    {
        //应用处于后台时的本地推送接受
    }
}

#pragma mark - deviceToken

- (NSString *)stringDevicetoken:(NSData *)deviceToken
{
    NSString *token = [deviceToken description];
    NSString *pushToken = [[[token stringByReplacingOccurrencesOfString:@"<"withString:@""]
                            stringByReplacingOccurrencesOfString:@">"withString:@""]
                           stringByReplacingOccurrencesOfString:@" "withString:@""];
    return pushToken;
}

#pragma mark - Token失效处理
- (void)dealWithToken:(NSNotification *)noti
{
    VVLog(@"%@",noti.object);
    [[UserModel currentUser] clear];
    [JJHomeVipShowManager homeVipShowManager].isVipShowed = NO;//清除isVipShowed
    [JJHomeVipShowManager homeVipShowManager].isVipShowedWithdrawing = NO;//清除isVipShowedWithdrawing
    [VVAlertUtils showAlertViewWithTitle:@"提示" message:[noti.object safeObjectForKey:@"message"] customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex  != kCancelButtonTag) {
            [alertView hideAlertViewAnimated:YES];
            [[JCRouter shareRouter] presentURL:@"login" withNavigationClass:[AppNavigationController class] completion:nil];
        }
    }];
}

- (void)dealWithServiceOut:(NSNotification *)noti
{
    if (_tipView == nil) {
        _tipView = [[JJServiceTipView alloc] initServiceTipWithFrame:self.window.frame];
    }
    [self.window addSubview:_tipView];
}

#pragma mark - iCloud 备份去掉
//移除backup
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    
    if([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]){
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            VVLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    
    return NO;
}

#pragma mark - scheme url
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[KSAppDelegateManager sharedInstance] application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [[KSAppDelegateManager sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[KSAppDelegateManager sharedInstance] application:app openURL:url options:options];
}

@end
