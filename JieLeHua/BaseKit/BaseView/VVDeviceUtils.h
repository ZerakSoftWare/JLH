//
//  VVDeviceUtils.h
//  VVlientV3
//
//  Created by Cao Kevin on 13-5-21.
//  Copyright 2013年 UinionPay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IPHONE_1G_NAMESTRING @"iPhone 1G"
#define IPHONE_3G_NAMESTRING @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING @"iPhone 3GS"
#define IPHONE_4G_NAMESTRING @"iPhone 4"
#define IPHONE_4GS_NAMESTRING @"iPhone 4S"
#define IPHONE_5_NAMESTRING @"iPhone 5"
#define IPHONE_5_SIMULATOR_NAMESTRING @"iPhone 5 Simulator"
#define SIMULATOR_NAMESTRING @"Simulator"
#define IPHONE_UNKNOWN_NAMESTRING @"Unknown iPhone"
#define IPOD_1G_NAMESTRING @"iPod touch 1G"
#define IPOD_2G_NAMESTRING @"iPod touch 2G"
#define IPOD_3G_NAMESTRING @"iPod touch 4"
#define IPOD_UNKNOWN_NAMESTRING @"Unknown iPod"
#define IPAD_1G_NAMESTRING @"iPad 1"
#define IPAD_2G_NAMESTRING @"iPad 2"
#define IPAD_UNKNOWN_NAMESTRING @"Unknown iPad"

typedef enum {
	UIDeviceUnknown,
	UIDevice1GiPhone,
	UIDevice1GiPod,
	UIDevice1GiPad,
	UIDevice3GiPhone,
	UIDevice2GiPod,
	UIDevice2GiPad,
	UIDevice3GSiPhone,
	UIDevice3GiPod,
	UIDevice4GiPhone,
	UIDevice4GSiPhone,
    
    UIDevice5iPhone,
    UIDeviceSimulator,
    UIDeviceiPhone5Simulator,
    
	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPad,
	UIDeviceUnknowniPod
} UIDevicePlatform;

enum  {
	UIDeviceScreen320X480,
	UIDeviceScreen640X960,
	UIDeviceScreen768X1024
};

enum {
	UIDeviceSupportsGPS	= 1 << 0,
	UIDeviceBuiltInSpeaker = 1 << 1,
	UIDeviceBuiltInCamera = 1 << 2,
	UIDeviceBuiltInMicrophone = 1 << 3,
	UIDeviceSupportsExternalMicrophone = 1 << 4,
	UIDeviceSupportsTelephony = 1 << 5,
	UIDeviceSupportsVibration = 1 << 6
};



@interface VVDeviceUtils : NSObject {
   
}

// macaddress已失效! 在iOS7中所有的机器返回02:00:00:00:00:00
// Return a string description of the UUID, such as "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
//获得的ID在删除app重装后会改变.
+ (NSString*)vendorIdentifier;

//iPhone OS
+ (NSString*)deviceOS;
//4.3.3
+ (NSString*)deviceOSVersion;

+ (NSString*)deviceName;

//iPhone
+ (NSString*)deviceModel;

+ (NSString*)machineType;
+ (NSString*)machineTypeMap;
+ (int)machineTypeInt;
+ (void)setIsIphone5Simulator:(BOOL) isOrNot;
+ (CGSize)deviceScreenBound;

+ (NSString*)machineTypeString;
+ (int)deviceResolution;
+ (int)platformCapabilities;

+ (NSString*)deviceWidth;
+ (NSString*)deviceHeight;

@end
