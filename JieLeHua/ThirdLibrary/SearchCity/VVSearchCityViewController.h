//
//  VVSearchCityViewController.h
//  O2oApp
//
//  Created by YuZhongqi on 16/4/21.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVSearchCityViewController : VVBaseViewController

@property(nonatomic,copy) void (^selectedRowInfo)(NSString *rowInfo, NSString *cityCode,id result);
@property(nonatomic,assign) UIViewController *loanViewController;


@end
