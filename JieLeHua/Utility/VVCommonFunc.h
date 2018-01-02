//
//  VVCommonFunc.h
//  O2oApp
//
//  Created by YuZhongqi on 16/4/15.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface VVCommonFunc : NSObject<UIAlertViewDelegate>

#pragma －－宽高互相适配
/**
 *  高度适配
 *
 *  @param height UI标注的高度
 *
 *  @return 适配后的高度
 */
+ (CGFloat)suitableHeightForCurrentDeviceWithStandardHeight:(CGFloat)height ;

/**
 *  宽度适配
 *
 *  @param width UI标注的宽度
 *
 *  @return 适配后的宽度
 */
+ (CGFloat)suitableWidthForCurrentDeviceWithStandardWidth:(CGFloat)width ;


#pragma －－是否含有数字／字母
/**
 *  是否含有数字
 *
 */
+(BOOL)isIncludeNumber: (NSString *)str;

/**
 *  是否含有字母
 *
 */
+(BOOL)isIncludeletter: (NSString *)str;

/**
 *  显示警告视图
 */
+(void)showAlert:(NSString*)string;


#pragma  －－日期时间<==>字符串 & 时间戳 & 年龄
/**
 *  时间字符串转换格式
 *
 *  @param inputDate 时间字符串
 *  @param format    想要转换的格式
 *  @return 想要的时间格式
 */
+ (NSString *)stringformatDateStr:(NSString *)inputDate formatter:(NSString *)format;

/**
 *  日期转字符串
 *
 *  @param inputDate NSDate类型
 *  @param format    想要转换的格式
 *
 *  @return 日期字符串
 */
+ (NSString *)stringformatDate:(NSDate *)inputDate formatter:(NSString *)format;

/**
 *  时间(NSString*)转日期(NSDate*)
 *
 */
+ (NSDate *)dateformatDateStr:(NSString *)inputDate formatter:(NSString *)format;
/**
 *  邮箱格式化
 */
+(NSString*)formatEmailByStr:(NSString*)email;
/**
 *  根据时间戳返回标准表达格式的字符串
 *
 *  @param timeStamps 时间戳
 */
+ (NSString *)returnFormatterDateByDate:(long int)timeStamps formatter:(NSString *)format;

+(NSString*)formatBankCardByStr:(NSString*)cardNum;

/**
 *  获取当前的时间戳
 */
+ (NSString *)getTimestamp;

/**
 *  获取距离当前时间为days的天数的日期
 *
 *  @param nowDate 当前时间
 *  @param days    整天数
 *
 *  @return        距离当前时间的整天数差（可输入正负皆可）
 */
+ (NSDate *)getDateFromDate:(NSDate *)nowDate andDays:(NSInteger)days;

/**
 *  根据date换算年龄
 */
+ (NSString *)ageWithDateOfBirth:(NSDate *)date;

#pragma mark -- 画图／圆角／分割线相关

/**
 *  指定点画虚线
 */
+ (void)addImaginaryByView:(UIView *)view FromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withLineColor:(UIColor *)lineColor;

/**
 *  指定frame画底部虚线
 */
+(void)drowDottedLineOnView:(UIView *)view frame:(CGRect)frame color:(UIColor *)color;

/**
 *  指定点画实线
 */
+ (void)addFullLineByView:(UIView *)view FromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withLineColor:(UIColor *)lineColor;

/**
 *  画圆角
 */
+ (void)drawCornerRadiusWithView:(UIView *)view frame:(CGRect)frame byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/**
 *  画带圆角虚线圈
 *  @param corners         圆角
 *  @param cornerRadii     圆角尺寸
 *  @param lineDashPattern 虚线线长，空白长
 *
 */
+ (void)drawLoopsImaginaryLineByView:(UIView *)view withLineColor:(UIColor *)lineColor andLineWith:(CGFloat)lineWith roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii lineDashPattern:(NSArray *)lineDashPattern;

/**
 *  画虚线圈
 *  @param lineDashPattern 虚线线长，空白长
 *
 */
+ (void)drawImaginaryLineByView:(UIView *)view withLineColor:(UIColor *)lineColor andLineWith:(CGFloat)lineWith startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineDashPattern:(NSArray *)lineDashPattern;

/**
 *  画带圆角实线圈
 *  @param cornerRadius      圆角半径
 *  @param frame             圈圈FRAME
 *
 */
+ (void)drawLoopsFullLineByView:(UIView *)view withLineColor:(UIColor *)lineColor fillColor:(UIColor *)fillColor andLineWith:(CGFloat)lineWith frame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius;

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
 */
