//
//  JJGetCustInfoRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJGetCustInfoRequest.h"

@interface JJGetCustInfoRequest ()
@property (nonatomic, copy) NSString *appleId;
@end

@implementation JJGetCustInfoRequest
- (instancetype)initWithApplyId:(NSString *)appleId
{
    if (self = [super init]) {
        self.appleId = appleId;
    }
    return self;
}

- (BOOL)useCustomApiMethodName
{
    return YES;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@%@/%@",App_Loan_Url,JJGetCustInfoUrl,self.appleId];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJLoanBaseInfoModel *)response
{
    JJLoanBaseInfoModel *model = [JJLoanBaseInfoModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
