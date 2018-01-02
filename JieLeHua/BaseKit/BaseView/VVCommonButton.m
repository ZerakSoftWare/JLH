//
//  VVommonButton.m
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-26.
//
//

#import "VVCommonButton.h"
#import "UIButton+JJMultiClickButton.h"
#import "UIButton+Gradient.h"

@interface VVCommonButton()
{
    NSArray *_gradientColors; //存储渐变色数组
}

@end
@implementation VVCommonButton
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
//实心btn
+ (instancetype)solidButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:VVWhiteColor forState:UIControlStateNormal];
    [bt setTitleColor:VVWhiteColor forState:UIControlStateHighlighted];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    [bt setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    [bt setBackgroundColor:VVAppButtonTitleHeightLightColor forState:UIControlStateHighlighted];
    bt.layer.cornerRadius = VVcornerRadius;
    bt.clipsToBounds = YES;
    bt.vv_acceptEventInterval = 1;
    return bt;
}

//实心btn
+ (instancetype)solidBlueButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:VVWhiteColor forState:UIControlStateNormal];
    [bt setTitleColor:VVWhiteColor forState:UIControlStateHighlighted];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
//    [bt setGradientColors:@[[UIColor colorWithHexString:@"00d3fe"],[UIColor colorWithHexString:@"37a1ff"]]];
//    [bt setBackgroundImage:[UIImage imageNamed:@"btn_home_repayment"] forState:UIControlStateNormal];
    
    
    [bt gradientButtonWithSize:CGSizeMake(vScreenWidth, 44) colorArray:@[(id)[UIColor colorWithHexString:@"00d3fe"],(id)[UIColor colorWithHexString:@"37a1ff"]] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftBottomToRightTop];
    
    [bt setBackgroundColor:[UIColor colorWithHexString:@"c8daf1"] forState:UIControlStateDisabled];
    bt.layer.cornerRadius = VVcornerRadius;
    bt.clipsToBounds = YES;
    bt.vv_acceptEventInterval = 1;
    
    return bt;
}

//实心btn
+ (instancetype)solidWhiteButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorWithHexString:@"095FB3"] forState:UIControlStateHighlighted];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    [bt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt setBackgroundColor:[UIColor colorWithHexString:@"CCDCEC"] forState:UIControlStateHighlighted];
    bt.layer.cornerRadius = VVcornerRadius;
    bt.clipsToBounds = YES;
    bt.vv_acceptEventInterval = 1;
    
    return bt;
}


//空心btn
+ (instancetype)hollowButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:VVBASE_COLOR forState:UIControlStateNormal];
    [bt setTitleColor:VVAppButtonTitleHeightLightColor forState:UIControlStateHighlighted];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    [bt setBackgroundColor:VVWhiteColor   forState:UIControlStateNormal];
    [bt setBackgroundColor:VV_COL_RGB(0xEFEFF4) forState:UIControlStateHighlighted];
    bt.layer.borderWidth = 1;
    bt.layer.borderColor = VVBASE_COLOR.CGColor;
    bt.layer.cornerRadius = VVcornerRadius;
    bt.clipsToBounds = YES;
    bt.vv_acceptEventInterval = 1;
    return bt;
}

//空心btn
+ (instancetype)hollowBlueButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorWithHexString:@"36A3FF"] forState:UIControlStateNormal];
//    [bt setTitleColor:VVAppButtonTitleHeightLightColor forState:UIControlStateHighlighted];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    [bt setBackgroundColor:VVWhiteColor   forState:UIControlStateNormal];
    [bt setBackgroundColor:VV_COL_RGB(0xEFEFF4) forState:UIControlStateHighlighted];
    bt.layer.borderWidth = 1;
    bt.layer.borderColor = [UIColor colorWithHexString:@"36A3FF"].CGColor;
    bt.layer.cornerRadius = VVcornerRadius;
    bt.clipsToBounds = YES;
    bt.vv_acceptEventInterval = 1;
    return bt;
}

+ (instancetype)getSMSCodeButton{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"获取验证码" forState:UIControlStateNormal];
    [bt setTitleColor:VVWhiteColor forState:UIControlStateNormal];
    [bt setTitleColor:VV_COL_RGB(0xefeff4) forState:UIControlStateHighlighted];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    [bt setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    [bt setBackgroundColor:VVAppButtonTitleHeightLightColor forState:UIControlStateHighlighted];
    bt.layer.cornerRadius = 6;
    bt.clipsToBounds = YES;
    bt.vv_acceptEventInterval = 1;

    return bt;
}


