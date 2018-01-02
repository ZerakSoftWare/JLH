//
//  JJBankCardModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJBankCardDataModel : NSObject
@property (nonatomic, copy) NSString *bankId;
@property (nonatomic, copy) NSString *fullKey;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *url;
@end

@interface JJBankCardModel : JJBaseResponseModel
@property (nonatomic, strong) NSArray <JJBankCardDataModel *> *data;
@end
