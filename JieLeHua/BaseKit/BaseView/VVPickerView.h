//
//  VVPickerView.h
//  O2oApp
//
//  Created by YuZhongqi on 16/6/14.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import <UIKit/UIKit.h>


#define bankCardPickerViewHeight 180  //pickerview高度
#define containterBtnViewHeight 40    //pickerview上方盛放按钮的view的高度

@protocol VVPickerViewDelegate <NSObject>
@optional

-(void)didFinishPickViewWithTextField:(UITextField*)myTextField text:(NSString*)text row:(NSInteger)row;
-(void)pickerviewbuttonclick:(UIButton *)sender;
-(void)hiddenPickerView;

@end


@interface VVPickerView : UIView
@property (nonatomic,strong)UITextField *myTextField;
@property(nonatomic,strong) NSArray * showDataArr;
@property(nonatomic,assign)id<VVPickerViewDelegate>delegate;

@property (nonatomic, strong) UIColor *upViewColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *rightBtnColor;
- (void)hiddenPickerView;
@end


