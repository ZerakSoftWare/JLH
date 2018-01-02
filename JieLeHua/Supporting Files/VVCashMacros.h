//
//  VVCashMacros.h
//  O2oApp
//
//  Created by YuZhongqi on 16/4/11.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#ifndef VVCashMacros_h
#define VVCashMacros_h

#define kUM_PushAppKey @"58bf958ef29d98230c0015de"

#if DEBUG
#define kUM_ClickAppKey @"58e4efe18630f5635f000378"
#else
#define kUM_ClickAppKey @"58bf958ef29d98230c0015de"
#endif

//===========初始化活体使用参数,接入方请换成自己的========
#define TPL                                         @"frfsd_ai"
#define APPKEY                                      @"e44f341e821d24904a18fa21620371c3b00c6c5b"
//===============================================
static NSString* const  sp_no = @"1300253110";//请将此sp_no换成您在磐石申请的sp_no
static NSString* const  api_key = @"e44f341e821d24904a18fa21620371c3b00c6c5b";//请将此apikey换成您在磐石申请的



#define kAppKey @"1462171128068307#jlh-ios"
#define kCustomerName @"huahua1"

#define kCustomerNickname @"借乐花用户"
#define kCustomerTenantId @"49809"

#define kCustomerProjectId @"2304958"

#define hxPassWord @"123456"


#define NSEaseLocalizedString(key, comment) [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"HelpDeskUIResource" withExtension:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]


//#define weakSelf __weak typeof(self) selfWeak = self;

#define vAppWindow      [UIApplication sharedApplication].keyWindow
#define vScreenHeight   [UIScreen mainScreen].bounds.size.height
#define vScreenWidth    [UIScreen mainScreen].bounds.size.width
#define vStatusBarHeight    [UIApplication sharedApplication].statusBarFrame.size.height
#define vTaBbarHeight 44
//定义颜色的宏
#define VVWhiteColor [UIColor whiteColor]
#define VVclearColor [UIColor clearColor]
#define VVBASE_COLOR [UIColor colorWithHexString:@"fbb13d"]
#define VVBASE_OLD_COLOR [UIColor globalThemeColor]

#define VVColor666666 [UIColor colorWithHexString:@"666666"]
#define VVColor999999 [UIColor colorWithHexString:@"999999"]
#define VVColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define VVColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define  VVRandomColor VVColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
//分割线颜色
#define VVSeparateColor VV_COL_RGB(0xdddddd)
//App全局颜色
#define VVAppButtonTitleColor [UIColor colorWithHexString:@"fbb13d"]
//#define VVOrangeColor [UIColor colorWithHexString:@"EC5F2B"]
//#define VVOrangeHeightLightColor [UIColor colorWithHexString:@"CD5123"]
#define VVAppButtonTitleHeightLightColor [UIColor colorWithHexString:@"095EB2"]
#define VVcornerRadius  5
//App背景灰色
#define VVAppBackGroundGrayColor  VVColor(241, 241, 241)
//btn左边距
#define VVleftMargin 24
#define VVBtnHeight 44

//型号判断
#define ISIPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define ISIPHONE6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)

#define ISIPAD  [VVUtils isiPad]
/* 正则表达式 */

//正则表达式
#define VV_REGEXP(X,REG)  [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REG] evaluateWithObject:X]
/* 正则表达式 */

//注册用户名验证的邮箱正则
#define kRegisterEmailPredicate @"(?=.{0,64})\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
//注册用户名验证的手机号正则
#define kRegisterPhoneNumberPredicate @"^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$"
//注册用户名验证的自定义用户名正则
#define kRegisterCustomNamePredicate @"^\\w*[a-zA-Z_]+\\w*$"
//登录用户名验证的自定义用户名正则
#define kLoginCustomNamePredicate @"([\\w\\d]{6,20})"
//信用卡 号 校验
#define kCreditCardPredicate @"\\d{13,19}"
// 信用卡 卡号 输入时 校验0-19位数字
#define kCreditCardInputPredicate @"[0-9]{0,19}"
// 信用卡 有效期校验
#define kCreditCardValidity @"[0-9]{4}"
// 信用卡 cvn2 校验
#define kCreditCardCVN2Predicate @"[0-9]{3}"
// 信用卡密码 校验
#define kCredicCardPasswordPredicate @"[0-9]{6}"

// 短信验证码 校验
#define kSMSCodePredicate @"[0-9]{6}"


// 数字 金额 校验 @"^[0-9]+(.|.[0-9]{1,2})?$"
#define kAmountPredicate @"^[0-9]+(\\.|\\.[0-9]{1,2})?$"
#define kAmountPredicateOnlyPoint @"(\\.|\\e.[0-9]{1,2})?$"

// 安全问题及答案
#define kSecurityQuestionPredicate @"[^!$%\\^&*?<>]{2,16}"

// 全为数字
#define kAllCharacterIsNumber @"\\d*"

// 密码全为字母
#define kAllCharacterIsLetter @"[a-zA-Z]*"

// 用户真实姓名
#define kRealNamePredicate @"[^!$%\\^&*?<>]{2,10}"

// 用户地址
#define kAddressPredicate @"[^!$%\\^&*?<>]*"

// 邮政编码
#define kPostcodePredicate @"\\d{6}"

// 图片验证码 4位数字校验
#define kImageCodePredicate @"[0-9]{0,4}"

// 手机号 输入时 校验0-11位数字
#define kMobleNumInputPredicate @"[0-9]{0,11}"

#define ValidPhoneNumberLength 11

// 信用卡 卡号分割
#define kSeperatorCreditCardNumber @"4"
// 手机号 分割
#define kSeperatorMobileNumber @"3,4"
// 通用号码校验
#define kTelAndPhoneNumber      @"^[0-9*#,;+-]+$"

/* 定义一般Toast宽高 */
#define kCommonToastSize CGSizeMake(120, 40)


#define kCommonTextFieldEditingRectLeftMargin 8
#define kCommonTextFieldEditingRectRightMargin 0

#define MobPassWordLength 10//手机密码长度
#define MobSMSLength 10 //手机sms长度

/* 定义导航栏和Application的高宽 */
#define  kNavigationBarHeight              44
#define  kStatusBarHeight                  20

#define  kScreenWidth             ([UIScreen mainScreen].bounds.size.width)
#define  kScreenHeight            ([UIScreen mainScreen].bounds.size.height - kStatusBarHeight)

#define  kLayoutTabbarHeight    49
#define  kLayoutTabbarItemWidth  80
#define  kLayoutTabbarItemHeight  34
#define  kLayoutTabbarFrame   CGRectMake(0,0,kScreenWidth,kLayoutTabbarHeight)

#define  kLayoutKeyboardHeight  216

//导航栏左侧按钮左边距
#define kNavigationLeftButtonMargin 6
//导航栏右侧按钮右边距
#define kNavigationRightButtonMargin 6
// 定义 分享界面 的宽度
#define kShareViewWidth 290


#define kBuddyListPageCellHeight 53.0f
#define kPublicListPageCellHeight 64.0f
#define kBuddyListPageCellWidth 245.0f
#define kBuddyListPageCellWithRightBtnWidth 197.0f
#define kBuddyListPageTopShadowHeight 2.0f

#define kNewFriendPageCellHeight 60.0f

/* 导航栏，右上角 按钮 右边距和 右上角 方形按钮大小 */
#define kVVNavLeftBtnLeftEdge      8
#define kVVNavRightBtnRightEdge    8
#define kVVNavRightBtnSize     CGSizeMake(48, 28)

#define ktextFieldLeft 20
#define ktextFieldheight 46

//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#endif /* VVCashMacros_h */
