//
//  JJHomeNoApplyView.h
//  JieLeHua
//
//  Created by pingyandong on 2017/5/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeStatusProtocal.h"
#import "JJMainStateModel.h"
@interface JJHomeNoApplyView : UIView
@property (nonatomic, weak)id <HomeStatusProtocal> delegate;
+ (instancetype)noApplyWithType:(HomeStatus)type frame:(CGRect)frame;
@end
