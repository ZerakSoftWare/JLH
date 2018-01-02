//
//  VVLoanBaseInfoView.h
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVBaseViewController.h"
@class VVLoanBaseInfoView;
@protocol  VVLoanBaseInfoViewDelagate<NSObject>
@optional
-(void)enterLoanMobileView;
-(void)postBaseInfoNextStep:(NSString*)step;

@end
@interface VVLoanBaseInfoView : UIView
@property(nonatomic,strong)VVCommonButton *nextBtn;

@property(nonatomic,weak)VVBaseViewController *controller;
@property(nonatomic,assign)id<VVLoanBaseInfoViewDelagate>loanBaseInfoDelagate;
- (void)basicInformationView;
- (VVCreditBaseInfoModel *)transforModel;
@end
