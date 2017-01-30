//
//  MarketFox.h
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketFox : NSObject

+ (instancetype)instance;

- (void)postEvent:(NSString *)name value:(NSString *)value;

- (void)updateDeviceToken:(NSData *)deviceToken;

- (NSSet *)configureMarketFoxNotificationCategories;

- (BOOL)isMarketFoxNotification:(NSDictionary *)userInfo;

@end
