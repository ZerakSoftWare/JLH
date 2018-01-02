//
//  ViewController.h
//  LocateCity
//
//  Created by ios3 on 14-11-11.
//  Copyright (c) 2014年 ios3. All rights reserved.
//

#import "Command.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


//returnCode 错误码
enum _SNLocateCityErrorCode {
    LocateCitySuccess = 0,    //定位成功
    LocateCityFail,           //定位失败
    LocateCityAddressFail,    //获取详细地址信息失败
    LocateCityServiceUnable,  //定位服务不可用
    LocateCityUserDenied,     //用户不允许定位
};

@interface LocateCityCommand : Command <CLLocationManagerDelegate>
{
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    
}

//responses
@property (nonatomic, assign) NSInteger     responseStatus; //定位状态
@property (nonatomic, strong) NSDictionary *addressInfoDic; //地址信息dic
@property (nonatomic, copy)   NSString     *cityName;       //城市名称 如：“南京市”
@property (nonatomic, copy)   NSString *stateName;            //城市省份 如：“江苏省”

@property (nonatomic, assign) CLLocationCoordinate2D coordinate; //当前用户坐标
@property (nonatomic, assign) CGFloat     timeOutDefault;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longtitude;

@end
