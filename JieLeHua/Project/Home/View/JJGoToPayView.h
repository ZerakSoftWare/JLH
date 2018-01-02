//
//  JJGoToPayView.h
//  JieLeHua
//
//  Created by pingyandong on 2017/12/21.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJGoToPayView : UIView
@property (nonatomic, copy) void(^closeActionBlock)();
@property (nonatomic, copy) void(^payVipActionBlock)();
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

+ (instancetype)xibView;
@end
