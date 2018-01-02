//
//  HouseLoginModel.h
//  JieLeHua
//
//  Created by admin2 on 2017/8/17.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HouseFormparams,HouseParameterext;

@interface HouseLoginModel : NSObject

@property (nonatomic, strong) NSArray<HouseFormparams *> *FormParams;

@property (nonatomic, copy) NSString *LoginTypeName;

@property (nonatomic, assign) NSInteger HasVerCode;

@property (nonatomic, copy) NSString *LoginTypeCode;

@end

@interface HouseFormparams : NSObject

@property (nonatomic, strong) NSArray<HouseParameterext *> *ParameterExt;

@property (nonatomic, copy) NSString *ParameterName;

@property (nonatomic, copy) NSString *ParameterType;

@property (nonatomic, assign) NSInteger Orderby;

@property (nonatomic, copy) NSString *ParameterCode;

@property (nonatomic, copy) NSString *ParameterMessage;

@end

@interface HouseParameterext : NSObject

@property (nonatomic, copy) NSString *Regex;

@property (nonatomic, copy) NSString *Lable;

@property (nonatomic, copy) NSString *Value;

@property (nonatomic, copy) NSString *Msg;

@end

