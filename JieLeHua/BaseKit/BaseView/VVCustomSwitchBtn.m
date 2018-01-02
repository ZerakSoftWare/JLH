//
//  VVCustomSwitchBtn.m
//  O2oApp
//
//  Created by chenlei on 16/9/23.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//
#import "VVCustomSwitchBtn.h"
@interface VVCustomSwitchBtn ()
{
    UIImage *_swithOnImage;
    UIImage *_swithOffImage;
}
@end


@implementation VVCustomSwitchBtn
@synthesize on;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype )switchButton{
    VVCustomSwitchBtn* bt = [VVCustomSwitchBtn buttonWithType:UIButtonTypeCustom];
    return bt;
}

- (void)switchButton:(UIImage *)onImage offImage:(UIImage *)offImage{
    [self setBackgroundImage:offImage forState:UIControlStateNormal];
    [self setBackgroundImage:onImage forState:UIControlStateNormal];
//    self.layer.cornerRadius = 13;
//    self.clipsToBounds = YES;
    _swithOffImage = offImage;
    _swithOnImage = onImage;
}

- (void)setOn:(BOOL)turnOn animated:(BOOL)animated;
{
    on = turnOn;
    if (animated)
    {
        [UIView  beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
    }
    
    if (on)
    {
        [self setBackgroundImage:_swithOnImage forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundImage:_swithOffImage forState:UIControlStateNormal];
    }
    
    if (animated)
    {
        [UIView commitAnimations];
    }
}

- (void)setOn:(BOOL)turnOn
{
    [self setOn:turnOn animated:NO];
}

@end