//切换btn   统一
+ (instancetype)grayButtonchangeSolidButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];

//    [bt setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateNormal];
//    [bt setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateHighlighted];
//    [bt setTitleColor:VV_COL_RGB(0xFFFFFF) forState:UIControlStateDisabled];
//    [bt setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
//    [bt setBackgroundColor:VVAppButtonTitleHeightLightColor forState:UIControlStateHighlighted];
//    [bt setBackgroundColor:VVBASE_COLOR forState:UIControlStateDisabled];
    
    [bt setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    [bt setBackgroundColor:[UIColor colorWithHexString:@"095EB2"] forState:UIControlStateHighlighted];
    [bt setBackgroundColor:[UIColor colorWithRed:166.0/255.0 green:196.0/255.0 blue:244.0/255.0 alpha:1.0f] forState:UIControlStateDisabled];
    bt.vv_acceptEventInterval = 1;

    bt.layer.cornerRadius = VVcornerRadius;
    bt.clipsToBounds = YES;
    bt.exclusiveTouch = YES;
    return bt;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        [self setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    }else{
        [self setBackgroundColor:[UIColor unableButtonThemeColor] forState:UIControlStateNormal];

    }
}

+ (instancetype)navigationButtonWithTitle:(NSString*)title
{
    VVCommonButton* button = [self buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateNormal];
    [button setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateHighlighted];
    [button setTitleColor:VV_COL_RGB(0x777e81) forState:UIControlStateDisabled];

    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    button.titleLabel.shadowColor = VV_COL_RGB(0x171c1e);
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
    button.vv_acceptEventInterval = 1;

    button.exclusiveTouch = YES;
    return button;
}

+ (instancetype)navigationRectangleButtonWithTitle:(NSString*)title
{
    VVCommonButton* button = [self buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateNormal];
    [button setTitleColor:VV_COL_RGB(0xefeff4) forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    button.titleLabel.shadowColor = VV_COL_RGB(0x171c1e);
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets = UIEdgeInsetsMake(1, 0, 0, 0);
    button.vv_acceptEventInterval = 1;

    button.exclusiveTouch = YES;
    return button;
}

+ (instancetype)actionSheetDestructiveButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateNormal];
    [bt setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateHighlighted];
    [bt setTitleColor:VV_COL_RGB(0x666666) forState:UIControlStateDisabled];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    UIImage* bg = [VV_GETIMG(@"cus_actionSheet_destructiveBtn") stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    UIImage* hlBg = [VV_GETIMG(@"cus_actionSheet_destructiveBtn_h") stretchableImageWithLeftCapWidth:5 topCapHeight:22];
    //    UIImage* disableBg = [VV_GETIMG(@"bt_disable") stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    
    [bt setBackgroundImage:bg forState:UIControlStateNormal];
    [bt setBackgroundImage:hlBg forState:UIControlStateHighlighted];
    //    [bt setBackgroundImage:disableBg forState:UIControlStateDisabled];
    bt.vv_acceptEventInterval = 1;

    bt.exclusiveTouch = YES;
    return bt;
}

+ (instancetype)actionSheetCancelButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateNormal];
    [bt setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateHighlighted];
    [bt setTitleColor:VV_COL_RGB(0x666666) forState:UIControlStateDisabled];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    UIImage* bg = [VV_GETIMG(@"cus_actionSheet_cancelBtn") stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    UIImage* hlBg = [VV_GETIMG(@"cus_actionSheet_cancelBtn_h") stretchableImageWithLeftCapWidth:5 topCapHeight:22];
    //    UIImage* disableBg = [VV_GETIMG(@"bt_disable") stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    
    [bt setBackgroundImage:bg forState:UIControlStateNormal];
    [bt setBackgroundImage:hlBg forState:UIControlStateHighlighted];
    //    [bt setBackgroundImage:disableBg forState:UIControlStateDisabled];
    bt.vv_acceptEventInterval = 1;

    bt.exclusiveTouch = YES;
    return bt;
}

