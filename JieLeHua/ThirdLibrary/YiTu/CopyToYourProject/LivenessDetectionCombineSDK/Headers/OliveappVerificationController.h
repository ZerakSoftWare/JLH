//
//  VerificationController.h
//  LivenessDetectionViewSDK
//
//  Created by Jiteng Hao on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OliveappAsyncLivenessDetectorDelegate.h"
#import "OliveappAsyncPrestartValidatorDelegate.h"
#import "OliveappCameraPreviewDelegate.h"
#import "OliveappPrestartValidator.h"
#import "OliveappLivenessDetector.h"
#import "OliveappViewUpdateEventDelegate.h"

@interface OliveappVerificationController: NSObject <OliveappAsyncLivenessDetectorDelegate, OliveappAsyncPrestartValidatorDelegate, OliveappCameraPreviewDelegate>

typedef NS_ENUM(NSUInteger,VerificationState) {
    // 定义步骤
    STEP_READY = 0, // 准备步骤
    STEP_PRESTART = 1, // 预检步骤
    STEP_LIVENESS = 2, // 活检步骤
    STEP_FINISH = 3 // 结束步骤
};

/**
 * 构造函数(依赖注入方式，主要用于测试). 注意: 所有参数不能为null
 * @param ViewUpdateEventDelegate 更新UI的事件响应回调
 * @param prestartValidator 预检模块实现
 * @param livenessDetector 活体检测模块实现
 */
- (BOOL) setConfigWithPrestartValidator: (OliveappPrestartValidator *) prestartValidator
                   WithLivenessDetector: (OliveappLivenessDetector *) livenessDetector
                       withViewDelegate: (id<OliveappViewUpdateEventDelegate>) viewDelegate
                              withError: (NSError **) error;


/**
 * 异步构造函数，内部会启动后台线程进行初始化, 初始化结束后会调用onInitializeSucc或onInitializeFail
 * 注意: 所有参数不能为null
 * @param ViewUpdateEventDelegate 更新UI的事件响应回调
 * @param SessionManagerConfig SessionManager的配置
 * @param mode 1表示动作间无间隔切换，2表示动作间可延迟切换
 */
- (BOOL) setConfig: (OliveappSessionManagerConfig *) config
          withMode: (int) mode
      withDelegate: (id<OliveappViewUpdateEventDelegate>)delegate
         withError: (NSError **) error;

/**
 * 进入状态机的下一个步骤。其中READY和FINISH步骤是不做任何事情的
 * READY -> PRESTART -> LIVENESS -> FINISH
 * 准备  -> 预检      -> 活检     -> 结束
 */
- (void) nextVerificationStep;

- (NSUInteger) getCurrentStep;

- (BOOL) unInit;

/*
 * 进入活检流程
 */
- (void) enterLivenessDetection;

/**
 *  手动切换到下一个动作
 */
- (void) nextAction: (NSError **) error;

// 仅供测试，请不要直接调用
- (void) onPreviewFrame:(OliveappPhotoImage *)image;

@end
