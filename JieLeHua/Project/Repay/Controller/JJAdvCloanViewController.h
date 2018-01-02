//
//  JJAdvCloanViewController.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJCloanInfoModel;
@protocol JJAdvCloanViewControllerUpdateDelegate <NSObject>

- (void)updateWithAdvData:(JJCloanInfoModel *)data isFail:(BOOL)failed;

@end
@interface JJAdvCloanViewController : UIViewController
@property (nonatomic, weak) id <JJAdvCloanViewControllerUpdateDelegate> delegate;
@end
