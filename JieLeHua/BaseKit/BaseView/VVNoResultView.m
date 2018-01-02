//
//  VVNoResultView.m
//  O2oApp
//
//  Created by chenlei on 16/8/1.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVNoResultView.h"
#import "VVWebView.h"
@interface VVNoResultView()<UIWebViewDelegate>
{
    VVWebView * _webView;
}
@end
@implementation VVNoResultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _webView = [[VVWebView alloc]init];
        _webView.frame = frame;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.bounces = YES;
        [self addSubview:_webView];
    }
    
    return self;
}

- (void)loadWebView:(NSString*)url{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

@end
