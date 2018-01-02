//
//  CameraPreviewViewController.h
//  LivenessDetector
//
//  Created by Jiteng Hao on 16/1/15.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//
//  这个类可以启动摄像头并设置获取摄像头每一帧图像的回调
//

#import <AVFoundation/AVFoundation.h>
#import "OliveappCameraPreviewDelegate.h"

@interface OliveappCameraPreviewController : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

/**
 * 启动摄像头
 * @param facing 摄像头朝向
 * @param previewLayer 用于显示界面回调的view
 * 
 * @return 初始化是否成功。注意：如果初始化不成功会弹出提示框
 */
- (BOOL) startCamera: (AVCaptureDevicePosition) facing;

/**
 * 停止摄像头预览
 */
- (void) stopCamera;


/**
 *  设置preview,第二个参数请传nil，否则无法做活体检测
 *
 *  @param previewView  preview
 *  @param videoGravity 请传nil
 */
- (void) setupPreview: (UIView *) previewView
     withVideoGravity: (NSString *) videoGravity;

/**
 * 设置摄像头预览回调
 @ @param delegate 回调函数，每帧图像都会回调此函数
 */
- (void) setCameraPreviewDelegate: (id<OliveappCameraPreviewDelegate>) delegate;


@end
