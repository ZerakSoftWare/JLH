//
//  VVCommonFunc.m
//  O2oApp
//
//  Created by YuZhongqi on 16/4/15.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVCommonFunc.h"
#import <CommonCrypto/CommonDigest.h>
#include <AVFoundation/AVFoundation.h>
#import "VLToast.h"


@implementation VVCommonFunc

+ (CGFloat)suitableHeightForCurrentDeviceWithStandardHeight:(CGFloat)height
{
    CGFloat rightHeight = height ;
    
    if (vScreenHeight == 480.f) {
        rightHeight = height / 667.f * 480.f ;
    }else if (vScreenHeight == 568.f) {
        rightHeight = height / 667.f * 568.f ;
    }else if (vScreenHeight == 1104.f) {
        rightHeight = height / 667.f * 1104.f ;
    }
    
    return rightHeight ;
}

+ (CGFloat)suitableWidthForCurrentDeviceWithStandardWidth:(CGFloat)width
{
    CGFloat rightWidth = width ;
    
    if (vScreenWidth == 320.f) {
        rightWidth = width / 375.f * 320.f ;
    }else if (vScreenWidth == 621.f){
        rightWidth = width / 375.f * 621.f ;
    }
    return rightWidth ;
}

#pragma mark -
+(BOOL)isIncludeNumber: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"0123456789"]];
    if (urgentRange.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+(BOOL)isIncludeletter: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"abcdefghigklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"]];
    if (urgentRange.location != NSNotFound)
    {
        return YES;
    }
    return NO;
}
#pragma mark - 时间日期相关
+(void)showAlert:(NSString*)string
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:string
                                                   delegate:nil
                                          cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
//时间字符串转换格式
+ (NSString *)stringformatDateStr:(NSString *)inputDate formatter:(NSString *)format
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //用[NSDate date]可以获取系统当前时间
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    NSDate* date_temp = [dateFormatter dateFromString:inputDate];
    NSString *currentDateStr = [dateFormatter stringFromDate:date_temp];
    return currentDateStr;
}

//日期转字符串
+ (NSString *)stringformatDate:(NSDate *)inputDate formatter:(NSString *)format
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //用[NSDate date]可以获取系统当前时间
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    NSString* date_temp = [dateFormatter stringFromDate:inputDate];
    return date_temp;
}

//时间字符串转日期
+ (NSDate *)dateformatDateStr:(NSString *)inputDate formatter:(NSString *)format
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //用[NSDate date]可以获取系统当前时间
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    NSDate* date_temp = [dateFormatter dateFromString:inputDate];
    
    return date_temp;
}

//根据时间戳返回标准表达格式的字符串
+ (NSString *)returnFormatterDateByDate:(long int)timeStamps formatter:(NSString *)format
{
    NSString *dateString = @"";
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamps];
    dateString = [formatter stringFromDate:date];
    return dateString;
}

//获取当前的时间戳
+ (NSString *)getTimestamp
{
    //获取当前时间的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}

//获取距离当前时间为days的天数的日期
+ (NSDate *)getDateFromDate:(NSDate *)nowDate andDays:(NSInteger)days
{
    NSDate *theDate;
    
    if(days!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow:oneDay*days];
    }
    else
    {
        theDate = nowDate;
    }
    return theDate;
}

//根据date换算年龄
+ (NSString *)ageWithDateOfBirth:(NSDate *)date
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return [NSString stringWithFormat:@"%ld",(long)iAge];
}

#pragma mark - 画图.圆角.分割线相关
//画条虚线
+(void)drowDottedLineOnView:(UIView *)view frame:(CGRect)frame color:(UIColor *)color
{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:frame];
    [view addSubview:imageView1];
    
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {1,1};                 //每个破折线长度=1   破折间距=1
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, color.CGColor);
    
    CGContextSetLineDash(line, 0,lengths, 2);   //画虚线
    CGContextMoveToPoint(line, 0.0, 0);       //开始画线  起始点（0，0）
    CGContextAddLineToPoint(line, vScreenWidth, 0);  //宽度320，结束点（320，0）
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    //return imageView1;
}

//画实线
+ (void)addFullLineByView:(UIView *)view FromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withLineColor:(UIColor *)lineColor
{
    CAShapeLayer *line = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    
    line.lineWidth = 0.5f;
    line.strokeColor = lineColor.CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    
    CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
    
    CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
    
    line.path = path;
    CGPathRelease(path);
    [view.layer insertSublayer:line atIndex:0];
}

