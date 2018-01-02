//
//  VVCustomActionSheet.m
//  VCREDIT
//
//  Created by chenlei on 14-4-7.
//  Copyright (c) 2014年  vcredit. All rights reserved.
//

#import "VVCustomActionSheet.h"
#import "VVCommonButton.h"

#define kAnimationDuration 0.3

@interface VVCustomActionSheetBlockDelegate : NSObject<VVCustomActionSheetDelegate>
@property (nonatomic, copy)VVFinishedWithButtonIndexBlock completion;

@end
@implementation VVCustomActionSheetBlockDelegate
- (void)customActionSheet:(VVCustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.completion(buttonIndex);
}
@end

@implementation VVCustomActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (void)dismissActionViewNc{
    
    [self dismissSelf];
}

- (id)initWithTitle:(NSString *)title delegate:(id<VVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle {
    return [self initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
}

//为我的钱包页面定制的VVCustomActionSheet
- (id)initWithTitle:(NSString *)title delegate:(id<VVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle isWalletView:(BOOL)isWalletView otherButtonTitles:(NSArray *)titleArray
{
    self = [super init];
    if (self) {
        
        _buttonTitles = [[NSMutableArray alloc] init];
        
        self.delegate = delegate;
        // 灰色遮罩
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+kStatusBarHeight)];
        [_maskView setAlpha:0.0];
        [_maskView setBackgroundColor:[UIColor blackColor]];
        
        // 点击 取消手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
        [_maskView addGestureRecognizer:tap];
        
        // 内容背景
        _actionView = [[UIView alloc] initWithFrame:CGRectZero];
        [_actionView setBackgroundColor:[UIColor whiteColor]];
        
        
        
        CGFloat originY = 22,height = 0;
        
        // add title
        CGFloat labelOriginX = 16;
        CGFloat labelWidth = kScreenWidth-labelOriginX*2;
        CGRect titleLabelFrame = CGRectMake(labelOriginX, originY, labelWidth, height);
        if (title) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = VV_COL_RGB(0x6c6c6c);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.numberOfLines = 0;
            //            if (VV_IOS_VERSION >= 7.0) {
            //                height = [title boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil].size.height;
            //            } else {
            height = [title sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
            //            }
            titleLabel.text = title;
            titleLabelFrame.size.height = height;
            titleLabel.frame = titleLabelFrame;
            [_actionView addSubview:titleLabel];
            
//            originY = titleLabelFrame.origin.y + titleLabelFrame.size.height+23;
        }
        
        __block NSInteger buttonTag = 0;
        CGFloat buttonHight = 48;
        
        //CGRect buttonFrame = CGRectMake(originX, originY, width, buttonHight);
        __block CGRect buttonFrame = CGRectMake(0, 0, kScreenWidth, buttonHight);
        
        // add other button
        if (titleArray.count>0) // The first argument isn't part of the varargs list,
        {                                   // so we'll handle it separately.
            [titleArray enumerateObjectsUsingBlock:^(NSDictionary *titleDict, NSUInteger idx, BOOL *stop){
                NSString *title = titleDict[@"name"];
                [self addOtherButtonsAtFrame:buttonFrame title:title tag:buttonTag];
                
                VVCommonButton *itemButton = [VVCommonButton actionSheetOtherButtonWithTitleAndColor:title fontColor:[UIColor blackColor]];
                [itemButton setFrame:buttonFrame];
                itemButton.tag = buttonTag;
                [itemButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
                [itemButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [_actionView addSubview:itemButton];
                
                //添加底部边界线
                UIView *_footLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonFrame.origin.y, kScreenWidth, 0.5f)];
                _footLine.hidden = NO;
                _footLine.alpha = 0.5f;
                _footLine.backgroundColor = VV_COL_RGB(0xaaaaaa);
                [_actionView addSubview:_footLine];
                
                
                buttonFrame.origin.y += buttonFrame.size.height;
                [_buttonTitles addObject:title];
                buttonTag++;

            }];
            
            
        }
        
        UIView * paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, buttonFrame.origin.y, kScreenWidth, 10)];
        [paddingView setBackgroundColor:VV_COL_RGB(0xefeff4)];
        [_actionView addSubview:paddingView];
        
        // add cancel button
        if (cancelButtonTitle) {
            
            VVCommonButton* cancelButton = [VVCommonButton actionSheetOtherButtonWithTitleAndColor:cancelButtonTitle fontColor:VV_COL_RGB(0x888888)];
            buttonFrame.origin.y += 10;
            [cancelButton setFrame:buttonFrame];
            
            cancelButton.tag = buttonTag;
            [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
            [cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_actionView addSubview:cancelButton];
            self.cancelIndex  = cancelButton.tag;
            
            [_buttonTitles addObject:cancelButtonTitle];
        }
        
        _totalHeight = buttonFrame.origin.y + buttonFrame.size.height;
        _actionView.frame = CGRectMake(0, kScreenHeight+kStatusBarHeight, kScreenWidth, _totalHeight);
    }
    return self;

}

- (void)showTitle:(NSString *)title delegate:(id<VVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
  

}


