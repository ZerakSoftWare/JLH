//
//  VVloanApplicationSetpView.m
//  O2oApp
//
//  Created by chenlei on 16/4/21.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVloanApplicationSetpView.h"
@interface VVloanApplicationSetpView ()

@end

@implementation VVloanApplicationSetpView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{

    __block  CGFloat width = (kScreenWidth-20*3)/3-20;


    _arrowRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, width, 30)];
    _arrowRightImageView.contentMode =  UIViewContentModeCenter;
    [self addSubview:_arrowRightImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, width, 26)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = VVclearColor;
    _titleLabel.textColor = VVWhiteColor;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [_arrowRightImageView addSubview:_titleLabel];
    
    _arrowDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * 0.33, self.bottom-2, width * 0.33, 1.5)];
    _arrowDownImageView.backgroundColor = [UIColor globalThemeColor];
    _arrowDownImageView.contentMode =  UIViewContentModeCenter;
    [self addSubview:_arrowDownImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapStepView:)];
    [self addGestureRecognizer:tap];

}

- (void)setIsArrowSelect:(BOOL)isArrowSelect
{
    switch ([_step integerValue]) {
        case 16:
        {
            NSString *imgStr = (isArrowSelect ? @"breadcrumb_nav_1_pre" : @"breadcrumb_nav_2");
            _arrowRightImageView.image = VV_GETIMG(imgStr);
            self.userInteractionEnabled = isArrowSelect;
        }
            break;
        case 17:
        {
            NSString *imgStr = (isArrowSelect ? @"breadcrumb_nav_2_pre" : @"breadcrumb_nav_2");
            _arrowRightImageView.image = VV_GETIMG(imgStr);
            self.userInteractionEnabled = isArrowSelect;
        }
            break;
        case 18:
        {
            NSString *imgStr = (isArrowSelect ? @"breadcrumb_nav_3_pre" : @"breadcrumb_nav_3");
            _arrowRightImageView.image = VV_GETIMG(imgStr);
            self.userInteractionEnabled = isArrowSelect;
        }
            break;
        default:
            break;
    }
}

- (BOOL)isArrowSelect{
    BOOL isSelect = NO;
    if (!_arrowRightImageView.hidden) {
        isSelect = YES;
    }
    return isSelect;
}

- (void)setIsDownSelect:(BOOL)isDownSelect{
    if (isDownSelect) {
        _arrowDownImageView.hidden = NO;
    }else{
        _arrowDownImageView.hidden = YES;
        
    }
    _arrowRightImageView.highlighted = isDownSelect;
}

- (BOOL)isDownSelect{
    BOOL isSelect = NO;
    if (!_arrowDownImageView.hidden) {
        isSelect = YES;
    }
    return isSelect;
}

- (void)tapStepView:(UITapGestureRecognizer *)tap{
    
    if ([_stepViewDelagate respondsToSelector:@selector(stepViewclickApplicationStep:)]) {
        [_stepViewDelagate stepViewclickApplicationStep:self];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
