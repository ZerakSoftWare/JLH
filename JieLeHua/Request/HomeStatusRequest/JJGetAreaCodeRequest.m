//
//  JJGetAreaCodeRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/13.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJGetAreaCodeRequest.h"

@implementation JJGetAreaCodeRequest
- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@%@",App_Loan_Url,JJGetAreaCodeUrl];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}
@end
