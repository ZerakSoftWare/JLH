//
//  UIImage+Extension.m
//  JieLeHua
//
//  Created by kuang on 2017/3/26.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

// 获得某个View的屏幕图像
+ (UIImage *)imageFromView: (UIView *)theView {
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)imageNamedForAdaptation:(NSString *)imageName
                                iphone4:(BOOL)iphone4
                                iphone6:(BOOL)iphone6
                               iphone6p:(BOOL)iphone6p
{
    NSString *realImageName = imageName;
    
    if (ISIPHONE4 && iphone4)
    {
        realImageName = [NSString stringWithFormat:@"%@_iphone4", realImageName];
    }
    else if (ISIPHONE6 && iphone6)
    {
        realImageName = [NSString stringWithFormat:@"%@_iphone6", realImageName];
    }
    else if (ISIPHONE6Plus && iphone6p)
    {
        realImageName = [NSString stringWithFormat:@"%@_iphone6p", realImageName];
    }
    else
    {
        realImageName = [NSString stringWithFormat:@"%@_iphone6", realImageName];
    }
    
    return [self imageNamed:realImageName];
}


- (UIImage *)compressWithWidth:(CGFloat)scaleWidth{
    
    //压缩后的高度
    CGFloat scaleHeight = scaleWidth/self.size.width * self.size.height;
    CGSize size = CGSizeMake(scaleWidth, scaleHeight);
    
    //开启图形上下文
    UIGraphicsBeginImageContext(size);
    
    //图片绘制到指定区域内
    [self drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    
    //通过图形上下文获取压缩后的图片
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return scaleImage;
}


- (UIImage *)compressWithHeight:(CGFloat)scaleHeight{
    
    //压缩后的宽度
    CGFloat scaleWidth = scaleHeight/self.size.height * self.size.width;
    CGSize size = CGSizeMake(scaleWidth, scaleHeight);
    
    //开启图形上下文
    UIGraphicsBeginImageContext(size);
    
    //图片绘制到指定区域内
    [self drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    
    //通过图形上下文获取压缩后的图片
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return scaleImage;
}

@end
