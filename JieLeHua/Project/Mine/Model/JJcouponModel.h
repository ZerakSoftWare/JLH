//
//  JJcouponModel.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"
@interface JJcouponDataModel:NSObject
@property(nonatomic,copy) NSString * voucherType;//1, --优惠券种类 1 提额券 2 优惠券
@property(nonatomic,copy) NSString * voucherStatus;// 0, 0 未使用 1 已使用 2 过期
@property(nonatomic,copy) NSString* voucherId; //提额券ID
@property(nonatomic,assign) long int voucherValidityTime;//1511939569000, --有效期
@property(nonatomic,copy) NSString * customerId;//468985,
@property(nonatomic,copy) NSString * voucherCreateTime;//1511939561000
@property(nonatomic,copy) NSString * voucherCredit;//"300",  --提额金额
@property(nonatomic,copy) NSString * voucherRemark;//"额度提现时可抵扣平台推荐费，连续主动还款3期可用" --备注
@end

@interface JJcouponModel : JJBaseResponseModel
@property(nonatomic,strong) NSArray <JJcouponDataModel*> *data ;
@end