+ (void)addFullLineByView:(UIView *)view FromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withLineColor:(UIColor *)lineColor lineWith:(CGFloat)lineWith shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)opactiy shadowRadius:(CGFloat)shadowRadius shadowColor:(UIColor *)shadowColor;

#pragma mark -- 字符串相关

/**
 *计算label宽度
 */
//+ (CGFloat)getLabelWidthWithLabel:(UILabel *)label andHeight:(CGFloat)height;
//获取字符串中的数字
+(NSString*)getNum:(NSString *)str;
/**
 *  数字金额转化为大写汉字金额
 *
 */
+ (NSString *)changetochinese:(NSString *)numstr;

/**
 *  计算字符串所占空间的大小
 *
 */
+(CGSize)sizeOfString:(NSString *)str withMaxWidth:(CGFloat)width withFont:(UIFont *)font withLineBreakMode:(NSLineBreakMode)mode;

/**32位MD5加密 大写
 *@function: 字符串md5加密
 *@param1  : 要加密的字符串
 *@return  : 加密后的字符串
 */
+ (NSString *)md5:(NSString *)str;

/**
 *  16位MD5加密方式 大写
 */
+ (NSString *)Md5_16Bit:(NSString *)srcString;

/**
 *  字典转Json字符串
 *
 */
+(NSString *)JsonStringWhthDict:(NSDictionary *)dict;

/**
 *  将字典转换成Json字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  取某个字符串从开始位置起，一段长度的字符串
 *
 *  @param str   传入的字符串
 *  @param begin 开始位置
 *  @param end   长度为end的位置
 *
 *  @return 定制的字符串
 */
+(NSString *)getStringWithRange:(NSString *)str Begin:(int)begin End:(int)end;

/**
 *  千分位格式化输出数字
 *
 *  @param number 传入的数字
 *
 *  @return string类型返回所要表示的数字
 */
+ (NSString *)returnFormatterNumber:(NSInteger)number;

/**
 *  千分位格式化输出数字
 *
 */
+(NSString*)returnFormatterFloat:(double)value;

/**
 *  千分符格式化数字，精确到两位
 */
+(NSString*)returnFormatterCurrencyFloat:(double)value;

/**
 *  一组数字每隔三位加一个“，”逗号
 */
+(NSString *)countNumAndChangeformat:(NSString *)num;

/**
 *  (前3后3中间加*)
 */
+(NSString*)replaceStringByDot:(NSString*)string;

/**
 *  格式化手机号码(前3后4中间加*)
 *
 */
+(NSString*)formatMobileByStr:(NSString*)mobile;

/**
 *  格式化身份证号码(前6后4中间加*)
 */
+(NSString*)formatPaperIdByStr:(NSString*)paperId;

/**
 *  格式化三位数为 2.. 200 020 002
 */
+(NSString*)getIndexFormat:(NSInteger)idx;

/**
 *  string进行非空非Null判断
 *
 */
+ (NSString *)isNullJudgeString:(NSString *)theString;

/**
 *  时间戳转时间字符串
 *
 */
+ (NSString *)returnDate:(NSString *)timep;

/**
 *  获得银行卡后4位数字
 */
+ (NSString *)getBankNumberForLast4:(NSString *)bankNumber;

/**
 *  获取当前日
 */
+(NSInteger)returnNowDay;
/**
 *  判断字符串的最后一个字符是否为数字
 */
+(BOOL)isPureNumandCharacters:(NSString *)string;

#pragma mark -- 验证信息相关

/**
 *  验证银行卡号
 */
+ (BOOL)checkCardNo11:(NSString*)cardNo;

/**
 *  判断手机号码是否合法
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;
/**
 *  手机号码344 用@“－”分隔
 */
+ (NSString*)formatPhoneNumber:(NSString*)mobileNum;
/**
 *  判断合法的用户，是否含有汉字
 */
+ (BOOL)isValidChinese:(NSString*)userName;

/**
 *  判断第一个字符是否为汉字
 */
+(BOOL)isFirstCharIsChinese:(NSString*)string;


/**
 *  判断合法的用户密码
 */
+ (BOOL)isValidUsrPwd:(NSString*)pwd;

/**
 *  校验用户名长度6--18位
 */
+ (BOOL)isValidUsrNameLength:(NSString*)usrName;

/**
 *  校验密码长度6--16位
 */
+ (BOOL)isValidPasswordLength:(NSString*)password;

/**
 *  校验是否含有特殊字符
 */
+ (BOOL)isIncludeSpecialCharact: (NSString *)str;

