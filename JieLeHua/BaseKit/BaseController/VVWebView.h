//
//  VVWebView.h
//  O2oApp
//
//  Created by chenlei on 16/6/30.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VVWebView;
@protocol VVWebViewNavDelegate <NSObject>

- (void)webViewDidGoBackWithGesture:(VVWebView*)webView;

@end

@interface VVWebView : UIWebView
@property(nonatomic, assign) BOOL enablePanGesture;
@property (nonatomic, weak) id<VVWebViewNavDelegate> navDelegate;
@property (nonatomic, strong)NSMutableArray* historyArray;

@end
