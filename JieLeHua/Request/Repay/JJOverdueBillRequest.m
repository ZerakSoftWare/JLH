//
//  JJOverdueBillRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJOverdueBillRequest.h"

@interface JJOverdueBillRequest ()
@property (nonatomic, copy) NSString *billId;
@end

@implementation JJOverdueBillRequest
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
    return [NSString stringWithFormat:@"%@%@/%@",App_Loan_Url,JJOverDueBillUrl,self.billId];
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
