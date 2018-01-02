//
//  CheckUpdateCommand.h
//  JieLeHua
//
//  Created by kuang on 2017/3/8.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "Command.h"

typedef enum {
    NoUpdate = 0,           //没有更新
    MustUpdate = 1,         //强制更新
    UpdatePrompt = 2,       //不强更，提示更新
    UnKnownUpadte           //未知状态，请求错误或超时时
}CheckUpdateMode;

@interface CheckUpdateCommand : Command

@property (nonatomic, assign) CheckUpdateMode updateType;

@property (nonatomic, copy) NSString *updateUrl;

@end
