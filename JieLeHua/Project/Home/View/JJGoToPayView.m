//
//  JJGoToPayView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/12/21.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGoToPayView.h"
@interface JJGoToPayView ()

@property (weak, nonatomic) IBOutlet UIImageView *personalInfoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personalInfoImageViewWCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personalInfoImageViewHCons;

@end

@implementation JJGoToPayView
+ (instancetype)xibView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (IBAction)close:(id)sender {
    if (self.closeActionBlock) {
        self.closeActionBlock();
    }
}

- (IBAction)gotoPayVip:(id)sender {
    if (self.payVipActionBlock) {
        self.payVipActionBlock();
    }
}

@end
