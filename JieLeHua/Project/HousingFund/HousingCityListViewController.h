//
//  HousingCityListViewController.h
//  JieLeHua
//
//  Created by admin2 on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "VVBaseViewController.h"
@class HouseCityModel;

#pragma mark Constants

typedef void (^SelectHouseCityBlock)(HouseCityModel *selectModel);

#pragma mark - Enumerations


#pragma mark - Class Interface

@interface HousingCityListViewController : VVBaseViewController


#pragma mark - Properties

@property (nonatomic, copy) SelectHouseCityBlock selectBlock;

//--对服务器返回的数据升序后的数据
@property (strong, nonatomic) NSMutableArray *dataSource;

#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods


@end
