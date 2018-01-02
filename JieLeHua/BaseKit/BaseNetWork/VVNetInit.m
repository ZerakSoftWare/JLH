//
//  VVNetInit.m
//  O2oApp
//
//  Created by chenlei on 16/4/28.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVNetInit.h"
#import "VVMobileInitModel.h"
#import "VVVcreditInitModel.h"

@implementation VVNetInit
+(void)creditNetInitSuccess:(void (^)(BOOL result))success
                    failure:(void (^)(NSError *error))failure{

     [[VVNetWorkUtility netUtility]getCreditInitSuccess:^(id result) {
        if ([result[@"StatusCode"]integerValue] == 0)  {
            VV_SHDAT.vcreditInitModel = nil;
            VVVcreditInitModel *initModel = [VVVcreditInitModel mj_objectWithKeyValues:result];
            VV_SHDAT.vcreditInitModel = initModel;
            if (success) {
                success(YES);
            }
        }else{
            if (success) {
                success(NO);
            }
            NSString *message = result[@"StatusDescription"];
            if (VV_IS_NIL(message)) {
                message = @"征信初始化失败,请点击验证码重试";
            }
            [VLToast showWithText:message];
          
        }
        
    } failure:^(NSError *error) {
        if (success) {
            success(NO);
        }
    }];

}
+(void)mobileNetInitPhoneNum:(NSString*)phoneNum  Name:(NSString*)name IdCard:(NSString *)idCard
             success:(void (^)(BOOL result))success
             failure:(void (^)(NSError *error))failure{
    if (VV_IS_NIL(phoneNum)) {
        NSString *message = @"手机账单初始化失败,请稍后重试";
        [VLToast showWithText:message];
        if (success) {
            success(NO);
        }
        return;
    }
    VVLog(@"VV_SHDAT.creditBaseInfoModel.custName %@ id:%@" ,VV_SHDAT.creditBaseInfoModel.custName,VV_SHDAT.creditBaseInfoModel.idcard);
    NSDictionary *dic = @{@"Name":name ,
                          @"Mobile":phoneNum,
                          @"IdentityCard":idCard,
                          @"bustype":@"JIELEHUA",
                          @"busid":@""
                          };
    
    NSString *str = [dic mj_JSONString];
    NSString *base64 = [str base64EncodedString];
    VVLog(@"str:%@",str);
    [[VVNetWorkUtility netUtility]postMobileInitSoapMessage:base64 success:^(id result)
     {
         NSDictionary *rsultDic = (NSDictionary *)result;
         if ([rsultDic[@"StatusCode"]integerValue] == 0)  {
             VV_SHDAT.mobileInitModel = nil;
             VVMobileInitModel *initModel = [VVMobileInitModel mj_objectWithKeyValues:rsultDic];
             initModel.mobile = phoneNum;
             VV_SHDAT.mobileInitModel = initModel;   //初始化成功全局存储状态
             VVLog(@"VV_SHDAT.mobileInitModel:%@",[VV_SHDAT.mobileInitModel mj_JSONObject]);
             if (success) {
                 success(YES);
             }
             
         }else{
             VV_SHDAT.mobileInitModel = nil;
             
             NSString *message;
             message = result[@"StatusDescription"];
             if (VV_IS_NIL(message)) {
                 message = @"手机账单初始化失败,请稍后重试";
             }
             [VLToast showWithText:message];

             if (success) {
                 success(NO);
             }
         }
         
     } failure:^(NSError *error) {
         
         if (failure) {
             failure(error);
         }
     }];

}



@end
