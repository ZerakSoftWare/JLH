//
//  CheckUpdateRequest.m
//  JieLeHua
//
//  Created by kuang on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "CheckUpdateRequest.h"

@implementation CheckUpdateRequest

- (NSString *)apiMethodName
{
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@/%@/%@",CheckUpdateUrl,@"ios",versionStr];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

@end
