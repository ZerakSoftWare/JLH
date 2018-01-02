//
//  JJCommerceModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JJCommerceResultModel : NSObject
@property (nonatomic, assign) float E_commercelimit;//电商额度
@property (nonatomic, copy) NSString *E_commercelimit_Isoverdue;//电商额度是否当前逾期,
@property (nonatomic, copy) NSString *E_commercelimit_In3_use;//近3个月电商额度是否有使用记录
@end

@interface JJCommerceModel : NSObject
@property (nonatomic, copy) NSString *EndTime;
@property (nonatomic, strong) JJCommerceResultModel *Result;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, assign) NSInteger StatusCode;
@property (nonatomic, copy) NSString *StatusDescription;
@property (nonatomic, copy) NSString *Token;
@property (nonatomic, copy) NSString *nextProCode;

@end
