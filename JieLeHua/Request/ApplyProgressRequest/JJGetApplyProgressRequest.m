//
//  JJGetApplyProgressRequest.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/5/17.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetApplyProgressRequest.h"


@implementation JJGetApplyProgressRequest

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/%@",JJGetApplyProgressUrl,[UserModel currentUser].customerId];
}


@end
