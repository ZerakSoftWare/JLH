//
//  AmountStatusView.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStatusProtocal.h"
#import "JJMainStateModel.h"
@interface AmountStatusView : UIView
@property (nonatomic, weak)id <HomeStatusProtocal> delegate;
+ (instancetype)amountStatusWithType:(HomeStatus)type frame:(CGRect)frame;
- (void)updateUIWithData:(JJMainStateSummaryModel *)data type:(HomeStatus)type;
@end
