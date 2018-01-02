//
//  ViewController.h
//  LocateCity
//
//  Created by ios3 on 14-11-11.
//  Copyright (c) 2014年 ios3. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommandDelegate;
@protocol Command;

#ifdef NS_BLOCKS_AVAILABLE
typedef void (^CommandCallBackBlock)(id<Command> cmd);
typedef void (^CommandFailerCallBackBlock)( id failed);



#endif


@protocol Command <NSObject>

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, unsafe_unretained) id<CommandDelegate> delegate;
@property (nonatomic, copy)   CommandCallBackBlock callBackBlock;

- (void)execute; //TODO doesn't need super
- (void)cancel;  //TODO need super;
- (void)done;

@end


@protocol CommandDelegate <NSObject>

@optional
- (void)commandDidFinish:(id<Command>)cmd;
- (void)commandDidFailed:(id<Command>)cmd;
@end



@interface Command : NSObject <Command>

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, unsafe_unretained) id<CommandDelegate> delegate;
@property (nonatomic, copy)   CommandCallBackBlock callBackBlock;

+ (id)command;

- (void)execute;
- (void)cancel;
- (void)done;

@end
