//
//  JJGetRedIsNewRequest.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGetRedIsNewRequest.h"

@interface JJGetRedIsNewRequest ()
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *timeStamp;
@end

@implementation JJGetRedIsNewRequest
- (instancetype)initWithCustomerId:(NSString *)customerId timeStamp:(NSString *)timeStamp
{
    if (self = [super init]) {
        self.customerId = customerId;
        self.timeStamp = timeStamp;
    }
    return self;
}

- (NSString *)apiMethodName
{
    return [NSString stringWithFormat:@"%@/%@/%@",JJRedIsNewUrl,self.customerId,self.timeStamp];
}

- (KZRequestMethod)requestMethod
{
    return KZRequestMethodGet;
}

- (JJRedIsNewModel *)response
{
    JJRedIsNewModel *model = [JJRedIsNewModel mj_objectWithKeyValues:self.responseJSONObject];
    return model;
}

@end
