//
//  VVAlertView.m
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-28.
//
//

#import "VVAlertView.h"
#import "VVCommonButton.h"

enum VVAlertViewButtonType {
    kButtonLeft = UIRectCornerBottomLeft,
    kButtonCenter = UIRectCornerAllCorners,
    kButtonRight = UIRectCornerBottomRight,
    kButtonAlone = UIRectCornerBottomLeft |UIRectCornerBottomRight
    };
@interface VVAlertViewWindowOverlay : UIWindow
@property (nonatomic, strong) VVAlertView *alertView;
@end
@interface VVAlertViewButton : UIButton
@property (retain, nonatomic) UIColor*  buttonBackgroundColor;
@property (retain, nonatomic) UIColor* buttonhighlightColor;
@property (assign, nonatomic) enum VVAlertViewButtonType type;
@end

@interface VVAlertView ()
@property (nonatomic, strong) VVAlertViewWindowOverlay *overlay;
@property (nonatomic, strong) UIWindow *hostWindow;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *subtitleFont;
@property (nonatomic, assign) NSInteger specialIndex;
@end

#define kAnimationDuration 0.25
#define kPopScale 0.5



#define kColorButtonCancel              0xf0f0f0
#define kColorButtonCancelHighlight     0x3e98ea
#define kColorButtonSpecial             0xea3e3e
#define kColorButtonSpecialHighlight    0x3e98ea
#define kColorButton                    0xeaeaea
#define kColorButtonHighlight           0x3e98ea

/* 警告框背景颜色 */
#define kColorAlertViewBackground 0xf6f5f1
/* 警告框title背景颜色 */
#define kColorAlertTitleBackground 0xfbb13d
/* 警告框Title文字颜色 */
#define kColorAlertViewTitleText 0xffffff
/* 警告框Title分割线颜色 */
#define kColorAlertViewTitleLine 0xb7b7b4
/* 警告框Message文字颜色 */
#define kColorAlertViewMessageText 0x2a2a2a


/* 警告框button文字颜色 */
//#define kColorAlertViewButtonText 
/*  警告框button高亮背景色 */
#define kColorAlertViewButtonHighlight 0xe5e5e5
/*  警告框button Normal色 */
#define kColorAlertViewButtonNormal 0xf6f5f1

/* 相对设备屏幕水平边距, 左右相等  UI设计45/2 取22 */
#define kHorizenInset (([UIScreen mainScreen].bounds.size.width - 270)/2)
/* 中心点相对设备屏幕高度百分比  380/960*/
#define kVerticalCenterScale 0.4
/* 按钮高度 */
#define kButtonHeight 40.0
/* 上边距 */
#define kTopMargin 14.0
/* 竖直方向边距 */
#define kVerticalPadding 20.0
/* 竖直最小值 */
#define kVerticalContentMinHeight 30.0
/* 最小高度 上边距+最小值+padding+按钮*/
#define kContentMinHeight (kTopMargin+kVerticalContentMinHeight+kVerticalPadding+kButtonHeight)



/* SubTitlte(如有)于title的边距 */
#define kSubTitlePadding 15.0
/* custom view于title的边距 */
#define kCustomViewPadding 8.0
/* Title的水平缩进 */
#define kTitleIndent 15.0
/* Title分割线于Title的距离 */
#define kTitleLinePadding 8.0


@implementation VVAlertView {
@private
    struct {
        CGRect titleRect;
        CGRect titlelineRect;
        CGRect subtitleRect;
        CGRect buttonRect;
        CGRect customViewRect;
    } layout;
}

@synthesize customView = _customView;
@synthesize title  = _title;
@synthesize subtitle = _subtitle;
@synthesize overlay = _overlay;
@synthesize hostWindow =  _hostWindow;
@synthesize contentView = _contentView;
@synthesize buttons = _buttons;
@synthesize titleFont = _titleFont;
@synthesize subtitleFont = _subtitleFont;
@synthesize specialIndex = _specialIndex;

+ (VVAlertView*)alertView
{
    static VVAlertView* alertView = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        alertView = [[self alloc] init];
    });
    return alertView;
}

