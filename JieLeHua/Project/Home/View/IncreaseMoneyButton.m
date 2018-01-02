//
//  IncreaseMoneyButton.m
//  JieLeHua
//
//  Created by pingyandong on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IncreaseMoneyButton.h"

@interface IncreaseMoneyButton ()
@property (weak, nonatomic) IBOutlet UIImageView *failImageView;
@property (weak, nonatomic) IBOutlet UIImageView *huabeiTipImageView;
@property (weak, nonatomic) IBOutlet UIButton *huabeiBtn;

@property (weak, nonatomic) IBOutlet UIImageView *gongjijinTipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gongjijinFailImageView;
@property (weak, nonatomic) IBOutlet UIButton *gongjijinBtn;

@end

@implementation IncreaseMoneyButton

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setupUIWithHuabeiStatus:(BOOL)huabeiFailed gongjijinStatus:(BOOL)gongjijinFailed
{
    //两者只能选择一个提额
    if (huabeiFailed) {
        //公积金可点
        self.huabeiTipImageView.hidden = YES;
        self.huabeiBtn.enabled = NO;
        self.gongjijinBtn.enabled = YES;
        self.gongjijinFailImageView.hidden = YES;
        self.failImageView.hidden = NO;
    }
    if (gongjijinFailed) {
        //花呗可点
        self.gongjijinTipImageView.hidden = YES;
        self.gongjijinBtn.enabled = NO;
        self.huabeiBtn.enabled = YES;
        self.failImageView.hidden = YES;
        self.gongjijinFailImageView.hidden = NO;
    }
    if (gongjijinFailed && huabeiFailed) {
        self.huabeiBtn.enabled = self.gongjijinBtn.enabled = NO;
        self.failImageView.hidden = self.gongjijinFailImageView.hidden = NO;
        self.huabeiTipImageView.hidden = self.gongjijinTipImageView.hidden = YES;
    }
    if (!huabeiFailed && !gongjijinFailed) {
        self.huabeiBtn.enabled = self.gongjijinBtn.enabled = YES;
        self.failImageView.hidden = self.gongjijinFailImageView.hidden = YES;
        self.huabeiTipImageView.hidden = self.gongjijinTipImageView.hidden = NO;
    }
}

- (IBAction)huabeiPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(startIncreaseMoneyWithType:)]) {
        [self.delegate startIncreaseMoneyWithType:IncreaseType_Huabei];
    }
}

- (IBAction)gongjijinPress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(startIncreaseMoneyWithType:)]) {
        [self.delegate startIncreaseMoneyWithType:IncreaseType_Gongjijin];
    }
}

@end
