//
//  AsyncPrestartValidator.h
//  LivenessDetector
//
//  Created by Jiteng Hao on 16/1/11.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "OliveappAsyncPrestartValidatorDelegate.h"
#import "OliveappAsyncLivenessDetectorDelegate.h"
#import "OliveappPhotoImage.h"
#import "OliveappSessionManagerConfig.h"

@interface OliveappPrestartValidator : NSObject<OliveappAsyncLivenessDetectorDelegate>


- (BOOL) setConfig: (OliveappSessionManagerConfig *) config
           withDelegate: (id<OliveappAsyncPrestartValidatorDelegate>) delegate
         withError:(NSError **) error;

- (BOOL) unInit: (NSError **) error;

- (BOOL) restartSession;

- (BOOL) doDetection: (OliveappPhotoImage *) photoContent
           withError:(NSError *__autoreleasing *)error;

@end
