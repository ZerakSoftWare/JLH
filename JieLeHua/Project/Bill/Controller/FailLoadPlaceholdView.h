//
//  FailLoadPlaceholdView.h
//  JieLeHua
//
//  Created by kuang on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

/**
 *  加载失败，点击重新加载。后期可做加载动画、提示。
 */

#import <UIKit/UIKit.h>

@interface FailLoadPlaceholdView : UIControl

@property (nonatomic, strong, readonly) UIImageView *holdImageView;
@property (nonatomic, strong, readonly) UILabel *holdLable;

- (instancetype)initWithSuperView:(UIView *)view;

/**
 *  加载失败，点击重新加载
 *
 *  @param errorImage errorImage
 *  @param errorMsg   errorInfo
 */
- (void)refreshErrorImage:(UIImage *)errorImage errorMsg:(NSString *)errorMsg;

- (void)show;
- (void)hidden;
- (void)setOriginY:(CGFloat)y;
@end
