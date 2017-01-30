//
//  NotificationService.m
//  MarketFoxNotificationExtension
//
//  Created by user on 31/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "NotificationService.h"
#import <Foundation/NSURLSession.h>
#import <Foundation/NSFileManager.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSString    *categoryIdentifier =   self.bestAttemptContent.categoryIdentifier;
    
    BOOL    isMarketFoxNotification =  [categoryIdentifier isEqualToString:@"MARKETFOXNOTIFICATION"];
    
    if(isMarketFoxNotification){
        
        NSString    *attachmentString   =   self.bestAttemptContent.userInfo[@"attachment-url"];
        
        if(attachmentString){
            NSURL   *attachmentUrl  =   [NSURL URLWithString:attachmentString];
            
            [[[NSURLSession sharedSession] downloadTaskWithURL:attachmentUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                NSString    *tmpDirectory  =   NSTemporaryDirectory();
                
                NSString   *tmpFile  =  [NSString stringWithFormat:@"file://%@%@",tmpDirectory,[attachmentUrl lastPathComponent]];
                
                NSURL   *tmpUrl =   [NSURL URLWithString:tmpFile];
                
                [[NSFileManager   defaultManager] moveItemAtURL:location toURL:tmpUrl error:nil];
                
                UNNotificationAttachment    *attachment =   [UNNotificationAttachment attachmentWithIdentifier:@"" URL:tmpUrl options:nil error:nil];
                
                self.bestAttemptContent.attachments =  @[attachment];
                
                self.contentHandler(self.bestAttemptContent);
                
            }] resume];
        }
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
