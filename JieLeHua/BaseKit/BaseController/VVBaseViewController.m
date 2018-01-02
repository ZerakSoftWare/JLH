//
//  UPBaseViewController.m
//  CHSP
//
//  Created by wxzhao on 12-11-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VVBaseViewController.h"
#import "AppDelegate.h"
#import "VVCommonTextField.h"
#import "VVCommonButton.h"
#import "VVDeviceUtils.h"
#import "VVNavigationController.h"

#define kViewTagAlertUserLogout   0x0000600A
#define kViewTagNavigationBarLabel 0x0000600B
#define kViewTagNavigationBarImage 0x0000600C
#define kViewTagNavigationBarActivityIndicator 0x0000600D
#define kViewTagNavigationSubBarLabel 0x0000600E
//#define UP_FLIPBOARD_ANIM

/* VC切换时旧的VC的黑色遮罩透明度 */
#define kUPBlackMaskAlpha 0.7f

/* VC切换时旧的VC的缩小倍数 */
#define kUPViewScale 0.9f

/* 键盘自动滚动时留的上边 */
#define kUPScrollTopPadding 15

//动画时间
#define kUPPushVCAnimationDuration 0.3f
#define kUPFlipVCAnimationDuration 0.75f

#define kUPNetworkTimeOut 60

//动画映射
#define kTypeArray @[kUPAnimationFlip,  kUPAnimationPush,kUPAnimationReveal,kUPAnimationMoveIn, kUPAnimationFade]

#define kTypePopArray @[kUPAnimationFlip,  kUPAnimationPush,kUPAnimationMoveIn,kUPAnimationReveal, kUPAnimationFade]

#define kSubTypeArray @[kUPAnimationFromRight,  kUPAnimationFromLeft,kUPAnimationFromTop,kUPAnimationFromBottom]

#define kSubTypePopArray @[kUPAnimationFromLeft,  kUPAnimationFromRight,kUPAnimationFromBottom,kUPAnimationFromTop]





@interface VVBaseViewController ()
{
    UITapGestureRecognizer* _tapGesture;

}

@end

@implementation VVBaseViewController

@synthesize scrollView = _scrollView;
@synthesize navigationBar = _navigationBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    VVLog( @"dealloc");
    _tapGesture.delegate = nil;
    [_scrollView removeFromSuperview];
    _scrollView.frame = CGRectZero;
}

