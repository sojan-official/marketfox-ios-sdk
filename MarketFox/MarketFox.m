//
//  MarketFox.m
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MarketFox.h"
#import "MarketFoxAPI.h"
#import "MarketFoxConstants.h"

@implementation MarketFox

+ (instancetype)instance{
    static MarketFox   *marketFox =   nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        marketFox   =   [[MarketFox alloc]init];
    });
    
    return marketFox;
}

- (id)init{
    self    =   [super init];
    {
        [self addCustomerDetail];
    }
    return self;
}

- (void)addCustomerDetail{
    
    MarketFoxAPI *api   =   [MarketFoxAPI new];
    
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    
    [dictionary setObject:MARKET_FOX_APP_ID forKey:@"app_id"];
    
    [dictionary setObject:[self customerUniqueId] forKey:@"user_session_key"];
    
    [api addCustomer:dictionary success:^{
        
    } failure:^{
        
    }];
    
}

- (NSString *)customerUniqueId{
    NSMutableString *string =   [NSMutableString string];
    
    [string appendFormat:@"%@",[NSUUID UUID]];
    
    [string appendFormat:@"%lf",[NSDate timeIntervalSinceReferenceDate]];
    
    return string;
}

@end
