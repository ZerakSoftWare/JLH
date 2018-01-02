//
//  UPGlobleData.h
//  VVlientV3
//
//  Created by wxzhao on 13-4-28.
//
//

#import <Foundation/Foundation.h>
#import "VVMobileInitModel.h"
#import "VVOrderInfoModel.h"
#import "VVVcreditInitModel.h"
#import "VVUserInfoModel.h"
#import "VVCreditBaseInfoModel.h"
#import "JJAuthenticationModel.h"
#import "JJMainStateModel.h"

@interface VVGlobleData : NSObject
{

}


@property(nonatomic,strong) UINavigationController* navi;
@property(nonatomic,copy)   NSString* deviceToken;
@property(nonatomic,copy) NSString *nextLoginUserName;//下次登录的用户
@property(nonatomic,assign) BOOL isFirstInstallApp;//第一次安装
@property (nonatomic,strong) NSDictionary *mineSalesEmployeeDic; //我的－销售信息
@property (nonatomic,strong) NSDictionary *mineAgencyDic; //我的－推荐人信息
@property(nonatomic,copy) NSString * city;
@property(nonatomic,assign) BOOL  isChatView;
@property(nonatomic,copy) NSString * headFrontUrl;

@property (nonatomic,strong) VVMobileInitModel *mobileInitModel;//／移动初始化信息
@property (nonatomic,strong) VVOrderInfoModel *orderInfo; //订单信息
@property (nonatomic,strong) VVVcreditInitModel *vcreditInitModel;//／征信初始化信息
@property (nonatomic,strong) VVUserInfoModel *userInfo; //用户信息
@property (nonatomic,strong) VVCreditBaseInfoModel *creditBaseInfoModel; //／征信用户信息
@property(nonatomic,strong) JJAuthenticationModel * authenticationModel;//身份认证

@property (nonatomic, strong) JJMainStateModel *mainStateModel;//首页状态
@property(nonatomic,strong) NSString * timestamp;
@property(nonatomic,strong) NSString * antsToken;
@property(nonatomic,strong) NSString * changeMobileNum;
+ (VVGlobleData*)sharedData;


@end
