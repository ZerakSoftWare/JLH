//
//  NSObject+Swizzling.m
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


+ (BOOL)gl_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)gl_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) gl_swizzleMethod:origSel withMethod:altSel];
}

@end