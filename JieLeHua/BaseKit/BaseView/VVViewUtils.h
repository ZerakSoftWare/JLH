//
//  VVViewUtils.h
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-22.
//
//

#import <Foundation/Foundation.h>
#import "VVBaseViewController.h"

@interface VVViewUtils : NSObject

+ (void)drawImage:(UIImage *)image rect:(CGRect)rect;

//寻找某个类的VC
+ (UIViewController*)viewControllerOfClass:(Class)cls;
/*
 
 find the parent UIViewController
 
 */

+ (UIViewController*)findUIViewController:(UIResponder*)responder;

+ (UIViewController*)findRootController:(UIView*)view;

+ (UIView*)findFirstResponder:(UIView*)view;

+ (NSArray*)editableTextInputsInView:(UIView*)view;

//去掉输入框中的 markedText

+ (void)deleteMarkedTextWithView:(id<UITextInput>) inputView;

//push HomeVc
+ (void)customPushHomeVCWithVC:(VVBaseViewController *)vc;

@end
