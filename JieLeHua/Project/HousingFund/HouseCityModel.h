//
//  HouseCityModel.h
//  JieLeHua
//
//  Created by admin2 on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseCityModel : NSObject

@property (nonatomic, copy) NSString *ProvinceName;

@property (nonatomic, assign) BOOL Online;

@property (nonatomic, strong) NSArray<NSString *> *OrderList;

@property (nonatomic, assign) NSInteger Status;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *CityName;

@property (nonatomic, strong) NSArray<NSString *> *KeyWords;

@property (nonatomic, copy) NSString *CityCode;

@property (nonatomic, copy) NSString *sortWords;

@end