- (NSMutableArray *)alertViewArr{
    if (!_alertViewArr) {
        _alertViewArr = [[NSMutableArray alloc]init];
    }
    return _alertViewArr;
}

- (id)initWithWindow:(UIWindow *)hostWindow
{
    self = [super initWithFrame:[self defaultAlertViewFrame]];
    if (self) {
        self.specialIndex = -1;
        self.titleFont = [UIFont systemFontOfSize:16];
        self.subtitleFont = [UIFont systemFontOfSize:14];
        self.hostWindow = hostWindow;
        self.opaque = NO;
        self.alpha = 1.0;
        self.buttons = [NSMutableArray array];
        
//        self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
//        self.layer.shadowOpacity = 0.75;
        // Register for keyboard notifications
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//        [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [nc addObserver:self selector:@selector(removeAlert:) name:@"removeAllAlertView" object:nil];

    }
    return self;
}

- (void)removeAllAlert{
    NSArray *arr = [[[VVAlertView alertView].alertViewArr reverseObjectEnumerator] allObjects];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        VVAlertView *alert = (VVAlertView *)obj;
        [alert hideAlertViewAnimated:YES];
    }];
    [[VVAlertView alertView].alertViewArr removeAllObjects];
}

- (void)removeAlert:(NSNotification *)notice{
    
    [self resignFirstResponder];
    NSMutableArray *arr = [[notice object] mutableCopy];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            VVAlertView *alert = (VVAlertView *)obj;
            [alert hideAlertViewAnimated:YES];
        }];
        [arr removeAllObjects];
        [[VVAlertView alertView].alertViewArr removeAllObjects];

    });

}

- (void)dealloc
{
    [VV_NC removeObserver:self];
}


