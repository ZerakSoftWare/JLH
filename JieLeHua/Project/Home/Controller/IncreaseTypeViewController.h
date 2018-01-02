//
//  IncreaseTypeViewController.h
//  JieLeHua
//
//  Created by pingyandong on 2017/11/20.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IncreaseTypeDelegate <NSObject>
- (void)chooseType:(IncreaseType)type;
@end
@interface IncreaseTypeViewController : UIViewController
@property (nonatomic, weak)id <IncreaseTypeDelegate> delegate;
+ (instancetype)viewController;
- (void)setupUIWithHuabeiStatus:(BOOL)huabeiFailed gongjijinStatus:(BOOL)gongjijinFailed;
@end
