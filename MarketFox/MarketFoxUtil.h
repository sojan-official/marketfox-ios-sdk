//
//  MarketFoxUtil.h
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketFoxUtil : NSObject

+ (NSInteger)getTimeZoneOffset;

+ (NSString *)getCorrectedLanguage;

+ (NSString *)carrierName;

+ (NSString *)hexadecimalStringFromData:(NSData *)data;

+ (BOOL)isDeviceVersionGreaterThanOrEqual:(NSInteger)version;

+ (BOOL)isValidEmail:(NSString *)email;

@end
