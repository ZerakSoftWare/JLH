//
//  LimitTextView.h
//  JieLeHua
//
//  Created by admin on 17/3/3.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitTextView : UIView<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) UILabel *residueLabel;

@end
