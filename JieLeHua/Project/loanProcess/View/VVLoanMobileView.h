//
//  VVLoanMobileView.h
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VVLoanMobileView;
@protocol  VVLoanMobileViewDelagate<NSObject>
@optional
-(void)enterLoanCreditView;
-(void)postMobileNextStep:(NSString*)step;
-(void)returnToHomeViewController;
@end
@interface VVLoanMobileView : UIView
@property(nonatomic,strong)VVCommonButton *nextBtn;
@property(nonatomic,weak)VVBaseViewController *controller;
@property(nonatomic,assign)id<VVLoanMobileViewDelagate>loanMobileViewDelagate;
- (void)showMobileNextView:(BOOL)isModification;
- (void)showBackPreviewShowMobileNextView;

@end
