//
//  JJBankListModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/21.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"
@interface JJBankListDataModel : NSObject
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankPersonAccount;
@property (nonatomic, copy) NSString *bankPersonMobile;
@property (nonatomic, copy) NSString *bankPersonName;

@end

@interface JJBankListModel : JJBaseResponseModel
@property (nonatomic, strong) NSArray <JJBankListDataModel *> *data;

@end
