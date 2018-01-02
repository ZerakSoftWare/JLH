//
//  JJHuabeiProgressView.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/3.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJHuabeiProgressView : UIView
@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIColor* trackTintColor;
@property (nonatomic, strong) UIImage *progressImage;
- (void)setProgress:(float)progress animated:(BOOL)animated;

@property (strong, nonatomic) UIColor *textColor;
// font can not be nil, it must be a valid UIFont
// default is ‘boldSystemFontOfSize:20.0’
@property (strong, nonatomic) UIFont *font;

// setting the value of 'popUpViewColor' overrides 'popUpViewAnimatedColors' and vice versa
// the return value of 'popUpViewColor' is the currently displayed value
// this will vary if 'popUpViewAnimatedColors' is set (see below)
@property (strong, nonatomic) UIColor *popUpViewColor;
// radius of the popUpView, default is 4.0
@property (nonatomic) CGFloat popUpViewCornerRadius;
- (void)showPopUpViewAnimated:(BOOL)animated;
- (void)hidePopUpViewAnimated:(BOOL)animated;
@end
