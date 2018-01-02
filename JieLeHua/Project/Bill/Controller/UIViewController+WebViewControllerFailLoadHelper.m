//
//  UIViewController+WebViewControllerFailLoadHelper.m
//  JieLeHua
//
//  Created by kuang on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "UIViewController+WebViewControllerFailLoadHelper.h"
#import <objc/runtime.h>

static const char associatedPlaceholdViewkey;

@implementation UIViewController (WebViewControllerFailLoadHelper)

#pragma mark - init

- (FailLoadPlaceholdView *)failLoadView {
    
    FailLoadPlaceholdView *view = objc_getAssociatedObject(self, &associatedPlaceholdViewkey);
    if (!view) {
        view = [[FailLoadPlaceholdView alloc] initWithSuperView:self.view];
        objc_setAssociatedObject(self, &associatedPlaceholdViewkey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return view;
}

- (void)showErrorPlaceholdView:(UIImage *)errorImage errorMsg:(NSString *)errorMsg
{
    [self.failLoadView show];
    [self.failLoadView refreshErrorImage:errorImage errorMsg:errorMsg];
}

- (void)addReloadTarget:(id)target action:(SEL)action
{
    [self.failLoadView addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

- (UIEdgeInsets)originalContentInset
{
    return UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)hiddenFailLoadViewView
{
    [self.failLoadView hidden];
}

- (void)setFailY:(CGFloat)y
{
    [self.failLoadView setOriginY:y];
}
@end