- (id)initWithTitle:(NSString *)title delegate:(id<VVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    
    self = [super init];
    if (self) {
        _buttonTitles = [[NSMutableArray alloc] init];
        
        self.delegate = delegate;
        // 灰色遮罩
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+kStatusBarHeight)];
        [_maskView setAlpha:0.0];
        [_maskView setBackgroundColor:[UIColor blackColor]];
        
        // 点击 取消手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
        [_maskView addGestureRecognizer:tap];
        
        // 内容背景
        _actionView = [[UIView alloc] initWithFrame:CGRectZero];
        [_actionView setBackgroundColor:VV_COL_RGB(0xe7e7e7)];
        
        CGFloat originX = 19,originY = 22,height = 0;
        
        // add title
        CGFloat labelOriginX = 16;
        CGFloat labelWidth = kScreenWidth-labelOriginX*2;
        CGRect titleLabelFrame = CGRectMake(labelOriginX, originY, labelWidth, height);
        if (title) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = VV_COL_RGB(0x6c6c6c);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.numberOfLines = 0;
            //            if (VV_IOS_VERSION >= 7.0) {
            //                height = [title boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil].size.height;
            //            } else {
            height = [title sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
            //            }
            titleLabel.text = title;
            titleLabelFrame.size.height = height;
            titleLabel.frame = titleLabelFrame;
            [_actionView addSubview:titleLabel];
            
            originY = titleLabelFrame.origin.y + titleLabelFrame.size.height+23;
        }
        
        NSInteger buttonTag = 0;
        
        CGFloat width = kScreenWidth-originX*2;
        // add destructive button
        CGFloat buttonHight = 44;
        CGRect buttonFrame = CGRectMake(originX, originY, width, buttonHight);
        if (destructiveButtonTitle) {
            
            VVCommonButton *destructiveButton = [VVCommonButton actionSheetDestructiveButtonWithTitle:destructiveButtonTitle];
            [destructiveButton setFrame:buttonFrame];
            [destructiveButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
            destructiveButton.tag = buttonTag;
            [destructiveButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_actionView addSubview:destructiveButton];
            
            buttonFrame.origin.y += buttonFrame.size.height + 18;
            [_buttonTitles addObject:destructiveButtonTitle];
            buttonTag++;
        }
        
        // add other button
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) // The first argument isn't part of the varargs list,
        {                                   // so we'll handle it separately.
            
            [self addOtherButtonsAtFrame:buttonFrame title:otherButtonTitles tag:buttonTag];
            
            buttonFrame.origin.y += buttonFrame.size.height + 18;
            [_buttonTitles addObject:otherButtonTitles];
            buttonTag++;
            va_start(argumentList, otherButtonTitles); // Start scanning for arguments after firstObject.
            while ((eachObject = va_arg(argumentList, NSString *))) {// As many times as we can get an argument of type "id"
                //                [self addObject: eachObject]; // that isn't nil, add it to self's contents.
                
                [self addOtherButtonsAtFrame:buttonFrame title:eachObject tag:buttonTag];
                
                buttonFrame.origin.y += buttonFrame.size.height + 18;
                [_buttonTitles addObject:eachObject];
                buttonTag++;
            }
            va_end(argumentList);
        }
        
        
        // add cancel button
        if (cancelButtonTitle) {
            VVCommonButton *cancelButton = [VVCommonButton actionSheetCancelButtonWithTitle:cancelButtonTitle];
            [cancelButton setFrame:buttonFrame];
            cancelButton.tag = buttonTag;
            [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
            [cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_actionView addSubview:cancelButton];
            self.cancelIndex  = cancelButton.tag;
            
            [_buttonTitles addObject:cancelButtonTitle];
        }else{
            buttonFrame.origin.y -= buttonFrame.size.height + 18;
        }
        _totalHeight = buttonFrame.origin.y + buttonFrame.size.height +20;
        _actionView.frame = CGRectMake(0, kScreenHeight+kStatusBarHeight, kScreenWidth, _totalHeight);
    }
    return self;
}

- (void)addOtherButtonsAtFrame:(CGRect )frame title:(NSString *)title tag:(NSInteger)tag
{
    VVCommonButton *cancelButton = [VVCommonButton actionSheetOtherButtonWithTitle:title];
    [cancelButton setFrame:frame];
    cancelButton.tag = tag;
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [cancelButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:cancelButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIImage*)createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//- (void)show{
//    if (self) {
//        [VV_App.naviController.view addSubview:self];
//    }else{
//        return;
//    }
//    UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
//    [window addSubview:_maskView];
//    [window addSubview:_actionView];
//    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        [_maskView setAlpha:0.6];
//        [_actionView setTop:kScreenHeight+kStatusBarHeight-_totalHeight];
//    } completion:^(BOOL finished) {
//    }];
//    
//}

- (void)dismissSelf{


    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_maskView setAlpha:0.0];
        [_actionView setTop:kScreenHeight+kStatusBarHeight];
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        [_actionView removeFromSuperview];
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(customActionSheet:clickedButtonAtIndex:)]) {
            [self.delegate customActionSheet:self clickedButtonAtIndex:self.cancelIndex];
        }
    }];
    
}

- (void)buttonPressed:(UIButton *)sender
{
    [self dismissSelf];
    if ([self.delegate respondsToSelector:@selector(customActionSheet:clickedButtonAtIndex:)]) {
        [self.delegate customActionSheet:self clickedButtonAtIndex:sender.tag];
    }
}

@end

@implementation VVCustomActionSheet(Convenience)

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle completion:(void (^)(NSInteger buttonIndex))completion
{
    VVCustomActionSheetBlockDelegate* delegate = [[VVCustomActionSheetBlockDelegate alloc] init];
    delegate.completion = completion;
    self = [self initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    objc_setAssociatedObject(self, "completionBlockKey", delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

@end