+ (void)addImaginaryByView:(UIView *)view FromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withLineColor:(UIColor *)lineColor
{
    CAShapeLayer *line = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    
    line.lineWidth = 0.5f;
    line.strokeColor = lineColor.CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    //    line.lineDashPhase = 6;
    line.lineDashPattern = @[@1,@1];
    
    CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
    
    CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
    
    line.path = path;
    CGPathRelease(path);
    [view.layer insertSublayer:line atIndex:0];
}

//画圆角
+ (void)drawCornerRadiusWithView:(UIView *)view frame:(CGRect)frame byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

/**
 *  画带圆角虚线圈
 *  @param corners         圆角
 *  @param cornerRadii     圆角尺寸
 *  @param lineDashPattern 虚线线长，空白长
 *
 *  @return            nil
 */
+ (void)drawLoopsImaginaryLineByView:(UIView *)view withLineColor:(UIColor *)lineColor andLineWith:(CGFloat)lineWith roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii lineDashPattern:(NSArray *)lineDashPattern
{
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    line.lineWidth = lineWith;
    line.strokeColor = lineColor.CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    line.lineDashPattern = lineDashPattern;
    line.path = path.CGPath;
    [view.layer insertSublayer:line atIndex:0];
}

/**
 *  画虚线圈
 *  @param lineDashPattern 虚线线长，空白长
 *
 *  @return            nil
 */
+ (void)drawImaginaryLineByView:(UIView *)view withLineColor:(UIColor *)lineColor andLineWith:(CGFloat)lineWith startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineDashPattern:(NSArray *)lineDashPattern
{
    CAShapeLayer *line = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    
    line.lineWidth = lineWith;
    line.strokeColor = lineColor.CGColor;
    
    CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
    line.lineDashPattern = lineDashPattern;
    line.path = path;
    CGPathRelease(path);
    [view.layer insertSublayer:line atIndex:0];
    
}

/**
 *  画带圆角实线圈
 *  @param cornerRadius      圆角半径
 *  @param frame             圈圈FRAME
 *
 *  @return            nil
 */
+ (void)drawLoopsFullLineByView:(UIView *)view withLineColor:(UIColor *)lineColor fillColor:(UIColor *)fillColor andLineWith:(CGFloat)lineWith frame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius
{
    CAShapeLayer *line = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    
    line.lineWidth = lineWith;
    line.strokeColor = lineColor.CGColor;
    line.fillColor = fillColor.CGColor;
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame));
    CGPoint point1 = CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    
    CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, nil, point1.x, point1.y);
    CGPathAddLineToPoint(path, nil, point2.x, point2.y);
    CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
    CGPathCloseSubpath(path);
    line.cornerRadius = cornerRadius;
    line.path = path;
    CGPathRelease(path);
    [view.layer insertSublayer:line atIndex:0];
}

/**
 *  画带阴影实线
 *  @param startPoint         起点
 *  @param endPoint           终点
 *  @param lineColor          线颜色
 *  @param shadowOffset       阴影位置
 *  @param shadowOpacity      阴影透明度
 *  @param shadowColor        阴影颜色
 *  @param shadowRadius       阴影半径
 *  @param lineWith           线宽
 *  @return            nil
 */
+ (void)addFullLineByView:(UIView *)view FromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withLineColor:(UIColor *)lineColor lineWith:(CGFloat)lineWith shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)opactiy shadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor
{
    CAShapeLayer *line = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    
    line.lineWidth = lineWith;
    line.strokeColor = lineColor.CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    
    CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
    
    CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
    
    line.path = path;
    CGPathRelease(path);
    [line setShadowOffset:offset];
    [line setShadowOpacity:opactiy];
    [line setShadowRadius:shadowRadius];
    [line setShadowColor:shadowColor.CGColor];
    [view.layer insertSublayer:line atIndex:0];
}

#pragma mark - 字符串相关

//+ (CGFloat)getLabelWidthWithLabel:(UILabel *)label andHeight:(CGFloat)height
//{
//    CGFloat labelWidth = 0.0f;
//    labelWidth = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:label.lineBreakMode].width;
//    
//    
//    labelWidth = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{} context:nil.size.width;
//    return labelWidth;
//}


