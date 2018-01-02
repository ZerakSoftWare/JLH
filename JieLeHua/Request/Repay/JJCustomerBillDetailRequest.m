//
//  JJCustomerBillDetailRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJCustomerBillDetailRequest.h"

@interface JJCustomerBillDetailRequest ()
@property (nonatomic, copy) NSString *billId;
@end

@implementation JJCustomerBillDetailRequest
- (instancetype)initWithCustomerBillId:(NSString *)billId
{
    if (self = [super init]) {
        self.billId = billId;
    }
    return self;
}

- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@%@/%@",App_Loan_Url,JJCustomerBillUrl,self.billId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJOverDueListModel *)response
{
    JJOverDueListModel *model = [JJOverDueListModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
