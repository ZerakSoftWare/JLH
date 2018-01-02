//
//  HouseCityModel.m
//  JieLeHua
//
//  Created by admin2 on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "HouseCityModel.h"

@implementation HouseCityModel

- (NSString *)sortWords
{
    NSArray *ary = [_CityCode componentsSeparatedByString:@"_"];
    _sortWords = [ary lastObject];
    return _sortWords;
}

@end
