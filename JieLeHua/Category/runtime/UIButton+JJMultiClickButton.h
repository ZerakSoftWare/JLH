//
//  UIButton+JJMultiClickButton.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JJMultiClickButton)
@property (nonatomic, assign) NSTimeInterval vv_acceptEventInterval; // 重复点击的间隔

@property (nonatomic, assign) NSTimeInterval vv_acceptEventTime;
@end
