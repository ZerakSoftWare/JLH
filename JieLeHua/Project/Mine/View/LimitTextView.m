//
//  LimitTextView.m
//  JieLeHua
//
//  Created by admin on 17/3/3.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "LimitTextView.h"

@implementation LimitTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10,3,self.bounds.size.width-24,self.bounds.size.height-30)];
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.delegate = self;
        
        self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(12,5,self.bounds.size.width-24,42)];
        self.placeHolderLabel.numberOfLines = 0;
        self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
        self.placeHolderLabel.textColor = VVColor999999;
        self.placeHolderLabel.text = @"使用过程中有什么不满都统统砸过来吧，产品汪会努力改进的~";
        
        self.residueLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-100, self.bounds.size.height-30, 90, 20)];
        self.residueLabel.textAlignment = NSTextAlignmentRight;
        self.residueLabel.font = [UIFont systemFontOfSize:12];
        self.residueLabel.text = @"0/300字";
        self.residueLabel.textColor = VVColor999999;
        
        [self addSubview:self.textView];
        [self addSubview:self.placeHolderLabel];
        [self addSubview:self.residueLabel];
    }
    return self;
}

- (void)textViewDidChange:(UITextView*)textView
{
    if([textView.text length] == 0)
    {
        self.placeHolderLabel.text = @"使用过程中有什么不满都统统砸过来吧，产品汪会努力改进的~";
    }
    else
    {
        self.placeHolderLabel.text = @"";//这里给空
    }
    
    //计算剩余字数   不需要的也可不写
    NSString *nsTextCotent = textView.text;
    
    int existTextNum = (int)[nsTextCotent length];
    
    self.residueLabel.text = [NSString stringWithFormat:@"%d/300字",existTextNum];
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return YES;
    }
    else
    {
        if (range.location >=300)
        {
            return  NO;
        }
        else
        {
            return YES;
        }
    }
}

@end
