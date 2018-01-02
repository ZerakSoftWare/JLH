//
//  AsyncLivenessDetectorDelegate.h
//  LivenessDetector
//
//  Created by Xiaoyang Lin on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OliveappDetectedFrame.h"

@protocol OliveappAsyncLivenessDetectorDelegate <NSObject>

@required
/**
 * 通知活体检测成功
 * 在LivenessDetector的delegate中调用，在处理图片的线程队列中调用
 * @param livenessDetectionFrames
 */
- (void) onLivenessSuccess: (OliveappDetectedFrame*) detectedFrame;

/**
 * 通知活体检测失败，告知失败原因
 * 在LivenessDetector的delegate中调用，在处理图片的线程队列中调用
 * @param result
 * @param livenessDetectionFrames
 */
- (void) onLivenessFail: (int) sessionState
      withDetectedFrame: (OliveappDetectedFrame*) detectedFrame;

/**
 * 通知活体检测动作切换
 * 在LivenessDetector的delegate中调用，在处理图片的线程队列中调用
 * @param lastActionType
 * @param lastActionResult
 * @param newActionType
 * @param currentActionIndex
 */
- (void) onActionChanged: (int)lastActionType
    withLastActionResult: (int)lastActionResult
       withNewActionType: (int)newActionType
  withCurrentActionIndex: (int)currentActionIndex;

/**
 * 通知每帧处理完毕后活体检测session的情况
 * 在LivenessDetector的delegate中调用，在处理图片的线程队列中调用
 * @param currentActionType
 * @param actionState
 * @param sessionState
 * @param remainingTimeoutMilliSecond
 */
- (void) onFrameDetected: (int)currentActionType
         withActionState: (int)actionState
        withSessionState: (int)sessionState
    withRemainingTimeoutMilliSecond: (int)remainingTimeoutMilliSecond;

@end
