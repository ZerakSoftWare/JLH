//
//  VVUtils.m
//  VVlientV3
//
//  Created by wxzhao on 13-4-10.
//  Copyright (c) 2013年 wxzhao. All rights reserved.
//

#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "VVUtils.h"
#import <objc/runtime.h>
#include <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "AESCrypt.h"

#import "VVDeviceUtils.h"

__attribute__((always_inline)) NSString* dec_3A0FFF645AFCBBF48673D59699D5AAD6(NSString* key, NSString* string)
{
    if (string == nil) return nil;
    NSString* str = string;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const char *chars = [str UTF8String];
    int i = 0;
    NSInteger len = str.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    if (data == nil) return nil;
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted] encoding:NSUTF8StringEncoding] ;
    }
    
    free(buffer); //free the buffer;
    return nil;
}


// 清楚 信用卡格式
static inline NSString* cleanNumber(NSString *string)
{
	return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}


int fibonacci(int n)
{
    return ( n<=2 ? 1 : fibonacci(n-1) + fibonacci(n-2) );
}


// In bytes
#define kFileHashDefaultChunkSizeForReadingData 4096

// Function
CFStringRef fileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = kFileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,
                      (const void *)buffer,
                      (CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

CGFloat scale()
{
    static CGFloat scale = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = kScreenWidth/320.0f;
    });
    return scale;
}

@implementation VVUtils

#pragma mark - 系统版本号

+ (float)deviceOS
{
    static float deviceOSVersion = 0.0f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceOSVersion = [[VVDeviceUtils deviceOSVersion] floatValue];
    });
    return deviceOSVersion;
}




#pragma mark - App版本号

+ (NSString*)appVersion
{
    NSString* version = nil;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    version = infoDictionary[@"CFBundleShortVersionString"];
    return version;
}

#pragma mark - build版本号

+ (NSString*)buildVersion
{
    NSString* version = nil;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    version = infoDictionary[@"CFBundleVersion"];
    return version;
}


//#pragma mark - 登录需要用到的拼接参数
+ (NSString*)loginDevice
{
    NSMutableString* loginDevice = [NSMutableString string];
    [loginDevice appendString:[VVDeviceUtils machineTypeMap]];
    [loginDevice appendString:@"|"];
//    [loginDevice appendString:[VVDeviceUtils vendorIdentifier]];
    [loginDevice appendString:[NSString stringWithFormat:@"iOS %@",[VVDeviceUtils deviceOSVersion]]];
    [loginDevice appendString:@"|"];
    
    
        return loginDevice;
}




#pragma mark - 从 image asset 获取图片


+ (UIImage*)image568H:(NSString*)imageName
{
    NSString* newImageName = nil;
    if (ISIPHONE5) {
        newImageName = [imageName stringByAppendingString:@"-568h@2x"];
    }
    else if(ISIPHONE6){
        newImageName = [imageName stringByAppendingString:@"-800-667h@2x"];
    }
    else if (ISIPHONE6Plus){
        newImageName = [imageName stringByAppendingString:@"-800-Portrait-736h@3x"];
    }
    else{
        newImageName = imageName;
    }
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:newImageName ofType:@"png"];
    return [[UIImage alloc] initWithContentsOfFile:imagePath];
}



#pragma mark -
#pragma mark 横竖屏切换

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        if (size.height>size.width) {
            size = CGSizeMake(size.height, size.width);
        }
    }else{
        if (size.width>size.height) {
            size = CGSizeMake(size.height, size.width);
        }
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

#pragma mark -
#pragma mark 是否retina

+ (BOOL)isRetina
{
    static BOOL isRetinaSkin = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isRetinaSkin = [UIScreen mainScreen].scale > 1.0;
    });
    return isRetinaSkin;
}



#pragma mark -
#pragma mark 本地化字符串
//static VVPlistUtils* localDict = nil;

+ (NSString*)localizedStringWithKey:(NSString*)key
{
	NSString* result = key;
//
//    if (!localDict) {
////        localDict = [VVPlistUtils reloadPlistWithType:kPlistTypeLocalization];
//    }
//    if (localDict){
//        result = [localDict objectForKey:key];
//    }
//    if (VV_IS_NIL(result)) {
//        result = [NSMutableString string];
//    }
	return result;
}

