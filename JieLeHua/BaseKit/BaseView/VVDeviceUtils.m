//
//  VVDeviceUtils.m
//  VVlientV3
//
//  Created by Cao Kevin on 11-6-21.
//  Copyright 2013年 UnionPay All rights reserved.
//

#import "VVDeviceUtils.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
#include <netinet/in.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "KeychainItemWrapper.h"
#define kKeyKeychainVendorIDIdentifier [[NSBundle mainBundle]bundleIdentifier]


static CGSize       g_screenSize = {0,0};
static BOOL         g_isIphone5Simulator =NO;

@implementation VVDeviceUtils

/* Return a string description of the UUID, such as "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" */
+ (NSString*)vendorIdentifier
{
    return [self readVendorID];
}
// 读取 VendorID，并存储钥匙串
+ (NSString *)readVendorID {
    NSString *group = [NSString stringWithFormat:@"%@.%@",[self bundleSeedID],[[NSBundle mainBundle] bundleIdentifier]];
    // 存储account
    KeychainItemWrapper *accountWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kKeyKeychainVendorIDIdentifier accessGroup:group];
    NSString *account = [accountWrapper objectForKey:(id)kSecAttrAccount];
    if (!account || [account isEqualToString:@""]) {
        [accountWrapper setObject:kKeyKeychainVendorIDIdentifier forKey:(id)kSecAttrAccount];
    }
    NSString *uuid = [accountWrapper objectForKey:(id)kSecValueData];
    if (!uuid || [uuid isEqualToString:@""]) {
        uuid = [[UIDevice.currentDevice.identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
        
        // save to keychain
        [accountWrapper setObject:uuid forKey:(id)kSecValueData];
    }else {
        
    }
    [accountWrapper release];
    return uuid;
}
/* 读取 AppIdentifierPrefix
 You can programmatically retrieve the Bundle Seed ID by looking at the access group attribute (i.e. kSecAttrAccessGroup) of an existing KeyChain item. In the code below, I look up for an existing KeyChain entry and create one if it doesn't not exist. Once I have a KeyChain entry, I extract the access group information from it and return the access group's first component separated by "." (period) as the Bundle Seed ID.
 */
+ (NSString *)bundleSeedID {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge NSString *)kSecClassGenericPassword, kSecClass,
                     			      @"bundleSeedID        ", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}


//iPhone OS
+ (NSString*)deviceOS 
{
    return [[UIDevice currentDevice] systemName];
}
//4.3.3
+ (NSString*)deviceOSVersion 
{
    
    return [[UIDevice currentDevice] systemVersion];
}


+ (NSString*)deviceName
{
    
    return [[UIDevice currentDevice] name];
}




//iPhone
+ (NSString*)deviceModel {
    return [[UIDevice currentDevice] model];
}

+ (NSString*)machineType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = (char*)malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];//iPhone3,1
    free(answer);
    return results;
}

