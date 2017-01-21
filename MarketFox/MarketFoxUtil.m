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

@end
