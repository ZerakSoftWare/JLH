//
//  UPDebug.h
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-21.
//
//

#if DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

#if DEBUG

#define     APP_BASE_URL  @"http://10.155.50.51:5080/api/jlh"
#define     CREDIT_BASE_URL  @"https://jlhtest.vcash.cn/credit"
#define     MOBILE_BASE_URL  @"https://jlhtest.vcash.cn"
//#define     APP_BASE_URL  @"http://jlhtest.vcash.cn/api/jlh"
//#define     CREDIT_BASE_URL  @"http://jlhtest.vcash.cn/credit"
//#define     MOBILE_BASE_URL  @"http://jlhtest.vcash.cn"
//#define     WEB_BASE_URL     @"https://jlhpredeploy.vcash.cn/webapp"
#define     WEB_BASE_URL     @"http://jlhtest.vcash.cn/webapp"

//花呗
#define APP_HUABEI_URL @"http://jlhtest.vcash.cn/emall/crawler/alipay"
#define APP_HUABEI_QUERY_URL @"http://jlhtest.vcash.cn/emall/query/alipay"
#define APP_HUABEI_BASE_URL @"http://jlhtest.vcash.cn/emall"
////放款中+清贷
#define App_Loan_Url @"http://jlhtest.vcash.cn/api/jlh"
////芝麻授信
#define APP_ZHIMA_URL @"https://jielehua.vcash.cn"

//#define     APP_BASE_URL  @"https://jlhpredeploy.vcash.cn/api/jlh"
//#define     CREDIT_BASE_URL  @"https://jlhpredeploy.vcash.cn/credit"
//#define     MOBILE_BASE_URL  @"https://jlhpredeploy.vcash.cn"
//#define     WEB_BASE_URL     @"https://jlhpredeploy.vcash.cn/webapp"
//
////花呗
//#define APP_HUABEI_URL @"https://jlhpredeploy.vcash.cn/emall/crawler/alipay"
//#define APP_HUABEI_QUERY_URL @"https://jlhpredeploy.vcash.cn/emall/query/alipay"
//#define APP_HUABEI_BASE_URL @"https://jlhpredeploy.vcash.cn/emall"
//////放款中+清贷
//#define App_Loan_Url @"https://jlhpredeploy.vcash.cn/api/jlh"
//////芝麻授信
//#define APP_ZHIMA_URL @"https://jielehua.vcash.cn"

#else

#define     APP_BASE_URL     @"https://jielehua.vcash.cn/api/jlh"
#define     CREDIT_BASE_URL  @"https://jielehua.vcash.cn/credit"
#define     MOBILE_BASE_URL  @"https://jielehua.vcash.cn"
#define     WEB_BASE_URL     @"https://jielehua.vcash.cn/webapp3"

//花呗
#define APP_HUABEI_URL @"https://jielehua.vcash.cn/emall/crawler/alipay"
#define APP_HUABEI_QUERY_URL @"https://jielehua.vcash.cn/emall/query/alipay"
#define APP_HUABEI_BASE_URL @"https://jielehua.vcash.cn/emall"
//放款中+清贷
#define App_Loan_Url @"https://jielehua.vcash.cn/api/jlh"
//芝麻授信
#define APP_ZHIMA_URL @"https://jielehua.vcash.cn"

#endif
 

#define API_Version @"v2"
#define     AES_PASSWORD        @"!VVc0REDIT@O2OAPP"


#define VVLogERROR(xx, ...)  DDLogError(xx, ##__VA_ARGS__)

#define VVLogWARNING(xx, ...)  DDLogWarn(xx, ##__VA_ARGS__)

#define VVLogNETMSG(xx, ...)   DDLogInfo(xx, ##__VA_ARGS__)

#define VVLog(xx, ...)   DDLogDebug(xx, ##__VA_ARGS__)

#define VVLogVerbose(xx, ...)   DDLogVerbose(xx, ##__VA_ARGS__)

#define VVLogSTART()  DDLogVerbose(@"<<< %s",__PRETTY_FUNCTION__);

#define VVLogEND()   DDLogVerbose(@">>> %s",__PRETTY_FUNCTION__);


#define VV_STR(X) [VVUtils localizedStringWithKey:X]

#define VV_ARRAY(X) (NSArray*)[VVUtils localizedArrayWithKey:X]


//从UI提示语配置文件中取得版本
#define VV_VERCONFIG VV_STR(@"LocalPlist_Version")

#define VV_COL_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define VV_COL_INT_RGB(r,g,b) [UIColor colorWithRed:((float)r)/255.0 green:((float)g)/255.0 blue:((float)b)/255.0 alpha:1.0]

#define VV_COL_STR(X)  [VVUtils colorWithHexString:X]
 
#define VV_FILEEXIST(X) [[NSFileManager defaultManager] fileExistsAtPath:X]
// 判断string是否为00, 00表示JSON数据正常；
#define VV_RESPOK(X) ([X intValue] == kNetRespOkValue)

#define VV_ISRETINA [VVUtils isRetina]

#define VV_SHDAT    [VVGlobleData sharedData]

#define VV_CGSizeScale(size, scale) CGSizeMake(size.width * scale, size.height * scale)

#define VV_CGRectScale(rect, scale) CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale)


#define VV_GETIMG(X) [VVUtils getImage:X]

#define VV_NC [NSNotificationCenter defaultCenter]

#define VV_USERDEFAULT  [NSUserDefaults standardUserDefaults]

#define VV_IOS_VERSION [VVUtils deviceOS]

#define VV_PROPERTY(X) [VVUtils propertyArray:X]

// 判断string是否为空 nil 或者 @"" 或者 @""；
#define VV_IS_NIL(X)  [VVUtils isEmpty:X]

#define VV_URL(X)  [VVUtils urlWithString:X]


#define VV_App ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define VV_NAV VV_SHDAT.navi

#define VV_App_Name [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

#define UPFloat(f) [VVUtils sizeFloat:f]

//打开URL
#define VV_CANOPENURL(appScheme) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]])
#define VV_OPENURL(appScheme) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:appScheme]])

#define VV_OBJATIDX(ARRAY,INDEX) (ARRAY&&(INDEX>=0)&&(INDEX<[ARRAY count]))?ARRAY[INDEX]:nil

//FMDB
#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }
#define NoWarningPerformSelector(target, action, object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
[target performSelector:action withObject:object]; \
_Pragma("clang diagnostic pop") \