//+ (NSArray*)localizedArrayWithKey:(NSString*)key
//{
//    NSArray* result = nil;
//    
//    if (!localDict) {
////        localDict = [VVPlistUtils reloadPlistWithType:kPlistTypeLocalization];
//    }
//    if (localDict){
//        result = [localDict objectForKey:key];
//    }
//    if (!result) {
//        result = [NSMutableArray array];
//    }
//	return result;
//}

#pragma mark - 错误码转成文字

+ (NSString*)strFromErrCode:(NSInteger)code
{
    NSString* msg = nil;
//    if (code == kNetTimeOut) {
//        //The request timed out
//        msg = VV_STR(kRequestTimeOut);
//    }
//    else if(code == kNetSSLError)
//    {
//        msg = VV_STR(kNetworkSSLError);
//    }
//    else if(code == kNetWrongResp)
//    {
//        msg = VV_STR(kNetworkRespError);
//    }
//    else
//    {
//        msg = VV_STR(kNetworkError);
//    }
    return msg;

}

//判断是否 ipad 机型
+ (BOOL)isiPad
{
    BOOL result = NO;
    NSString* strDevice = [[UIDevice currentDevice].model substringToIndex:4];
    if ([strDevice isEqualToString:@"iPad"]) {
        result = YES;
    }
    return result;
}



#pragma mark -
#pragma mark 判断是否越狱

+ (BOOL)isJailbroken
{
    
    //If the app is running on the simulator
#if TARGET_IPHONE_SIMULATOR
    return NO;
    
    //If its running on an actual device
#else
    BOOL isJailbroken = NO;
    
    //This line checks for the existence of Cydia
    BOOL cydiaInstalled = VV_FILEEXIST(@"/Applications/Cydia.app");
    
    FILE *f = fopen("/bin/bash", "r");
    
    if (!(errno == ENOENT) || cydiaInstalled) {
        
        //Device is jailbroken
        isJailbroken = YES;
    }
    fclose(f);
    return isJailbroken;
#endif
}

#pragma mark -
#pragma mark 从字符串生成UIColor


+ (UIColor*)colorWithHexString: (NSString *) str
{
    NSString *tmp = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([tmp length] < 8){
        return nil;
    }
    
    if ([tmp hasPrefix:@"0X"]){
        tmp = [tmp substringFromIndex:2];

    }
    if ([tmp hasPrefix:@"#"]){
        tmp = [tmp substringFromIndex:1];
    }
    
    if ([tmp length] != 8){
        return nil;
    }
    
    unsigned long color = strtoul([tmp UTF8String],0,16);
    float a = ((float)((color & 0xFF000000) >> 24))/255.0;
    float r = ((float)((color & 0xFF0000) >> 16))/255.0;
    float g = ((float)((color & 0xFF00) >> 8))/255.0;
    float b = ((float)(color & 0xFF))/255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *) colorWithHexStringNoAlpha: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma mark -
#pragma mark 写文件
// fileName格式 ****/****/**.ext
+ (void)writeFile:(NSString*)fileName data:(NSData*)data append:(BOOL)append
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths firstObject];
    
    NSMutableString* dirPath = [[NSMutableString alloc] initWithString:docDir];
    NSArray* array = [fileName componentsSeparatedByString:@"/"];
    NSUInteger count = [array count];
    for (int i = 0; i < count-1; i++) {
        [dirPath appendFormat:@"/%@",array[i]];
    }
    NSString* filePath = [dirPath stringByAppendingPathComponent:array[count-1]];

    NSFileManager* fm = [NSFileManager defaultManager];
    if (!VV_FILEEXIST(dirPath)) {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (!VV_FILEEXIST(filePath)) {
        [fm createFileAtPath:filePath contents:data attributes:nil];
    }
    
    NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (append) {
        [file seekToEndOfFile];
    }
    
    [file writeData:data];
    [file closeFile];
    
}

#pragma mark -
#pragma mark 读文件

+ (NSData*)readFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    return data;
}

#pragma mark -
#pragma mark 删除文件

