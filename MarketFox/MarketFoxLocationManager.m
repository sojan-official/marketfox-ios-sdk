//
//  MarketFoxLocationManager.m
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MarketFoxLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface MarketFoxLocationManager ()<CLLocationManagerDelegate>

@property   (nonatomic,strong)  CLLocationManager   *locationManager;

@end

@implementation MarketFoxLocationManager

+ (BOOL)isLocationServicesEnabled{
    return [CLLocationManager locationServicesEnabled];
}

+ (CLAuthorizationStatus)locationServicesStatus{
    return [CLLocationManager authorizationStatus];
}

+ (BOOL)canRequestLocation{
    return ([MarketFoxLocationManager locationServicesStatus]==kCLAuthorizationStatusNotDetermined)?YES:NO;
}

+ (instancetype)locationManagerInstance{
    static  MarketFoxLocationManager    *locationManager    =   nil;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager =   [[MarketFoxLocationManager alloc]init];
    });
    return locationManager;
}

- (id)init{
    self    =   [super init];
    if(self){
        
        self.locationManager    =   [CLLocationManager new];
        if([MarketFoxLocationManager canRequestLocation]){
            self.locationManager.delegate   =   self;
            self.locationManager.desiredAccuracy    =   kCLLocationAccuracyBest;
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager   startUpdatingLocation];
        }
        
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation  *location   =   locations.lastObject;
    [self.delegate  updateLocation:location.coordinate.latitude longitude:location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

@end
