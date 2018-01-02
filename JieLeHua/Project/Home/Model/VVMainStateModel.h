//
//  VVMainStateModel.h
//  JieLeHua
//
//  Created by 维信金科 on 17/2/24.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVMainStateModel : NSObject
@property(nonatomic,copy)NSString *applyStatus; // 当天申请状态
@property(nonatomic,copy)NSString *availableMoney; // 可用额度
@property(nonatomic,copy)NSString *drawStatus; // 当天提现状态
@property(nonatomic,copy)NSString *isApplyClosed; //申请单是否关闭
@property(nonatomic,copy)NSString *isDrawClosed; //提现单当前是否关闭
@property(nonatomic,copy)NSString *lockDays; //锁单天数
@property(nonatomic,copy)NSString *lockTime; //锁单时间
@property(nonatomic,copy)NSString *overAmt; // 逾期金额
@property(nonatomic,copy)NSString *overDue; // 是否逾期
@property(nonatomic,copy)NSString *reAmt; // 当期需还金额
@property(nonatomic,copy)NSString *repayStatus; // 当天还款状态
@property(nonatomic,copy)NSString *usedMoney; // 已用额度
@property(nonatomic,copy)NSString *vbsCreditMoney; //


@end