+ (void)removeFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString* path = [documentsDirectory stringByAppendingString:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}


//#pragma mark - 
//#pragma mark 从UI提示语配置文件中取得相应的String
//
//+ (void)writeConfigFile:(NSData *)data
//{
//    NSString *errorDescription = nil;
//    NSPropertyListFormat format;
//    NSDictionary *dict = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&errorDescription];
//    //merge 新旧config , 保留旧的字段, 只更新新的
//    
//    [dict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
//        [localDict setObject:obj forKey:key];
//    }];
//    [localDict synchronize];
//    
//    //下次本地化时reload plist
//    [VVPlistUtils releasePlist:kPlistTypeLocalization];
//    
//    localDict = nil;
//}


#pragma mark -
#pragma mark 判断字符串是否为空（nil和length为0都是空）

+ (BOOL)isEmpty:(NSString *)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return  (nil == value || [value isKindOfClass:[NSNull class]] || ([value length] == 0) || [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]);
    }
    //非字符串类型直接返回empty
    return YES;
    
}

#pragma mark -
#pragma mark 从String创建URL
+ (NSURL*)urlWithString:(NSString *)value
{
    NSURL* url = nil;
    if (![self isEmpty:value]) {
        url = [NSURL URLWithString:value];
    }
    return url;
}

#pragma mark -
#pragma mark 获取UIImage， 如果图片找不到或者尺寸为0 返回nil
+ (UIImage*)getImage:(NSString*) imageName
{
    UIImage* image = nil;
    if (VV_IOS_VERSION >= 8.0) {
        image = [UIImage imageNamed:imageName inBundle:nil compatibleWithTraitCollection:nil];
    }
    else{
        image = [UIImage imageNamed:imageName];
    }
    if (!image) {
        return nil;
    }    
    if ( CGSizeEqualToSize(image.size, CGSizeZero)) {
        return nil;
    }
    return image;
}





//#pragma mark 从cordova中返回的参数生成NSDictionary
//
//+ (NSDictionary*)dictionaryFromCordovaArgument:(id)object
//{
//    NSDictionary* result = nil;
//    if ([object isKindOfClass:[NSNull class]]) {
//        result = nil;
//    }
//    if ([object isKindOfClass:[NSString class]]) {
//        if (!VV_IS_NIL(object)) {
//            result = [object objectFromJSONString];
//        }
//    }
//    if ([object isKindOfClass:[NSDictionary class]]) {
//        result = object;
//    }
//    return result;
//    
//}


#pragma mark - return if open remote notification

+ (BOOL)isAllowRemoteNotification
{
//    if (VV_IOS_VERSION >=8.0) {
        UIUserNotificationType t = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        return (t != UIUserNotificationTypeNone);
//    }
//    else{
//        UIRemoteNotificationType t = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        return (t != UIRemoteNotificationTypeNone);
//    }
}

#pragma mark - 对象转JsonString

/* parse the object to string */
//+ (NSString*)parseObjectToJsonString:(id)object
//{
//    NSString * jsonString = nil;
//    if (object && [object isKindOfClass:[NSDictionary class]]) {
//        jsonString = [object mj_JSONString];
//    }
//    return jsonString; 
//}
/* format bank card number */
+ (NSString*)formatCardNumber:(NSString *)cardNumber
{
    NSInteger length = [cardNumber length];
    if (length < 8) return cardNumber;
    NSRange range = NSMakeRange(0, 4);
    NSString * frontSubString = [cardNumber substringWithRange:range];
    range = NSMakeRange(length - 4, 4);
    NSString * behindSubString = [cardNumber substringWithRange:range];
    return [NSString stringWithFormat:@"%@%@%@",frontSubString, @" **** **** ", behindSubString];
}

+ (NSString*)formatPhoneNumber:(NSString *)phoneNumber
{
    NSInteger length = [phoneNumber length];
    if (length < 11) return phoneNumber;
    NSRange range = NSMakeRange(0, 3);
    NSString * frontSubString = [phoneNumber substringWithRange:range];
    range = NSMakeRange(length - 4, 4);
    NSString * behindSubString = [phoneNumber substringWithRange:range];
    return [NSString stringWithFormat:@"%@%@%@",frontSubString, @"****", behindSubString];
}


