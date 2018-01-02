//
//  JJHuabeiImageModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJHuabeiImageModel : NSObject
@property (nonatomic, copy) NSString *EndTime;
@property (nonatomic, copy) NSString *Result;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *StatusCode;
@property (nonatomic, copy) NSString *StatusDescription;
@property (nonatomic, copy) NSString *Token;
@property (nonatomic, copy) NSString *VerCodeBase64;
@property (nonatomic, copy) NSString *VerCodeRefreshUrl;
@property (nonatomic, copy) NSString *VerCodeUrl;
@property (nonatomic, copy) NSString *nextProCode;
@end
