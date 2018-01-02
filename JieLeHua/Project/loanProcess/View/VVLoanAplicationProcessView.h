//
//  VVLoanAplicationProcessView.h
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VVLoanAplicationProcessView;
@protocol  VVLoanAplicationProcessViewDelagate<NSObject>
- (void)clickApplicationStep:(enum ApplyType)showViewType ;

@end
@interface VVLoanAplicationProcessView : UIView
@property(nonatomic,assign)id<VVLoanAplicationProcessViewDelagate>loanAppProcessDelagate;
- (void)changeStepViewStatus:(enum ApplyType)showViewType;
@end
