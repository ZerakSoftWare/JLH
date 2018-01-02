//
//  MBProgressHUD+BWMExtension.m
//  Example
//
//  Created by 伟明 毕 on 15/7/20.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "MBProgressHUD+BWMExtension.h"
#import <ImageIO/ImageIO.h>

NSString * const kBWMMBProgressHUDMsgLoading = @"正在加载...";
NSString * const kBWMMBProgressHUDMsgLoadError = @"加载失败";
NSString * const kBWMMBProgressHUDMsgLoadSuccessful = @"加载成功";
NSString * const kBWMMBProgressHUDMsgNoMoreData = @"没有更多数据了";
NSTimeInterval kBWMMBProgressHUDHideTimeInterval = 1.2f;

static CGFloat FONT_SIZE = 16.0f;
static CGFloat OPACITY = 0.7;


@interface GifImageView: UIImageView

@end

@implementation GifImageView
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(122, 105);
}
@end


@implementation MBProgressHUD (BWMExtension)

+ (MBProgressHUD *)bwm_showHUDAddedTo:(UIView *)view title:(NSString *)title animated:(BOOL)animated {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:animated];
    HUD.labelFont = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.labelText = title;
    HUD.opacity = OPACITY;
    return HUD;
}

+ (MBProgressHUD *)bwm_showHUDAddedTo:(UIView *)view title:(NSString *)title {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.labelFont = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.labelText = title;
    HUD.opacity = OPACITY;
    return HUD;
}

- (void)bwm_hideWithTitle:(NSString *)title hideAfter:(NSTimeInterval)afterSecond {
    if (title) {
        self.labelText = title;
        self.mode = MBProgressHUDModeText;
    }
    [self hide:YES afterDelay:afterSecond];
}

- (void)bwm_hideAfter:(NSTimeInterval)afterSecond {
    [self hide:YES afterDelay:afterSecond];
}

- (void)bwm_hideWithTitle:(NSString *)title
                hideAfter:(NSTimeInterval)afterSecond
                  msgType:(BWMMBProgressHUDMsgType)msgType {
    self.labelText = title;
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[self class ]p_imageNamedWithMsgType:msgType]]];
    [self hide:YES afterDelay:afterSecond];
}

+ (MBProgressHUD *)bwm_showTitle:(NSString *)title toView:(UIView *)view hideAfter:(NSTimeInterval)afterSecond {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelFont = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.labelText = title;
    HUD.opacity = OPACITY;
    [HUD hide:YES afterDelay:afterSecond];
    return HUD;
}

+ (MBProgressHUD *)bwm_showTitle:(NSString *)title
                      toView:(UIView *)view
                   hideAfter:(NSTimeInterval)afterSecond
                     msgType:(BWMMBProgressHUDMsgType)msgType {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.labelFont = [UIFont systemFontOfSize:FONT_SIZE];
    
    NSString *imageNamed = [self p_imageNamedWithMsgType:msgType];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNamed]];
    HUD.labelText = title;
    HUD.opacity = OPACITY;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.minSize = CGSizeMake(200, 0);
    [HUD hide:YES afterDelay:afterSecond];
    return HUD;
    
}

+ (NSString *)p_imageNamedWithMsgType:(BWMMBProgressHUDMsgType)msgType {
    NSString *imageNamed = nil;
    if (msgType == BWMMBProgressHUDMsgTypeSuccessful) {
        imageNamed = @"hud_success";
    } else if (msgType == BWMMBProgressHUDMsgTypeError) {
        imageNamed = @"hud_warning";
    } else if (msgType == BWMMBProgressHUDMsgTypeWarning) {
        imageNamed = @"hud_warning";
    } else if (msgType == BWMMBProgressHUDMsgTypeInfo) {
        imageNamed = @"hud_info";
    }
    return imageNamed;
}

+ (MBProgressHUD *)bwm_showDeterminateHUDTo:(UIView *)view {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.labelText = kBWMMBProgressHUDMsgLoading;
    HUD.labelFont = [UIFont systemFontOfSize:FONT_SIZE];
    return HUD;
}

+ (void)bwm_setHideTimeInterval:(NSTimeInterval)second fontSize:(CGFloat)fontSize opacity:(CGFloat)opacity {
    kBWMMBProgressHUDHideTimeInterval = second;
    FONT_SIZE = fontSize;
    OPACITY = opacity;
}

/**
 *  显示一个带gif的HUD
 *
 *  @param title 显示的文字
 *  @param view  目标view
 */
+ (MBProgressHUD *)showAnimationWithtitle:(NSString *)title toView:(UIView *)view
{
    if (view == nil){
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t frameCout=CGImageSourceGetCount(gifSource);
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (size_t i=0; i < frameCout; i++)
    {
        CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *imageName=[UIImage imageWithCGImage:imageRef];
        [frames addObject:imageName];
        CGImageRelease(imageRef);
    }
    
    GifImageView *imageview = [[GifImageView alloc] initWithFrame:CGRectMake(0, 0, 122, 105)];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.animationImages = frames;
    imageview.animationDuration = 2.5;
    [imageview startAnimating];
    CFRelease(gifSource);
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.customView = imageview;
    HUD.labelText = title;
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD show:YES];
    
    return HUD;
}

@end
