//
//  VVCustomSwitchBtn.h
//  O2oApp
//
//  Created by chenlei on 16/9/23.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVCustomSwitchBtn : UIButton
@property(nonatomic,getter=isOn) BOOL on;
+(instancetype )switchButton;
- (void)switchButton:(UIImage *)onImage offImage:(UIImage *)offImage;
- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end
