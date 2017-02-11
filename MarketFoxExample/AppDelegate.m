//
//  AppDelegate.m
//  MarketFoxExample
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UserNotifications/UserNotifications.h>
#import "Util.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[MarketFox instance]startSession];
    [[MarketFox instance] configureEmail:@"test@gmail.com"];
    [self registerForPushNotification];
    [[MarketFox instance] postEvent:@"app_open" value:@"1"];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[MarketFox instance] updateDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
}

- (void)registerForPushNotification{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    if([Util isDeviceVersionGreaterThanOrEqual:10]){
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
           
            [UNUserNotificationCenter currentNotificationCenter].delegate   =   (AppDelegate *)[UIApplication sharedApplication].delegate;
        }];
    }
    else{
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:[[MarketFox instance] configureMarketFoxNotificationCategories]]];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary    *userInfo   =   response.notification.request.content.userInfo;

    if([response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]){
        if([[MarketFox instance] isMarketFoxNotification:userInfo]){
            [[MarketFox instance] updateNotificationStatus:MF_NOTIFICATION_CLICKED payload:userInfo];
        }
    }
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSDictionary    *userInfo   =   notification.request.content.userInfo;
    if([[MarketFox instance] isMarketFoxNotification:userInfo]){
        completionHandler(UNNotificationPresentationOptionAlert);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    UIApplicationState  applicationState    =   [UIApplication sharedApplication].applicationState;
    
    if(applicationState==UIApplicationStateInactive){
        if([[MarketFox instance] isMarketFoxNotification:userInfo]){
            [[MarketFox instance] updateNotificationStatus:MF_NOTIFICATION_CLICKED payload:userInfo];
        }
    }
    
    completionHandler(UIBackgroundFetchResultNoData);
}

@end
