//
//  VVLoanAplicationProcessView.m
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVLoanAplicationProcessView.h"
#import "VVloanApplicationSetpView.h"

@interface VVLoanAplicationProcessView ()<VVloanApplicationSetpViewDelagate>{
    VVloanApplicationSetpView *_selectView;//标题view
    UIView *_stepBackView;//标题背景view
    NSMutableArray *_stepViewArr;//步骤
   enum ApplyType _showViewType;
}

@end
@implementation VVLoanAplicationProcessView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _stepViewArr = [NSMutableArray arrayWithCapacity:1];
        [self setStepView];
    }
    return self;
}

- (void)setStepView{
    
    CGFloat stepBackViewHeight = 50;
    
    __block  CGFloat width = (kScreenWidth-ktextFieldLeft*3)/3;
    CGFloat place = ktextFieldLeft;
    _stepBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, kScreenWidth, stepBackViewHeight)];
    _stepBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_stepBackView];
    NSArray* titleArr = @[@{@"title":@"基本信息",@"step":@"16"},
                          @{@"title":@"身份认证",@"step":@"17"},
                          @{@"title":@"获取征信",@"step":@"18"}
                          ];
    
    [titleArr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _selectView = [[VVloanApplicationSetpView alloc]initWithFrame:CGRectMake(place*(idx+1)+idx*width, 0, width, stepBackViewHeight)];
        _selectView.stepViewDelagate = self;
        _selectView.backgroundColor = [UIColor clearColor];
        _selectView.titleLabel.text = obj[@"title"];
        _selectView.step = obj[@"step"];
        [_stepBackView addSubview:_selectView];
        [_stepViewArr addObject:_selectView];
        
       
    }];
    [self changeStepViewStatus:(enum ApplyType)[VV_SHDAT.orderInfo.applyStep integerValue]];


}

//点击步骤按钮
- (void)stepViewclickApplicationStep:(VVloanApplicationSetpView *)stepView{
    VVLog(@" 点击的步骤.step == %@  申请服务返回步骤==%@",stepView.step,VV_SHDAT.orderInfo.applyStep);

    if ([_loanAppProcessDelagate respondsToSelector:@selector(clickApplicationStep:)]) {
        [_loanAppProcessDelagate clickApplicationStep:(enum ApplyType)[stepView.step integerValue]];
    }

}

- (void)changeStepViewStatus:(enum ApplyType)showViewType{

    [_stepViewArr enumerateObjectsUsingBlock:^(VVloanApplicationSetpView * obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if ([VV_SHDAT.orderInfo.applyStatusCode  integerValue] == 15) {
            
            if ( [obj.step integerValue]  <= 17) {
                obj.isArrowSelect = YES;

            }else{
                obj.isArrowSelect = NO;
                
            }
            
        }else{
        
            if ( [obj.step integerValue] <= [VV_SHDAT.orderInfo.applyStatusCode integerValue]) {
                obj.isArrowSelect = YES;
               
            }else{
                obj.isArrowSelect = NO;
            }
        
        }
     
        if ([obj.step integerValue] == showViewType)
        {
            obj.isDownSelect = YES;
        }
        else
        {
            obj.isDownSelect = NO;
        }
        
    }];
    
    _showViewType = showViewType;

}

@end
