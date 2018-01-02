//
//  JJHuabeiResultViewController.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/3.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "VVBaseViewController.h"

/**
 *步骤说明http://note.youdao.com/share/?id=50dc41743c768ef4b6c8b26074649ff4&type=note#/
 *调用蚂蚁花呗步骤
 1. 获取蚂蚁花呗token，调用beginapply接口，创建订单
 2. 当获取额度后，调用AntsChantFlowersMoney，更新额度信息
 3. 异步获取蚂蚁花呗账单，获取完成后更新蚂蚁花呗账单，接口updateAntsChantBill
 PS：由于花呗token存在过期，所以处理时有更新和获取token的方便，/antsToken/{antsToken}/{customerId}更新token ,获取token:getAntsToken
 *
 **/

@interface JJHuabeiResultViewController : VVBaseViewController
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *result;
@end
