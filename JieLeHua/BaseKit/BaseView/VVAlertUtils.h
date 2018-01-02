//
//  VVAlertUtils.h
//  VCREDIT
//
//  Created by kevin on 15-3-5.
//  Copyright (c) 2015年  vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVAlertView.h"
@interface VVAlertUtils : NSObject

/*  block 形式调用alertView */
+ (VVAlertView*)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                            customView :(UIView *) view
                      cancelButtonTitle:(NSString *)cancelTitle
                      otherButtonTitles:(NSArray *)otherButtonTitles
                                    tag:(NSInteger)tag
                          completeBlock:(VVAlertViewBlock)block;

/*  只接受message,cancelTitle参数 其他为nil */
+ (VVAlertView *)showAlertViewWithMessage:(NSString *)message
                         cancelButtonTitle:(NSString*)cancelTitle
                                       tag:(NSInteger)tag
                             completeBlock:(VVAlertViewBlock)block;

@end
