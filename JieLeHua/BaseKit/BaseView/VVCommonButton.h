//
//  VVommonButton.h
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-26.
//
//

#import <UIKit/UIKit.h>

@interface VVCommonButton : UIButton

+ (instancetype)solidButtonWithTitle:(NSString*)title;
+ (instancetype)solidBlueButtonWithTitle:(NSString*)title;
+ (instancetype)solidWhiteButtonWithTitle:(NSString*)title;
+ (instancetype)hollowButtonWithTitle:(NSString*)title;
+ (instancetype)hollowBlueButtonWithTitle:(NSString*)title;
+ (instancetype)getSMSCodeButton;
+ (instancetype)grayButtonchangeSolidButtonWithTitle:(NSString*)title;

+ (instancetype)navigationButtonWithTitle:(NSString*)title;
+ (instancetype)navigationRectangleButtonWithTitle:(NSString*)title;
+ (instancetype)actionSheetDestructiveButtonWithTitle:(NSString*)title;
+ (instancetype)actionSheetCancelButtonWithTitle:(NSString*)title;
+ (instancetype)actionSheetOtherButtonWithTitle:(NSString*)title;
+ (instancetype)actionSheetOtherButtonWithTitleAndColor:(NSString*)title fontColor:(UIColor *)color;
//设置文字渐变色
- (void)setGradientColors:(NSArray<UIColor *> *)colors;
@end



@interface VVBackButton : UIButton

+ (instancetype)backButton;

@end
