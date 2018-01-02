//
//  VVPickerView.m
//  O2oApp
//
//  Created by YuZhongqi on 16/6/14.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVPickerView.h"

#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#define containterTextFieldViewHeight 45 //盛放TextField的视图高度
// 缩放比
#define kScale ([UIScreen mainScreen].bounds.size.width) / 375
#define hScale ([UIScreen mainScreen].bounds.size.height) / 667

@interface VVPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIView *upVeiw;
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    
}

@property (nonatomic, copy) NSArray *selectedArray;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@property(nonatomic,strong) UIView * bgView;
@property(nonatomic,strong) UILabel * pleaseChooseLab;
@property(nonatomic,assign) NSInteger  selectedRow;

@end

@implementation VVPickerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(0, 0, screenWith, screenHeight);
        self.backgroundColor = [UIColor colorWithRed:0.2  green:0.2  blue:0.2  alpha:0.5];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWith, screenHeight)];
        bgView.backgroundColor = [ UIColor whiteColor];
        bgView.frame = CGRectMake(0, screenHeight, screenWith, (bankCardPickerViewHeight + containterBtnViewHeight) *hScale);
        [self addSubview:bgView];
        self.bgView = bgView;
        
        [self showAnimation];
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, containterBtnViewHeight-20, [UIScreen mainScreen].bounds.size.width, 180)];
        self.pickerView.backgroundColor = [UIColor clearColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        [self.bgView addSubview:self.pickerView];
        
        UIView *seperateLine = [[UIView alloc]init];
        seperateLine.frame = CGRectMake(0, 66, vScreenWidth, 0.5);
        seperateLine.backgroundColor = VVColorRGBA(1, 1, 1, 0.2);
        [self.pickerView addSubview:seperateLine];
        
        UIView *seperateLine1 = [[UIView alloc]init];
        seperateLine1.frame = CGRectMake(0, 66 + 46.5, vScreenWidth, 0.5);
        seperateLine1.backgroundColor = VVColorRGBA(1, 1, 1, 0.2);
        [self.pickerView addSubview:seperateLine1];

        
        //盛放按钮的View
        upVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWith, containterBtnViewHeight)];
        upVeiw.backgroundColor = self.upViewColor ? self.upViewColor:[UIColor colorWithWholeRed:241 green:244 blue:246] ;
        [self.bgView addSubview:upVeiw];
        
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 0, 40, containterBtnViewHeight);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:VVColor666666 forState:UIControlStateNormal];
        [cancelButton setTitleColor:VV_COL_RGB(0x8ebbee) forState:UIControlStateHighlighted];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton addTarget:self action:@selector(hiddenPickerView) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:cancelButton];
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 40, containterBtnViewHeight);
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        [chooseButton setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
        [chooseButton setTitleColor:VV_COL_RGB(0x8ebbee) forState:UIControlStateHighlighted];
        chooseButton.backgroundColor = [UIColor clearColor];
        [chooseButton addTarget:self action:@selector(hiddenPickerViewRight) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:chooseButton];
        
        UILabel *pleaseChooseLab = [[UILabel alloc]init];
        pleaseChooseLab.frame = CGRectMake(cancelButton.right, 0, upVeiw.width - cancelButton.width - chooseButton.width - 20, containterBtnViewHeight);
        pleaseChooseLab.text = self.title;
        pleaseChooseLab.textAlignment = NSTextAlignmentCenter;
        pleaseChooseLab.textColor = VVWhiteColor;
        pleaseChooseLab.font = [UIFont systemFontOfSize:16.0f];
        [upVeiw addSubview:pleaseChooseLab];
        self.pleaseChooseLab = pleaseChooseLab;
        
    }
    
    return self;
}

- (void)setUpViewColor:(UIColor *)upViewColor
{
    upVeiw.backgroundColor = upViewColor;
}

- (void)setTitle:(NSString *)title
{
    self.pleaseChooseLab.textColor = [UIColor colorWithHexString:@"333333"];
    self.pleaseChooseLab.text = title;
}

- (void)setRightBtnColor:(UIColor *)rightBtnColor
{
    [chooseButton setTitleColor:rightBtnColor forState:UIControlStateNormal];
    [chooseButton setTitleColor:rightBtnColor forState:UIControlStateHighlighted];}

//显示动画
- (void)showAnimation{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.bgView.frame;
        frame.origin.y = screenHeight-(bankCardPickerViewHeight + containterBtnViewHeight)*hScale;
        self.bgView.frame = frame;
    }];
    
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.showDataArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}


#pragma mark -- UIPickerViewDelegate
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWith, 100)];
    label.font = [UIFont systemFontOfSize:21.f];
    label.tag = 200 + row;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.showDataArr[row];
    return label;
    
    
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedRow = row;
    _string = self.showDataArr[row];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hiddenPickerView];
}


//隐藏View
- (void)hiddenPickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = self.bgView.frame;
        frame.origin.y = screenHeight;
        self.bgView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
    [self.myTextField resignFirstResponder];
}

//确认的隐藏
-(void)hiddenPickerViewRight
{
    [self hiddenPickerView];
    
    if (VV_IS_NIL(_string)) {
        _string = _showDataArr[0];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishPickViewWithTextField:text:row:)]) {
        if (_string == nil) {
            [self.delegate didFinishPickViewWithTextField:self.myTextField text:[self.showDataArr objectAtIndex:0] row:0];
        }else{
            [self.delegate didFinishPickViewWithTextField:self.myTextField text:_string row:_selectedRow];
        }
    }
    [self.myTextField resignFirstResponder];
    
}


@end
