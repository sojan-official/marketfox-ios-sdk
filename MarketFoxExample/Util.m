//
//  Util.m
//  MarketFox
//
//  Created by user on 31/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "Util.h"
#import <UIKit/UIDevice.h>

@implementation Util

+ (BOOL)isDeviceVersionGreaterThanOrEqual:(NSInteger)version{
    return ([[UIDevice currentDevice].systemVersion integerValue]>=version)?YES:NO;
}


@end
