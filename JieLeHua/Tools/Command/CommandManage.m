//
//  ViewController.h
//  LocateCity
//
//  Created by ios3 on 14-11-11.
//  Copyright (c) 2014年 ios3. All rights reserved.
//

#import "CommandManage.h"

@implementation CommandManage

+ (CommandManage *)sharedInstance
{
    static dispatch_once_t once;
    static CommandManage * __singleton__;
    dispatch_once( &once, ^{
        __singleton__ = [[CommandManage alloc] init];
    } );
    return __singleton__;
};

- (id)init
{
    self = [super init];
    if (self) {
        self.commandQueues = [NSMutableArray array];
    }
    return self;
}

+ (void)excuteCommand:(id<Command>)cmd observer:(id<CommandDelegate>)observer
{
    if (cmd && ![self isExcuteingCommand:[cmd class]])
    {
        [[CommandManage sharedInstance] excuteCommand:cmd observer:observer];
    }
}

- (void)excuteCommand:(id<Command>)cmd observer:(id<CommandDelegate>)observer
{
    [self.commandQueues addObject:cmd];
    cmd.delegate = observer;
    [cmd execute];
}

+ (void)excuteCommand:(id<Command>)cmd completeBlock:(CommandCallBackBlock)block
{
    if (cmd && ![self isExcuteingCommand:[cmd class]])
    {
        [[CommandManage sharedInstance] excuteCommand:cmd completeBlock:block];
    }
}

- (void)excuteCommand:(id<Command>)cmd completeBlock:(CommandCallBackBlock)block
{
    [self.commandQueues addObject:cmd];
    cmd.callBackBlock = block;
    [cmd execute];
}


+ (void)cancelCommand:(id<Command>)cmd
{
    if (cmd) {
        [cmd cancel];
        [[CommandManage sharedInstance].commandQueues removeObject:cmd];
    }
}

+ (void)cancelCommandByClass:(Class)cls
{
    NSArray *tempArr = [NSArray arrayWithArray:[CommandManage sharedInstance].commandQueues];
    for (id<Command> cmd in tempArr)
    {
        if ([cmd isKindOfClass:cls])
        {
            [cmd cancel];
            [[CommandManage sharedInstance].commandQueues removeObject:cmd];
        }
    }
}

+ (void)cancelCommandByObserver:(id)observer
{
    if (!observer)
    {
        return;
    }
    
    NSArray *tempArr = [NSArray arrayWithArray:[CommandManage sharedInstance].commandQueues];
    for (id<Command> cmd in tempArr)
    {
        if (cmd.delegate == observer)
        {
            [cmd cancel];
            [[CommandManage sharedInstance].commandQueues removeObject:cmd];
        }
    }
}

+ (id)isExcuteingCommand:(Class)cls
{
    NSArray *tempArr = [NSArray arrayWithArray:[CommandManage sharedInstance].commandQueues];
    for (id cmd in tempArr)
    {
        if ([cmd isKindOfClass:cls]) {
            return cmd;
        }
    }
    return nil;
}

@end
