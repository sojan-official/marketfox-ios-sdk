//
//  MarketFoxNotificationHandler.m
//  MarketFox
//
//  Created by user on 31/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MarketFoxNotificationHandler.h"

@implementation MarketFoxNotificationHandler

+ (UNNotificationCategory *)categoryForNotificationExtension{
    
    UNNotificationCategory  *category   =   [UNNotificationCategory categoryWithIdentifier:kMarketFoxCategoryIdentifier actions:nil intentIdentifiers:nil options:UNNotificationCategoryOptionNone];
    return category;
}
                                             
+ (UIUserNotificationCategory *)categoryForNonNotificationExtension{
    UIMutableUserNotificationCategory  *category   =   [[UIMutableUserNotificationCategory alloc]init];
    category.identifier =   kMarketFoxCategoryIdentifier;
    return category;
}

+ (NSSet *)marketFoxCategory{

    if([MarketFoxUtil isDeviceVersionGreaterThanOrEqual:10]){
        return [MarketFoxNotificationHandler categoryForNotificationExtension];
    }
    return [MarketFoxNotificationHandler categoryForNonNotificationExtension];
}

+ (BOOL)isMarketFoxNotification:(NSDictionary *)payload{
    NSString    *category   =   payload[@"aps"][@"category"];
    return [category isEqualToString:kMarketFoxCategoryIdentifier];
}

@end
