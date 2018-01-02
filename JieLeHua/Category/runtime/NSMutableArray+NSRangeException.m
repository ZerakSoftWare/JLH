//
//  NSMutableArray+NSRangeException.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/23.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "NSMutableArray+NSRangeException.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"
@implementation NSMutableArray (NSRangeException)
//__NSArrayM (可变数组) __NSArrayI (一般数组) __NSArray0 (一般的空数组)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(mutableObjectIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(mutableInsertObject:atIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(integerValue) swizzledSelector:@selector(replace_integerValue)];
        }
    });
}

- (id)mutableObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self mutableObjectIndex:index];
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }
}

- (NSInteger)replace_integerValue {
    return 0;
}


@end
