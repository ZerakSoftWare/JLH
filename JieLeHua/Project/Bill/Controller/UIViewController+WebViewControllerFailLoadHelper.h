//
//  UIViewController+WebViewControllerFailLoadHelper.h
//  JieLeHua
//
//  Created by kuang on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FailLoadPlaceholdView.h"

@interface UIViewController (WebViewControllerFailLoadHelper)

@property (nonatomic, strong, readonly) FailLoadPlaceholdView *failLoadView;

- (void)showErrorPlaceholdView:(UIImage *)errorImage errorMsg:(NSString *)errorMsg;
- (void)addReloadTarget:(id)target action:(SEL)action;

- (void)hiddenFailLoadViewView;
- (void)setFailY:(CGFloat)y;
@end
