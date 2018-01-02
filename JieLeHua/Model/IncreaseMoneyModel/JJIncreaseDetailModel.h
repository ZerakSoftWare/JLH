//
//  JJIncreaseDetailModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/8/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJIncreaseDetailStatusModel : NSObject
@property (nonatomic, copy) NSString *gongjijinComment;
@property (nonatomic, assign) int antsChantFlowersCreditStatus;
@property (nonatomic, assign) int gongjijinCreditStatus;
@end

@interface JJIncreaseDetailModel : NSObject
@property (nonatomic, strong) JJIncreaseDetailStatusModel *improveCreditStatus;
@end