//数字金额转化为大写汉字金额
+ (NSString *)changetochinese:(NSString *)numstr
{
    double numberals=[numstr doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    if (valstr.length<=2) {
        prefix=@"零元";
        if (valstr.length==0) {
            suffix=@"零角零分";
        }
        else if (valstr.length==1)
        {
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
        }
        else
        {
            NSString *head=[valstr substringToIndex:1];
            NSString *foot=[valstr substringFromIndex:1];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar objectAtIndex:[foot intValue]]];
        }
    }
    else
    {
        prefix=@"";
        suffix=@"";
        NSInteger flag=valstr.length-2;
        NSString *head=[valstr substringToIndex:flag-1];
        NSString *foot=[valstr substringFromIndex:flag];
        if (head.length>13) {
            return@"数值太大（最大支持13位整数），无法处理";
        }
        //处理整数部分
        NSMutableArray *ch=[[NSMutableArray alloc]init];
        for (int i = 0; i < head.length; i++) {
            NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
            [ch addObject:str];
        }
        int zeronum=0;
        
        for (int i=0; i<ch.count; i++) {
            NSInteger index=(ch.count -i-1)%4;//取段内位置
            NSInteger indexloc=(ch.count -i-1)/4;//取段位置
            if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
                zeronum++;
            }
            else
            {
                if (zeronum!=0) {
                    if (index!=3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum=0;
                }
                prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
            }
            if (index ==0 && zeronum<4) {
                prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
            }
        }
        prefix =[prefix stringByAppendingString:@"元"];
        //处理小数位
        if ([foot isEqualToString:@"00"]) {
            suffix =[suffix stringByAppendingString:@"整"];
        }
        else if ([foot hasPrefix:@"0"])
        {
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
        }
        else
        {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix= [NSString stringWithFormat:@"%@角%@分",[numberchar  objectAtIndex:[headch intValue]],[numberchar objectAtIndex:[footch intValue]]];
        }
    }
    return [prefix stringByAppendingString:suffix];
}

//计算字符串所占空间的大小
+ (CGSize)sizeOfString:(NSString *)str withMaxWidth:(CGFloat)width withFont:(UIFont *)font  withLineBreakMode:(NSLineBreakMode)mode
{
    CGSize s;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0) {
        s = [str boundingRectWithSize:CGSizeMake(width, 999999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    else
    {
        s = [str sizeWithFont:font constrainedToSize:CGSizeMake(width, 99999) lineBreakMode:mode];
    }
    return s;
}

/**
 *@function: 字符串md5加密
 *@param1  : 要加密的字符串
 *@return  : 加密后的字符串
 */
+(NSString*)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    NSString* str_format = [NSString stringWithFormat:
                            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                            result[0], result[1], result[2], result[3],
                            result[4], result[5], result[6], result[7],
                            result[8], result[9], result[10], result[11],
                            result[12], result[13], result[14], result[15]
                            ];
    return  str_format.uppercaseString;
    
}


//16位MD5加密方式
+ (NSString *)Md5_16Bit:(NSString *)srcString{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self md5:srcString];
    
    VVLog(@"===========s=sssss===%@",md5_32Bit_String);
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result;
}



//字典转Json字符串
+(NSString *)JsonStringWhthDict:(NSDictionary *)dict
{
    if (dict == nil) {
        return @"";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//将字典转换成Json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  取某个字符串从开始位置起，一段长度的字符串
 *
 *  @param str   传入的字符串
 *  @param begin 开始位置
 *  @param end   长度为end的位置
 *
 *  @return 定制的字符串
 */
+ (NSString *)getStringWithRange:(NSString *)str Begin:(int)begin End:(int)end;
{
    return [str substringWithRange:NSMakeRange(begin,end)];
}

/**
 *  格式化输出数字
 *
 *  @param number 传入的数字
 *
 *  @return string类型返回所要表示的数字
 */
+ (NSString *)returnFormatterNumber:(NSInteger)number
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
    NSString *numString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:number]];
    return numString;
}

+ (NSString*)returnFormatterCurrencyFloat:(double)value
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    NSString *numString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
    return [numString substringFromIndex:1];
}


//千分符格式化数字，精确到两位
+ (NSString*)returnFormatterFloat:(double)value
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    [numberFormatter setPositiveFormat:@"#,###.##"];  //自定义数据格式

    NSString *numString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
    return numString;
}

