//
//  NSArray+Category.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)
//以下写法均防止闪退
+ (instancetype)safeArrayWithObject:(id)object;

- (id)safeObjectAtIndex:(NSUInteger)index;

- (NSArray *)safeSubarrayWithRange:(NSRange)range;

- (NSUInteger)safeIndexOfObject:(id)anObject;

//通过Plist名取到Plist文件中的数组
+ (NSArray *)arrayNamed:(NSString *)name;

// 数组转成json 字符串
- (NSString *)toJSONStringForArray;
@end
