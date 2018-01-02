//
//  JJJsonTransformation.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/10/27.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJJsonTransformation.h"

@implementation JJJsonTransformation
+(JJJsonTransformation*)sharedInstance{
    static JJJsonTransformation *tool;
    static dispatch_once_t toolonce;
    dispatch_once(&toolonce, ^{
        tool = [[JJJsonTransformation alloc] init];
    });
    return tool;
}

// JSON字符串 --- > NSArray/NSDictionary
-(id)stringToNSArrayOrNSDictionaryWithString:(NSString *)string
{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

// NSArray-->JSON字符串
- (NSString *)toJSONData:(id)theData{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData  options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if ([jsonData length] > 0 && error == nil){
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

@end
