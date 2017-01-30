//
//  MarketFoxNotificationHandler.h
//  MarketFox
//
//  Created by user on 31/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIUserNotificationSettings.h>
#import <UIKit/UIApplication.h>

#import "MarketFoxConstants.h"
#import "MarketFoxUtil.h"

@interface MarketFoxNotificationHandler : NSObject

+ (NSSet *)marketFoxCategory;
+ (BOOL)isMarketFoxNotification:(NSDictionary *)payload;

@end
