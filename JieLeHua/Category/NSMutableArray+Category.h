//
//  NSMutableArray+Category.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Category)
//以下写法均防止闪退
- (void)safeAddObject:(id)object;

- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index;

- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexs;

- (void)safeRemoveObjectAtIndex:(NSUInteger)index;

- (void)safeRemoveObjectsInRange:(NSRange)range;

@end
