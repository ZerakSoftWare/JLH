//
//  VVWaitingView.m
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-6-13.
//
//

#import "VVWaitingView.h"

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

@implementation VVWaitingView

@synthesize dimBackground;
@synthesize title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code 
        
        //大背景 50%透明 黑色背景
//        _bgView =  [[UIView alloc] initWithFrame:frame];
//        _bgView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
//        [self addSubview:_bgView];
//
        //小背景 纯白色圆角矩形
        float x = (frame.size.width - kWaitingViewWidth)/2;
        float y = kWaitingViewOffsetY;
        
        if (VV_IOS_VERSION >= 7.0)
        {
            //在ios7上增加偏移量
            y += kStatusBarHeight;
        }
        CGRect rect = CGRectIntegral(CGRectMake(x, y, kWaitingViewWidth, kWaitingViewHeight));
        _dialogView = [[UIView alloc] initWithFrame:rect];
        _dialogView.backgroundColor = VV_COL_RGB(0x000000);
        _dialogView.layer.cornerRadius = 5.0f;
        [self addSubview:_dialogView];

        //菊花
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_dialogView addSubview:_activityView];
        int cx = _dialogView.frame.size.width/2;
        int cy = kWaitingViewTopMargin + kWaitingViewActivityHeight/2;
//        int cy = kWaitingViewTopMargin + _titleLabel.frame.size.height + kWaitingViewRowMargin;
        CGPoint ct = CGPointMake(cx, cy);
        [_activityView setCenter:ct];
        
        //文字
        int width = kWaitingViewWidth - 2*kWaitingViewLeftMargin;
        int height = kWaitingViewHeight - kWaitingViewTopMargin - kWaitingViewButtonMargin - kWaitingViewActivityHeight;
        cy = kWaitingViewTopMargin + _activityView.frame.size.height + kWaitingViewRowMargin;
        CGRect labelRt = CGRectIntegral(CGRectMake(kWaitingViewLeftMargin, cy, width, height));
        _titleLabel = [[UILabel alloc] initWithFrame:labelRt];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = VV_COL_RGB(kWaitingViewTextColor);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_dialogView addSubview:_titleLabel];
        
        
    }
    return self;
}


- (void)dealloc
{

}

- (void)show
{
    _titleLabel.text = self.title;
    self.hidden = NO;
    [_activityView startAnimating];
}
- (void)hide
{
    _titleLabel.text = nil;
    self.title = nil;
    [_activityView stopAnimating];
    self.hidden = YES;
}

@end
