//
//  JJFourElementBankCardModel.h
//  JieLeHua
//
//  Created by YuZhongqi on 17/7/13.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"
@interface JJFourElementBankCardDataModel : NSObject
@property (nonatomic, copy) NSString *dicId;
@property (nonatomic, copy) NSString *dicCode;
@property (nonatomic, copy) NSString *dicName;
@property (nonatomic, copy) NSString *dicTypeCode;
@end

@interface JJFourElementBankCardModel : JJBaseResponseModel
@property(nonatomic,strong) NSArray<JJFourElementBankCardDataModel*> * data;
@end
