//
//  JJBillListRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBillListRequest.h"

@implementation JJBillListRequest
- (NSString *)apiMethodName
{
    return JJUserBillListUrl;
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJBillListModel *)response
{
    JJBillListModel *model = [JJBillListModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
