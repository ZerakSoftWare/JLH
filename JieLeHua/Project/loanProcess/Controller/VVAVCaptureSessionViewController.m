//
//  VVAVCaptureSessionViewController.m
//  O2oApp
//
//  Created by YuZhongqi on 16/7/11.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//  身份证拍照

#import "VVAVCaptureSessionViewController.h"
#import "UIImage+Extension.h"
#define TOOL_HEIGHT 70

@interface VVAVCaptureSessionViewController ()
{
    NSString *_imageName;
    UIView *_preView;
    UIImage *_image;
    UIImageView *_imgv;
    UIImageView *_boxView;
}
@end

@implementation VVAVCaptureSessionViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _cameraShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight-TOOL_HEIGHT-64)];
    [self.view addSubview:_cameraShowView];
    [self addBoxViewWithImageName:_imageName];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled= NO;
    
    [self confifToggleButton];
    [self configShutterButton];
    [self createCancelButton];
    [self initialSession];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)createCancelButton
{
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.frame = CGRectMake(20, vScreenHeight - TOOL_HEIGHT, 60, TOOL_HEIGHT);
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
}

//
//KKIDFront  = 1,//身份证正面
//KKIDBack   = 2,//身份证背面
//KKIDInHand = 3,//手持身份证

- (void)setPictureKind:(PictureKind)pictureKind
{
    _pictureKind = pictureKind;
    _imageName = [NSString string];
    switch (_pictureKind)
    {
        case KKIDFront:
        {
            _imageName = @"img_facade";
        }
            break;
        case KKIDBack:
        {
//            _imageName = @"img_holding";
           _imageName = @"img_obverse";
        }
            break;
        case KKIDInHand:
        {
          _imageName = @"img_holding";
        }
            break;
        default:
            break;
    }
}

- (void)addBoxViewWithImageName:(NSString *)imageName
{
    UIImage *boxImage = VV_GETIMG(imageName);
    CGFloat weight = boxImage.size.height/boxImage.size.width;
    
    _boxView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - (_cameraShowView.height-30)/weight)/2, 15,  (_cameraShowView.height-15)/weight, _cameraShowView.height-30)];
    _boxView.image = [UIImage imageNamed:imageName];
    [_cameraShowView addSubview:_boxView];
}

- (void)confifToggleButton
{
    _toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toggleButton.frame = CGRectMake(vScreenWidth - 40, 30, 30, 24);
    [_toggleButton setBackgroundImage:[UIImage imageNamed:@"icon_reversal"] forState:UIControlStateNormal];
    [_toggleButton addTarget:self action:@selector(toggleCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toggleButton];
}

- (void)configShutterButton
{
    _shutterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *photoImage = VV_GETIMG(@"btn_photo");
    _shutterButton.frame = CGRectMake(vScreenWidth/2 - photoImage.size.width/2, vScreenHeight-(TOOL_HEIGHT- photoImage.size.width)/2-photoImage.size.width, photoImage.size.width, photoImage.size.width);
    [_shutterButton setBackgroundImage:photoImage forState:UIControlStateNormal];
    _shutterButton.contentMode = UIViewContentModeCenter;
    [_shutterButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shutterButton];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSString *message = [NSString stringWithFormat:@"无法打开相机，请进入系统[设置] > [隐私] > [相机]中打开开关，并允许%@使用相机。",VV_App_Name];
        

        
        [VVAlertUtils showAlertViewWithTitle:@"打开相机" message:message customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex ==0) {
                [self customPopViewController];
            }else{
                
            }
            [alertView hideAnimated:NO];
        }];
        
        return;
        
    }
    [self setUpCameraLayer];
}

#pragma mark - 启动session

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.session)
    {
        [self.session startRunning];
    }
    
}

#pragma mark - 关闭session

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear: animated];
    self.navigationController.navigationBar.hidden = NO;

    if (self.session) {
        
        [self.session stopRunning];
        
    }
    
}

#pragma mark - 初始化session

- (void)initialSession

{
    
    //这个方法的执行我放在init方法里了
    
    self.session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device;
    if (_pictureKind == KKIDInHand)
    {
        device = [self frontCamera];
    }
    else
    {
        device = [self backCamera];
    }
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    
    //[self fronCamera]方法会返回一个AVCaptureDevice对象，因为我初始化时是采用前摄像头，所以这么写，具体的实现方法后面会介绍
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    
    
    if ([self.session canAddInput:self.videoInput]) {
        
        [self.session addInput:self.videoInput];
        
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        
        [self.session addOutput:self.stillImageOutput];
        
    }
    
}

#pragma mark - 这是获取前后摄像头对象的方法

- (AVCaptureDevice *)frontCamera {
    
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
    
}



- (AVCaptureDevice *)backCamera {
    
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
    
}


- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        
        if ([device position] == position) {
            
            return device;
            
        }
        
    }
    
    return nil;
    
}

#pragma mark - 加载预览图层的方法

- (void)setUpCameraLayer
{
    
    //    if (_cameraAvaible == NO) return;
    
    
    if (self.previewLayer == nil) {
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        UIView * view = self.cameraShowView;
        
        CALayer * viewLayer = [view layer];
        
        [viewLayer setMasksToBounds:YES];
        
        
        
        CGRect bounds = [view bounds];
        
        [self.previewLayer setFrame:bounds];
        
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        
        
        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
        
        
        
    }
    
}

#pragma mark - 切换摄像头

- (void)toggleCamera
{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    
    if (cameraCount > 1)
    {
        
        NSError *error;
        
        AVCaptureDeviceInput *newVideoInput;
        
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
        {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        }
        else if (position == AVCaptureDevicePositionFront)
        {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        }
        else
        {
            return;
        }
        
        if (newVideoInput != nil)
        {
            [self.session beginConfiguration];
            
            [self.session removeInput:self.videoInput];
            
            if ([self.session canAddInput:newVideoInput])
            {
                [self.session addInput:newVideoInput];
                
                [self setVideoInput:newVideoInput];
                
            } else
            {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        }
        else if (error)
        {
            VVLog(@"toggle carema failed, error = %@", error);
        }
    }
}

#pragma mark - 拍照

- (void)shutterCamera
{
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection)
    {
        VVLog(@"take photo failed!");
        
        return;
        
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == NULL)
        {
            
            return;
            
        }
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage * image = [UIImage imageWithData:imageData];
        [self thePhotoPreview:image];
        VVLog(@"image size = %@",NSStringFromCGSize(image.size));
        
    }];
}

#pragma mark - 照片预览

- (void)thePhotoPreview:(UIImage *)image
{
    CGFloat height = image.size.height;
    CGFloat weight = image.size.width;
    image = [self image:image byScalingToSize:CGSizeMake( kScreenWidth , kScreenWidth*(height/weight))];
    CGFloat top = 10;
    if (ISIPHONE4) {
        top =  44;
    }
    image = [self imageFromImage:image inRect:CGRectMake(_boxView.left,_boxView.top+64+top , kScreenWidth-_boxView.left*2, _cameraShowView.height-30)];

    if (_preView == nil)
    {
        _preView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, vScreenWidth, vScreenHeight-20)];
        _preView.backgroundColor = [UIColor blackColor];
        _imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, vScreenWidth,  vScreenHeight-TOOL_HEIGHT-44-20)];
        [_preView addSubview:_imgv];
        
        _imgv.layer.masksToBounds = YES;
        _imgv.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addToolBar];
    }
    

    _imgv.image = image;
    _image = image;

    [self.view addSubview:_preView];
}

//修改图片size
- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

//裁剪图片
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

- (void)addToolBar
{
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vScreenWidth, 44)];
    topBar.backgroundColor = [UIColor blackColor];
    [_preView addSubview:topBar];
    
    UIView *buttomBar = [[UIView alloc] initWithFrame:CGRectMake(0, vScreenHeight - TOOL_HEIGHT-20, vScreenWidth, TOOL_HEIGHT)];
    [_preView addSubview:buttomBar];
    buttomBar.backgroundColor = [UIColor blackColor];
    //    toolBar.alpha = 0.5;
    [self addButtonBySuperView:buttomBar];
}

- (void)addButtonBySuperView:(UIView *)superView
{
    UIButton *chongPai = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongPai setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chongPai setTitle:@"重拍" forState:UIControlStateNormal];
    chongPai.frame = CGRectMake(40, 0, 80, TOOL_HEIGHT);
    [chongPai addTarget:self action:@selector(chongPaiAction) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:chongPai];
    
    UIButton *userPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [userPhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userPhoto setTitle:@"确定" forState:UIControlStateNormal];
    userPhoto.frame = CGRectMake(vScreenWidth-120, 0, 80, TOOL_HEIGHT);
    [userPhoto addTarget:self action:@selector(usePhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:userPhoto];
}

- (void)chongPaiAction
{
    [_preView removeFromSuperview];
}


- (void)usePhotoAction
{
    if (self.pictureKind == KKIDInHand) {
        //手持等比压缩
        _image = [_image compressWithHeight:500];
    }else{
        //正反面等比压缩
        _image = [_image compressWithWidth:500];
    }
    NSData *imageData = UIImageJPEGRepresentation(_image,0.5);
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(useImageData:withPictureKind:)])
        {
            [self.delegate useImageData:imageData withPictureKind:_pictureKind];
        }
    }
    [self customPopViewController];
}

- (void)cancelAction
{
    [self customPopViewController];
}

@end
