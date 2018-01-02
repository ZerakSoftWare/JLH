//
//  JJPayVipViewController.h
//  JieLeHua
//
//  Created by pingyandong on 2017/12/21.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJPayVipViewController : UIViewController
+ (instancetype)viewController;
@property (nonatomic, copy) void(^payVipActionBlock)();

@end
