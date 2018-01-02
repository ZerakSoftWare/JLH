//
//  ViewController.h
//  LocateCity
//
//  Created by ios3 on 14-11-11.
//  Copyright (c) 2014年 ios3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface CommandManage : NSObject

+ (CommandManage *)sharedInstance;

@property (strong) NSMutableArray     *commandQueues;

+ (void)excuteCommand:(id<Command>)cmd observer:(id<CommandDelegate>)observer;
+ (void)excuteCommand:(id<Command>)cmd completeBlock:(CommandCallBackBlock)block;

+ (void)cancelCommand:(id<Command>)cmd;
+ (void)cancelCommandByClass:(Class)cls;
+ (void)cancelCommandByObserver:(id)observer;

+ (id)isExcuteingCommand:(Class)cls;

@end
