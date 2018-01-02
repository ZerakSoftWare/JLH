//
//  NoAmountView.h
//  JieLeHua
//
//  Created by pingyandong on 2017/7/11.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStatusProtocal.h"
#import "JJMainStateModel.h"
@interface NoAmountView : UIView
@property (nonatomic, weak)id <HomeStatusProtocal> delegate;
+ (instancetype)amountStatusWithType:(HomeStatus)type frame:(CGRect)frame;
- (void)updateUIWithData:(JJMainStateSummaryModel *)data type:(HomeStatus)type;
@end