- (void)adjustToKeyboardBounds:(CGRect)bounds
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat height = CGRectGetHeight(screenBounds) - CGRectGetHeight(bounds);
    
    CGRect frame = self.frame;
    frame.origin.y = (height - CGRectGetHeight(self.bounds)) / 2.0;
    
    if (CGRectGetMinY(frame) < 0) {
    }
    
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        // stub
    }];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    NSValue *value = [[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [value CGRectValue];
    
    [self adjustToKeyboardBounds:frame];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [self adjustToKeyboardBounds:CGRectZero];
}

- (CGRect)defaultAlertViewFrame
{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect insetFrame = CGRectInset(appFrame, kHorizenInset, 0.0);
    insetFrame.size.height = kContentMinHeight;
    CGFloat cy = appFrame.size.height * kVerticalCenterScale;
    cy -= kContentMinHeight/2;
    insetFrame.origin.y = (int)cy;
    insetFrame = CGRectIntegral(insetFrame);
    return insetFrame;
}

- (void)layoutComponents
{
    [self setNeedsDisplay];
    
    // Compute frames of components
    CGRect layoutFrame = self.bounds;
    CGFloat layoutWidth = CGRectGetWidth(layoutFrame);
    
    // Title frame
    CGFloat titleHeight = 0;
    CGFloat titleWidth = layoutWidth - 2*kTitleIndent;
    CGFloat offsetY = CGRectGetMinY(layoutFrame);
    if (self.title.length > 0) {
        titleHeight = [self.title sizeWithFont:self.titleFont
                             constrainedToSize:CGSizeMake(layoutWidth, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByWordWrapping].height;
        offsetY += kTopMargin;
    }
    layout.titleRect = CGRectMake(CGRectGetMinX(layoutFrame) + kTitleIndent, offsetY, titleWidth, titleHeight);
    
    
    //Title Line
    CGFloat titleLineHeight = 0;
    CGFloat titleLineWidth = CGRectGetWidth(layoutFrame);
    offsetY = CGRectGetMaxY(layout.titleRect);
    if (self.title.length > 0) {
        titleLineHeight = 0;
        offsetY += kTitleLinePadding;
    }
    layout.titlelineRect = CGRectMake(CGRectGetMinX(layoutFrame), offsetY, titleLineWidth, titleLineHeight);

    // Subtitle frame
    CGFloat subtitleHeight = 0;
    CGFloat subtitleWidth = CGRectGetWidth(layoutFrame) - 2*kTitleIndent;
    offsetY = CGRectGetMaxY(layout.titlelineRect);
    if (self.subtitle.length > 0) {
        subtitleHeight = [self.subtitle sizeWithFont:self.subtitleFont
                                   constrainedToSize:CGSizeMake(layoutWidth, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping].height;
        if (subtitleHeight < kVerticalContentMinHeight) {
            subtitleHeight = kVerticalContentMinHeight;
        }
        offsetY += kSubTitlePadding;
    }
    layout.subtitleRect = CGRectMake(CGRectGetMinX(layoutFrame) + kTitleIndent, offsetY, subtitleWidth, subtitleHeight);
    
    //custom view
    CGFloat customViewHeight = 0;
    CGFloat customViewWidth = 0;
    CGFloat customViewLeft = 0;
    offsetY = CGRectGetMaxY(layout.subtitleRect);
    if (self.customView) {
        customViewHeight = CGRectGetHeight(self.customView.frame);
        customViewWidth = CGRectGetWidth(self.customView.frame);
        customViewLeft = (CGRectGetWidth(layoutFrame) - customViewWidth) / 2.0;
        offsetY += kCustomViewPadding;
    }
    layout.customViewRect = CGRectMake(customViewLeft, offsetY, customViewWidth, customViewHeight);

    // Buttons frame (note that views are in the content view coordinate system)
    CGFloat buttonsHeight = 0;
    offsetY = CGRectGetMaxY(layout.customViewRect);
    if (self.buttons.count > 0) {
        buttonsHeight = kButtonHeight;
        offsetY += kVerticalPadding;
    }
    layout.buttonRect = CGRectMake(CGRectGetMinX(layoutFrame), offsetY, layoutWidth, buttonsHeight);
    
    // Adjust layout frame
    //根据实际内容调整大小
    layoutFrame.size.height = CGRectGetMaxY(layout.buttonRect);
    
    // Create new content view
    UIView *newContentView = [[UIView alloc] initWithFrame:layoutFrame];
    newContentView.contentMode = UIViewContentModeRedraw;
    // Layout custom view
    self.customView.frame = layout.customViewRect;
    [newContentView addSubview:self.customView];
    
    // Layout buttons
    NSUInteger count = self.buttons.count;
    CGFloat buttonWidth = (int)(layoutWidth/count);
    offsetY = CGRectGetMinY(layout.buttonRect);
    int offsetX = 0;
    for (int i = 0; i < count; ++i) {
        VVAlertViewButton* bt = [self.buttons objectAtIndex:i];
        if (count == 1) {
            bt.type = kButtonAlone;
            [bt setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
        }
        else{
            if (i == 0) {
                bt.type = kButtonLeft;

            }
            else if (i == (count -1)){
                bt.type = kButtonRight;
                [bt setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
            }
            else{
                bt.type = kButtonCenter;
                
            }
           
        }
        CGRect buttonFrame = CGRectIntegral(CGRectMake(offsetX, offsetY, buttonWidth, kButtonHeight));
        bt.frame = buttonFrame;
        bt.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        
        if (i>0) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 0.5, kButtonHeight-10)];
            line.backgroundColor = VV_COL_RGB(0x999999);
            [bt addSubview:line];

        }
        
        if (bt.tag == kCancelButtonTag) {
            bt.buttonBackgroundColor = VV_COL_RGB(kColorAlertViewButtonNormal);
            bt.buttonhighlightColor = VV_COL_RGB(kColorAlertViewButtonHighlight);
        }
        else if(self.specialIndex == i){
            bt.buttonBackgroundColor = [UIColor globalThemeColor];
            bt.buttonhighlightColor = [UIColor globalThemeColor];
        }
        else{
            bt.buttonBackgroundColor = VV_COL_RGB(kColorAlertViewButtonNormal);
            bt.buttonhighlightColor = VV_COL_RGB(kColorAlertViewButtonHighlight);
        }
    
        [newContentView addSubview:bt];
        offsetX += buttonWidth;
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, offsetY, self.width, 0.5)];
    line.backgroundColor = VV_COL_RGB(0x999999);
    [newContentView addSubview:line];
    
    // Fade content views
    CGFloat animationDuration = kAnimationDuration;
    if (self.contentView.superview != nil) {
        [UIView transitionFromView:self.contentView
                            toView:newContentView
                          duration:animationDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        completion:^(BOOL finished) {
                            self.contentView = newContentView;
                        }];
    } else {
        self.contentView = newContentView;
        [self addSubview:newContentView];
        
        // Don't animate frame adjust if there was no content before
        animationDuration = 0;
    }
    
    // Adjust frame size
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
        CGRect alertFrame = layoutFrame;
        alertFrame.origin.x = (int)((CGRectGetWidth(self.hostWindow.bounds) - CGRectGetWidth(alertFrame)) / 2.0);
        alertFrame.origin.y = (int)((CGRectGetHeight(self.hostWindow.bounds) - CGRectGetHeight(alertFrame)) / 2.0);
        
        self.frame = CGRectIntegral(alertFrame);
    } completion:^(BOOL finished) {
        [self setNeedsDisplay];
    }];
     
}

