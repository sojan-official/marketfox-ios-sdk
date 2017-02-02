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
#import "MarketFoxNotificationHandler.h"
#import "MarketFoxConstants.h"
#import "MarketFoxUtil.h"

@interface NSMutableDictionary (MarketFox)

- (void)skipObjectWithNullValues:(id)anObject   key:(NSString *)key;

@end

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
        [self setCustomerID];
        
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
    
    [dictionary skipObjectWithNullValues:[self getAppID] key:kAppID];
    
    [dictionary skipObjectWithNullValues:[self getCustomerID] key:kSessionID];
    
    [dictionary skipObjectWithNullValues:[NSNumber numberWithDouble:self.latitude] key:kLocationLatitude];
    
    [dictionary skipObjectWithNullValues:[NSNumber numberWithDouble:self.longitude] key:kLocationLongitude];
    
    [dictionary skipObjectWithNullValues:self.deviceToken key:kAPNSID];
    
    [dictionary skipObjectWithNullValues:[NSNumber numberWithInteger:[MarketFoxUtil getTimeZoneOffset]] key:kTimeZoneOffset];
    
    [dictionary skipObjectWithNullValues:[MarketFoxUtil getCorrectedLanguage] key:kLanguage];
    
    [dictionary skipObjectWithNullValues:[MarketFoxUtil carrierName] key:kCarrier];
    
    [[MarketFoxAPI apiInstance] addCustomer:dictionary success:^{
        
    } failure:^{
        
    }];
}

- (void)postEvent:(NSString *)name value:(NSString *)value{
    
    NSAssert([self getAppID], @"Configure MarketFox to post events");
    
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    
    [dictionary skipObjectWithNullValues:[self getAppID] key:kAppID];
    
    [dictionary skipObjectWithNullValues:[self getCustomerID] key:kSessionID];
    
    [dictionary skipObjectWithNullValues:name key:kEventName];
    
    [dictionary skipObjectWithNullValues:value key:kEventValue];
    
    [dictionary skipObjectWithNullValues:self.deviceToken key:kAPNSID];
    
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

- (void)setCustomerID{
    NSString    *uniqueCustomerID   =   [self getCustomerID];
    
    if(!uniqueCustomerID){
        uniqueCustomerID    =   [self generateUniqueCustomerID];
        [[MarketFoxPersistance persistanceInstance] saveObject:uniqueCustomerID forKey:kMFCustomerID];
    }
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

- (NSSet *)configureMarketFoxNotificationCategories{
    return [MarketFoxNotificationHandler marketFoxCategory];
}

- (BOOL)isMarketFoxNotification:(NSDictionary *)userInfo{
    return [MarketFoxNotificationHandler isMarketFoxNotification:userInfo];
}

@end

@implementation NSMutableDictionary (MarketFox)

- (void)skipObjectWithNullValues:(id)anObject   key:(NSString *)key{
    
    if(!anObject){
        return;
    }
    
    if([anObject isKindOfClass:[NSString class]]){
        NSString    *mfString   =   anObject;
        if(mfString.length<=0){
            return;
        }
    }
    [self setObject:anObject forKey:key];
}

@end
