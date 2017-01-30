//
//  MarketFoxUtil.m
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MarketFoxUtil.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIDevice.h>

@implementation MarketFoxUtil

+ (NSInteger)getTimeZoneOffset{
    return [[NSTimeZone systemTimeZone] secondsFromGMT];
}

+ (NSString *)getCorrectedLanguage{
    
    NSDictionary    *dictionary     =   [NSLocale componentsFromLocaleIdentifier:[NSLocale currentLocale].localeIdentifier];
    NSString        *languageCode   =   [dictionary objectForKey:kCFLocaleLanguageCode];
    
    if([languageCode isEqualToString:@"iw"]){
        languageCode    =   @"he";
    }
    else if([languageCode isEqualToString:@"in"]){
        languageCode    =   @"id";
    }
    else if([languageCode isEqualToString:@"ji"]){
        languageCode    =   @"yi";
    }
    else if([languageCode isEqualToString:@"zh"]){
        languageCode    =   [NSString stringWithFormat:@"%@-%@",languageCode,[dictionary objectForKey:kCFLocaleCountryCode]];
    }

    return languageCode;
}

+ (NSString *)carrierName{
    
    CTTelephonyNetworkInfo  *info   =   [CTTelephonyNetworkInfo new];
    
    return [info.subscriberCellularProvider carrierName];
}

+ (NSString *)hexadecimalStringFromData:(NSData *)data {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return hexString;
}

+ (BOOL)isDeviceVersionGreaterThanOrEqual:(NSInteger)version{
    return ([[UIDevice currentDevice].systemVersion integerValue]>=version)?YES:NO;
}

@end
