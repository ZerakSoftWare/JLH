//
//  VVReachabilityTool.m
//  O2oApp
//
//  Created by YuZhongqi on 16/4/23.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVReachabilityTool.h"

@implementation VVReachabilityTool
//判断有没有网络
+(BOOL)connectionInternet
{
    //1.发送网络请求
    Reachability *reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status=[reach currentReachabilityStatus];
    if(status==NotReachable){
        return NO; //没有网络
    }
    
    return YES;
}
@end