//一组数字每隔三位加一个“，”逗号
+(NSString *)countNumAndChangeformat:(NSString *)num
{
    if (num == nil) {
        return nil ;
    }else{
        NSString *temp;
        if (![num isKindOfClass:[NSString class]])
        {
            temp = [NSString stringWithFormat:@"%@", num];
        }
        else
        {
            temp = num;
        }
        NSRange range1 = [temp rangeOfString:@"."];
        NSMutableString *str1;
        NSMutableString *str2;
        if (range1.location != NSNotFound) {  //有小数点的话
            str1 = (NSMutableString *)[temp substringToIndex:range1.location]; //小数点以前的数
            str2 = (NSMutableString *)[temp substringFromIndex:range1.location]; //小数点以后的数
            if (str2.length < 3)
            {
                str2 = (NSMutableString *)[NSString stringWithFormat:@"%@0", str2];
            }
            else
            {
                str2 = (NSMutableString *)[str2 substringToIndex:3];
            }
        }
        else{    //没小数点
            str1 =(NSMutableString *) temp;
            str2 = (NSMutableString *)@".00";
        }
        
        int count = 0;
        long long int a = str1.longLongValue;
        while (a != 0)
        {
            count++;
            a /= 10;
        }
        NSMutableString *string = [NSMutableString stringWithString:str1];
        NSMutableString *newstring = [NSMutableString string];
        while (count > 3)
        {
            count -= 3;
            NSRange rang = NSMakeRange(string.length - 3, 3);
            NSString *str = [string substringWithRange:rang];
            [newstring insertString:str atIndex:0];
            [newstring insertString:@"," atIndex:0];
            [string deleteCharactersInRange:rang];
        }
        [newstring insertString:string atIndex:0];
        
        return [NSString stringWithFormat:@"%@%@",newstring,str2];
    }
}

//(前3后3中间加*)
+(NSString*)replaceStringByDot:(NSString*)string
{
    //(22223234234234)->(222***234)  右括号
    NSInteger stringLength = string.length;
    NSString *strFormat = string;
    if (stringLength > 6 && stringLength < 12)
    {
        NSRange range = NSMakeRange(3, stringLength-7);
        strFormat = [string stringByReplacingCharactersInRange:range withString:@"****"];
    }if (stringLength > 11) {
        NSRange range = NSMakeRange(3, stringLength-6);
        strFormat = [string stringByReplacingCharactersInRange:range withString:@"*********"];
    }
    
    return strFormat;
}

//格式化邮箱号码(前3后4中间加*)
+(NSString*)formatEmailByStr:(NSString*)email{
    NSRange oldRange = [email rangeOfString:@"@"];
    NSRange newRange = NSMakeRange(3,oldRange.location  - 6 );
    NSString * strFormat;
    if (oldRange.location > 6) {
        strFormat = [email stringByReplacingCharactersInRange:newRange withString:@"****"];
    }else{
        strFormat = email;
    }
        return strFormat;

}


//格式化手机号码(前3后4中间加*)
+(NSString*)formatMobileByStr:(NSString*)mobile
{
    if (mobile.length < 11) {
        return mobile;
    }
    NSRange range = NSMakeRange(3, 4);
    NSString* strFormat = [mobile stringByReplacingCharactersInRange:range withString:@"****"];
    return strFormat;
}

//格式
+(NSString*)formatBankCardByStr:(NSString*)cardNum
{
    NSString* strFormat;
    if (cardNum.length < 16) {
        return cardNum;
    }
        NSRange range = NSMakeRange(4, cardNum.length - 8);
        strFormat  = [cardNum stringByReplacingCharactersInRange:range withString:@"********"];
    
   
    return strFormat;
}

//格式化身份证号码(前6后4中间加*)
+(NSString*)formatPaperIdByStr:(NSString*)paperId
{
    NSRange range;
    NSString* strFormat;
    if ([paperId length] == 15) {
        range = NSMakeRange(6, 5);
        strFormat = [paperId stringByReplacingCharactersInRange:range withString:@"*****"];     //15位的用5个“*”代替
    }else if ([paperId length] == 18){
        range = NSMakeRange(6, 8);
        strFormat = [paperId stringByReplacingCharactersInRange:range withString:@"********"];  //18位的用8个“*”代替
    }
    if (paperId.length < 14) {
        return paperId;
    }
    
    return strFormat;
}
//格式化三位数为 2.. 200 020 002

