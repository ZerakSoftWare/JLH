//
//  GradientButton.m
//  JieLeHua
//
//  Created by pingyandong on 2017/6/7.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "GradientButton.h"
@interface GradientButton()
{
    NSArray *_gradientColors; //存储渐变色数组
}

@end
@implementation GradientButton

- (void)setGradientColors:(NSArray<UIColor *> *)colors {
    _gradientColors = [NSArray arrayWithArray:colors];
}

//绘制UIButton对象titleLabel的渐变色特效
- (void)setTitleGradientColors:(NSArray<UIColor *> *)colors {
    if (colors.count == 1) { //只有一种颜色，直接上色
        [self setTitleColor:colors[0] forState:UIControlStateNormal];
    } else { //有多种颜色，需要渐变层对象来上色
        //创建渐变层对象
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        //设置渐变层的frame等同于titleLabel属性的frame（这里高度有个小误差，补上就可以了）
        gradientLayer.frame = CGRectMake(0, 0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height + 3);
        //将存储的渐变色数组（UIColor类）转变为CAGradientLayer对象的colors数组，并设置该数组为CAGradientLayer对象的colors属性
        NSMutableArray *gradientColors = [NSMutableArray array];
        for (UIColor *colorItem in colors) {
            [gradientColors addObject:(id)colorItem.CGColor];
        }
        gradientLayer.colors = [NSArray arrayWithArray:gradientColors];
        //下一步需要将CAGradientLayer对象绘制到一个UIImage对象上，以便使用这个UIImage对象来填充按钮的字体
        UIImage *gradientImage = [self imageFromLayer:gradientLayer];
        //使用UIColor的如下方法，将字体颜色设为gradientImage模式，这样就可以将渐变色填充到字体上了，同理可以设置按钮各状态的不同显示效果
        [self setTitleColor:[UIColor colorWithPatternImage:gradientImage] forState:UIControlStateNormal];
    }
}

//将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_gradientColors) {
        [self setTitleGradientColors:_gradientColors];
    }
}
@end
