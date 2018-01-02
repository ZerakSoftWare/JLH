//
//  UPBaseViewController.h
//  CHSP
//
//  Created by wxzhao on 12-11-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VVAlertView.h"
#import "VVWaitingView.h"
#import "VVNavigationBar.h"
//#import "VVNetworkErrorView.h"
//#import "MKNetworkOperation.h"
#import "VVScrollView.h"
#import "VVLodingView.h"
#import "MBProgressHUD+NJ.h"
@class VVBackButton;
#define kUPAnimationFlip        @"oglFlip"
#define kUPAnimationPush        kCATransitionPush
#define kUPAnimationReveal      kCATransitionReveal
#define kUPAnimationMoveIn      kCATransitionMoveIn
#define kUPAnimationFade        kCATransitionFade

#define kUPAnimationFromRight   kCATransitionFromRight
#define kUPAnimationFromLeft    kCATransitionFromLeft
#define kUPAnimationFromTop     kCATransitionFromTop
#define kUPAnimationFromBottom  kCATransitionFromBottom
@class VVCommonButton, VVHttpMessage;
@interface VVBaseViewController : UIViewController<UIGestureRecognizerDelegate>
{
    float       _deltaY;//iOS7于iOS6以前的offset=20

    UIButton* _btnLeft;
    UIButton* _btnRight;

    VVNavigationBar*  _navigationBar;
    VVScrollView* _scrollView;
        
    //记住push动画
    NSMutableString* _pushAnimationType;
    NSMutableString* _pushAnimationSubType;

    
    //NSMutableArray* _alertArray;//对话框
    NSMutableArray* _toastArray;//toast

    VVLodingView* _activityView;
    VVWaitingView* _waitingView;
    NSMutableArray*  _requestOpertation;//目前发出去并未结束的请求队列
    
    NSMutableString* _navigationBarTitle;
}

//@property(nonatomic,retain)   VVNetworkErrorView *networkErrorView;
@property(nonatomic,assign)   BOOL        isPresentMode;
@property(nonatomic,readonly) NSString*   pushAnimationType;
@property(nonatomic,readonly) NSString*   pushAnimationSubType;
@property(nonatomic, retain)  UIScrollView* scrollView;
@property(nonatomic,strong) VVWaitingView*      waitingView;
@property(nonatomic,strong) VVLodingView* activityView;
@property(nonatomic,strong) VVNavigationBar*  navigationBar;
@property (nonatomic, strong) MBProgressHUD *hudView;
@property (nonatomic, strong) VVBackButton* btnBack;
#pragma mark
#pragma mark 文字输入框/键盘相关处理

-(void)moveEditableTextInputToVisible:(UIControl*) responder;
- (void)hideKeyboard;

#pragma mark
#pragma mark Push & Pop View Controller

- (void)customPushViewController:(UIViewController *)viewController withType:(NSString*) type
                         subType:(NSString*) subType;
- (void)customPushViewController:(UIViewController *)viewController withType:(NSString*) type
                          subType:(NSString*) subType removeCurrent:(BOOL)remove;
- (void)customPopViewController;
- (void)customPopToRootViewController;
- (void)customPopToViewController:(UIViewController *)viewController;
- (void)customPopViewControllerAnimatedType:(NSString*) type subType:(NSString*) subType;
- (void)customPopToViewController:(UIViewController *)viewController animatedType:(NSString*) type subType:(NSString*) subType;


#pragma mark
#pragma mark 导航栏以及相关按钮
-(void)setupNavigationBar;
- (void)setNavigationBarTitle:(NSString*)title;
- (void)setNavigationBarColor:(NSString*)color;
- (void)showLoadingNavigationBar;
- (void)hideLoadingNavigationBar;
- (void)setTitleLabelText:(NSString*)text;
//- (void)setTitleLabelTextWithSubtitle:(NSString *)text subtitle:(NSString*)subtitle;
//- (void)cleanSubTitle:(NSString*)title;

- (void)addBackButton;

- (void)addBackButtonWithTitle:(NSString *)title;
- (void)addLeftButtonWithImage:(UIImage*)image highlightedImage:(UIImage*) highlightedImage title:(NSString *)title size:(CGSize)size;
- (void)addLeftButtonWithImage:(UIImage*)image highlightedImage:(UIImage*) highlightedImage title:(NSString *)title size:(CGSize)size titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;
- (void)addRightButton:(NSString*)title;
- (void)addRightButtonWithImage:(UIImage*) image highlightedImage:(UIImage*) highlightedImage;
- (void)addRectangleRightButtonWithImage:(UIImage*) image highlightedImage:(UIImage*) highlightedImage;

// add right special button
- (VVCommonButton *)navigationRightSpecialButton:(NSString *)title frame:(CGFloat)detalX;

- (void)removeBackButton;
- (void)removeLeftButton;
- (void)removeRightButton;
- (void)hiddenRightButton;
- (void)showRightButton;

- (void)backAction:(id)sender;
- (void)leftAction:(id)sender;
- (void)rightAction:(id)sender;

#pragma mark -
#pragma mark 对话框/等待框相关函数
- (void)showWaitingView:(NSString*)title;
- (void)showLoadingView;
//- (void)showLoadingView:(CGPoint)center;
- (void)hideLoadingView;
//- (void)showFlashInfo:(NSString*)info;
//- (void)showFlashInfo:(NSString*)info withImage:(UIImage*)image;

- (void)dismiss;

- (void)showHud;
- (void)hideHud;

//手势回调
#pragma mark
#pragma mark Gesture 手势处理

- (void)tapGestureAction:(id)sender;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

#pragma mark - 判断使用缓存的GET的请求是否真正结束

//- (BOOL)upGetRequestIsFinish:(MKNetworkOperation *)mkOp;
- (NSString*)strFromErrCode:(NSError*)error;

@end
