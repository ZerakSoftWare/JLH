//
//  DetectedFrame.h
//  LivenessDetector
//
//  Created by Jiteng Hao on 16/1/18.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OliveappDetectedFrame : NSObject

@property (strong) NSData* frameData; // 默认为nil
@property (strong) NSData* verificationData; // 比对数据包(包含一张图. 约30KB)
@property (strong) NSData* verificationDataFull; // 比对数据包(包含三张图，可以用于做交叉比对. 约100KB)
@property (strong) NSData* verificationDataFullWithFanpai;

- (id) initWithFrameData: (NSData*) frameData
    withVerificationData: (NSData*) verificationData
withVerificationDataFull: (NSData*) verificationDataFull
withVerificationDataWithFanpai: (NSData*) verificationDataFullWithFanpai;

@end
