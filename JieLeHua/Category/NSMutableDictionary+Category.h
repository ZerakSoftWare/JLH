//
//  NSMutableDictionary+Category.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/1.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Category)
- (void)safeSetObject:(id)aObj forKey:(id<NSCopying>)aKey;

- (id)safeObjectForKey:(id<NSCopying>)aKey;
@end
