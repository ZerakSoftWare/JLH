//
//  ViewController.h
//  LocateCity
//
//  Created by ios3 on 14-11-11.
//  Copyright (c) 2014年 ios3. All rights reserved.
//

#import "LocateCityCommand.h"

@implementation LocateCityCommand 

- (void)cancel
{
    [self stopUpdatingLocation];
    manager.delegate = nil;
    
    [geocoder cancelGeocode];
    
    [super cancel];
}

- (void)setTimeOutDefault:(CGFloat)timeOutDefault {
    _timeOutDefault = timeOutDefault;
}

- (void)execute
{
    if (![CLLocationManager locationServicesEnabled])
    {
        self.responseStatus = LocateCityServiceUnable;

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示"
                                                        message:@"位置服务不可用，您可以进入设置开启位置服务"
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        [alert show];

        [self done];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        self.responseStatus = LocateCityUserDenied;

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示"
                                                        message:@"位置服务不可用，您可以进入设置开启位置服务"
                                                       delegate:nil
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        [alert show];

        [self done];
    }
    else
    {
        [self startUpdatingLocation];
    }
}

- (void)startUpdatingLocation
{
    if (!manager)
    {
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        
        // fix ios8 location issue
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
            
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [manager performSelector:@selector(requestWhenInUseAuthorization)];//用这个方法，plist里要加字段NSLocationWhenInUseUsageDescription
            }
#endif
        }
    }
    
    [manager startUpdatingLocation];
    //time out
    [self performSelector:@selector(stopUpdatingLocation)
               withObject:nil
               afterDelay:self.timeOutDefault > 0 ? self.timeOutDefault : 60.0f];
}

- (void)stopUpdatingLocation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stopUpdatingLocation)
                                               object:nil];
    [manager stopUpdatingLocation];
}

#pragma mark -
#pragma mark delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.coordinate = newLocation.coordinate;
    
    [self stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    CLLocation *newLocation = locations.lastObject;
    
    [self stopUpdatingLocation];
    
    self.coordinate = newLocation.coordinate;
    
    if (!geocoder)
    {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (error && ![placemarks count])
         {
             self.responseStatus = LocateCityAddressFail;
         }
         else
         {
             // 保存 Device 的现语言 (英语 法语 ，，，)
             NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                                     objectForKey:@"AppleLanguages"];

             [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                                       forKey:@"AppleLanguages"];
             
             for(CLPlacemark *placemark in placemarks)
             {
                 self.addressInfoDic = placemark.addressDictionary;
                 NSString *currentCity = [placemark.addressDictionary objectForKey:@"City"];
                 NSString *state = [placemark.addressDictionary objectForKey:@"State"];

                 if (!state.length)
                 {
                     self.cityName = [placemark.addressDictionary objectForKey:@"City"];
                     self.stateName = self.cityName;
                 }
                 else
                 {
                     self.cityName = currentCity;
                     self.stateName = [placemark.addressDictionary objectForKey:@"State"];
                 }
                 
                 
                 break;
             }
             
             // 还原Device 的语言
             [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
         }
         
         [self done];
     }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopUpdatingLocation];
    
    self.responseStatus = LocateCityFail;
    [self done];
}

@end
