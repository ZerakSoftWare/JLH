//
//  IntroduceToolbarView.h
//  JieLeHua
//
//  Created by admin2 on 2017/6/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroduceToolbarView;

@protocol IntroduceToolbarViewDelegate <NSObject>

@optional
- (void)topToolbar:(IntroduceToolbarView *)topToolbar didSelectedTag:(int)tag;
@end

@interface IntroduceToolbarView : UIView

@property (nonatomic, weak) id<IntroduceToolbarViewDelegate> delegate;

@property (nonatomic, weak) UIButton *selectedButton;

@property (nonatomic, strong) NSArray *productArr;

//--渐变的浅颜色
@property (nonatomic, strong) UIColor *lightColor;

//--渐变深的颜色
@property (nonatomic, strong) UIColor *deepColor;

//--背景色
@property (nonatomic, strong) UIColor *backColor;

- (void)tagButtonClick:(UIButton *)sender;

// 重置选中状态
- (void)resetSelectedButtonStatus;

- (void)setSelectedBtnIndex:(NSInteger)selectedBtnIndex;

@end