- (void)resetLayout
{
    self.tag = 0;
    self.title = nil;
    self.subtitle = nil;
    self.customView = nil;
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    [self removeAllControls];
}

- (void)removeAllControls
{
    [self removeAllButtons];
}

- (void)removeAllButtons
{
    [self.buttons removeAllObjects];
    self.specialIndex = -1;
}

- (void)btnClicked:(UIButton*)sender
{
//    if (self.tag != kViewTagMustUpdateClient) {
//        [self hideAnimated:YES];
//    }
//    if (sender.tag == kCancelButtonTag) {
//        [self.delegate alertViewOnCancel:self];
//    }
//    else{
//        [self.delegate alertView:self onDismiss:sender.tag];
//    }
  if ((sender.tag == kCancelButtonTag)) {
    [self hideAnimated:YES];
  }
  if (_block) {
    _block(self,sender.tag);
  }
}

- (void)addOtherButtons:(NSArray*)buttonTitles specialIndex:(NSInteger)index
{
    for (int i = 0 ; i < [buttonTitles count]; ++i) {
        NSString* title = [buttonTitles objectAtIndex:i];
        BOOL special = NO;
        if (index == i) {
            special = YES;
        }
        
        [self addButtonWithTitle:title special:special tag:i];
    }
 }


- (void)addButtonCancel:(NSString *)title
{
    [self addButtonWithTitle:title special:NO tag:kCancelButtonTag];
}


- (void)addButtonWithTitle:(NSString *)title special:(BOOL)flag tag:(NSInteger)tag
{
    VVAlertViewButton *button = [VVAlertViewButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    //修改默认样式的button
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    if (flag) {
        self.specialIndex = self.buttons.count;
    }
    [self.buttons addObject:button];
}


- (void)showOrUpdateAnimatedInternal:(BOOL)flag
{
    
    VVAlertViewWindowOverlay *overlay = self.overlay;
    BOOL show = (overlay == nil);
    
    // Create overlay
    if (show) {
        self.overlay = overlay = [VVAlertViewWindowOverlay new];
        overlay.opaque = NO;
        overlay.windowLevel = UIWindowLevelStatusBar + 1;
        overlay.alertView = self;
        overlay.frame = self.hostWindow.bounds;
        overlay.alpha = 0.0;
        overlay.backgroundColor = [UIColor clearColor];
    }
    
    // Layout components
    [self layoutComponents];
    
    if (show) {
        // Scale down ourselves for pop animation
        self.transform = CGAffineTransformMakeScale(kPopScale, kPopScale);
        
        // Animate
        NSTimeInterval animationDuration = (flag ? kAnimationDuration : 0.0);
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            overlay.alpha = 1.0;
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // stub
        }];
        
        [overlay addSubview:self];
        [overlay makeKeyAndVisible];
    }
    
    if ([VVAlertView alertView].alertViewArr.count>0) {
        [[VVAlertView alertView].alertViewArr enumerateObjectsUsingBlock:^(VVAlertView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >0 ) {
                obj.hidden = YES;
                obj.overlay.hidden = YES;
            }
        }];
    }

    
}

