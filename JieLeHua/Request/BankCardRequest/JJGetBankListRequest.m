//
//  JJGetBankListRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/20.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetBankListRequest.h"

@implementation JJGetBankListRequest
- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/%@",JJGetBankListUrl,[UserModel currentUser].customerId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJBankListModel *)response
{
    JJBankListModel *model = [JJBankListModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
