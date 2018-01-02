//
//  JJJsonTransformation.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/27.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJJsonTransformation : NSObject

+(JJJsonTransformation*)sharedInstance;

// String --- > NSArray/NSDictionary
-(id)stringToNSArrayOrNSDictionaryWithString:(NSString *)string;

// JSON-->NSArray
- (NSString *)toJSONData:(id)theData;

@end
