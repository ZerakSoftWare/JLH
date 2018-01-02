//
//  JJHuabeiProgressView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/3.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJHuabeiProgressView.h"
#import "ASPopUpView.h"

@interface JJHuabeiProgressView ()<ASPopUpViewDelegate>
{
    UIColor *_popUpViewColor;
    CALayer *_progressLayer;
    BOOL _shouldAnimate;
    CAGradientLayer *_gradientLayer;
}

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) ASPopUpView *popUpView;
@end

@implementation JJHuabeiProgressView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - public

- (void)showPopUpViewAnimated:(BOOL)animated
{
    if (self.popUpView.alpha == 1.0) return;
    
    [self.popUpView showAnimated:animated];
}

- (void)hidePopUpViewAnimated:(BOOL)animated
{
    if (self.popUpView.alpha == 0.0) return;
    
    [self.popUpView hideAnimated:animated completionBlock:^{
        
    }];
}


- (void)setTextColor:(UIColor *)color
{
    _textColor = color;
    [self.popUpView setTextColor:color];
}

- (void)setFont:(UIFont *)font
{
    NSAssert(font, @"font can not be nil, it must be a valid UIFont");
    _font = font;
    [self.popUpView setFont:font];
}

- (void)setTrackTintColor:(UIColor *)color
{
    self.backgroundColor = color;
}

- (UIColor *)trackTintColor
{
    return self.backgroundColor;
}

// return the currently displayed color if possible, otherwise return _popUpViewColor
// if animated colors are set, the color will change each time the progress view updates
- (UIColor *)popUpViewColor
{
    return [self.popUpView color] ?: _popUpViewColor;
}

- (void)setPopUpViewColor:(UIColor *)color
{
    _popUpViewColor = color;
    [self.popUpView setColor:color];
//    [self setGradientColors:@[color, color] withPositions:nil];
}

// returns the current progress in the range 0.0 – 1.0
- (CGFloat)currentValueOffset
{
    return self.progress;
}

#pragma mark - private

- (void)setup
{
    _progressLayer = [CALayer layer];
    _progressLayer.masksToBounds = YES;
    _progressLayer.anchorPoint = CGPointMake(0, 0);
    [self.layer addSublayer:_progressLayer];
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.startPoint = CGPointZero;
    _gradientLayer.endPoint = CGPointMake(1, 0);
    [_progressLayer addSublayer:_gradientLayer];
    
    self.progress = 0;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    _numberFormatter = formatter;
    
    self.popUpView = [[ASPopUpView alloc] initWithFrame:CGRectZero];
    self.popUpViewColor = [UIColor colorWithHue:0.6 saturation:0.6 brightness:0.5 alpha:0.8];
    
    self.popUpView.alpha = 0.0;
    self.popUpView.delegate = self;
//    self.popUpView.clipsToBounds = NO;
    [self addSubview:self.popUpView];
    
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont boldSystemFontOfSize:20.0f];
}


- (void)updatePopUpView
{
    NSString *progressString; // ask dataSource for string, if nil get string from _numberFormatter
    progressString = [_numberFormatter stringFromNumber:@(self.progress)];
    if (progressString.length == 0) progressString = @"???"; // replacement for blank string
    
    CGSize popUpViewSize = [self calculatePopUpViewSize];
    
    // calculate the popUpView frame
    CGRect bounds = self.bounds;
    CGFloat xPos = (CGRectGetWidth(bounds) * self.progress) - popUpViewSize.width/2;
    
    CGRect popUpRect = CGRectMake(xPos, CGRectGetMinY(bounds)-popUpViewSize.height,
                                  popUpViewSize.width, popUpViewSize.height);
    
    // determine if popUpRect extends beyond the frame of the progress view
    // if so adjust frame and set the center offset of the PopUpView's arrow
    CGFloat minOffsetX = CGRectGetMinX(popUpRect);
    CGFloat maxOffsetX = CGRectGetMaxX(popUpRect) - CGRectGetWidth(bounds);
    
    CGFloat offset = minOffsetX < 0.0 ? minOffsetX : (maxOffsetX > 0.0 ? maxOffsetX : 0.0);
    popUpRect.origin.x -= offset;
    
    [self.popUpView setFrame:popUpRect arrowOffset:offset colorOffset:self.progress text:progressString];
    
}

- (CGSize)calculatePopUpViewSize
{
    CGSize size =  CGSizeMake(50, 40);
    return size;
}


#pragma mark - subclassed

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateProgressLayer];
    [self updatePopUpView];
}

- (void)setProgress:(float)progress
{
    _progress = MAX(0.0, MIN(progress, 1.0));
    [self updateProgressLayer];
}

- (void)updateProgressLayer
{
    _gradientLayer.frame = self.bounds;
    _progressLayer.frame = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
}


- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (progress > 0.98) {
        VVLog(@"======");
    }
    _shouldAnimate = animated;
    
    if (animated) {
        [self.popUpView animateBlock:^(CFTimeInterval duration) {
            CABasicAnimation *anim = [CABasicAnimation animation];
            anim.duration = duration;
            anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            anim.fromValue = [_progressLayer.presentationLayer valueForKey:@"bounds"];
            _progressLayer.actions = @{@"bounds" : anim};
            
            [UIView animateWithDuration:duration animations:^{
                self.progress = progress;
                [self layoutIfNeeded];
            }];
        }];
    } else {
        _progressLayer.actions = @{@"bounds" : [NSNull null]};
        self.progress = progress;
    }
}

- (void)setGradientColors:(NSArray *)gradientColors withPositions:(NSArray *)positions
{
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *col in gradientColors) {
        [cgColors addObject:(id)col.CGColor];
    }
    
    _gradientLayer.colors = cgColors;
    _gradientLayer.locations = positions;
}

@end
