//
//  JJRouterManager.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJRouterManager.h"

@implementation JJRouterManager
+ (instancetype)sharedRouterManager
{
    static JJRouterManager *sharedRouterManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRouterManager = [[self alloc] init];
    });
    return sharedRouterManager;
}

/**
 *
 *注册管理urlRouter
 *
 */
- (void)setupRouter {
    //暂定为代码写死逻辑，后面调整为根据json解析跳转对应router
#ifdef JIELEHUAQUICK
    //    VVLog(@"quick target!!!!!!!");
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"routerQuick" ofType:@"json"];
#else
    //    VVLog(@"normal target!!!!!!");
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:@"router" ofType:@"json"];
#endif
    NSString *routerString = [NSString stringWithContentsOfFile:jsonPath  encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *jsonDict = [routerString mj_JSONObject];
    NSDictionary *routerDict = [jsonDict safeObjectForKey:@"router"];

    for (NSString *key in routerDict.allKeys) {
        [[JCRouter shareRouter] mapKey:key toController:NSClassFromString([routerDict objectForKey:key])];
    }
   //以下无效
//    [self setupLogin];
//    [self setupHomeRouter];
}
@end
