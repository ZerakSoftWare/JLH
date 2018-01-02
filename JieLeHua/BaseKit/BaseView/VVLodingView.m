//
//  VVLodingView.m
//  O2oApp
//
//  Created by chenlei on 16/5/13.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVLodingView.h"
#import "UIImage+GIF.h"

#define kWaitingViewOffsetY 160
#define kWaitingViewWidth 150
#define kWaitingViewHeight 92 //UI给的菊花高度为35/2 , 实际为40/2 所以要加2
#define kWaitingViewLeftMargin 10
/* 菊花距离最上边的垂直距离 */
#define kWaitingViewTopMargin 28
/* 菊花距离文字的垂直距离 */
#define kWaitingViewButtonMargin 15
#define kWaitingViewRowMargin 5
#define kWaitingViewActivityHeight 20
#define kWaitingViewTextColor 0xffffff
@implementation VVLodingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIImage *backImge = VV_GETIMG(@"white");

        //小背景 纯白色圆角矩形
//        float x = (kScreenWidth - backImge.size.width/2)/2;
//        float y = kScreenHeight/2;
        
        

        
//            float x = (kScreenWidth - 100)/2;
//            float y = kScreenHeight/2;

        
        
//            CGRect rect = CGRectIntegral(CGRectMake(x, y, 100, 100));
        CGRect rect = CGRectIntegral(CGRectMake(0, -20, kScreenWidth, kScreenHeight+kNavigationBarHeight));

        _dialogView = [[UIImageView alloc] initWithFrame:rect];

        
        
        _dialogView = [[UIImageView alloc] initWithFrame:rect];
        _dialogView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        _dialogView.layer.cornerRadius = 5.0f;
//        _dialogView.alpha = 0.8;
        [self addSubview:_dialogView];
        
        //菊花
        _activityView = [[UIImageView alloc] init];
        
        UIImage *image = [UIImage sd_animatedGIFNamed:@"loading.gif"];
//        UIImage *image = VV_GETIMG(@"small");

        _activityView.image = image;
        [_dialogView addSubview:_activityView];
        int cx = _dialogView.width/2;
        int cy = _dialogView.height/2;
        CGPoint ct = CGPointMake(cx, cy);
        _activityView.size = CGSizeMake(image.size.width, image.size.height);
        [_activityView setCenter:ct];
        
        //菊花
        _bigActivityView = [[UIImageView alloc] init];
        
//        UIImage *image2 = [UIImage sd_animatedGIFNamed:@"loading"];
//        UIImage *image2 = VV_GETIMG(@"big");


        
        
//        //文字
//        int width = kWaitingViewWidth - 2*kWaitingViewLeftMargin;
//        int height = kWaitingViewHeight - kWaitingViewTopMargin - kWaitingViewButtonMargin - kWaitingViewActivityHeight;
//        cy = kWaitingViewTopMargin + _activityView.frame.size.height + kWaitingViewRowMargin;
//        CGRect labelRt = CGRectIntegral(CGRectMake(kWaitingViewLeftMargin, cy, width, height));
//        _titleLabel = [[UILabel alloc] initWithFrame:labelRt];
//        _titleLabel.numberOfLines = 0;
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textColor = VV_COL_RGB(kWaitingViewTextColor);
//        _titleLabel.font = [UIFont systemFontOfSize:14];
//        [_dialogView addSubview:_titleLabel];
        
        
    }
    return self;
}


- (void)dealloc
{
    
}


-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    
    _activityView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    _bigActivityView.transform = CGAffineTransformMakeRotation(-_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
    
}

-(void)endAnimation
{
    _angle += 45;
    if (_angle==360) {
        _angle = 0;
    }
    if (!_stop) {
        [self startAnimation];
    }
}

- (void)show
{
    _stop = NO;
    [self startAnimation];
    self.hidden = NO;
//    [_activityView startAnimating];
}
- (void)hide
{
    _stop = YES;
    [self endAnimation];
//    [_activityView stopAnimating];
    self.hidden = YES;
}
@end
