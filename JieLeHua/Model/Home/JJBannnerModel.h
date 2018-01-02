//
//  JJBannnerModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBaseResponseModel.h"

@interface JJBannnerDataModel : NSObject
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *pageUrl;
@end

@interface JJBannnerModel : JJBaseResponseModel
@property (nonatomic, strong)NSArray <JJBannnerDataModel *> *data;
@end
