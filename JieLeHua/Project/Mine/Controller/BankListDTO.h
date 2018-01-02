//
//  BankListDTO.h
//  JieLeHua
//
//  Created by admin on 17/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankListDTO : NSObject

@property (nonatomic, copy) NSString *bankPersonMobile;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *bankPersonAccount;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *unenabledTime;

@property (nonatomic, assign) NSInteger customerId;

@property (nonatomic, copy) NSString *bankCode;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, assign) NSInteger isEnabled;

/**
 *  1是提现，0是还款
 */
@property (nonatomic, assign) NSInteger isDrawMoneyBankcard;

@property (nonatomic, copy) NSString *bankPersonName;

@property (nonatomic, copy) NSString *modifyTime;

@property (nonatomic, assign) NSInteger customerBankId;

@property (nonatomic, assign) long long enabledTime;

@end