+ (NSString*)machineTypeMap
{
	NSString *model = [VVDeviceUtils machineType];
    if ([model isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([model isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([model isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([model isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([model isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([model isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([model isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([model isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([model isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([model isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([model isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([model isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([model isEqualToString:@"iPhone8,1"])    return @"iPhone 6s Plus";
    if ([model isEqualToString:@"iPhone8,2"])    return @"iPhone 6s";
    if ([model isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([model isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([model isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([model isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([model isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([model isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([model isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([model isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([model isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([model isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([model isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([model isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([model isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([model isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([model isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    if ([model isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([model isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([model isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([model isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([model isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([model isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([model isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([model isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([model isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([model isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([model isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([model isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([model isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([model isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([model isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([model isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([model isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([model isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([model isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([model isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (Cellular)";
    if ([model isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    
    if ([model isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([model isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    if ([model hasSuffix:@"86"] || [model isEqual:@"x86_64"])
    {
        return @"Simulator";
    }
    
    return model;
}

+ (int)machineTypeInt
{
	NSString *platform = [VVDeviceUtils machineType];
	if ([platform isEqualToString:@"iPhone1,1"]) return UIDevice1GiPhone;
	if ([platform isEqualToString:@"iPhone1,2"]) return UIDevice3GiPhone;
	if ([platform isEqualToString:@"iPhone2,1"]) return UIDevice3GSiPhone;
	if ([platform isEqualToString:@"iPhone3,1"]) return UIDevice4GiPhone;
	if ([platform isEqualToString:@"iPhone4,1"]) return UIDevice4GSiPhone;
    if ([platform isEqualToString:@"iPhone5,1"]) return UIDevice5iPhone;
	if ([platform isEqualToString:@"iPod1,1"])   return UIDevice1GiPod;
	if ([platform isEqualToString:@"iPod2,1"])   return UIDevice2GiPod;
	if ([platform isEqualToString:@"iPod3,1"])   return UIDevice3GiPod;
	if ([platform isEqualToString:@"iPad1,1"])   return UIDevice1GiPad;
	if ([platform isEqualToString:@"iPad2,1"])   return UIDevice2GiPad;
	if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
	if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;
	if ([platform hasPrefix:@"iPad"]) return UIDeviceUnknowniPad;
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        if (g_isIphone5Simulator) {
            return UIDeviceiPhone5Simulator;
        }else
            return UIDeviceSimulator;
    }
	return UIDeviceUnknown;
}

+ (void)setIsIphone5Simulator:(BOOL) isOrNot
{
    g_isIphone5Simulator = isOrNot;
}

+ (CGSize)deviceScreenBound
{
    if ((g_screenSize.height ==0) && (g_screenSize.width ==0)) {
        if (([self machineTypeInt] == UIDevice5iPhone) || ([self machineTypeInt] == UIDeviceiPhone5Simulator))
        {      //主要是因为iphone5存在兼容模式 而在兼容模式下获取的bounds不对
            g_screenSize =CGSizeMake(320, 568);
        }else
        {
            g_screenSize =[UIScreen mainScreen].bounds.size;
        }
    }
    return g_screenSize;
}


+ (NSString*)machineTypeString
{
	switch ([VVDeviceUtils machineTypeInt])
	{
		case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
		case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
		case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
		case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
		case UIDevice4GiPhone: return IPHONE_4G_NAMESTRING;
		case UIDevice4GSiPhone: return IPHONE_4GS_NAMESTRING;
        case UIDevice5iPhone:   return IPHONE_5_NAMESTRING;
        case UIDeviceSimulator: return SIMULATOR_NAMESTRING;
		case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
		case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
		case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
		case UIDevice1GiPad: return IPAD_1G_NAMESTRING;
		case UIDevice2GiPad: return IPAD_2G_NAMESTRING;
		case UIDeviceUnknowniPad: return IPAD_UNKNOWN_NAMESTRING;
		case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
		default: return nil;
	}
}

+ (int)deviceResolution{
	switch ([VVDeviceUtils machineTypeInt])
	{
		case UIDevice1GiPhone: return UIDeviceScreen320X480;
		case UIDevice3GiPhone: return UIDeviceScreen320X480;
		case UIDeviceUnknowniPhone: return UIDeviceScreen320X480;
		case UIDevice3GSiPhone: return UIDeviceScreen320X480;
		case UIDevice4GiPhone: return UIDeviceScreen640X960;
		case UIDevice4GSiPhone:	return UIDeviceScreen640X960;
		case UIDevice1GiPod: return UIDeviceScreen320X480;
		case UIDevice2GiPod: return UIDeviceScreen320X480;
		case UIDevice3GiPod: return UIDeviceScreen640X960;
		case UIDevice1GiPad: return UIDeviceScreen768X1024;
		case UIDevice2GiPad: return UIDeviceScreen768X1024;
		case UIDeviceUnknowniPad: return UIDeviceScreen768X1024;
		case UIDeviceUnknowniPod: return UIDeviceScreen320X480;
			
		default: return UIDeviceScreen320X480;
	}
    
}

+ (int)platformCapabilities
{
	switch ([VVDeviceUtils machineTypeInt])
	{
		case UIDevice1GiPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
		case UIDevice3GiPhone: return UIDeviceSupportsGPS | UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
		case UIDeviceUnknowniPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
            
		case UIDevice1GiPod: return 0;
		case UIDevice2GiPod: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone;
		case UIDeviceUnknowniPod: return 0;
            
		default: return 0;
	}
}



+ (NSString*)deviceWidth
{
    CGRect mainRect =  [UIScreen mainScreen].bounds;
	CGFloat scale = [UIScreen mainScreen].scale;
    int width =(int) mainRect.size.width*scale;
    NSString* strWidth = [NSString stringWithFormat:@"%d",width];
    return strWidth;
}

+ (NSString*)deviceHeight
{
    CGRect mainRect =  [UIScreen mainScreen].bounds;
	CGFloat scale = [UIScreen mainScreen].scale;
    int height =(int) mainRect.size.height*scale;
    NSString* strHeight = [NSString stringWithFormat:@"%d",height];
    return strHeight;
}


@end
