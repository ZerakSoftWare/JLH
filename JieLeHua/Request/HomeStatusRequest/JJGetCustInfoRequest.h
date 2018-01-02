//
//  JJGetCustInfoRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseRequest.h"
#import "JJLoanBaseInfoModel.h"

@interface JJGetCustInfoRequest : JJBaseRequest
- (instancetype)initWithApplyId:(NSString *)appleId;
- (JJLoanBaseInfoModel *)response;
@end
