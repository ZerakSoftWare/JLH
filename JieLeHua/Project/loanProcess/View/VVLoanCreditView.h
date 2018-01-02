//
//  VVLoanCreditView.h
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VVLoanCreditView;
@protocol  VVLoanCreditViewDelagate<NSObject>
@optional
-(void)enterHomeView;
- (void)postCreditInfoNextStep:(NSString*)step;
-(void)pushMobileBillController;

@end
@interface VVLoanCreditView : UIView
@property(nonatomic,strong)VVCommonButton *nextBtn;

@property(nonatomic,weak)VVBaseViewController *controller;
@property(nonatomic,assign)id<VVLoanCreditViewDelagate>loanCreditDelagate;
- (void)showCreditSubView;
@end
