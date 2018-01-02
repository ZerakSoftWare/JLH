//
//  BillStatusDetailView.h
//  JieLeHua
//
//  Created by pingyandong on 2017/11/17.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStatusProtocal.h"
#import "JJMainStateModel.h"


@interface BillStatusDetailView : UIView
@property (nonatomic, weak)id <HomeStatusProtocal> delegate;
+ (instancetype)billStatusWithType:(HomeStatus)type frame:(CGRect)frame;;
- (void)updateUIWithData:(JJMainStateSummaryModel *)data type:(HomeStatus)type;
@end
