//
//  MarketFox.m
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MarketFox.h"
#import "MarketFoxAPI.h"
#import "MarketFoxLocationManager.h"
#import "MarketFoxPersistance.h"
#import "MarketFoxConstants.h"
#import "MarketFoxUtil.h"

@interface MarketFox ()<MarketFoxLocationManagerDelegate>

@property   (nonatomic,assign)  double      latitude;
@property   (nonatomic,assign)  double      longitude;
@property   (nonatomic,strong)  NSString    *deviceToken;

@end

@implementation MarketFox

+ (instancetype)instance{
    static MarketFox   *marketFox =   nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        marketFox   =   [[MarketFox alloc]init];
    });
    
    return marketFox;
}

- (id)init{
    self    =   [super init];
    {
        [[MarketFoxPersistance persistanceInstance] saveObject:[self generateUniqueCustomerID] forKey:kMFCustomerID];
        
        [MarketFoxLocationManager locationManagerInstance].delegate =   self;
        
        self.latitude   =   0;
        
        self.longitude  =   0;
        
        [self addCustomerDetail];
    }
    return self;
}

- (void)addCustomerDetail{
    
    NSAssert([self getAppID], @"Configure MarketFox to post events");
    
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    
    [dictionary setObject:[self getAppID] forKey:kAppID];
    
    [dictionary setObject:[self getCustomerID] forKey:kSessionID];
    
    if(self.latitude){
        [dictionary setObject:[NSNumber numberWithDouble:self.latitude] forKey:kLocationLatitude];
    }
    
    if(self.longitude){
        [dictionary setObject:[NSNumber numberWithDouble:self.longitude] forKey:kLocationLongitude];
    }
    
    if(self.deviceToken){
        [dictionary setObject:self.deviceToken forKey:kAPNSID];
    }
    
    [dictionary setObject:[NSNumber numberWithInteger:[MarketFoxUtil getTimeZoneOffset]] forKey:kTimeZoneOffset];
    
    [dictionary setObject:[MarketFoxUtil getCorrectedLanguage] forKey:kLanguage];
    
    [dictionary setObject:[MarketFoxUtil carrierName] forKey:kCarrier];
    
    [[MarketFoxAPI apiInstance] addCustomer:dictionary success:^{
        
    } failure:^{
        
    }];
}

- (void)postEvent:(NSString *)name value:(NSString *)value{
    
    NSAssert([self getAppID], @"Configure MarketFox to post events");
    
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    
    [dictionary setObject:[self getAppID] forKey:kAppID];
    
    [dictionary setObject:[self getCustomerID] forKey:kSessionID];
    
    [dictionary setObject:name forKey:kEventName];
    
    [dictionary setObject:value forKey:kEventValue];
    
    [[MarketFoxAPI apiInstance] addEvent:dictionary success:^{
        
    } failure:^{
        
    }];
}

- (NSString *)generateUniqueCustomerID{
    NSMutableString *string =   [NSMutableString string];
    
    [string appendFormat:@"%@",[[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    
    [string appendFormat:@"%ld",lround([NSDate timeIntervalSinceReferenceDate])];
    
    return string;
}

- (NSString *)getAppID{
    return [[NSBundle mainBundle]objectForInfoDictionaryKey:kMarketFoxAppID];
}

- (NSString *)getCustomerID{
    return [[MarketFoxPersistance persistanceInstance] objectForKey:kMFCustomerID];
}

- (void)updateLocation:(double)latitude longitude:(double)longitude{
    self.latitude   =   latitude;
    self.longitude  =   longitude;
    [self addCustomerDetail];
}

- (void)updateDeviceToken:(NSData *)deviceToken{
    
    self.deviceToken    =  [MarketFoxUtil hexadecimalStringFromData:deviceToken];
    [self addCustomerDetail];
}

@end
