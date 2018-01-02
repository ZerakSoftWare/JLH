//
//  VVNoNetworkingViewController.m
//  O2oApp
//
//  Created by YuZhongqi on 16/5/18.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVNoNetworkingView.h"

@interface VVNoNetworkingView ()
@property(nonatomic,weak) UIImageView *img;
@property(nonatomic,weak) UILabel * lab;
@end

@implementation VVNoNetworkingView




-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    CGFloat imgW = 60;
    CGFloat imgH = 40;
    UIImageView *img = [[UIImageView alloc]init];
    [img setImage:[UIImage imageNamed:@"signal"]];
    img.frame =CGRectMake(0.5 * (vScreenWidth - imgW), 150, imgW, imgH);
    [self addSubview:img];
    self.img = img;
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 265, vScreenWidth, 16);
    lab.text = @"暂无网络";
    lab.textColor = [UIColor colorWithHexString:@"999999"];
    lab.font = [UIFont systemFontOfSize:15.f];
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    self.lab = lab;
        
    }
    return self;
}


@end
