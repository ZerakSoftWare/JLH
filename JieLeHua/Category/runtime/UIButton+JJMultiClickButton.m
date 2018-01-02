//
//  UIButton+JJMultiClickButton.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "UIButton+JJMultiClickButton.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation UIButton (JJMultiClickButton)
// 因category不能添加属性，只能通过关联对象的方式。
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

- (NSTimeInterval)vv_acceptEventInterval {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setVv_acceptEventInterval:(NSTimeInterval)vv_acceptEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(vv_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)vv_acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setVv_acceptEventTime:(NSTimeInterval)vv_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(vv_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// 在load时执行hook
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self gl_swizzleMethod:@selector(sendAction:to:forEvent:) withMethod:@selector(vv_sendAction:to:forEvent:)];
    });
}

- (void)vv_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {

    if ([NSStringFromClass([self class]) isEqualToString:@"CUShutterButton"] || [NSStringFromClass([self class]) isEqualToString:@"CAMShutterButton"]) {
        [self vv_sendAction:action to:target forEvent:event];
        return;
    }
    
    if (self.vv_acceptEventInterval <= 0) {
        self.vv_acceptEventInterval = 1;
        if ([ NSStringFromClass([self class]) isEqualToString:@"VVCustomSwitchBtn"]) {
            self.vv_acceptEventInterval = 0.1;
        }
    }
    if ([NSDate date].timeIntervalSince1970 - self.vv_acceptEventTime < self.vv_acceptEventInterval) {
        return;
    }
    
    if (self.vv_acceptEventInterval > 0) {
        self.vv_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    
    [self vv_sendAction:action to:target forEvent:event];
}

@end
