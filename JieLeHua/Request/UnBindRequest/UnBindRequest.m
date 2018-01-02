//
//  UnBindRequest.m
//  JieLeHua
//
//  Created by kuang on 2017/3/14.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "UnBindRequest.h"

@implementation UnBindRequest

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"/umeng/unBind/%@",[UserModel currentUser].customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

@end
