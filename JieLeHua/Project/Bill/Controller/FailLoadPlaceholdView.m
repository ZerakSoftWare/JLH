//
//  FailLoadPlaceholdView.m
//  JieLeHua
//
//  Created by kuang on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "FailLoadPlaceholdView.h"

@implementation FailLoadPlaceholdView

- (id)initWithSuperView:(UIView *)superView
{    
    if (self = [super initWithFrame:superView.bounds]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        _holdImageView = [[UIImageView alloc] init];
        [self addSubview:_holdImageView];
        
        [_holdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(206, 195));
            make.top.equalTo(self).offset(116);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        _holdLable = [[UILabel alloc] init];
        [_holdLable setTextColor:VVColor(153, 153, 153)];
        [_holdLable setTextAlignment:NSTextAlignmentCenter];
        [_holdLable setFont:[UIFont systemFontOfSize:15.0]];
        [self addSubview:_holdLable];
        
        [_holdLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_holdImageView.mas_bottom).offset(32);
            make.left.right.equalTo(self);
        }];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadingData)];
        [self addGestureRecognizer:tapGes];
        CGSize size = [UIScreen mainScreen].bounds.size;
        if (iPhoneX)
        {
            [self setOriginY:64 + 20];
        }else{
            [self setOriginY:64];
        }
        [superView addSubview:self];
    }
    
    return self;
}

- (void)resetPlaceholdState
{
    self.userInteractionEnabled = NO;
    self.holdImageView.image = nil;
    self.holdImageView.animationImages = nil;
    [self.holdImageView setAnimationDuration:0];
}

#pragma mark - error

- (void)refreshErrorImage:(UIImage *)errorImage errorMsg:(NSString *)errorMsg
{
    [self resetPlaceholdState];
    
    self.userInteractionEnabled = YES;
    self.holdImageView.image = errorImage;
    self.holdLable.text = errorMsg;
    
    [self show];
}

- (void)show
{
    [self setAlpha:1];
}

- (void)hidden
{
    [self setAlpha:0];
}

- (void)setOriginY:(CGFloat)y
{
    self.y = y;
}

#pragma mark - layout subviews

- (void)layoutSubviews {
    //居中显示
    UIView *parentView = self.superview;
    if (parentView) {
        [self setFrame:CGRectMake(0, self.frame.origin.y, CGRectGetWidth(parentView.bounds), CGRectGetHeight(parentView.bounds))];
    }
}

#pragma mark - 加载失败，点击重新加载

- (void)reloadingData
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
