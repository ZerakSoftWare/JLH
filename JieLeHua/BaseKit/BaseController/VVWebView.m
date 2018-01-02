//
//  VVWebView.m
//  O2oApp
//
//  Created by chenlei on 16/6/30.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVWebView.h"

@interface VVWebView()<UIWebViewDelegate>
{
    UIGestureRecognizer* _popGesture;
    CGFloat _panStartX;
    UIImageView* _historyimageView;
    
    __weak id<UIWebViewDelegate> _originalDelegate;
}
@end

@implementation VVWebView

+ (UIImage *)screenshotOfView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    }
    else{
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _historyimageView.frame = self.bounds;
}

- (void)setUp
{
    [super setDelegate:self];
    _historyArray = [[NSMutableArray alloc] init];
    _popGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(pan:)];
    [self addGestureRecognizer:_popGesture];
    _historyimageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _historyimageView.contentMode = UIViewContentModeScaleAspectFill;
    CALayer *layer = _historyimageView.layer;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
    layer.shadowPath = path.CGPath;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.4f;
    layer.shadowRadius = 8.0f;
    _popGesture.enabled = _enablePanGesture;
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate
{
    _originalDelegate = delegate;
}

- (id<UIWebViewDelegate>)delegate
{
    return _originalDelegate;
}

- (void)setEnablePanGesture:(BOOL)enablePanGesture
{
    _enablePanGesture = enablePanGesture;
    _popGesture.enabled = enablePanGesture;
}

- (void)goBack{
    [super goBack];
    [_historyArray removeLastObject];
}

- (BOOL)canGoBack
{
    if (_historyArray.count == 0) return NO;
    return [super canGoBack];
}

#pragma - panGesture

- (void)pan:(UIPanGestureRecognizer *)sender
{
    if (![self canGoBack] || _historyArray.count == 0) {
        
        return;
    }
    CGPoint point = [sender translationInView:self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        _panStartX = point.x;
    }
    else if (sender.state == UIGestureRecognizerStateChanged){
        CGFloat deltaX = point.x - _panStartX;
        if (deltaX > 0) {
            if ([self canGoBack]) {
                
                [self.superview insertSubview:_historyimageView belowSubview:self];
                
                CGRect rc = self.frame;
                rc.origin.x = deltaX;
                self.frame = rc;
                _historyimageView.image = [[_historyArray lastObject] objectForKey:@"preview"];
                rc.origin.x = -self.bounds.size.width/2.0f + deltaX/2.0f;
                _historyimageView.frame = rc;
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded){
        CGFloat deltaX = point.x - _panStartX;
        CGFloat duration = .5f;
        if ([self canGoBack]) {
            if (deltaX > self.bounds.size.width/4.0f) {
                [UIView animateWithDuration:(1.0f - deltaX/self.bounds.size.width)*duration animations:^{
                    CGRect rc = self.frame;
                    rc.origin.x = self.bounds.size.width;
                    self.frame = rc;
                    rc.origin.x = 0;
                    _historyimageView.frame = rc;
                } completion:^(BOOL finished) {
                    CGRect rc = self.frame;
                    rc.origin.x = 0;
                    self.frame = rc;
                    [self.superview insertSubview:_historyimageView aboveSubview:self];
                    [self goBack];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [_historyimageView removeFromSuperview];
                        if (self.navDelegate && [self.navDelegate respondsToSelector:@selector(webViewDidGoBackWithGesture:)]) {
                            [self.navDelegate webViewDidGoBackWithGesture:self];                        }
                        _historyimageView.image = nil;
                    });
                }];
            }
            else{
                [UIView animateWithDuration:(deltaX/self.bounds.size.width)*duration animations:^{
                    CGRect rc = self.frame;
                    rc.origin.x = 0;
                    self.frame = rc;
                    rc.origin.x = -self.bounds.size.width/2.0f;
                    _historyimageView.frame = rc;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
}

#pragma - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL ret = YES;
    
    if (_originalDelegate && [_originalDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_originalDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTPOrFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    if (ret && !isFragmentJump && isHTTPOrFile && isTopLevelNavigation) {
        if ((navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeOther) && [[webView.request.URL description] length]) {
            if (![[[_historyArray lastObject] objectForKey:@"url"] isEqualToString:[self.request.URL description]]) {
                UIImage *curPreview = [VVWebView screenshotOfView:self];
                [_historyArray addObject:@{@"preview":curPreview, @"url":[self.request.URL description]}];
            }
        }
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_originalDelegate && [_originalDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_originalDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_originalDelegate && [_originalDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_originalDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (_originalDelegate && [_originalDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_originalDelegate webView:webView didFailLoadWithError:error];
    }
}

@end
