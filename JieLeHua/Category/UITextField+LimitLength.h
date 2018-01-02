//
//  UITextField+LimitLength.h
//  JRFProject
//
//  Created by feng jia on 15-2-6.
//  Copyright (c) 2015年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditEndBlock)(NSString *text);

@interface UITextField (LimitLength)

/**
 *  限制字数输入
 */
- (void)limitTextLength:(int)length block:(EditEndBlock)block;

@end
