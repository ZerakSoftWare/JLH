//
//  UPGlobleData.m
//  VVlientV3
//
//  Created by wxzhao on 13-4-28.
//
//

#import "VVGlobleData.h"

#define kMsgContentFontSize @"MsgContentFontSize"
#define KEarPieceMode       @"EarPieceMode"
#define kUPNextLoginUserInfo     @"VVNextLoginUserInfo"


@implementation VVGlobleData

//@synthesize userInfo = _userInfo;
@synthesize nextLoginUserName = _nextLoginUserName;


+ (VVGlobleData*)sharedData
{
    static VVGlobleData* sharedData = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedData = [[self alloc] init];
        
    });
    
    return sharedData;
}


- (id)init
{
    self = [super init];
    if (self) {
        _mineAgencyDic = [[NSMutableDictionary alloc]initWithCapacity:0];
        _mineSalesEmployeeDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return self;
}

- (void)setNextLoginUserName:(NSString *)nextLoginUserName{
    [VV_USERDEFAULT setObject:nextLoginUserName forKey:@"nextLoginUserName"];
    [VV_USERDEFAULT synchronize];
}

- (NSString*)nextLoginUserName{
    NSString *usernextName =  [VV_USERDEFAULT objectForKey:@"nextLoginUserName"];
    return usernextName;
}



- (BOOL)isFirstInstallApp
{
    BOOL isFirst;
    NSNumber* obj =  [VV_USERDEFAULT objectForKey:@"isFirstInstallApp"];
    if (obj) {
        isFirst = [obj boolValue];
    }
    else{
        isFirst = NO;
    }
    return isFirst;
}

- (void)setIsFirstInstallApp:(BOOL)isFirstInstallApp
{
    NSNumber* obj = [NSNumber numberWithBool:isFirstInstallApp];
    [VV_USERDEFAULT setObject:obj forKey:@"isFirstInstallApp"];
    [VV_USERDEFAULT synchronize];
}


@end
