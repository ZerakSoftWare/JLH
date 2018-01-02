//
//  JJOverDueViewController.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/10.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJOverDueListModel;
@protocol JJOverDueViewControllerUpdateDelegate <NSObject>

- (void)updateWithData:(JJOverDueListModel *)data isFail:(BOOL)failed;

@end

@interface JJOverDueViewController : UIViewController
@property (nonatomic, copy) NSString *customerBillId;
@property (nonatomic, weak) id<JJOverDueViewControllerUpdateDelegate> delegate;
-(void)refreashOverDueView;
@end
