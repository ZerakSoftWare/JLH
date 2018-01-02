//
//  VVAVCaptureSessionViewController.h
//  O2oApp
//
//  Created by YuZhongqi on 16/7/11.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//图片类型
typedef NS_ENUM(NSInteger, PictureKind){
    KKIDFront  = 0,//身份证正面
    KKIDBack   = 1,//身份证背面
    KKIDInHand = 2,//手持身份证
    
};

@protocol VVAVCaptureSessionViewControllerDelegate <NSObject>

@optional
- (void)useImageData:(NSData *)imageData withPictureKind:(PictureKind)pictureKind;

@end

@interface VVAVCaptureSessionViewController : VVBaseViewController

@property (nonatomic, weak) id<VVAVCaptureSessionViewControllerDelegate>delegate;

@property (nonatomic, strong) AVCaptureSession *session;

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;

//AVCaptureDeviceInput对象是输入流

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//预览图层，来显示照相机拍摄到的画面

@property (nonatomic, strong) UIButton *toggleButton;

//切换前后镜头的按钮

@property (nonatomic, strong) UIButton *shutterButton;

//拍照按钮

@property (nonatomic, strong) UIView *cameraShowView;

//放置预览图层的View

@property (nonatomic, assign) PictureKind pictureKind;



@end
