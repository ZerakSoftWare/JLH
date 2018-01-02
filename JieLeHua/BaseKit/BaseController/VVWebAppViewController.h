//
//  VVBaseWebViewController.h
//  O2oApp
//
//  Created by chenlei on 16/6/14.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVBaseViewController.h"
#import "VVWebView.h"


@interface VVWebAppViewController : VVBaseViewController
{
    UIButton*   _btnClose;
    VVWebView * _webView;
    NSString *_newWebTitle;
}
@property(nonatomic,copy)NSString *webTitle;
@property(nonatomic,copy)NSString *startPage;
@end