/**
 *  验证邮箱的合法性
 */
+ (BOOL)isLegalityEmail:(NSString *)email;

/**
 *  身份证未满18岁提示框
 *
 *  @param paperId 15位或者18位中国身份证号
 *
 *  @return BOOL值(是否为有效的身份证号)
 */
+ (BOOL)isEighteenYearOld:(NSString *)IDCard;

/**
 *  验证身份证有效性
 *
 *  @param paperId 15位或者18位中国身份证号
 *
 *  @return BOOL值(是否为有效的身份证号)
 */
+ (BOOL)checkPaperId:(NSString*)sPaperId;

/**
 *  校验银行卡是否正确
 */
+ (BOOL)checkCardNo:(NSString*) cardNo;

/**
 *  地区码是否有效
 */
+ (BOOL)areaCode:(NSString *)code;

/**
 *  判断TextField的Text是否为空
 */
+ (BOOL)isTheTextFieldEmpty:(UITextField *)textField;

#pragma mark -- 图片相关
/**
 *  判断关于相机是否能够使用
 */
+(BOOL)isAVAuthorizationStatus;
/**
 *  自由拉伸图片
 */
+ (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)EdgeInsets image:(NSString *)imageName;

/**
 *  将theView转换为Image
 */
+ (UIImage *)getImageFromView:(UIView *)theView;

/**
 *  根据颜色和尺寸创建图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)imageName;

/**
 *  拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

#pragma mark -- UItextField

/**
 *  textfield添加背景和左侧图片
 *
 *  @param status    背景名称
 *  @param txd       所要设置的textField
 *  @param value     value
 *  @param imageName 图片名字
 */
+ (void)setTxdBgImg:(NSString*)status andTxd:(UITextField*)txd andLeftValue:(NSInteger)value andLeftImageName:(NSString *)imageName;

/**
 *  textfield设置边框颜色
 *
 *  @param width  边框宽度
 *  @param radius 边框圆角
 *  @param color  边框颜色
 *  @param txd    索要设置的textfield
 */
+ (void)setTxdBoardWidth:(NSInteger)width cornerRadius:(NSInteger)radius color:(UIColor *)color onTextfield:(UITextField *)txd;

#pragma mark -- UILabel

/**
 *  设置最小字体
 */
+ (void)label:(UILabel *)label setMiniFontSize:(CGFloat)fMiniSize forNumberOfLines:(NSInteger)iLines;

/**
 *  由固定宽度根据text动态计算label高度
 */
+ (CGFloat)getLabelHeightWithWidth:(CGFloat)width text:(NSString *)string font:(UIFont *)font lineBreakMode:(NSLineBreakMode)kLineBreakMode;

/**
 *  由固定高度根据text动态计算label宽度
 */
+ (CGFloat)getLabelWidthWithHeight:(CGFloat)height text:(NSString *)string font:(UIFont *)font lineBreakMode:(NSLineBreakMode)kLineBreakMode;

#pragma mark -- UITableView

/**
 *  隐藏tableView多余的分隔线
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView;

#pragma mark -- 移除观察者

/**
 *  清除PerformRequests和notification
 */
+ (void)cancelPerformRequestAndNotification:(UIViewController *)viewCtrl;

#pragma mark -- UIScrollView

/**
 *  重设scroll view的内容区域和滚动条区域
 */
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar;

+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar iOS7ContentInsetStatusBarHeight:(NSInteger)iContentMulti inidcatorInsetStatusBarHeight:(NSInteger)iIndicatorMulti;

/**
 *  返回当前推荐人
 */
+ (AppDelegate *)returnAppDelegate;

/**
 *  当前视图从父视图中移除
 */
+ (void)removeFromSuperview:(UIView *)view;


//判断数据
//+ (BOOL)jugStauts:(NSDictionary *)data;

/**
 *  4,5,6适配
 */
+ (void)isIphone4:(void (^)())block4 isIphone5:(void (^)())block5 isIphone6:(void (^)())block6 isIphone6P:(void (^)())block6P blockElse:(void(^)())blockElse;
+ (void)telPhone:(NSString *)mobileNum;
+(NSString*)currentTime;
+(NSString*)currentYear;
+(NSString*)currentMounth;
+(NSString*)currentYearMounthDayTime;
+(NSString *)birthdayYearStrFromIdentityCard:(NSString *)numberStr;
+(NSString *)birthdayMounthStrFromIdentityCard:(NSString *)numberStr;
//时间戳格式化
+(NSString*)formatWithTimestamp:(long int)timestamp;

@end
