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
        [MarketFoxLocationManager locationManagerInstance].delegate =   self;
        
        self.latitude   =   0;
        
        self.longitude  =   0;
    }
    return self;
}

- (void)startSession{
    [self setCustomerID];
}

- (void)addCustomerDetail{
    
    NSAssert([self getAppID], @"Configure MarketFox to post events");
    
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    
    [dictionary skipObjectWithNullValues:[self getAppID] key:kAppID];
    
    [dictionary skipObjectWithNullValues:[self getCustomerID] key:kSessionID];
    
    [dictionary skipObjectWithNullValues:[self getEmail] key:kEmailID];
    
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
    return [NSSet setWithObject:[MarketFoxNotificationHandler marketFoxCategory]];
}

- (BOOL)isMarketFoxNotification:(NSDictionary *)userInfo{
    return [MarketFoxNotificationHandler isMarketFoxNotification:userInfo];
}

- (void)configureEmail:(NSString *)email{
        
    if(![MarketFoxUtil isValidEmail:email]){
        return;
    }
    
    NSString *emailString    =   [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(emailString){
        emailString =   [emailString lowercaseString];
    }
    
    [[MarketFoxPersistance persistanceInstance]  saveObject:emailString forKey:kMFCustomerEmail];
}

- (NSString *)getEmail{
    return [[MarketFoxPersistance persistanceInstance] objectForKey:kMFCustomerEmail];
}

- (void)updateCustomer:(NSDictionary *)details{
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    NSString    *userConfiguredEmail    =   [details objectForKey:kEmailOnUpdateCustomer];
    
    if(userConfiguredEmail){
        [self configureEmail:userConfiguredEmail];
    }
    
    [dictionary skipObjectWithNullValues:[self getEmail] key:kMFCustomerEmail];
    [dictionary skipObjectWithNullValues:[self getAppID] key:kAppID];
    [dictionary skipObjectWithNullValues:[self getCustomerID] key:kSessionID];
    [dictionary skipObjectWithNullValues:self.deviceToken key:kAPNSID];
    [dictionary skipObjectWithNullValues:details key:kCustomer];
    
    [[MarketFoxAPI apiInstance] addCustomer:dictionary success:^{
        
    } failure:^{
        
    }];
}

- (void)updateNotificationStatus:(MFNotificationStatus)status payload:(NSDictionary *)payload{

    NSString    *campaignId =   payload[@"campaign_id"];
    
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    
    [dictionary skipObjectWithNullValues:[self getAppID] key:kAppID];
    [dictionary skipObjectWithNullValues:[self getCustomerID] key:kSessionID];
    [dictionary skipObjectWithNullValues:self.deviceToken key:kAPNSID];
    [dictionary skipObjectWithNullValues:[NSNumber numberWithBool:true] key:kNotificationOpened];
    [dictionary skipObjectWithNullValues:campaignId key:kCampaignID];
    
    if(status==MF_NOTIFICATION_RECEIVED){
        [[MarketFoxAPI apiInstance] addView:dictionary success:^{
            
        } failure:^{
            
        }];
    }
    else if(status==MF_NOTIFICATION_CLICKED){
        [[MarketFoxAPI apiInstance] addClick:dictionary success:^{
            
        } failure:^{
            
        }];
        
        [self handleDeepLinking:payload];
    }
}

- (void)handleDeepLinking:(NSDictionary *)payload{
    NSString    *string =   payload[@"url"];
    if(!string)
        return;
    NSURL   *deepLinkUrl    =   [NSURL URLWithString:string];
    
    if([MarketFoxUtil isDeviceVersionGreaterThanOrEqual:10]){
        [[UIApplication sharedApplication] openURL:deepLinkUrl options:@{} completionHandler:nil];
    }
    else{
        if([[UIApplication sharedApplication] canOpenURL:deepLinkUrl])
        {
            [[UIApplication sharedApplication] openURL:deepLinkUrl];
        }
    }
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
    else if([anObject isKindOfClass:[NSDictionary class]]){
        NSDictionary    *mfDictionary   =   anObject;
        if([[mfDictionary allKeys] count]<=0){
            return;
        }
    }
    [self setObject:anObject forKey:key];
}

@end
