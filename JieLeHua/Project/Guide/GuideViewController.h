//
//  GuideViewController.h
//  JieLeHua
//
//  Created by kuang on 2017/3/26.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

@import UIKit;

#pragma mark Constants

@class GuideViewController;

/**
 *  完成界面展示后的block回调
 */
typedef void (^GuideFinishBlock)();

/**
 状态栏样式
 */
typedef enum : NSUInteger {
    GuideStatusBarStyleBlack,  // 黑色
    GuideStatusBarStyleWhite,  // 白色
    GuideStatusBarStyleNone,   // 隐藏
} GuideStatusBarStyle;

@protocol GuideVCDelegate <NSObject>

@optional

- (void)guideVC:(GuideViewController *)guideVC page:(NSInteger)page;

@end


@interface GuideViewController : UIViewController


#pragma mark - Properties

/**
 *  当前点(分页控制器)的颜色
 */
@property (nonatomic, strong) UIColor *pointCurrentColor;

/**
 *  其他点(分页控制器)的颜色
 */
@property (nonatomic, strong) UIColor *pointOtherColor;

@property (nonatomic, assign) GuideStatusBarStyle statusBarStyle;

@property (nonatomic, weak) id<GuideVCDelegate> delegate;

+ (BOOL)shouldShowGuide;

+ (instancetype)guidewithImageName:(NSString *)imageName
                        imageCount:(NSInteger)imageCount
                   showPageControl:(BOOL)showPageControl
                       enterButton:(UIButton *)enterButton
                   pointOtherColor:(UIColor *)pointOtherColor
                 pointCurrentColor:(UIColor *)pointCurrentColor
                       finishBlock:(GuideFinishBlock)finishBlock;


@end
