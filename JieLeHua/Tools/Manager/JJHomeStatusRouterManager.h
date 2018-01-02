//
//  JJHomeStatusRouterManager.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/11.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJMainStateModel.h"

@interface JJHomeStatusRouterManager : NSObject
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *name;

+ (JJHomeStatusRouterManager *)homeStatusRouterManager;
- (void)dealWithStatus:(HomeStatus)status data:(JJMainStateModel *)data;
@end