+(NSString*)getIndexFormat:(NSInteger)idx{
    if (idx / 1000 >= 1) {
        return [NSString stringWithFormat:@"%@%@", [ NSString stringWithFormat:@"%ld",(idx/1000) ],@".."];
    }else if (idx / 100 >= 1){
        return [NSString stringWithFormat:@"%ld",idx ];
    }else if (idx /10 >=1){
        return [NSString stringWithFormat:@"0%ld",idx ];
    }else if (idx  >=1){
        return [NSString stringWithFormat:@"00%ld",idx ];
    }else{
        return [NSString stringWithFormat:@"%ld",idx ];
        
    }
    
}

//string进行非空非Null判断
+ (NSString *)isNullJudgeString:(NSString *)theString
{
    if (theString == nil || [theString isKindOfClass:[NSNull class]]) {
        return @"";
    }
    else
    {
        return [NSString stringWithFormat:@"%@",theString];
    }
}

+(BOOL)isPureNumandCharacters:(NSString *)string
{
    
    NSString *lastString = nil;
    lastString = [string substringFromIndex:(string.length -1)];
    NSLog(@"%@",lastString);
    lastString = [lastString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(lastString.length > 0)
    {
        return NO;
    }
    return YES;
}

#pragma mark - 校验相关

//判断手机号码是否合法
+ (BOOL) isValidateMobile:(NSString *)mobile
{
//    NSString *phoneRegex = @"1[3|4|5|7|8|][0-9]{9}";
    NSString *phoneRegex = @"^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//判断合法的用户，是否含有汉字
+ (BOOL)isValidChinese:(NSString*)userName
{
    
    for(int i = 0; i < [userName length]; i++) {
        int a = [userName characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            [VLToast showWithText:@"用户名中含有汉字" duration:1.5];
            return YES;
        }
    }
    return NO;
}
//判断首字母是否为汉字
+ (BOOL)isFirstCharIsChinese:(NSString*)string
{
    if (string.length >= 1) {
        int a = [string characterAtIndex:0];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

//判断合法的用户密码
+ (BOOL)isValidUsrPwd:(NSString*)pwd
{
    NSNumber* _temp = [NSNumber numberWithInteger:[pwd length]];
    if ([_temp intValue] >= 6 && [_temp intValue] <= 16) {
        return YES;
    }
    else
    {
        return NO;
    }
}

//校验用户名长度6--18位
+ (BOOL)isValidUsrNameLength:(NSString*)usrName
{
    NSNumber* _temp = [NSNumber numberWithInteger:[usrName length]];
    if (6 <= [_temp intValue] && [_temp intValue] <= 18) {
        return YES;
    }else{
        [VLToast showWithText:@"请输入长度为6到18位的用户名" duration:1.5];
        return NO;
    }
}

//校验密码长度6--16位
+ (BOOL)isValidPasswordLength:(NSString*)password
{
    NSNumber* _temp = [NSNumber numberWithInteger:[password length]];
    
    if (6 <= [_temp intValue] && [_temp intValue] <= 16) {
        return YES;
    }else{
        [VLToast showWithText:@"密码为6-16位字符,可包含数字,字母(区分大小写)" duration:1.5];
        return NO;
    }
}

+(NSString *)getNum:(NSString *)str{
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    NSLog(@"scanNumber : %d", number);
    return [NSString stringWithFormat:@"%d", number] ;
}

//校验是否含有特殊字符
+ (BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        [VLToast showWithText:@"用户名中含有特殊字符" duration:1.5];
        return YES;
    }
    return NO;
}

//验证邮箱的合法性
+ (BOOL)isLegalityEmail:(NSString *)email {

    NSString *fullEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//  后台    NSString *emailRegex = @"\s*\w+(?:\.{0,1}[\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\.[a-zA-Z]+\s*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:fullEmail];
}

/**
 *  身份证未满18岁提示框
 *
 *  @param paperId 15位或者18位中国身份证号
 *
 *  @return BOOL值(是否为有效的身份证号)
 */
+ (BOOL)isEighteenYearOld:(NSString *)IDCard
{
    
    NSString *carid = IDCard;
    
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};//校验码
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:IDCard];
    
    if ([IDCard length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    
    NSString* idString = [self getStringWithRange:carid Begin:6 End:8] ;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    //身份证时间
    NSDate *idDate = [dateFormat dateFromString:idString];
    //当前时间
    NSDate *currentDate = [NSDate date];
    
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    //身份证时间距1970的秒数
    NSInteger seconds1 = [idDate timeIntervalSince1970]+timezoneFix;
    //当前时间距1970年的秒数
    NSInteger seconds2 = [currentDate timeIntervalSince1970]+timezoneFix;
    
    if ((seconds2-seconds1)/(24*3600*365) >=18) {
        return YES;
    }else{
        return NO;
    }
    
}

/**
 *  验证身份证有效性
 *
 *  @param paperId 15位或者18位中国身份证号
 *
 *  @return BOOL值(是否为有效的身份证号)
 */
+ (BOOL)checkPaperId:(NSString*)sPaperId
{
    //判断位数
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    
    long lSumQT =0;
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};//校验码
    
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    
    if ([sPaperId length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    int strYear = [[self getStringWithRange:carid Begin:6 End:4] intValue];
    int strMonth = [[self getStringWithRange:carid Begin:10 End:2] intValue];
    int strDay = [[self getStringWithRange:carid Begin:12 End:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        return NO;
    }
    
    //检验长度
    const char *PaperId  = [carid UTF8String];
    if( 18 != strlen(PaperId)) return -1;
    
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}

//校验银行卡是否正确
+ (BOOL)checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

//地区码是否有效
+ (BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

//判断TextField的Text是否为空
+ (BOOL)isTheTextFieldEmpty:(UITextField *)textField
{
    BOOL isEmpty = NO;
    if ([textField.text isEqualToString:@""] || textField.text == nil) {
        isEmpty = YES;
    }
    return isEmpty;
}

#pragma mark - 图片相关


+(BOOL)isAVAuthorizationStatus{

    if ( [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        NSString *mediaType = AVMediaTypeVideo;
        BOOL isAuthor = YES;;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            NSString *message = [NSString stringWithFormat:@"无法打开相机，请进入系统[设置] > [隐私] > [相机]中打开开关，并允许%@使用相机。",VV_App_Name];
            [VVAlertUtils showAlertViewWithTitle:@"打开相机" message:message customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                
                [alertView hideAnimated:NO];
            }];
            
            isAuthor = NO;
            
        }
        return isAuthor;
        
    }else{
        
        [VVAlertUtils showAlertViewWithMessage:@"无法获取您的拍照设备" cancelButtonTitle:@"确定" tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        
        return NO;
    }
    
}


//自由拉伸图片
+ (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)EdgeInsets image:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    UIEdgeInsets edge = EdgeInsets;
    img= [img resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    return img;
}

//将UIView转成UIImage
+ (UIImage *)getImageFromView:(UIView *)theView
{
    //UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//根据颜色和尺寸创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    UIView *theView = [[UIView alloc] initWithFrame:(CGRect){{0,0}, size}];
    theView.backgroundColor = color;
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//可以自由拉伸的图片

+ (UIImage *)resizedImage:(NSString *)imageName
{
    return [self resizedImage:imageName xPos:0.5 yPos:0.5];
}

+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width*xPos topCapHeight:image.size.height*yPos];
}

#pragma mark - UItextField

/**
 *  textfield添加背景和左侧图片
 *
 *  @param status    背景名称
 *  @param txd       所要设置的textField
 *  @param value     value
 *  @param imageName 图片名字
 */
+ (void)setTxdBgImg:(NSString*)status andTxd:(UITextField*)txd andLeftValue:(NSInteger)value andLeftImageName:(NSString *)imageName
{
    UIImage* bgImg = [UIImage imageNamed:status];
    bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    [txd setBackground:bgImg];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        [txd setValue:[NSNumber numberWithInteger:value] forKey:@"paddingLeft"];
    }else
    {
        [txd setValue:[NSNumber numberWithInteger:value] forKey:@"_paddingLeft"];
    }
    if (![imageName isEqualToString:@""] && imageName != nil) {
        UIView *userLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
        userImageView.image = [UIImage imageNamed:imageName];
        [userLeftView addSubview:userImageView];
        
        txd.leftView = userLeftView;
        txd.leftViewMode = UITextFieldViewModeAlways;
    }
}

//textfield设置边框颜色
+ (void)setTxdBoardWidth:(NSInteger)width cornerRadius:(NSInteger)radius color:(UIColor *)color onTextfield:(UITextField *)txd
{
    txd.layer.borderColor = [color CGColor];
    txd.layer.cornerRadius = radius;
    txd.layer.borderWidth = width;
}

#pragma mark - UILabel

// label设置最小字体大小
+ (void)label:(UILabel *)label setMiniFontSize:(CGFloat)fMiniSize forNumberOfLines:(NSInteger)iLines
{
    if (label)
    {
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = fMiniSize/label.font.pointSize;
        
    }else{}
}

+ (CGFloat)getLabelHeightWithWidth:(CGFloat)width text:(NSString *)string font:(UIFont *)font lineBreakMode:(NSLineBreakMode)kLineBreakMode
{
    CGFloat labelHeight = 0.0f;
    labelHeight = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:kLineBreakMode].height;
    return labelHeight;
}

+ (CGFloat)getLabelWidthWithHeight:(CGFloat)height text:(NSString *)string font:(UIFont *)font lineBreakMode:(NSLineBreakMode)kLineBreakMode
{
    CGFloat labelWidth = 0.0f;
    labelWidth = [string sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:kLineBreakMode].width;
    return labelWidth;
}

#pragma mark - UITableView

//隐藏tableView多余的分隔线
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - 移除观察者

// 清除PerformRequests和notification
+ (void)cancelPerformRequestAndNotification:(UIViewController *)viewCtrl
{
    if (viewCtrl)
    {
        [[viewCtrl class] cancelPreviousPerformRequestsWithTarget:viewCtrl];
        [[NSNotificationCenter defaultCenter] removeObserver:viewCtrl];
    }else{}
}

#pragma mark - UIScrollView

// 重设scroll view的内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar
{
    [[self class] resetScrlView:sclView contentInsetWithNaviBar:bHasNaviBar tabBar:bHasTabBar iOS7ContentInsetStatusBarHeight:0 inidcatorInsetStatusBarHeight:0];
}

+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar iOS7ContentInsetStatusBarHeight:(NSInteger)iContentMulti inidcatorInsetStatusBarHeight:(NSInteger)iIndicatorMulti
{
    if (sclView)
    {
        UIEdgeInsets inset = sclView.contentInset;
        UIEdgeInsets insetIndicator = sclView.scrollIndicatorInsets;
        CGPoint ptContentOffset = sclView.contentOffset;
        CGFloat fTopInset = bHasNaviBar ? 44 : 0.0f;
        CGFloat fTopIndicatorInset = bHasNaviBar ? 44 : 0.0f;
        CGFloat fBottomInset = bHasTabBar ? 49 : 0.0f;
        
        fTopInset += vStatusBarHeight;
        fTopIndicatorInset += vStatusBarHeight;
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)
        {
            fTopInset += iContentMulti * vStatusBarHeight;
            fTopIndicatorInset += iIndicatorMulti * vStatusBarHeight;
        }else{}
        
        inset.top += fTopInset;
        inset.bottom += fBottomInset;
        [sclView setContentInset:inset];
        
        insetIndicator.top += fTopIndicatorInset;
        insetIndicator.bottom += fBottomInset;
        [sclView setScrollIndicatorInsets:insetIndicator];
        
        ptContentOffset.y -= fTopInset;
        [sclView setContentOffset:ptContentOffset];
    }else{}
}


+ (AppDelegate *)returnAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (void)removeFromSuperview:(UIView *)view
{
    for(UIView *view1 in [view subviews])
    {
        [UIView animateWithDuration:0.5 animations:^{
            view1.alpha = 0;
        } completion:^(BOOL finished) {
            //            view1.alpha = 1;
            [view1 removeFromSuperview];
        }];
        
    }
}

+ (NSString *)returnDate:(NSString *)timep
{
    //时间戳转时间字符串
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *endDate = [dateFormatter dateFromString: [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timep doubleValue]]]];
    NSString *stringtime = [dateFormatter stringFromDate:endDate];
    return stringtime;
}

