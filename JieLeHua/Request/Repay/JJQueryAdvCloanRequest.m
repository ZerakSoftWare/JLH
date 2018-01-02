//
//  JJQueryAdvCloanRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJQueryAdvCloanRequest.h"

@implementation JJQueryAdvCloanRequest
- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@%@",App_Loan_Url,JJAdvCloanUrl];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodPost;
}

- (JJCloanInfoModel *)response
{
    JJCloanInfoModel *model =[JJCloanInfoModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
