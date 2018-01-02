//
//  IntroduceToolbarView.m
//  JieLeHua
//
//  Created by admin2 on 2017/6/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IntroduceToolbarView.h"

@interface IntroduceToolbarView ()

@property (strong, nonatomic) UIView *topLine;

@property (nonatomic, strong) NSMutableArray *btnsArray;

@property (nonatomic, retain) CAGradientLayer *gradientLayer;

@end

@implementation IntroduceToolbarView

@synthesize productArr = _productArr;

- (NSArray *)productArr{
    return _productArr;
}

- (void)setProductArr:(NSArray *)productArr
{
    _productArr = productArr;
    [self buildView];
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 94, 32)];
        _topLine.layer.cornerRadius = 16;
        _topLine.clipsToBounds = YES;
        
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.locations = @[@0,@1.0f];
        self.gradientLayer.startPoint = CGPointMake(0, 0.5f);
        self.gradientLayer.endPoint = CGPointMake(1, 0.5f);
        self.gradientLayer.frame = _topLine.bounds;
        [_topLine.layer addSublayer:self.gradientLayer];
        self.gradientLayer.colors = @[(__bridge id)self.lightColor.CGColor,
                                      (__bridge id)self.deepColor.CGColor];
    }
    return _topLine;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setBackColor:(UIColor *)backColor
{
    self.backgroundColor = backColor;
}

- (void)buildView
{
    int btnWidth = 94;
    
    self.topLine.frame = CGRectMake(0, 0, 94, 32);
    [self addSubview:self.topLine];
    
    self.topLine.hidden = YES;
    
    self.btnsArray = [NSMutableArray array];
    for (int i = 0; i < self.productArr.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(btnWidth*i, 0, btnWidth, 32)];
        button.userInteractionEnabled = YES;
        [button setTitleColor:kColor_TipColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = kFont_Title;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:self.productArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1989;
        [self addSubview:button];
        
        [self.btnsArray addObject:button];
    }
}

- (void)tagButtonClick:(UIButton *)sender
{
    self.topLine.hidden = NO;
    // 1.控制按钮状态
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    
    // 2.控制下划线的位置
    [UIView animateWithDuration:0.25 animations:^{
        self.topLine.centerX = sender.centerX;
    }];
    
    // 3.通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(topToolbar:didSelectedTag:)]) {
        [self.delegate topToolbar:self didSelectedTag:(int)sender.tag-1988];
    }
}

- (void)setSelectedBtnIndex:(NSInteger)selectedBtnIndex {
    
    if (selectedBtnIndex < 0 || selectedBtnIndex >= self.productArr.count) {
        return;
    }
    
    UIButton *sender = self.btnsArray[selectedBtnIndex];
    
    [self tagButtonClick:sender];
}

// 重置选中状态
- (void)resetSelectedButtonStatus {
    self.topLine.hidden = YES;
    // 1.控制按钮状态
    self.selectedButton.selected = NO;
}

@end
