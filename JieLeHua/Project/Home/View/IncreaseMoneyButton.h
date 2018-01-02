//
//  IncreaseMoneyButton.h
//  JieLeHua
//
//  Created by pingyandong on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IncreaseMoneyButtonDelegate <NSObject>
///提额按钮
- (void)startIncreaseMoneyWithType:(IncreaseType)type;
@end

@interface IncreaseMoneyButton : UIView
@property (nonatomic, weak) id <IncreaseMoneyButtonDelegate> delegate;

- (void)setupUIWithHuabeiStatus:(BOOL)huabeiFailed gongjijinStatus:(BOOL)gongjijinFailed;
@end
