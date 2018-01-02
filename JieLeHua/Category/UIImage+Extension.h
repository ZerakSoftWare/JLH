//
//  UIImage+Extension.h
//  JieLeHua
//
//  Created by kuang on 2017/3/26.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

// 获得某个View的屏幕图像
+ (UIImage *)imageFromView: (UIView *)theView;

+ (instancetype)imageNamedForAdaptation:(NSString *)imageName
                                iphone4:(BOOL)iphone4
                                iphone6:(BOOL)iphone6
                               iphone6p:(BOOL)iphone6p;

/**
 *  根据指定压缩宽度,生成等比压缩后的图片
 *
 *  @param scaleWidth 压缩宽度
 *
 *  @return 等比压缩后的图片
 */
- (UIImage *)compressWithWidth:(CGFloat)scaleWidth;

- (UIImage *)compressWithHeight:(CGFloat)scaleHeight;
@end
