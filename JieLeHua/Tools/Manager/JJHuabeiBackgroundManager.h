//
//  JJHuabeiBackgroundManager.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJHuabeiBackgroundManager : NSObject
+ (JJHuabeiBackgroundManager *)huabeiBackgroundManager;
- (void)getSummaryWithToken:(NSString *)token;
@end
