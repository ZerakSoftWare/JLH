//
//  HouseLoginModel.m
//  JieLeHua
//
//  Created by admin2 on 2017/8/17.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "HouseLoginModel.h"

@implementation HouseLoginModel

+ (NSDictionary *)objectClassInArray{
    return @{@"FormParams" : [HouseFormparams class]};
}
@end

@implementation HouseFormparams

+ (NSDictionary *)objectClassInArray{
    return @{@"ParameterExt" : [HouseParameterext class]};
}

@end


@implementation HouseParameterext

@end


