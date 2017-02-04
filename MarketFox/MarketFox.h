//
//  MarketFox.h
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MFNotificationStatus){
    MF_NOTIFICATION_RECEIVED,
    MF_NOTIFICATION_CLICKED
};

@interface MarketFox : NSObject

+ (instancetype)instance;

- (void)postEvent:(NSString *)name value:(NSString *)value;

- (void)updateDeviceToken:(NSData *)deviceToken;

- (NSSet *)configureMarketFoxNotificationCategories;

- (BOOL)isMarketFoxNotification:(NSDictionary *)userInfo;

- (void)configureEmail:(NSString *)email;

- (void)updateCustomer:(NSDictionary *)details;

- (void)updateNotificationStatus:(MFNotificationStatus)status payload:(NSDictionary *)payload;

@end
