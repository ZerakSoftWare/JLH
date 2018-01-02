//
//  JJGetTipsRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/12/4.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetTipsRequest.h"

@interface JJGetTipsRequest()
@property (nonatomic, assign) NSString *type;
@end

@implementation JJGetTipsRequest
- (instancetype)initWithType:(NSString *)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:JJGetTipsUrl,self.type];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJTipsModel *)response
{
    JJTipsModel *model = [JJTipsModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}
@end
