//
//  LivenessDetector.h
//  LivenessDetector
//
//  Created by Xiaoyang Lin on 16/1/7.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OliveappAsyncLivenessDetectorDelegate.h"
#import "OliveappPhotoImage.h"
#import "OliveappSessionManagerConfig.h"
#import "OliveappImageForVerifyConf.h"

@interface OliveappLivenessDetector : NSObject


/**
 *  生成操作对象
 *
 *  @return LivenessDetector对象
 */
- (id) init;

/**
 *  初始化
 *
 *  @param config    活体检测模块的配置，使用默认参数的话请传nil
 *  @param delegate  活体检测回调
 *  @param imgConfig 设置从preview图片中截取人脸框的位置, 使用默认参数的话
 *  @param error     错误信息
 *  设置动作切换模式，1是普通模式，2是手动模式
 *  @return 初始化是否成功
 */
- (BOOL) setConfig: (OliveappSessionManagerConfig *) config
         withMode: (int) mode
        withDelegate: (id<OliveappAsyncLivenessDetectorDelegate>) delegate
    withImageConfig: (OliveappImageForVerifyConf *) imgConfig
            withError: (NSError **) error;

/**
 *  析构函数
 *
 *  @param error 错误信息
 *
 *  @return 是否成功
 */
- (BOOL) unInit: (NSError **) error;

/**
 *  重置活体检测模块
 *
 *  @param error 错误信息
 *
 *  @return 是否成功
 */
- (BOOL) restartSession: (NSError **) error;

/**
 *  传入一帧图片进行活体检测，非阻塞
 *
 *  @param photoContent 传入的照片类
 *  @param error        错误信息
 *
 *  @return 是否传入成功，如果后台处理帧数太多将会丢弃
 */
- (BOOL) doDetection: (OliveappPhotoImage *) photoContent
           withError: (NSError **) error;

/**
 *  手动切换到下一个动作
 */
- (void) nextAction: (NSError **) error;

@end