/* format money */
+ (NSString*)convertMoneyFormat:(NSString *)moneyString
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setCurrencySymbol:@""];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber * number = [NSNumber numberWithDouble:[moneyString doubleValue] * 0.01];
    NSString * formatMoneyString = [formatter stringFromNumber:number];
    return [formatMoneyString stringByAppendingString:VV_STR(@"String_Unit_RMB")];
}

#pragma mark - Luhn算法验证信用卡卡号是否有效
/* luhn 算法 http://www.pbc.gov.cn/rhwg/20001801f102.htm
 LUHN算法，主要用来计算信用卡等证件号码的合法性。
 1、从卡号最后一位数字开始,偶数位乘以2,如果乘以2的结果是两位数，将两个位上数字相加保存。
 2、把所有数字相加,得到总和。
 3、如果信用卡号码是合法的，总和可以被10整除。
 */
+ (NSMutableArray*)charArrayFromString:(NSString *)string {
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[string length]];
    for (int i=0; i < [string length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [string characterAtIndex:i]];
        [characters addObject:ichar];
    }
    return characters;
}
+ (BOOL)luhnCheck:(NSString *)stringToTest {
    NSMutableArray *stringAsChars = [VVUtils charArrayFromString:stringToTest];
    BOOL isOdd = YES;
    int oddSum = 0;
    int evenSum = 0;
    for (NSInteger i = [stringToTest length] - 1; i >= 0; i--) {
        int digit = [(NSString *)stringAsChars[i] intValue];
        if (isOdd) {
            oddSum += digit;
        }
        else {
//            evenSum += digit/5 + (2*digit) % 10;
            // 上面一句话分为下面三句话
            digit = digit*2;
            int even = digit / 10 + digit % 10;
            evenSum = evenSum + even;
        }
        isOdd = !isOdd;
    }
    return ((oddSum + evenSum) % 10 == 0);
}

+ (BOOL)isCreditCardLegal:(NSString *)cardNum
{
    BOOL isLegal = NO;
    BOOL isMatch  = VV_REGEXP(cardNum, kCreditCardPredicate);
    if (isMatch) {
        // luhn 算法 ，校验 卡号 最后一位 是否合法
        BOOL isLuhnOk = [VVUtils luhnCheck:cardNum];
        if (isLuhnOk) {
            isLegal = YES;
        }
    }    
    return isLegal;
}



