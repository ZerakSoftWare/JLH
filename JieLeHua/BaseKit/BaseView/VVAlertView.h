//
//  VVAlertView.h
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-28.
//
//


#import <UIKit/UIKit.h>

@class VVAlertView;

//@protocol VVAlertViewDelegate <NSObject>
////对话框回调
//@required
//- (void)alertView:(VVAlertView*)alertView onDismiss:(NSInteger)buttonIndex;
//- (void)alertViewOnCancel:(VVAlertView*)alertView;
//
//@end
/*  cancelButton tag  */
#define kCancelButtonTag 9999

/* 定义alertView的回调block */
typedef void(^VVAlertViewBlock)(VVAlertView *alertView, NSInteger buttonIndex);

@interface VVAlertView : UIView
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) VVAlertViewBlock block;
//@property (nonatomic, assign) id<VVAlertViewDelegate> delegate;

@property(nonatomic,strong) NSMutableArray *alertViewArr;
+ (VVAlertView*)alertView;

- (id)initWithWindow:(UIWindow *)hostWindow;

-(void)hideAlertViewAnimated:(BOOL)flag;

/** @name Configuration */

- (void)resetLayout;
- (void)removeAllControls;
- (void)removeAllButtons;
- (void)addOtherButtons:(NSArray*)buttonTitles specialIndex:(NSInteger)index;
- (void)addButtonCancel:(NSString *)title;
/** @name Showing, Updating and Hiding */

- (void)showOrUpdateAnimated:(BOOL)flag;
- (void)hideAnimated:(BOOL)flag;
- (void)hideAnimated:(BOOL)flag afterDelay:(NSTimeInterval)delay;

- (void)removeAllAlert;
/** @name Methods to Override */

- (void)drawRect:(CGRect)rect;
- (void)drawBackgroundInRect:(CGRect)rect;
- (void)drawTitleInRect:(CGRect)rect isSubtitle:(BOOL)isSubtitle;
- (void)drawDimmedBackgroundInRect:(CGRect)rect;

@end
