//
//  StatusTopView.h
//  JieLeHua
//
//  Created by pingyandong on 2017/11/17.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusTopView : UIView
+ (instancetype)initWithType:(HomeStatus)type;
- (void)updateIWithType:(HomeStatus)type;
@end
