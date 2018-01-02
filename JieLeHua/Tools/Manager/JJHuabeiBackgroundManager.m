//
//  JJHuabeiBackgroundManager.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJHuabeiBackgroundManager.h"
#import "JJCommerceModel.h"

@interface JJHuabeiBackgroundManager ()
//花呗额度数值信息
@property (nonatomic, strong) JJCommerceResultModel *commerceResultModel;
@end

@implementation JJHuabeiBackgroundManager
+ (JJHuabeiBackgroundManager *)huabeiBackgroundManager
{
    static dispatch_once_t onceToken;
    static JJHuabeiBackgroundManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

//查询蚂蚁花呗额度
- (void)getSummaryWithToken:(NSString *)token
{
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] summaryWithToken:token success:^(id result) {
        VVLog(@"%@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJCommerceModel *commercrModel = [JJCommerceModel mj_objectWithKeyValues:result];
        if (commercrModel.StatusCode == 0) {
            strongSelf.commerceResultModel = commercrModel.Result;
            if (commercrModel.Result.E_commercelimit > 0) {
                [strongSelf updateAntsChantBill];
            }
        }else{
            [strongSelf getSummaryWithToken:token];
        }
    } failure:^(NSError *error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getSummaryWithToken:token];
    }];
}

//异步获取蚂蚁花呗账单，获取完成后更新蚂蚁花呗账单，接口updateAntsChantBill
- (void)updateAntsChantBill
{
    UserModel *userModel = [UserModel currentUser];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] applyAntsChantBillWithParam:@{@"antsChantFlowersMoney":[NSString stringWithFormat:@"%.f",self.commerceResultModel.E_commercelimit],@"commercelimitIn3Use":self.commerceResultModel.E_commercelimit_In3_use,@"commercelimitIsoverdue":self.commerceResultModel.E_commercelimit_Isoverdue,@"customerId":userModel.customerId} success:^(id result) {
        VVLog(@"%@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[result safeObjectForKey:@"success"] integerValue ] == 1) {
            
        }else{
            //失败后继续请求
            [strongSelf updateAntsChantBill];
        }
        
    } failure:^(NSError *error) {
        //失败后继续请求
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateAntsChantBill];
    }];
}

@end
