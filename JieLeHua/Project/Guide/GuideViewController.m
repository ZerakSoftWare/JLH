//
//  GuideViewController.m
//  JieLeHua
//
//  Created by kuang on 2017/3/26.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "GuideViewController.h"
#import "UIImage+Extension.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface GuideViewController ()<UIScrollViewDelegate>
{
    /** 图片名 */
    NSString *_imageName;
    
    /** 图片个数 */
    NSInteger _imageCount;
    
    /** 分页控制器 */
    UIPageControl *_pageControl;
    
    /** 是否显示分页控制器 */
    BOOL _showPageControl;
    
    /** 进入主界面的按钮 */
    UIButton *_enterButton;
    
    /** 完成界面展示后的block回调 */
    GuideFinishBlock _finishBlock;
}

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation GuideViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc
{
    
}


#pragma mark - Public Methods

#pragma mark - UIScrollViewDelegate 方法

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    // 最后一张再向左划的话
    if (scrollView.contentOffset.x == vScreenWidth * (_imageCount - 1)) {
        
        if (_finishBlock) {
            
            [UIView animateWithDuration:0.4f animations:^{
                
                self.view.transform = CGAffineTransformMakeTranslation(-vScreenWidth, 0);
                
            } completion:^(BOOL finished) {
                
                _finishBlock();
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint currentPoint = scrollView.contentOffset;
    NSInteger page = currentPoint.x / scrollView.bounds.size.width;
    _pageControl.currentPage = page;
    
    if ([self.delegate respondsToSelector:@selector(guideVC:page:)]) {
        [self.delegate guideVC:self page:page];
    }
}

#pragma mark - Overridden Methods

+(instancetype)guidewithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      enterButton:(UIButton *)enterButton
                  pointOtherColor:(UIColor *)pointOtherColor
                pointCurrentColor:(UIColor *)pointCurrentColor
                      finishBlock:(GuideFinishBlock)finishBlock
{
    return [[self alloc] initWithImageName:imageName
                                imageCount:imageCount
                           showPageControl:showPageControl
                               enterButton:enterButton pointOtherColor:pointOtherColor pointCurrentColor:pointCurrentColor finishBlock:finishBlock];
}

- (instancetype)initWithImageName:(NSString *)imageName
                       imageCount:(NSInteger)imageCount
                  showPageControl:(BOOL)showPageControl
                      enterButton:(UIButton *)enterButton
                  pointOtherColor:(UIColor *)pointOtherColor
                pointCurrentColor:(UIColor *)pointCurrentColor
                      finishBlock:(GuideFinishBlock)finishBlock
{
    if (self = [super init]) {
        
        _imageName       = imageName;
        _imageCount      = imageCount;
        _showPageControl = showPageControl;
        _finishBlock     = finishBlock;
        _enterButton     = enterButton;
        _pointOtherColor = pointOtherColor;
        _pointCurrentColor = pointCurrentColor;
        [self setupMainView];
    }
    
    return self;
}

- (void)setupMainView
{
    self.view.backgroundColor = [UIColor whiteColor];
    // 默认状态栏样式为黑色
    self.statusBarStyle = GuideStatusBarStyleBlack;
    
    // 图片数组非空时
    if (_imageCount) {
        
        // 滚动视图
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setDelegate:self];
        [scrollView setBounces:NO];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size}];
        [scrollView setContentSize:(CGSize){vScreenWidth * _imageCount, 0}];
        [self.view addSubview:scrollView];
        
        // 滚动图片
        CGFloat imageW = vScreenWidth;
        CGFloat imageH = vScreenHeight;
        
        for (int i = 0; i < _imageCount; i++) {
            
            CGFloat imageX = imageW * i;
            NSString *realImageName = [NSString stringWithFormat:@"%@_%d", _imageName, i + 1];
            UIImage *realImage = [UIImage imageNamedForAdaptation:realImageName iphone4:YES iphone6:YES iphone6p:YES];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImage:realImage];
            [imageView setFrame:(CGRect){imageX, 0, imageW, imageH}];
            [scrollView addSubview:imageView];
            
            if (_enterButton && i == _imageCount - 1) {
                
                [imageView setUserInteractionEnabled:YES];
                [imageView addSubview:_enterButton];
            }
        }
        
        // 分页视图
        if (_showPageControl) {
            
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            [pageControl setNumberOfPages:_imageCount];
            [pageControl setHidesForSinglePage:YES];
            [pageControl setUserInteractionEnabled:NO];
            [pageControl setPageIndicatorTintColor:self.pointOtherColor ? self.pointOtherColor:RGB(153, 153, 153)];
            [pageControl setCurrentPageIndicatorTintColor:self.pointCurrentColor ? self.pointCurrentColor : [UIColor whiteColor]];
            [pageControl setFrame:(CGRect){0, vScreenHeight * 0.9, vScreenWidth, 37.0f}];
            [self.view addSubview:pageControl];
            _pageControl = pageControl;
        }
        
    } else {
        
        VVLog(@"警告: 请放入引导图!");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    switch (self.statusBarStyle) {
            
        case GuideStatusBarStyleBlack:
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            break;
            
        case GuideStatusBarStyleWhite:
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            break;
            
        case GuideStatusBarStyleNone:
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            break;
            
        default:
            break;
    }
    
    if (_showPageControl) {
        
        // 如果设置了分页控制器当前点的颜色
        if (self.pointCurrentColor) {
            
            [_pageControl setCurrentPageIndicatorTintColor:self.pointCurrentColor];
        }
        
        // 如果设置了分页控制器其他点的颜色
        if (self.pointOtherColor) {
            
            [_pageControl setPageIndicatorTintColor:self.pointOtherColor];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.statusBarStyle == GuideStatusBarStyleNone) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

+ (BOOL)shouldShowGuide
{
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
