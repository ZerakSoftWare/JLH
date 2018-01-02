//
//  JJBaseResponseModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJBaseResponseModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) BOOL error;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *message;
@end
