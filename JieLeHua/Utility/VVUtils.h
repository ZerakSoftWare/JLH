//
//  VVUtils.h
//  VVlientV3
//
//  Created by wxzhao on 13-4-10.
//  Copyright (c) 2013年 wxzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define dbKey_confuse deviceModel
//#define aesEncryptStr       systemStr
//#define aesEncryptData      systemData
//#define aesDecryptString    macAddr
//#define aesDecryptData      locationEnable
//#define byPwd           with

int fibonacci(int n);

@interface VVUtils : NSObject

+ (float)deviceOS;


//+ (NSString*)dbKey_confuse;

#pragma mark - App版本号

+ (NSString*)appVersion;

#pragma mark - build版本号

+ (NSString*)buildVersion;


#pragma mark - 登录需要用到的拼接参数

+ (NSString*)loginDevice;

#pragma mark - 从 image asset 获取图片

+ (UIImage*)image568H:(NSString*)imageName;

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;

+ (BOOL)isRetina;

+ (NSString*)localizedStringWithKey:(NSString*)key;

//+ (NSArray*)localizedArrayWithKey:(NSString*)key;

#pragma mark - 错误码转成文字

+ (NSString*)strFromErrCode:(NSInteger)code;

//是否 ipad
+ (BOOL)isiPad;


+ (BOOL)isJailbroken;
//从字符串生成UIColor
+ (UIColor*)colorWithHexString:(NSString*)str;

//从字符串生成UIColor没有透明度
+ (UIColor *) colorWithHexStringNoAlpha: (NSString *)color;

/* fileName 示例 test/hello/test.txt */
+ (void)writeFile:(NSString*)fileName data:(NSData*)data append:(BOOL)append;

+ (NSData*)readFile:(NSString*)fileName;

+ (void)removeFile:(NSString*)fileName;

+ (BOOL)isEmpty:(NSString*)value;
#pragma mark -
#pragma mark 从String创建URL
+ (NSURL*)urlWithString:(NSString *)value;

//获取UIImage， 如果图片找不到或者尺寸为0 返回nil
+ (UIImage*)getImage:(NSString*) imageName;

//+ (void)writeConfigFile:(NSData*)data;


#pragma mark 从cordova中返回的参数生成NSDictionary
//+ (NSDictionary*)dictionaryFromCordovaArgument:(id)object;

#pragma mark - return if open remote notification

+ (BOOL)isAllowRemoteNotification;

#pragma mark - format string
//+ (NSString *)parseObjectToJsonString:(id)object;
+ (NSString *)convertMoneyFormat:(NSString *)moneyString;
+ (NSString *)formatCardNumber:(NSString *)cardNumber;


#pragma mark - Luhn算法验证信用卡卡号是否有效
+ (BOOL)luhnCheck:(NSString *)stringToTest;
#pragma mark - 信用卡 卡号是否合法,里面包含了 Luhn 算法校验
+ (BOOL)isCreditCardLegal:(NSString *)cardNum;



#pragma mark - 银行卡号 4 位 分割
//+ (NSString*)getFormatCardID:(NSString*)cardID;
+ (NSString*)getNormalString:(NSString*)string;

+ (NSString*)formatPhoneNumber:(NSString *)phoneNumberl;

#pragma mark 手机号码 3，4，4 分割
//+ (NSString*)getFormatMobileNumber:(NSString *)mobileNum;

//验证身份证是否合法
+ (BOOL)isIdCardNumberLegal:(NSString*)certId;
/**
 *	@brief	移动光标的位置，前三个参数 对应 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 中的三个参数
 *
 *	@param 	textField 	对应的输入框
 *	@param 	range 	<#range description#>
 *	@param 	string 	<#string description#>
 *	@param 	source 	修改后 没有格式化 的字符串。
 */
+ (void)moveCaretOfTextfield:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string source:(NSString *)source  seperator:(NSString *)seperator
;

/**
 *	@brief	分割字符串
 *
 *	@param 	string 	需要分割的原始字符串
 *	@param 	seperator 	分割的长度。例如 手机号可以是 3,4,4  或 3,4 ; 信用卡还款是 4 
 *
 *	@return	返回分割后的字符串
 */
+ (NSString*)seperateString:(NSString *)string seperator:(NSString *)seperator;


//获得上拉加载更多的自定义view
//+ (UIView *)getTableViewLoadMoreView;

#pragma mark 根据folder拼网络图片URL

+ (NSURL*)urlWithFolder:(NSString*)folder withURL:(NSString*)org;


#pragma mark - 生成随机数字  -

+ (NSString*)generateRandomChar:(NSInteger)len;
#pragma mark - encrypt  -

+ (NSString*)aesEncryptStr:(NSString*)str byPwd:(NSString*)pwd;

+ (NSData*)aesEncryptData:(NSData*)data byPwd:(NSString*)pwd;

#pragma mark - decrypt  -

+ (NSString*)aesDecryptString:(NSString*)encryptedStr byPwd:(NSString*)pwd;

+ (NSData*)aesDecryptData:(NSData*)encryptedData byPwd:(NSString*)pwd;

#pragma mark - MD5Crypt  -

+ (NSString *)md5:(NSString *)str;

+ (CGFloat)sizeFloat:(CGFloat)f;
@end
