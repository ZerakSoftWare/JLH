//
//  VVloanApplicationSetpView.h
//  O2oApp
//
//  Created by chenlei on 16/4/21.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VVloanApplicationSetpView;
@protocol  VVloanApplicationSetpViewDelagate<NSObject>
- (void)stepViewclickApplicationStep:(VVloanApplicationSetpView *)setpView;

@end

@interface VVloanApplicationSetpView : UIView
@property(nonatomic,assign)BOOL isArrowSelect;
@property(nonatomic,assign)BOOL isDownSelect;

@property(nonatomic,strong)UIImageView *itemImageView;
@property(nonatomic,strong)UILabel  *titleLabel;
@property(nonatomic,strong)UIImageView  *arrowRightImageView;
@property(nonatomic,strong)UIImageView  *arrowDownImageView;

@property(nonatomic,strong)NSString  *step;

@property(nonatomic,weak)id<VVloanApplicationSetpViewDelagate>stepViewDelagate ;

@end
