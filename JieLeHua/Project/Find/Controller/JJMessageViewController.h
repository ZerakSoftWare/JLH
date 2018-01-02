//
//  JJMessageViewController.h
//  JieLeHua
//
//  Created by 维信金科 on 17/2/27.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JJMessageViewController : VVBaseViewController<UIWebViewDelegate>

@property (nonatomic,strong) NSString *messageTitle;

@property (nonatomic, strong) UIWebView *messageWeb;

@property (nonatomic, strong) JSContext *context;

@end
