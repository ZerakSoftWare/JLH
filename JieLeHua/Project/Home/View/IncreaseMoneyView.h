//
//  IncreaseMoneyView.h
//  JieLeHua
//
//  Created by pingyandong on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStatusProtocal.h"
#import "JJMainStateModel.h"

/***
 花呗 公积金提额首页UI
 ***/
@interface IncreaseMoneyView : UIView
@property (nonatomic, weak)id <HomeStatusProtocal> delegate;
+ (instancetype)increaseStatusWithType:(HomeStatus)type frame:(CGRect)frame;;
- (void)updateUIWithData:(JJMainStateModel *)data type:(HomeStatus)type;

@end
