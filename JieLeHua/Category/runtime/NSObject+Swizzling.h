//
//  NSObject+Swizzling.h
//  TestDemo
//
//  Created by Bruce on 16/12/22.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
+ (BOOL)gl_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)gl_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel;
@end