+ (instancetype)actionSheetOtherButtonWithTitle:(NSString*)title
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:VV_COL_RGB(0x6c6c6c) forState:UIControlStateNormal];
    [bt setTitleColor:VV_COL_RGB(0x6c6c6c) forState:UIControlStateHighlighted];
    [bt setTitleColor:VV_COL_RGB(0x666666) forState:UIControlStateDisabled];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    UIImage* bg = [VV_GETIMG(@"cus_actionSheet_otherBtn") stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    UIImage* hlBg = [VV_GETIMG(@"cus_actionSheet_otherBtn_h") stretchableImageWithLeftCapWidth:5 topCapHeight:22];
    //    UIImage* disableBg = [VV_GETIMG(@"bt_disable") stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    
    [bt setBackgroundImage:bg forState:UIControlStateNormal];
    [bt setBackgroundImage:hlBg forState:UIControlStateHighlighted];
    //    [bt setBackgroundImage:disableBg forState:UIControlStateDisabled];
    bt.vv_acceptEventInterval = 1;

    bt.exclusiveTouch = YES;
    return bt;
}

+ (instancetype)actionSheetOtherButtonWithTitleAndColor:(NSString*)title fontColor:(UIColor *)color
{
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:color forState:UIControlStateNormal];
    [bt setTitleColor:color forState:UIControlStateHighlighted];
    [bt setTitleColor:VV_COL_RGB(0x666666) forState:UIControlStateDisabled];
    bt.titleLabel.font  = [UIFont systemFontOfSize:17.0];
    UIImage* bg = [VV_GETIMG(@"cus_actionSheet_otherBtn") stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    UIImage* hlBg = [VV_GETIMG(@"cus_actionSheet_otherBtn_h") stretchableImageWithLeftCapWidth:5 topCapHeight:22];
    //    UIImage* disableBg = [VV_GETIMG(@"bt_disable") stretchableImageWithLeftCapWidth:4 topCapHeight:22];
    
    [bt setBackgroundImage:bg forState:UIControlStateNormal];
    [bt setBackgroundImage:hlBg forState:UIControlStateHighlighted];
    //    [bt setBackgroundImage:disableBg forState:UIControlStateDisabled];
    bt.vv_acceptEventInterval = 1;

    bt.exclusiveTouch = YES;
    return bt;
}


+ (instancetype)threeStateWithTitle:(NSString*)title
{
    
    VVCommonButton* bt = [self buttonWithType:UIButtonTypeCustom];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt.vv_acceptEventInterval = 1;

    return bt;
}


@end


@interface VVBackButton()
@property(nonatomic) UIEdgeInsets normalEdgeInsets;
@property(nonatomic) UIEdgeInsets highlightedEdgeInsets;
@end

@implementation VVBackButton

+ (instancetype)backButton
{
    VVBackButton* button = [VVBackButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        [button setTitleColor:VV_COL_RGB(0x777e81) forState:UIControlStateNormal];
        [button setTitleColor:VV_COL_RGB(0xf3f3f4) forState:UIControlStateHighlighted];
        [button setTitleColor:VV_COL_RGB(0x777e81) forState:UIControlStateDisabled];
        UIImage* bg = [VV_GETIMG(@"btn_nav_bar_return") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        UIImage* hlBg = VV_GETIMG(@"ic_titleBar_return_bg_tap");
//        UIImage* disableBg = VV_GETIMG(@"ic_titleBar_return_bg_tap");
        UIImage *hightlightBg = VV_GETIMG(@"btn_nav_bar_return");
        [button setImage:bg forState:UIControlStateNormal];
        [button setImage:hightlightBg forState:UIControlStateHighlighted];
//        [button setBackgroundImage:hlBg forState:UIControlStateHighlighted];
//        [button setBackgroundImage:disableBg forState:UIControlStateDisabled];
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        
        button.titleLabel.font  = [UIFont systemFontOfSize:17.0];
        button.titleLabel.shadowColor = VV_COL_RGB(0x171c1e);
        button.titleLabel.shadowOffset = CGSizeMake(0, -1);
        
        button.titleEdgeInsets = UIEdgeInsetsMake(1, -5.5, 0, 0);
        button.normalEdgeInsets = button.titleEdgeInsets;
        button.highlightedEdgeInsets =  button.titleEdgeInsets;
        
        
        button.exclusiveTouch = YES;
    }
    return button;
}

//- (void) setHighlighted:(BOOL)highlighted {
//    self.titleEdgeInsets = highlighted ? self.highlightedEdgeInsets : self.normalEdgeInsets;
//    [super setHighlighted:highlighted];
//    [self.imageView setAlpha:0.5];
//    [self.titleLabel setAlpha:0.5];
//}
@end

