//
//  JJTipsModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/12/4.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJTipsDataModel: NSObject
@property (nonatomic, copy) NSString *dicName;
@property (nonatomic, copy) NSString *remark;

@end

@interface JJTipsModel : JJBaseResponseModel
@property (nonatomic, strong) NSArray <JJTipsDataModel *> *data;

@end