+(NSInteger)returnNowDay
{
    unsigned units  = NSCalendarUnitHour;
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp1 = [myCal components:units fromDate:[NSDate date]];
    return [comp1 day];
}

//
//+ (BOOL)jugStauts:(NSDictionary *)data
//{
//    BOOL string11;
//    if ([[[data objectForKey:@"data"] objectForKey:@"operationResult"] integerValue] != 0) {
//        string11 = YES;
//    }else{
//        if (![[[data objectForKey:@"data"] objectForKey:@"displayInfo"] isKindOfClass:[NSNull class]])
//        {
//            [DDAlertView showOnView:[self returnAppDelegate].window withTitle:@"" Msg:[[data objectForKey:@"data"] objectForKey:@"displayInfo"]];
//
////            [self showAlert:[[data objectForKey:@"data"]objectForKey:@"displayInfo"]];
//
////            [VLToast showWithText:[[data objectForKey:@"data"] objectForKey:@"displayInfo"]];
//        }
//
//        string11 = NO;
//    }
//    return string11;
//}


+ (void)isIphone4:(void (^)())block4 isIphone5:(void (^)())block5 isIphone6:(void (^)())block6 isIphone6P:(void (^)())block6P blockElse:(void(^)())blockElse{
    if (ISIPHONE4) {
        block4();
    }else if (ISIPHONE5){
        block5();
    }else if (ISIPHONE6){
        block6();
    }else if (ISIPHONE6Plus){
        block6P();
    }else{
        blockElse();
    }
}

