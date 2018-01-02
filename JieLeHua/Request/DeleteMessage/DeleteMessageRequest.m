//
//  DeleteMessageRequest.m
//  JieLeHua
//
//  Created by kuang on 2017/3/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "DeleteMessageRequest.h"

@implementation DeleteMessageRequest

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"/home/deleteAll/%@",[UserModel currentUser].customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

@end