- (void)showOrUpdateAnimated:(BOOL)flag
{
    SEL selector = @selector(showOrUpdateAnimatedInternal:);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelectorOnMainThread:selector withObject:[NSNumber numberWithBool:flag] waitUntilDone:NO];
}

- (void)hideAnimated:(BOOL)flag
{
    [self hideAlertViewAnimated:flag];
}
-(void)hideAlertViewAnimated:(BOOL)flag{
    
    
    if ([VVAlertView alertView].alertViewArr.count>0) {
        [[VVAlertView alertView].alertViewArr enumerateObjectsUsingBlock:^(VVAlertView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
            if (idx == [VVAlertView alertView].alertViewArr.count-1) {
                obj.hidden = NO;
                obj.overlay.hidden = NO;

            }else{
                obj.hidden = YES;
                obj.overlay.hidden = YES;
                
            }
        }];
    }
    

    VVAlertViewWindowOverlay *overlay = self.overlay;
    
    // Nothing to hide if it is not key window
    if (overlay == nil) {
        return;
    }
    
    NSTimeInterval animationDuration = (flag ? kAnimationDuration : 0.0);
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        overlay.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(kPopScale, kPopScale);
    } completion:^(BOOL finished) {
        overlay.hidden = YES;
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        self.overlay = nil;
        [self.hostWindow makeKeyWindow];
    }];
    
    [[VVAlertView alertView].alertViewArr removeLastObject];

}
- (void)hideAnimated:(BOOL)flag afterDelay:(NSTimeInterval)delay
{
    SEL selector = @selector(hideAnimated:);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:[NSNumber numberWithBool:flag] afterDelay:delay];
}

- (void)drawBackgroundInRect:(CGRect)rect
{
    // General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set alpha
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 1.0);
    
    // Color Declarations
    UIColor *color = VV_COL_RGB(kColorAlertViewBackground);
    CGFloat cornerRadius = 8.0;
    // Rounded Rectangle Drawing
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    CGContextSaveGState(context);    
    [color setFill];
    [roundedRectanglePath fill];
    CGContextRestoreGState(context);
    // Set clip path
    [roundedRectanglePath addClip];
        
    // Cleanup
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
     
}


- (void)drawTitleBackgroundInRect:(CGRect)rect
{
    // General Declarations
    if (self.title.length >0) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Set alpha
        CGContextSaveGState(context);
        CGContextSetAlpha(context, 1.0);
        
        // Color Declarations
        UIColor *color = [UIColor globalThemeColor];
        //    VV_COL_RGB(kColorAlertViewBackground);
        //    CGFloat cornerRadius = 8.0;
        // Rounded Rectangle Drawing
        UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight   cornerRadii:CGSizeMake(8, 8)];
        //    [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        CGContextSaveGState(context);
        [color setFill];
        [roundedRectanglePath fill];
        CGContextRestoreGState(context);
        // Set clip path
        [roundedRectanglePath addClip];
        // Cleanup
        CGColorSpaceRelease(colorSpace);
        CGContextRestoreGState(context);

    }
    
}

- (void)drawTitleInRect:(CGRect)rect isSubtitle:(BOOL)isSubtitle
{
    NSString *title = (isSubtitle ? self.subtitle : self.title);
    NSTextAlignment alignment = NSTextAlignmentCenter;
    if (title.length > 0) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        UIFont *font = (isSubtitle ? self.subtitleFont : self.titleFont);
        UIColor *color = (isSubtitle ? VV_COL_RGB(kColorAlertViewMessageText) : VV_COL_RGB(kColorAlertViewTitleText));
        [color set];
        //可能rect比较大,垂直输出
        CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(CGRectGetWidth(rect), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        int y = (rect.size.height - size.height)/2;
        CGRect textRect = CGRectMake(rect.origin.x,rect.origin.y + y, rect.size.width, size.height);
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = alignment;
        NSDictionary * dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:color};
        [title drawInRect:textRect withAttributes:dic];
        CGContextRestoreGState(ctx);
    }
}

