//
//  VVommonTextField.m
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-26.
//
//

#import "VVCommonTextField.h"

@implementation VVCommonTextField


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.borderStyle = UITextBorderStyleNone;
        self.font = [UIFont systemFontOfSize:15.0];
//        self.backgroundColor = VVRandomColor;
        // 改变 边界颜色
        //        self.layer.cornerRadius = 4.0;
        //        self.layer.borderWidth = 1.0;
        //        self.layer.borderColor = [[UIColor colorWithRed:195.0/255 green:208.0/255 blue:221.0/255 alpha:1.0] CGColor];
        
//        self.placeHolderColor = VV_COL_RGB(kColorTextFieldPlaceHolder);
//        self.textColor = VV_COL_RGB(kColorPublicPayText);
        self.canBeginEditting = YES;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.adjustsFontSizeToFitWidth = NO;
        self.textColor = [UIColor blackColor];
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1,frame.size.width, 1)];
        _lineView.backgroundColor = VV_COL_RGB(0xdddddd);
        [self addSubview:_lineView];
        [self setExclusiveTouch:YES];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
//        self.background = [VV_GETIMG(@"textbox") stretchableImageWithLeftCapWidth:6 topCapHeight:6];
//        UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
//        toolView.backgroundColor = VVRandomColor;
//        self.inputAccessoryView = toolView;
    }
    return self;
}

- (void)setLineHeight:(CGFloat)lineHeight{
    _lineView.frame = CGRectMake(0, self.height-lineHeight, kScreenWidth-30, lineHeight);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

// 先执行  becomeFirstResponder,再执行 canBecomeFirstResponder
//- (BOOL)canBecomeFirstResponder {
//    [super canBecomeFirstResponder];
//    return self.canBeginEditting;
//}

//改变绘文字属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了.
//- (BOOL)becomeFirstResponder{
//    if (self.canBeginEditting) {
//        //        self.layer.borderColor = [VV_COL_RGB(0x00AEFF) CGColor];
//        BOOL is = [super becomeFirstResponder];
//        return is;
//    }
//    else {
//        return NO;
//    }
//    
//}


- (BOOL)resignFirstResponder{
    //    self.layer.borderColor  = [kTextColor_TextFieldBorderColor CGColor];
    return [super resignFirstResponder];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.leftImage) {
        bounds.origin.x = bounds.origin.x + 8;
    } else {
        bounds.origin.x = bounds.origin.x + 8;
    }
    
    bounds.size.width = bounds.size.width - 8 -8;
    return [super textRectForBounds:bounds];
    //    return CGRectMake(bounds.origin.x + 10.0f, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.leftImage) {
        bounds.origin.x = bounds.origin.x + 8;
    } else {
        bounds.origin.x = bounds.origin.x + 8;
    }
    bounds.size.width = bounds.size.width - kCommonTextFieldEditingRectLeftMargin -kCommonTextFieldEditingRectRightMargin;
    return [super textRectForBounds:bounds];
    //    return CGRectMake(bounds.origin.x + 10.0f, bounds.origin.y, bounds.size.width, bounds.size.height);
}


//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    [self.placeHolderColor setFill];
    UIFont *font = [UIFont systemFontOfSize:13.0];
    CGRect placeholderRect = CGRectMake(rect.origin.x, (rect.size.height- font.lineHeight)/2, rect.size.width, font.lineHeight);
    NSDictionary *dic = @{NSFontAttributeName:font,NSForegroundColorAttributeName:VV_COL_RGB(0x999999)};
    [[self placeholder] drawInRect:placeholderRect withAttributes:dic];
}

//控制右视图位置
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    float insetY = (bounds.size.height - self.rightView.bounds.size.height)/2.0;
    float insetX = bounds.size.width - self.rightView.bounds.size.width - insetY;
    
    CGRect inset = CGRectMake(insetX, insetY, self.rightView.bounds.size.width, self.rightView.bounds.size.height);
    
    return inset;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect rect = CGRectZero;
    
    if (self.leftText && ![self.leftText isEqualToString:@""]) {
        CGSize size = [self.leftText sizeWithFont:self.font];
        rect.size = CGSizeMake(76, size.height);
        if (size.width>76) {
            rect.size = size;
        }
        float y = (bounds.size.height - self.font.lineHeight)/2.0;
        rect.origin.y = y;
        rect.origin.x = 0;

//        if (self.leftImage) {
//            rect.origin.x = 14.0+15.0;
//
//        }
        
    }
    else if (self.leftImage) {
        CGSize size = self.leftImage.size;
        
        rect.size = CGSizeMake(30, size.height);
        
        float y = (bounds.size.height - size.height)/2.0;
        rect.origin.y = y;
        
        rect.origin.x = 0.0;
        
    }
    else {
        return CGRectZero;
    }
    return rect;
}


#pragma mark -
#pragma mark set leftText
-(void)setLeftText:(NSString *)leftText
{
    if (_leftText != leftText) {
        _leftText = [leftText copy];
        // create leftView
        [self createLeftView];
    }
}

- (void)createLeftView
{
    CGRect rect = [self leftViewRectForBounds:self.bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.font = self.font;
    self.textColor = VV_COL_RGB(0x333333);
    label.text = self.leftText;
    
    self.leftView = label;
    
    self.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - set leftImage
- (void)setLeftImage:(UIImage *)leftImage {
    if (_leftImage != leftImage) {
        _leftImage = leftImage;
        // create leftView
        [self createLeftImageView];
    }
}

- (void)createLeftImageView {
    CGRect rect = [self leftViewRectForBounds:self.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = self.leftImage;
    imageView.contentMode = UIViewContentModeCenter;
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
}



@end



#pragma mark -
#pragma mark VVPhoneNumberTextField

@implementation VVPhoneNumberTextField

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGSize  clearBtnSize    = CGSizeMake(20, 20);
    float   insetY  = (bounds.size.height - clearBtnSize.height)/2.0;
    float   insetX  = bounds.size.width - 20 - 50;
    CGRect  inset   = CGRectMake(insetX,
                                 insetY,
                                 clearBtnSize.width,
                                 clearBtnSize.height);
    return inset;
}

@end

#pragma mark -
#pragma mark VVRoundCornerTextField

@implementation VVRoundCornerTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 改变 边界颜色
        self.layer.cornerRadius = 15/2;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [VV_COL_RGB(0xd0d0d0) CGColor];
    }
    return self;
}

@end
