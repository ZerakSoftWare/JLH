//
//  JJHomeNoApplyView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/5/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJHomeNoApplyView.h"
#import "UIButton+JJMultiClickButton.h"

#define kSourceTag  1000
@interface JJHomeNoApplyView ()
{
    UIView *topView;
}
@property (nonatomic) HomeStatus type;
@end

@implementation JJHomeNoApplyView

+ (instancetype)noApplyWithType:(HomeStatus)type frame:(CGRect)frame
{
    return [[self alloc] noApplyWithType:type frame:frame];
}

- (instancetype)noApplyWithType:(HomeStatus)type frame:(CGRect)frame
{
    if (self == [super init]) {
        self.frame = frame;
        self.type = type;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI界面
- (void)setupUI
{
//#ifdef JIELEHUAQUICK
    topView = [[UIView alloc] init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(0);
        make.right.mas_equalTo(self).offset(0);
        make.top.mas_equalTo(self).offset(0);
        make.height.equalTo(@(0));
    }];
    [self setupBottomView];
//#else
//    [self setupTopView];
//    [self setupBottomView];
//#endif
}

- (void)setupTopView
{
    int scale = [UIScreen mainScreen].scale;
    topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 6;
    topView.layer.masksToBounds = YES;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ISIPHONE4) {
            make.left.mas_equalTo(self).offset(8*scale);
            make.right.mas_equalTo(self).offset(-8*scale);
            make.top.mas_equalTo(self).offset(12);
            make.height.equalTo(@(106));
        }else{
            make.left.mas_equalTo(self).offset(8*scale);
            make.right.mas_equalTo(self).offset(-8*scale);
            make.top.mas_equalTo(self).offset(20);
            make.height.equalTo(@(62.5*2));
        }
    }];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@"img_home_putongban"];
    [topView addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@75);
        make.width.equalTo(@75);
        make.left.mas_equalTo(topView).offset(16);
        make.centerY.mas_equalTo(topView).offset(0);
    }];
    
    UILabel *allTopLabel = [[UILabel alloc] init];
    allTopLabel.text = @"全额申请";
    allTopLabel.textColor = [UIColor globalThemeColor];
    allTopLabel.font = [UIFont boldSystemFontOfSize:24];
    [topView addSubview:allTopLabel];
    [allTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImage.mas_right).offset(16);
        if (ISIPHONE4) {
            make.top.mas_equalTo(topView).offset(23);
        }else{
            make.top.mas_equalTo(topView).offset(28);
        }
    }];
    
    UILabel *allBottomLabel = [[UILabel alloc] init];
    allBottomLabel.text = @"3步操作，3万额度轻松贷";
    allBottomLabel.textColor = [UIColor globalThemeColor];
    allBottomLabel.font = [UIFont systemFontOfSize:17];
    allBottomLabel.adjustsFontSizeToFitWidth = YES;
    [topView addSubview:allBottomLabel];
    [allBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImage.mas_right).offset(16);
        make.top.mas_equalTo(allTopLabel.mas_bottom).offset(12);
        if (ISIPHONE4) {
            make.right.mas_equalTo(topView).offset(-41);
        }else{
            make.right.mas_equalTo(topView).offset(-44);
        }
    }];
    
    
    UIImageView *rightImage = [[UIImageView alloc] init];
    rightImage.image = [UIImage imageNamed:@"img_jinbi"];
    [topView addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView).offset(0);
        if (ISIPHONE4) {
            make.height.equalTo(@(106));
            make.width.equalTo(@41);
        }else{
            make.width.equalTo(@44);
            make.height.equalTo(@(62.5*2));
        }
        make.top.mas_equalTo(topView).offset(0);
    }];
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topBtn.backgroundColor = [UIColor clearColor];
    [topView addSubview:topBtn];
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView).offset(0);
        make.right.mas_equalTo(topView).offset(0);
        make.top.mas_equalTo(topView).offset(0);
        if (ISIPHONE4) {
            make.height.equalTo(@(106));
        }else{
            make.height.equalTo(@(62.5*2));
        }
    }];
    topBtn.tag = kSourceTag;
    [topBtn addTarget:self action:@selector(dealWithClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBottomView
{
    int scale = [UIScreen mainScreen].scale;
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.cornerRadius = 6;
    bottomView.layer.masksToBounds = YES;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(8*scale);
        make.right.mas_equalTo(self).offset(-8*scale);
        make.top.mas_equalTo(topView.mas_bottom).offset(30);
        if (ISIPHONE4) {
            make.height.equalTo(@(106));
        }else{
            make.height.equalTo(@(62.5*2));
        }
    }];
    
    UIImageView *fastIconImage = [[UIImageView alloc] init];
    
#ifdef JIELEHUAQUICK
    fastIconImage.image = [UIImage imageNamed:@"img_default_portrait"];
#else
    fastIconImage.image = [UIImage imageNamed:@"img_home_jisuban"];
#endif
    [bottomView addSubview:fastIconImage];
    [fastIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@75);
        make.width.equalTo(@75);
        make.left.mas_equalTo(bottomView).offset(16);
        make.centerY.mas_equalTo(bottomView).offset(0);
    }];

    UILabel *fastTopLabel = [[UILabel alloc] init];
    fastTopLabel.text = @"极速申请";
    fastTopLabel.textColor = [UIColor globalThemeColor];
    fastTopLabel.font = [UIFont boldSystemFontOfSize:24];
    [bottomView addSubview:fastTopLabel];
    [fastTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fastIconImage.mas_right).offset(16);
        if (ISIPHONE4) {
            make.top.mas_equalTo(bottomView).offset(23);
        }else{
            make.top.mas_equalTo(bottomView).offset(28);
        }
    }];
    
    UILabel *fastBottomLabel = [[UILabel alloc] init];
    fastBottomLabel.text = @"“极”你所急，闪电申请";
    fastBottomLabel.textColor = [UIColor globalThemeColor];
    fastBottomLabel.font = [UIFont systemFontOfSize:17];
    fastBottomLabel.adjustsFontSizeToFitWidth = YES;
    [bottomView addSubview:fastBottomLabel];
    [fastBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fastIconImage.mas_right).offset(16);
        make.top.mas_equalTo(fastTopLabel.mas_bottom).offset(12);
        make.right.mas_equalTo(bottomView).offset(-61);
    }];
    
    
    UIImageView *rightFastImage = [[UIImageView alloc] init];
    rightFastImage.image = [UIImage imageNamed:@"img_huojian"];
    [bottomView addSubview:rightFastImage];
    [rightFastImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView).offset(0);
        if (ISIPHONE4) {
            make.height.equalTo(@(106));
        }else{
            make.height.equalTo(@(62.5*2));
        }
        make.width.equalTo(@61);
        make.top.mas_equalTo(bottomView).offset(0);
    }];
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView).offset(0);
        make.right.mas_equalTo(bottomView).offset(0);
        make.top.mas_equalTo(bottomView).offset(0);
        if (ISIPHONE4) {
            make.height.equalTo(@(106));
        }else{
            make.height.equalTo(@(62.5*2));
        }
    }];
    bottomBtn.tag = kSourceTag+2;//2 极速版
    bottomBtn.vv_acceptEventInterval = 2;
    [bottomBtn addTarget:self action:@selector(dealWithClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealWithClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int source = btn.tag - kSourceTag;
    if ([self.delegate respondsToSelector:@selector(startApplyWithStatus:)]) {
        [self.delegate startApplyWithStatus:source];
    }
}

@end