+ (NSString *)getBankNumberForLast4:(NSString *)bankNumber{
    if (bankNumber.length >= 4) {
        NSString *str = [bankNumber substringFromIndex:bankNumber.length-3];
        return [NSString stringWithFormat:@"%@",str];
    }else{
        return  @"";
    }
}

+ (BOOL)checkCardNo11:(NSString*)cardNo
{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


+ (NSString*)formatPhoneNumber:(NSString*)mobileNum{
    if (mobileNum.length !=11) {
        return mobileNum;
    }
    NSMutableString* subStr = [[NSMutableString alloc] initWithCapacity:1];
    [subStr appendString:[mobileNum substringToIndex:3]];
    [subStr appendString:@"-"];
    [subStr appendString:[mobileNum substringWithRange:NSMakeRange(3, 4)]];
    [subStr appendString:@"-"];
    [subStr appendString:[mobileNum substringWithRange:NSMakeRange(7, 4)]];

    return subStr;
}

+ (void)telPhone:(NSString *)mobileNum{
    NSString *mobile = [NSString stringWithFormat:@"tel://%@",mobileNum];
    [VVAlertUtils showAlertViewWithTitle:nil message:[VVCommonFunc formatPhoneNumber:mobileNum] customView:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"呼叫"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != kCancelButtonTag) {
            [alertView hideAlertViewAnimated:YES];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
        }
    }];
}