- (void)lazyView
{
    _scrollView = [[VVScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.scrollsToTop = NO;
    
    _pushAnimationType = [[NSMutableString alloc] initWithCapacity:10];
    _pushAnimationSubType = [[NSMutableString alloc] initWithCapacity:10];
    
    _toastArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    _requestOpertation  =  [[NSMutableArray alloc] initWithCapacity:5];
    
    
    _navigationBarTitle = [[NSMutableString alloc] init];
    
    //点击空白 收起键盘
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    _tapGesture.cancelsTouchesInView =  NO;
    _tapGesture.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self lazyView];
    _deltaY = 0.0f;
    
    if (VV_IOS_VERSION >= 7.0)
    {
        //在ios7上增加偏移量
        _deltaY = kStatusBarHeight;
        
        //关闭ios7引入的scrollview默认insets
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        //状态栏变回ios6的黑底白字
        UIView* blackStatusBarBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kStatusBarHeight)];
        blackStatusBarBackground.backgroundColor = [UIColor clearColor];
        [self.view addSubview:blackStatusBarBackground];
        //白字
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        //返回手势
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    CGRect scrollFrame = self.view.bounds;
    scrollFrame.origin.y += kNavigationBarHeight+_deltaY;
    scrollFrame.size.height = kScreenHeight-kNavigationBarHeight;
    _scrollView.frame = scrollFrame;
    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.tintColor = VV_COL_RGB(kColorNaviBg);
    [self.view addSubview: _scrollView];
//    self.view.backgroundColor = VV_COL_RGB(0xefeff4);
    self.view.backgroundColor = VVColor(241, 244, 246);
    if (_tapGesture != nil) {
        [self.view addGestureRecognizer:_tapGesture];
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //键盘通知，调整frame, 避免键盘遮挡焦点
    if (VV_IOS_VERSION > 5.0) {
        [VV_NC addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [VV_NC addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [VV_NC addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    [VV_NC addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    [VV_NC addObserver:self selector:@selector(showAlertView) name:@"endEditingKeyBoad" object:nil];

    //    if (VV_IOS_VERSION >= 7.0)
    //    {
    //        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    

    if (VV_IOS_VERSION > 5.0) {
        [VV_NC removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [VV_NC removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [VV_NC removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    [VV_NC removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [VV_NC removeObserver:self name:@"endEditingKeyBoad" object:nil];

    [self dismiss];
    
    //    if (VV_IOS_VERSION >= 7.0)
    //    {
    //        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    //    }

}

- (void)showAlertView{
    [self.view endEditing:YES];
}

#pragma mark - 加载动画
- (void)showHud
{
//    if (!_hudView) {
        _hudView = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
//    }
    [self.hudView show:YES];
}

- (void)hideHud
{
    [self.hudView hide:NO];
}

#pragma mark 生成 _activityView 和 _waitingView
-(VVLodingView *)activityView
{
    if (!_activityView) {
        CGRect rt = [UIApplication sharedApplication].keyWindow.bounds;
        _activityView = [[VVLodingView alloc] initWithFrame:rt];
        [VV_App.window addSubview:_activityView];
    }
    return _activityView;

    
}


-(VVWaitingView *)waitingView
{
    if (!_waitingView) {
        CGRect rt = [UIApplication sharedApplication].keyWindow.bounds;
        _waitingView = [[VVWaitingView alloc] initWithFrame:rt];
        [self.view addSubview:_waitingView];
    }
    return _waitingView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}


#pragma mark
#pragma mark 键盘动作相关

- (void)scrollSelfToVisible:(CGRect)rect animated:(BOOL)animated
{
    CGPoint pt = CGPointZero;
    //scroll view 可视高度
    int visibleHeight = CGRectGetHeight(_scrollView.bounds);
    //scroll view 内容的总高度
    int totalHeight = _scrollView.contentSize.height;
    //控件的上边 + padding
    int topY = CGRectGetMinY(rect) - kUPScrollTopPadding;
    
    if (topY > (totalHeight - visibleHeight)) {
        //屏幕滚动到最底部可以显示下这个rect
        pt.y = totalHeight - visibleHeight;
    }
    else{
        //显示不下, 调整
        pt.y = topY;
    }
    if (pt.y < 0) {
        pt.y = 0;
    }
    [_scrollView setContentOffset:pt animated:YES];
}



//避免焦点遮挡键盘
- (void)moveEditableTextInputToVisible:(UIControl*) responder
{
    if (responder) {
        CGRect rect = [responder convertRect:responder.bounds toView:_scrollView];
        [self scrollSelfToVisible:rect animated:YES];
    }
}

- (void)modifyScrollView:(NSNotification *)notification
{
    BOOL animation = NO;
    NSValue *keyboardBoundsEnd = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect; [keyboardBoundsEnd getValue:&keyboardRect];
        
    int keyboardTop = CGRectGetMinY(keyboardRect);
    
    if (keyboardRect.origin.y < kScreenHeight) {
        animation = YES;
    }
    
    NSValue *animationDurationValue = [notification userInfo][UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
        

    //键盘消失时的动画如果打开会有scrollview上下多抖动的问题
    if (animation) {
        [UIView beginAnimations:@"move scroll view" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
    
    CGRect frame = _scrollView.frame;
    frame.size.height = keyboardTop - frame.origin.y; // 没必要修改scrollView的origin.y，只要修改高度就可以了
    frame.origin.y = kNavigationBarHeight + _deltaY;
    _scrollView.frame = frame;
    
    
    if (animation) {
        [UIView commitAnimations];
    }
    
    UIView* firstResponder =  [VVViewUtils findFirstResponder:self.view];
    if (firstResponder) {
        CGRect rect = [firstResponder convertRect:firstResponder.bounds toView:_scrollView];
        [self scrollSelfToVisible:rect animated:animation];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self modifyScrollView:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self modifyScrollView:notification];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    [self modifyScrollView:notification];
}

- (void)textFieldDidChangeNotification:(NSNotification *)notification
{

}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark 处理横竖屏切换

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark
#pragma mark Gesture 手势处理的回调和代理方法

- (void)tapGestureAction:(id)sender
{
    [self hideKeyboard];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //子类可以重写
    
    if (self.childViewControllers.count > 0) {
        return NO;
    }
    
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    else{
        return YES;
    }
}


#pragma mark
#pragma mark Push & Pop View Controller

-(NSString *)pushAnimationType
{
    return _pushAnimationType;
}

-(NSString *)pushAnimationSubType
{
    return _pushAnimationSubType;
}

- (void)pushControllerToNavigationStack:(UIViewController*)viewController removeCurrent:(BOOL)remove animated:(BOOL)animated
{
    VVNavigationController *nav = (VVNavigationController *)VV_App.naviController;
    
    // 禁止连续pushViewController
    static BOOL isPushing = NO;
    if (!isPushing) {
        [nav pushViewController:viewController animated:animated];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        if (remove) {
            [viewControllers removeObjectIdenticalTo:self];
            [nav setViewControllers: viewControllers animated: animated];
        }
//        [viewControllers addObject:viewController];
         VVLog(@" \n pushVC == %@ \n ",viewController);
        
        isPushing = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isPushing = NO;
        });
        
    }else {
        // 如果正在进行动画时，又进行push操作，上一个动画没有完成，可能导致push的ViewController不显示。
        if (!isPushing) {
            if (remove) {
                [nav.removeVCs addObject:self];
            }
            [nav.addVCs addObject:viewController];
        }
        
    }
}

- (void)customPushViewController:(UIViewController *)viewController withType:(NSString*) type
                         subType:(NSString*) subType
{
    
    //发送通知，dismiss ActionSheet
    //[VV_NC postNotificationName:kUPDismissActionSheet object:nil userInfo:nil];
    //[VV_NC postNotificationName:@"removeAlertView" object:nil];
    
    [self customPushViewController:viewController withType:type subType:subType removeCurrent:NO];
}

- (void)customPushViewController:(UIViewController *)viewController
                         withType:(NSString*) type
                          subType:(NSString*) subType
                    removeCurrent:(BOOL)remove
{
    @autoreleasepool {
        
    
    if (VV_IS_NIL(type) || VV_IS_NIL(subType))
    {
        [self pushControllerToNavigationStack:viewController removeCurrent:remove animated:YES];
        [_pushAnimationType setString:@""];
        [_pushAnimationSubType setString:@""];
    }
    else if([type isEqualToString:kUPAnimationFlip] || [type isEqualToString:kUPAnimationFade])
    {
        CATransition *transition = [CATransition animation];
        transition.type = type;
        transition.subtype = subType;
        transition.duration =  kUPFlipVCAnimationDuration;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self pushControllerToNavigationStack:viewController removeCurrent:remove animated:NO];
//        [self.navigationController pushViewController:viewController animated:NO];
        [_pushAnimationType setString:type];
        [_pushAnimationSubType setString:subType];
    }
    else 
    {
        VVLog(@"self frame = %@, bounds = %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds));
        VVLog(@"viewController frame = %@, bounds = %@",NSStringFromCGRect(viewController.view.frame),NSStringFromCGRect(viewController.view.bounds));
            UINavigationController* navi = VV_NAV;
            //原vc的截图, 加遮罩, 加缩小
            UIView* oldView = [[UIView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0, kStatusBarHeight-_deltaY)];
            [oldView addSubview:self.view];
            
#ifdef UP_FLIPBOARD_ANIM
            UIView* blackMask = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
            blackMask.backgroundColor = [UIColor blackColor];
            blackMask.alpha = 0.0;
            [oldView addSubview:blackMask];
#endif
            [navi.view addSubview:oldView];
            
            
            CGRect dstFrame = CGRectZero;
            if ([type isEqualToString:kUPAnimationMoveIn] ) {
                
                if ([subType isEqualToString:kUPAnimationFromTop]) {
                    dstFrame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
                }
                else if ([subType isEqualToString:kUPAnimationFromRight])
                {
                    dstFrame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
                }
            }
            UIView* newView = [[UIView alloc] initWithFrame:dstFrame];
            [newView addSubview:viewController.view];
            [navi.view addSubview:newView];//新VC的截图
        oldView.userInteractionEnabled = NO;
        newView.userInteractionEnabled = NO;
        
            [UIView animateWithDuration:kUPPushVCAnimationDuration delay:0.0f options:0 animations:^{
#ifdef UP_FLIPBOARD_ANIM
                
                blackMask.alpha = kUPBlackMaskAlpha;//边暗
                oldView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kUPViewScale, kUPViewScale);//缩小
#endif
                newView.frame = CGRectOffset(self.view.bounds, 0, 0);//新VC移入
            }   completion:^(BOOL finished) {
                if (finished) {
#ifdef UP_FLIPBOARD_ANIM
                    [blackMask removeFromSuperview];
                    oldView.transform = CGAffineTransformIdentity;
#endif
                    [oldView removeFromSuperview];
                    [newView removeFromSuperview];
                    [self.view removeFromSuperview];
                    [viewController.view removeFromSuperview];
                    [self pushControllerToNavigationStack:viewController removeCurrent:remove animated:NO];
                    oldView.userInteractionEnabled = YES;
                    newView.userInteractionEnabled = YES;
//                    [self.navigationController pushViewController:viewController animated:NO];
                }
            }];
            [_pushAnimationType setString:type];
            [_pushAnimationSubType setString:subType];
        }
    }
}

- (void)customPopViewControllerAnimatedType:(NSString*) type
                                    subType:(NSString*) subType
{
    NSArray* viewStack = self.navigationController.viewControllers;
    UIViewController* preViewController =  VV_OBJATIDX(viewStack, [viewStack count] -2);
    [self customPopToViewController:preViewController animatedType:type subType:subType];
}

- (void)customPopViewController
{
    NSArray* viewStack = self.navigationController.viewControllers;
    UIViewController* preViewController =  VV_OBJATIDX(viewStack, [viewStack count] -2);
    [self customPopToViewController:preViewController];
}

- (void)customPopToRootViewController
{
    NSArray* viewStack = self.navigationController.viewControllers;
    UIViewController* preViewController =  VV_OBJATIDX(viewStack, 0);
    [self customPopToViewController:preViewController];
}

- (void)customPopToViewController:(UIViewController *)viewController
{
    NSString* type = nil;
    NSString* subType = nil;
    
    NSDictionary* typeDict = [NSDictionary dictionaryWithObjects:kTypeArray forKeys:kTypePopArray];
    NSDictionary* subTypeDict = [NSDictionary dictionaryWithObjects:kSubTypeArray forKeys:kSubTypePopArray];
    //由于push保存的变量不在pop时的view controller中， 需要找到上一个view controller
    NSArray* viewStack = self.navigationController.viewControllers;
    UIViewController* preViewController =  VV_OBJATIDX(viewStack, [viewStack count] -2);
    
    if ([preViewController isKindOfClass:[VVBaseViewController class]]) {
        VVBaseViewController* ctl = (VVBaseViewController*) preViewController;
        if (!VV_IS_NIL(ctl.pushAnimationType) ) {
            type = typeDict[ctl.pushAnimationType];
        }
        
        if (!VV_IS_NIL(ctl.pushAnimationSubType) ) {
            subType = subTypeDict[ctl.pushAnimationSubType];
        }
    }
    
    [self customPopToViewController:viewController animatedType:type subType:subType];
}

- (void)customPopToViewController:(UIViewController*)viewController
                     animatedType:(NSString*) type
                          subType:(NSString*) subType
{
    
    if (type == nil)
    {
        VVLog(@" \n popVC == %@ \n before %@ \n ",viewController,self.navigationController.viewControllers);
        [self.navigationController popToViewController:viewController animated:YES];
        VVLog(@" \n popVC == %@ \n after %@ \n ",viewController,self.navigationController.viewControllers);
    }
    else if([type isEqualToString:kUPAnimationFlip])
    {
        CATransition *transition = [CATransition animation];
        transition.type = type;
        transition.subtype = subType;
        float dur = [type isEqualToString:kUPAnimationFlip]?kUPFlipVCAnimationDuration:kUPPushVCAnimationDuration;
        transition.duration =  dur;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popToViewController:viewController animated:NO];

    }
    else
    {
        VVLog(@"self frame = %@, bounds = %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds));
        VVLog(@"viewController frame = %@, bounds = %@",NSStringFromCGRect(viewController.view.frame),NSStringFromCGRect(viewController.view.bounds));
        UINavigationController* navi = VV_NAV;
        
        //加载push之前的view
        UIView* prevView = [[UIView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, kStatusBarHeight - _deltaY)];
        [prevView addSubview:viewController.view];
#ifdef UP_FLIPBOARD_ANIM
        UIView* blackMask = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
        blackMask.backgroundColor = [UIColor blackColor];
        blackMask.alpha = kUPBlackMaskAlpha;
        [prevView addSubview:blackMask];
        prevView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kUPViewScale, kUPViewScale);
#endif

        [navi.view addSubview:prevView];
        
        //加载当前view截图
        UIView* oldView =  [[UIView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, kStatusBarHeight)];
        [oldView addSubview:self.view];
        [navi.view addSubview:oldView];

        CGRect srcFrame = CGRectZero;
        if ([type isEqualToString:kUPAnimationReveal] ) {
            if ([subType isEqualToString:kUPAnimationFromBottom]) {
                srcFrame = CGRectOffset(self.view.frame, 0, self.view.bounds.size.height+kStatusBarHeight);
            }
            else if ([subType isEqualToString:kUPAnimationFromLeft]){
                srcFrame = CGRectOffset(self.view.frame, self.view.bounds.size.width, kStatusBarHeight);
            }
        }
        
        prevView.userInteractionEnabled = NO;
        oldView.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:kUPPushVCAnimationDuration delay:0.0f options:0 animations:^{
            oldView.frame = srcFrame;
#ifdef UP_FLIPBOARD_ANIM
            blackMask.alpha = 0.0;
            prevView.transform = CGAffineTransformIdentity;
#endif
        }   completion:^(BOOL finished) {
            if (finished) {
                [self.navigationController popToViewController:viewController animated:NO];
                [self.view removeFromSuperview];
                [viewController.view removeFromSuperview];
                [oldView removeFromSuperview];
#ifdef UP_FLIPBOARD_ANIM
                [blackMask removeFromSuperview];
#endif
                [prevView removeFromSuperview];
                prevView.userInteractionEnabled = YES;
                oldView.userInteractionEnabled = YES;
            }
        }];
    }
}





- (void)setupNavigationBar
{
    if (nil == _navigationBar) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        if (iPhoneX)
        {
            _navigationBar = [[VVNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight+kStatusBarHeight+20)];
            [self.view insertSubview:_navigationBar aboveSubview:_scrollView];
            return;
        }
        if (VV_IOS_VERSION >= 7.0)
        {
            _navigationBar = [[VVNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight+kStatusBarHeight)];
            [self.view insertSubview:_navigationBar aboveSubview:_scrollView];
            return;
        }
        else {
            _navigationBar = [[VVNavigationBar alloc] initWithFrame:CGRectMake(0, _deltaY, kScreenWidth, kNavigationBarHeight)];
            [self.view insertSubview:_navigationBar aboveSubview:_scrollView];
            return;
        }
    }
}


- (void)setNavigationBarTitle:(NSString*)title
{
    [self setupNavigationBar];
    if (!VV_IS_NIL(title)) {
        [_navigationBarTitle setString:title];
        [self setTitleLabelText:title];
    } else {
        [_navigationBarTitle setString:@""];
        [self setTitleLabelText:@""];
    }
}

- (void)setTitleLabelText:(NSString*)text
{
    UILabel* labelTitle = (UILabel*)[_navigationBar viewWithTag:kViewTagNavigationBarLabel];
    UILabel* labelSubtitle = (UILabel*)[_navigationBar viewWithTag:kViewTagNavigationSubBarLabel];
    [labelSubtitle removeFromSuperview];
    [labelTitle removeFromSuperview];
    
    UIFont* naviFont = [UIFont systemFontOfSize:18];
    CGSize sz = [text sizeWithFont:naviFont constrainedToSize:CGSizeMake(kScreenWidth/2-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat x = (kScreenWidth - sz.width)/2;
    CGFloat y = (kNavigationBarHeight - sz.height)/2 + _deltaY;
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, sz.width, sz.height)];
    labelTitle.font = [UIFont systemFontOfSize:18];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    [labelTitle setText:text];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    labelTitle.tag = kViewTagNavigationBarLabel;
    if (iPhoneX)
    {
        labelTitle.y = labelTitle.y + 20;
    }
    [_navigationBar addSubview:labelTitle];
}

//- (void)setTitleLabelTextWithSubtitle:(NSString *)text subtitle:(NSString*)subtitle
//{
//    [self setupNavigationBar];
//    UILabel* labelTitle = (UILabel*)[_navigationBar viewWithTag:kViewTagNavigationBarLabel];
//    [labelTitle removeFromSuperview];
//    
//    UIFont* naviFont = [VVFontUtils navigationTitleFont];
//    CGSize sz = [text sizeWithFont:naviFont constrainedToSize:CGSizeMake(kScreenWidth/2, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//    CGFloat x = (kScreenWidth - sz.width)/2;
//    CGFloat y = (kNavigationBarHeight - sz.height)/5 + _deltaY;
//    
//    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, sz.width, sz.height)];
//    labelTitle.font = [VVFontUtils navigationTitleFont];
//    labelTitle.backgroundColor = [UIColor clearColor];
//    labelTitle.textColor = [UIColor whiteColor];
//    [labelTitle setText:text];
//    [labelTitle setTextAlignment:NSTextAlignmentCenter];
//    labelTitle.tag = kViewTagNavigationBarLabel;
//    [_navigationBar addSubview:labelTitle];
//    
//    CGSize szSub = [subtitle sizeWithFont:naviFont constrainedToSize:CGSizeMake(kScreenWidth/2, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//    CGFloat xSub = (kScreenWidth - szSub.width)/2;
//    CGFloat ySub = (kNavigationBarHeight - szSub.height)/5 + _deltaY;
//    
//    UILabel* labelSubtitle = (UILabel*)[_navigationBar viewWithTag:kViewTagNavigationSubBarLabel];
//    [labelSubtitle removeFromSuperview];
//    labelSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(xSub, ySub+18, szSub.width, szSub.height)];
//    labelSubtitle.font = [VVFontUtils defaultFontWihtSize:11];
//    labelSubtitle.backgroundColor = [UIColor clearColor];
//    labelSubtitle.textColor = [UIColor whiteColor];
//    [labelSubtitle setText:subtitle];
//    labelSubtitle.tag = kViewTagNavigationSubBarLabel;
//
//    [labelSubtitle setTextAlignment:NSTextAlignmentCenter];
//    [_navigationBar addSubview:labelSubtitle];
//}
//
//- (void)cleanSubTitle:(NSString*)title{
//    
//    [self setupNavigationBar];
//    UILabel* labelTitle = (UILabel*)[_navigationBar viewWithTag:kViewTagNavigationBarLabel];
//    UILabel* subLabelTitle = (UILabel*)[_navigationBar viewWithTag:kViewTagNavigationSubBarLabel];
//    [labelTitle removeFromSuperview];
//    [subLabelTitle removeFromSuperview];
//
//}

- (void)showLoadingNavigationBar
{
    [self hideLoadingNavigationBar];
    //在title左边显示
    UIActivityIndicatorView* view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    UILabel* labelTitle = (UILabel*)[_navigationBar viewWithTag:kViewTagNavigationBarLabel];
    CGRect frame = labelTitle.frame;
    [view setCenter:CGPointMake(CGRectGetMinX(frame) - CGRectGetWidth(view.frame), labelTitle.center.y)];
    view.tag = kViewTagNavigationBarActivityIndicator;
    [view startAnimating];
    [_navigationBar addSubview:view];
}

- (void)hideLoadingNavigationBar
{
    UIActivityIndicatorView* view = (UIActivityIndicatorView*)[_navigationBar viewWithTag:kViewTagNavigationBarActivityIndicator];
    [view stopAnimating];
    [view removeFromSuperview];
}


- (void)setNavigationBarColor:(NSString*)color
{
    [self setupNavigationBar];
    
//    UIImageView* imageView = (UIImageView*)[_navigationBar viewWithTag:kViewTagNavigationBarImage];
//    [imageView removeFromSuperview];
//        
//    CGRect rect = CGRectMake((kScreenWidth - image.size.width)/2, (kNavigationBarHeight - image.size.height)/2, image.size.width, image.size.height);
//    
//    imageView = [[UIImageView alloc] initWithFrame:rect];
//    imageView.image = image;
    _navigationBar.imageView.backgroundColor = [VVUtils colorWithHexStringNoAlpha:color];
//    [_navigationBar addSubview:_navigationBar.imageView];
}

#pragma mark -
#pragma mark - addBackButton
- (void)addBackButton
{
    [self addBackButtonWithTitle:VV_STR(@"")];
}

- (void)addBackButtonWithTitle:(NSString *)title
{
    _btnBack = [VVBackButton backButton];
    [_btnBack setTitle:title forState:UIControlStateNormal];
    CGSize buttonSz = CGSizeMake(80, 44);
    //    float topMargin = (kNavigationBarHeight - buttonSz.height)/2;
    //    CGSize buttonSz = CGSizeMake(_btnBack.width, _btnBack.height);
    [_btnBack setFrame:  CGRectIntegral(CGRectMake(0, _deltaY, buttonSz.width,  buttonSz.height))];
    
    if (iPhoneX)
    {
        _btnBack.y = _deltaY + 20;
    }
    [_btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_btnBack removeFromSuperview];
    [_navigationBar addSubview:_btnBack];
    
    _btnBack.exclusiveTouch = YES;
}

- (void)addLeftButtonWithImage:(UIImage*)image highlightedImage:(UIImage*) highlightedImage title:(NSString *)title size:(CGSize)size {
    [self addLeftButtonWithImage:image highlightedImage:highlightedImage title:title size:size titleEdgeInsets:UIEdgeInsetsZero];
}

- (void)addLeftButtonWithImage:(UIImage*)image highlightedImage:(UIImage*) highlightedImage title:(NSString *)title size:(CGSize)size titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
{
    _btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize imageSz = image.size;
    CGSize buttonSz = CGSizeZero;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        buttonSz = CGSizeMake(imageSz.width, imageSz.height);
    } else {
        buttonSz = size;
    }
    float topMargin = (kNavigationBarHeight - buttonSz.height)/2;
    [_btnLeft setFrame:  CGRectMake(kVVNavLeftBtnLeftEdge, _deltaY + topMargin, buttonSz.width,  buttonSz.height)];
    [_btnLeft setImage:image forState:UIControlStateNormal];
    if(highlightedImage)
    {
        [_btnLeft setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    if (title) {
        [_btnLeft setTitle:title forState:UIControlStateNormal];
    }
    _btnLeft.titleEdgeInsets = titleEdgeInsets;
    [_btnLeft addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_btnLeft removeFromSuperview];
    [_navigationBar addSubview:_btnLeft];
    _btnLeft.titleLabel.font  = [UIFont systemFontOfSize:14];

    _btnLeft.exclusiveTouch = YES;
}

- (void)addRightButton:(NSString*)title;
{
    //左右各留11
    int margin = 18;
    _btnRight = [VVCommonButton navigationRectangleButtonWithTitle:title];
    CGSize buttonSz = CGSizeMake(52, 44);
    CGSize keySize = [title sizeWithFont:_btnRight.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    int minWidth = buttonSz.width - margin*2;
    int width = keySize.width <= minWidth ? buttonSz.width : (keySize.width + margin*2);
    int height = buttonSz.height;
    float topMargin = (kNavigationBarHeight - height)/2;
    [_btnRight setFrame:CGRectMake(kScreenWidth - width, _deltaY + topMargin, width, height)];
    [_btnRight addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight removeFromSuperview];
    [_navigationBar addSubview:_btnRight];
    [_btnRight setTitleColor:VV_COL_RGB(0xffffff) forState:UIControlStateDisabled];
    
    _btnRight.exclusiveTouch = YES;
}


- (void)addRightButtonWithImage:(UIImage*) image highlightedImage:(UIImage*) highlightedImage
{
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize imageSz = image.size;
    float topMargin = (kNavigationBarHeight - image.size.height)/2;
    CGSize buttonSz = CGSizeMake(imageSz.width+2*kNavigationRightButtonMargin, imageSz.height);
    if (buttonSz.height < 10) {
        [_btnRight setFrame:  CGRectIntegral(CGRectMake(kScreenWidth - buttonSz.width-10, _deltaY + 5, 40,  30))];
    }
    else {
        [_btnRight setFrame:  CGRectIntegral(CGRectMake(kScreenWidth - buttonSz.width, _deltaY + topMargin, buttonSz.width,  buttonSz.height))];
    }
    [_btnRight setImage:image forState:UIControlStateNormal];
    if (highlightedImage) {
        [_btnRight setImage:highlightedImage forState:UIControlStateHighlighted];
        
    }
    
    [_btnRight addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_btnRight removeFromSuperview];
    [_navigationBar addSubview:_btnRight];
    
    _btnRight.exclusiveTouch = YES;
}

- (void)addRectangleRightButtonWithImage:(UIImage*) image highlightedImage:(UIImage*) highlightedImage
{
    //左右各留11
    _btnRight = [VVCommonButton navigationRectangleButtonWithTitle:nil];
    
    CGSize buttonSz = CGSizeMake(44, 44);
//    float topMargin = (kNavigationBarHeight - buttonSz.height)/2;
//    CGSize buttonSz = CGSizeMake(imageSz.width+2*kNavigationRightButtonMargin, imageSz.height);
    [_btnRight setFrame:  CGRectIntegral(CGRectMake(kScreenWidth - buttonSz.width, _deltaY , buttonSz.width,  buttonSz.height))];
    [_btnRight setImage:image forState:UIControlStateNormal];
    if (highlightedImage) {
        [_btnRight setImage:highlightedImage forState:UIControlStateHighlighted];
        
    }
    [_btnRight addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_btnRight removeFromSuperview];
    [_navigationBar addSubview:_btnRight];
    
    _btnRight.exclusiveTouch = YES;
}

- (VVCommonButton *)navigationRightSpecialButton:(NSString *)title frame:(CGFloat)detalX {
  VVCommonButton *button = [VVCommonButton navigationButtonWithTitle:title];
  CGFloat buttonW = 55;
  CGFloat buttonH = 44;
  CGFloat buttonY = VV_IOS_VERSION >= 7.0 ? 20 : 0;
  CGFloat buttonX = self.view.frame.size.width - buttonW - detalX;
  [button setFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
  [button setTitleColor:VV_COL_RGB(0x84DEFA) forState:UIControlStateDisabled];
  [button setEnabled:NO];
  return button;
}

- (void)removeBackButton
{
    [_btnBack removeFromSuperview];
}

- (void)removeLeftButton
{
    [_btnLeft removeFromSuperview];
}

- (void)hiddenRightButton{
    _btnRight.hidden = YES;
}
- (void)showRightButton{
    _btnRight.hidden = NO;
}

- (void)removeRightButton
{
    [_btnRight removeFromSuperview];
}

- (void)backAction:(id)sender
{
    [self customPopViewController];
}

- (void)leftAction:(id)sender
{
    
}

- (void)rightAction:(id)sender
{
    
}

#pragma mark -
#pragma mark AlertView, Toast, Loading 相关函数


- (void)showWaitingView:(NSString*)title;
{
    if (!VV_IS_NIL(title)) {
        self.waitingView.title = title;
        [self.waitingView.superview bringSubviewToFront:self.waitingView];
        [self.waitingView show];
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)hideWaitingView
{
//    UPDINFO(@"hideWaitingView");
    if (_waitingView) {
        [_waitingView hide];
    }
}

- (void)showLoadingView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 默认 在显示区域（不包括导航栏）居中，而不是整个屏幕居中
        self.activityView.center = CGPointMake(kScreenWidth/2.0, (kScreenHeight + kNavigationBarHeight)/2.0);
        [self.activityView show];
        [self.view bringSubviewToFront:self.activityView];
    });
}

//- (void)showLoadingView:(CGPoint)center
//{
//    self.activityView.center = center;
//    [self.activityView startAnimating];
//    [self.view bringSubviewToFront:self.activityView];
//}

- (void)hideLoadingView
{
//    UPDINFO(@"hideLoadingView");
    if (self.activityView) {
        [self.activityView hide];
        [self.activityView removeFromSuperview];
        self.activityView = nil;

    }
}


//- (void)hideFlashInfo
//{
//    [_toastArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [obj removeToast];
//    }];
//    [_toastArray removeAllObjects];
//}
//
//- (void)showFlashInfo:(NSString*)info
//{
//    [self hideFlashInfo];
//    if (!VV_IS_NIL(info)) {
//        CGSize size = kCommonToastSize;
//        VVToast* toast = [[[[VVToast makeText:info]
//                             setGravity:kToastGravityCenter]
//                            setDuration:kToastDurationNormal]
//                           setSize:size];
//        [toast show];
//        [_toastArray addObject:toast];
//    }
//}
//
//
//- (void)showFlashInfo:(NSString*)info withImage:(UIImage*)image
//{
//    [self hideFlashInfo];
//    if (!VV_IS_NIL(info) || image) {
//        VVToast* toast = [[[[[VVToast makeText:info]
//                              setGravity:kToastGravityCenter]
//                             setDuration:kToastDurationNormal]
//                            setSize:CGSizeMake(100, 100)] setImage:image];
//        [toast show];
//        [_toastArray addObject:toast];
//    }
//}
//
- (void)dismiss
{
////    UPDINFO(@" \n\n dismiss %@ ",NSStringFromClass([self class]));
    [self hideWaitingView];
    [self hideLoadingView];
//    [self hideFlashInfo];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//
}

#pragma mark - 错误码转成文字

- (NSString*)strFromErrCode:(NSError*)error
{
    NSString* msg = @"网络不给力";
    if (error.code == NSURLErrorTimedOut) {
        //The request timed out
        msg = @"网络连接超时";
    }else if(error.code == NSURLErrorCannotConnectToHost)
    {
        msg = @"未能连接到服务器";
    }else if(error.code == NSURLErrorCancelled){
        msg = @"";
    }else if(error.code == NSURLErrorNotConnectedToInternet){
       msg = @"网络不给力";
    }else{
        msg = [error localizedDescription];
    }
    return msg;
    
}


@end
