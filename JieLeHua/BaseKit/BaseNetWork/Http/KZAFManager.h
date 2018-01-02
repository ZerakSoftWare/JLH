//
//  KZAFManager.h
//  JieLeHua
//
//  Created by pingyandong on 2017/5/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZAFManager : NSObject
+ (KZAFManager *)sharedManager;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end