+(NSString*)currentTime{
    NSDate*currentDate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    NSLog(@"currentString:----------->%@",currentString);
    return currentString;
}

+(NSString*)currentYearMounthDayTime{
    NSDate*currentDate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    NSLog(@"currentString:----------->%@",currentString);
    return currentString;
}

+(NSString*)currentYear{
    
    NSDate*currentDate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    //    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    NSLog(@"currentString:----------->%@",currentString);
    return currentString;

}

+(NSString*)currentMounth{
    
    NSDate*currentDate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM"];
    //    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentString=[dateformatter stringFromDate:currentDate];
    NSLog(@"currentString:----------->%@",currentString);
    return currentString;
}


+(NSString *)birthdayYearStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    //    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    //**截取前14位
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    //    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
//    [result appendString:@"-"];
//    [result appendString:month];
    //    [result appendString:@"-"];
    //    [result appendString:day];
    VVLog(@"birthdayYearStrFromIdentityCard%@",result);
    return result;
}

+(NSString *)birthdayMounthStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    //    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    //    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    //**截取前14位
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    if(!isAllNumber)
        return result;
    
    //    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    //    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    //    [result appendString:year];
    //    [result appendString:@"-"];
    [result appendString:month];
    //    [result appendString:@"-"];
    //    [result appendString:day];
    VVLog(@"birthdayMounthStrFromIdentityCard%@",result);
    return result;
}

+(NSString*)formatWithTimestamp:(long int)timestamp{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy.MM.dd"];
    NSString *tempStr1= [dateFormatter1 stringFromDate:date1];
    return tempStr1;
}

@end