+ (NSString*)getNormalString:(NSString*)string{   // 将4个一空格的卡号转为正常的卡号
    return cleanNumber(string);
//    return [cardID stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark 手机号码 3，4，4 分割
//+ (NSString*)getFormatMobileNumber:(NSString *)mobileNum
//{
//    if (mobileNum) {
//        NSString *string = [VVUtils seperateString:mobileNum seperator:kSeperatorMobileNumber];
//        return string;
//    }else {
//        return nil;
//    }
//    
//}

#pragma mark 移动光标位置
+ (NSInteger)spaceCountOfString:(NSString *)string {
    NSArray *arr = [string componentsSeparatedByString:@" "];
    NSInteger count = arr.count - 1;
    if (count < 0) {
        count = 0;
    }
    return count;
}

+ (void)moveCaretOfTextfield:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string source:(NSString *)source seperator:(NSString *)seperator
{
    if([textField conformsToProtocol:@protocol(UITextInput)])
    {
        id<UITextInput>textInput = (id<UITextInput>)textField;
        
        // 复制一份 source,改成可变字符串 ，source 是没有格式化的，可以得到当前光标位置
        NSMutableString *cardNo = [[NSMutableString alloc]initWithString:source];
        NSInteger currentIndex = range.location+string.length; // 修改后的位置
        NSString *sub = [cardNo substringToIndex:currentIndex]; // 修改后的 光标之前的字符串，没有格式化
        NSInteger oldSpaceCount = [VVUtils spaceCountOfString:sub];  //  格式化之前的 空格 的个数
        NSString *normalSub = [VVUtils getNormalString:sub];   // 修改的字符串 去掉所有的空格
        NSString *formatSub = [VVUtils seperateString:normalSub seperator:seperator]; //  重新格式化 光标之前的字符串
        NSInteger newSpaceCount = [VVUtils spaceCountOfString:formatSub];    // 计算 新空格的个数
        
        NSInteger count = newSpaceCount - oldSpaceCount; // 计算空格差
        
        // 从左边计算 偏移量，移动光标
        UITextPosition *startPos = [textInput positionFromPosition:textInput.beginningOfDocument offset:currentIndex+count];
        [textInput setSelectedTextRange:[textInput textRangeFromPosition:startPos toPosition:startPos]];
    }
}

#pragma mark 新的分割字符串的方法
+ (NSString*)seperateString:(NSString *)string seperator:(NSString *)seperator {
    // 清楚 string 前后空格
    NSCharacterSet* set = [NSCharacterSet whitespaceCharacterSet];
    NSString *newStr = [string stringByTrimmingCharactersInSet:set];
    
    // 字符串为nil或空。则直接返回。
    if (newStr.length == 0) {
        return newStr; 
    }
    // seperator 为nil或空。则直接返回。
    if (seperator.length == 0) {
        return string;
    }
    // 把 分割的 要求字符串 分成数组
    NSArray *seperatorArr = [seperator componentsSeparatedByString:@","];
    NSString *normalStr = cleanNumber(newStr);
    NSMutableArray* array = [NSMutableArray array];
    
    // 放子 字符串
    NSMutableString* subStr = [[NSMutableString alloc] initWithCapacity:1];
    // 默认起始位置
    int seperatorIndex = 0;
    int location = 0;
    // 遍历 字符串
    @autoreleasepool {
        for (NSInteger i = 0; i < normalStr.length; i++)
        {
            // 获取 需要的 长度
            int length = [[seperatorArr objectAtIndex:seperatorIndex] intValue];
            NSRange r = NSMakeRange(location, 1);
            
            // 获取每一位 字符，并加到 字符串中
            NSString *str = [normalStr substringWithRange:r];
            [subStr appendString:str];
            
            // 子字符串达到长度，就加到数组中
            if (subStr.length == length) {
                [array addObject:subStr];
                // 取下一个长度
                if (seperatorIndex != seperatorArr.count-1) {
                    seperatorIndex++;
                }
                // 重新 初始化 子字符串
                subStr = [[NSMutableString alloc] initWithCapacity:1];
            }
            else if (i == normalStr.length -1) {
                // 把剩下的字符串 也放到数组中
                [array addObject:subStr];
            }
            
            location++;
        }
    }
    
    
    // 把 分割后的数组，中间加上空格，拼成字符串
    NSString *formatStr =[array componentsJoinedByString:@" "];
    return  [formatStr stringByTrimmingCharactersInSet:set];
}

//+ (UIView *)getTableViewLoadMoreView{
//    //自定义加载更多的view
//    UIView *loadMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [activityIndicatorView startAnimating];
//    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, 20)];
//    [textLabel setBackgroundColor:[UIColor clearColor]];
//    [textLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [textLabel setTextColor:VV_COL_RGB(0x666666)];
//    [textLabel setText:@"正在加载..."];
//    [textLabel setCenterY:textLabel.centerY];
//    [loadMoreView addSubview:activityIndicatorView];
//    [loadMoreView addSubview:textLabel];
//    activityIndicatorView = nil;
//    textLabel = nil;
//    return loadMoreView;
//}


#pragma mark 根据folder拼网络图片URL

+ (NSURL*)urlWithFolder:(NSString*)folder withURL:(NSString*)org
{
    NSString* last = [org lastPathComponent];
    NSMutableString* tmp = [NSMutableString stringWithString:org];
    [tmp deleteCharactersInRange:NSMakeRange([org length] - [last length], [last length])];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%@",tmp,folder,last];
    return [NSURL URLWithString:urlString];
}





/**
 *  从ATM 所属的银行名字 中取第一个字符，显示在大头针上。
 *  2013.11.14 16:30,沈老板要求 如果以“中国”开头的银行跳过“中国”两个字取第三个字（中国银行除外），其他银行取第一个字
 *  @param atmName ATM 所属银行的名字
 *
 *  @return ATM所属银行的简称
 */
+ (NSString *)getATMFirstCharter:(NSString *)atmName {
    NSString *result = nil;
    
    if ([atmName hasPrefix:@"中国"] && atmName.length >= 4) {
        if ([[atmName substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"银行"]) {
            // 判断为 “中国银行”，取第一个字 “中”
            result = [atmName substringWithRange:NSMakeRange(0, 1)];
        }
        else {
            // 以中国开头，且后面不跟 “银行” 两个字的，去掉中国，去后面的第三个字
            result = [atmName substringWithRange:NSMakeRange(2, 1)];
        }
    }else {
        // 不以 “中国” 开头，则取第一个字。
        if (atmName.length >0) {
            result = [atmName substringWithRange:NSMakeRange(0, 1)];
        }
    }
    
    return result;
}

#pragma mark - 生成随机数字  -

+ (NSString*)generateRandomChar:(NSInteger)len
{
    char* data = (char*)malloc(len);
    for (int x=0;x<len;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *str =  [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
    free(data);
    return str;
}

#pragma mark - encrypt  -

+ (NSString*)aesEncryptStr:(NSString*)str byPwd:(NSString*)pwd
{
    return [AESCrypt encryptStr:str password:pwd];
}

+ (NSData*)aesEncryptData:(NSData*)data byPwd:(NSString*)pwd
{
    return [AESCrypt encryptData:data password:pwd];
}
#pragma mark - decrypt  -


+ (NSString*)aesDecryptString:(NSString*)encryptedStr byPwd:(NSString*)pwd
{
    return  [AESCrypt decryptStr:encryptedStr password:pwd];
}

+ (NSData*)aesDecryptData:(NSData*)encryptedData byPwd:(NSString*)pwd
{
    return  [AESCrypt decryptData:encryptedData password:pwd];
}

#pragma mark - MD5Crypt  -

+ (NSString *)md5:(NSString *)str
{
    return  [str md5];
}

+ (BOOL)isSameUid:(NSString*)firstId toUid:(NSString*)secondId
{
    return ([firstId compare:secondId options:NSCaseInsensitiveSearch] == NSOrderedSame);
}

+ (CGSize)getEqualScaleSize:(CGSize)size toSize:(CGSize)toSize
{
    if (CGSizeEqualToSize(size, CGSizeZero) || CGSizeEqualToSize(toSize, CGSizeZero)) {
        return CGSizeZero;
    }
    CGFloat width = size.width;
    CGFloat height = size.height;
    
	float verticalRadio = toSize.height*1.0/height;
	float horizontalRadio = toSize.width*1.0/width;
	
	float radio = 1;
	if(verticalRadio>1 && horizontalRadio>1)
	{
		radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
	}
	else
	{
		radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
	}
	
	width = width*radio;
	height = height*radio;
    return CGSizeMake(width, height);
}



+ (CGFloat)sizeFloat:(CGFloat)f
{
    return f * scale();
}

#pragma mark 判断身份证是否合法


//判断是否在地区码内

+(BOOL)areaCode:(NSString *)code
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


//验证身份证是否合法

+ (BOOL)isIdCardNumberLegal:(NSString*)certId
{
    //判断位数
    if ([certId length] < 15 ||[certId length] > 18) {
        
        return NO;
    }
    
    NSString *carid = certId;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [certId mutableCopy];
    if ([mString length] == 15) {
        
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
    NSString * province = [carid substringToIndex:2];
    
    if (![self areaCode:province]) {
        
        return NO;
    }
    
    //判断年月日是否有效
    int strYear = [[carid substringWithRange:NSMakeRange(6, 4)] intValue];
    int strMonth = [[carid substringWithRange:NSMakeRange(10, 2)] intValue];
    int strDay = [[carid substringWithRange:NSMakeRange(12, 2)] intValue];
    
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
    
    const char *paperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(paperId)) return NO;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(paperId[i]) && !(('X' == paperId[i] || 'x' == paperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (paperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != paperId[17] )
    {
        return NO;
    }
    
    return YES;
}



@end


