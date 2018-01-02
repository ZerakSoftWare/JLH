//
//  VVCustomActionSheet.h
//  VCREDIT
//
//  Created by chenlei on 14-4-7.
//  Copyright (c) 2014年  vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VVCustomActionSheetDelegate;
@interface VVCustomActionSheet : UIView<UIGestureRecognizerDelegate>
{
    CGFloat _totalHeight;
}
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *actionView;

@property (nonatomic, assign) NSInteger cancelIndex;
@property (nonatomic, assign) id<VVCustomActionSheetDelegate> delegate;

@property (nonatomic, readonly) NSMutableArray *buttonTitles;

- (id)initWithTitle:(NSString *)title delegate:(id<VVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle;
- (id)initWithTitle:(NSString *)title delegate:(id<VVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithTitle:(NSString *)title delegate:(id<VVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle isWalletView:(BOOL)isWalletView otherButtonTitles:(NSArray *)titleArray;

- (void)showTitle:(NSString *)title delegate:(id<VVCustomActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


- (void)show;
@end


@protocol VVCustomActionSheetDelegate <NSObject>

@optional
- (void)customActionSheet:(VVCustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


typedef void(^VVFinishedWithButtonIndexBlock)(NSInteger buttonIndex);
@interface VVCustomActionSheet(Convenience)
- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle completion:(VVFinishedWithButtonIndexBlock)completion;
@end