- (void)drawTitleLineInRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [VV_COL_RGB(kColorAlertViewTitleLine) setFill];
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawDimmedBackgroundInRect:(CGRect)rect
{
//    // General Declarations
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // Color Declarations
//    UIColor *greyInner = [UIColor colorWithWhite:0.0 alpha:0.70];
//    UIColor *greyOuter = [UIColor colorWithWhite:0.0 alpha:0.2];
//    
//    // Gradient Declarations
//    NSArray* gradientColors = @[(id)greyOuter.CGColor,
//                               (id)greyInner.CGColor];
//    CGFloat gradientLocations[] = {0, 1};
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
//    
//    // Rectangle Drawing
//    CGPoint mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
//    
//    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:rect];
//    CGContextSaveGState(context);
//    [rectanglePath addClip];
//    CGContextDrawRadialGradient(context,
//                                gradient,
//                                mid, 10,
//                                mid, CGRectGetMidY(rect),
//                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
//    CGContextRestoreGState(context);
//    
//    // Cleanup
//    CGGradientRelease(gradient);
//    CGColorSpaceRelease(colorSpace);
  
  CGContextRef ref = UIGraphicsGetCurrentContext();
  CGContextSetRGBFillColor(ref, 0, 0, 0, 0.75);
  CGContextFillRect(ref, rect);
}


- (void)drawRect:(CGRect)rect
{
    [self drawBackgroundInRect:rect];
    CGRect titleRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, layout.titleRect.size.height+kCustomViewPadding+kTopMargin);
    [self drawTitleBackgroundInRect:titleRect];
    [self drawTitleInRect:layout.titleRect isSubtitle:NO];
    [self drawTitleLineInRect:layout.titlelineRect];
    [self drawTitleInRect:layout.subtitleRect isSubtitle:YES];
}


@end

@implementation VVAlertViewWindowOverlay
@synthesize alertView = _alertVIew;

- (void)drawRect:(CGRect)rect
{
    [self.alertView drawDimmedBackgroundInRect:rect];
}

@end


@implementation VVAlertViewButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:NULL];
      
        //设置button 中label 的字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return self;
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    [self setNeedsDisplay];
//}

///* 重写 buttonhighlightColor 返回的颜色方法 */
//#pragma mark -
//#pragma mark - 返回alertButton highlight 颜色
//
- (UIColor *)buttonhighlightColor {
  return  VV_COL_RGB(kColorAlertViewButtonHighlight);
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    // General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set alpha
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 1.0);
    
    CGContextSaveGState(context);

    // Color Declarations
    UIColor *color = self.highlighted ? self.buttonhighlightColor : self.buttonBackgroundColor;
    CGSize cornerRadius = {6.0,6.0};
    [color setFill];

    //Background 
    if(self.type == kButtonCenter) {
        CGContextFillRect(context, rect);
    }
    else{
        // Rounded Rectangle Drawing
        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:(UIRectCorner)self.type cornerRadii:cornerRadius];
        [path fill];
    }
    CGContextRestoreGState(context);
    // Cleanup
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
    
    int offsetY = CGRectGetMinY(rect);
    int offsetX = CGRectGetMinX(rect);
    int width = CGRectGetWidth(rect);
    int hight = CGRectGetHeight(rect);

    //top border
    UIImage* border = [VV_GETIMG(@"alert_bt_border") stretchableImageWithLeftCapWidth:0 topCapHeight:1];
    CGRect borderRect = CGRectMake(offsetX,offsetY,width , 0.5);
    [border drawInRect:borderRect];

    //vertical line
    if (self.type == kButtonCenter || self.type == kButtonRight) {
        UIImage* line = [VV_GETIMG(@"alert_bt_line") stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        //从第二个开始
        CGRect lineRect = CGRectMake(offsetX, offsetY+1, 0.5, hight -1);
        [line drawInRect:lineRect];
    }
}

@end



