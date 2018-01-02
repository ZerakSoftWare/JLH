//
//  JJGetBillDetailByIdRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetBillDetailByIdRequest.h"

@interface JJGetBillDetailByIdRequest()
@property (nonatomic, copy) NSString *drawMoneyApplyId;
@end

@implementation JJGetBillDetailByIdRequest
- (instancetype)initWithDrawMoneyApplyId:(NSString *)drawMoneyApplyId
{
    if (self = [super init]) {
        self.drawMoneyApplyId = drawMoneyApplyId;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:JJGetBillDetailByIdUrl,self.drawMoneyApplyId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJBillDetailModel *)response
{
    JJBillDetailModel *model = [JJBillDetailModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
