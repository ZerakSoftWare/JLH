//
//  SessionManagerConfig.h
//  LivenessDetector
//
//  Created by Xiaoyang Lin on 16/1/12.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OliveappSessionManagerConfig : NSObject <NSMutableCopying>

typedef NS_ENUM(NSUInteger, PREDEFINED_ACTION_CONFIG) {
    ACTION_CONFIG_3_ACTION_ALL_PASS = 0, // 默认：活体检测三个动作必须全部通过
    ACTION_CONFIG_3_ACTION_ALLOW_1_FAIL = 1, // 不推荐: 活体检测三个动作允许失败1个动作
    ACTION_CONFIG_2_ACTION_ALL_PASS = 2, // 不推荐: 活体检测两个动作必须全部通过
    ACTION_CONFIG_1_ACTION_ALL_PASS = 3, // 不推荐: 只检测一个动作
    ACTION_CONFIG_FACE_CAPTURE = 4, // 正脸人像捕获
    ACTION_CONFIG_MAX_VALUE = 5, // 最大值
};

// 动作生成规则
//// 标准动作生成器
@property NSNumber * totalActions;
@property NSNumber * actionOrderSeed;

//// 使用固定动作序列
@property NSMutableArray* actionList;

// 检测通过规则
@property NSNumber * minPass;
@property NSNumber * maxFail;
@property NSNumber * timeoutMs;

- (BOOL) validate: (NSError**) error;

- (void) usePredefinedConfig: (int) solutionId;

- (NSString *) toJson;

@end
