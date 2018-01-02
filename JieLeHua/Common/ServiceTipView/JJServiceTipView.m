//
//  JJServiceTipView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/7/12.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJServiceTipView.h"

@implementation JJServiceTipView
- (instancetype)initServiceTipWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *tipImage = [[UIImageView alloc] init];
        tipImage.image = [UIImage imageNamed:@"img_home_maintenance"];
        [self addSubview:tipImage];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
        [btn setTitle:@"一会再来" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(237, 148));
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(tipImage.mas_bottom).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(180, 50));
        }];
    }
    return self;
}

- (void)exit
{
    exit(0);
}
@end
