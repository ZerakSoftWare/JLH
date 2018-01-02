//
//  JJGetDrawResultRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/13.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJGetDrawResultRequest.h"

@implementation JJGetDrawResultRequest
- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@%@",App_Loan_Url,JJGetDrawResulrUrl];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}
@end
