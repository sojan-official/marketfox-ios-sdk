//
//  MarketFox.m
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MarketFox.h"
#import "MarketFoxAPI.h"
#import "MarketFoxPersistance.h"
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
        [[MarketFoxPersistance persistanceInstance] saveObject:[self generateUniqueCustomerID] forKey:kMFCustomerID];
        
        [self addCustomerDetail];
    }
    return self;
}

- (void)addCustomerDetail{
    
    NSAssert([self getAppID], @"Configure MarketFox to post events");
    
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    
    [dictionary setObject:[self getAppID] forKey:kAppID];
    
    [dictionary setObject:[self getCustomerID] forKey:kSessionID];
    
    [[MarketFoxAPI apiInstance] addCustomer:dictionary success:^{
        
    } failure:^{
        
    }];
}

- (void)postEvent:(NSString *)name value:(NSString *)value{
    
    NSAssert([self getAppID], @"Configure MarketFox to post events");
    
    NSMutableDictionary *dictionary =   [NSMutableDictionary dictionary];
    
    [dictionary setObject:[self getAppID] forKey:kAppID];
    
    [dictionary setObject:[self getCustomerID] forKey:kSessionID];
    
    [dictionary setObject:name forKey:kEventName];
    
    [dictionary setObject:value forKey:kEventValue];
    
    [[MarketFoxAPI apiInstance] addEvent:dictionary success:^{
        
    } failure:^{
        
    }];
}

- (NSString *)generateUniqueCustomerID{
    NSMutableString *string =   [NSMutableString string];
    
    [string appendFormat:@"%@",[NSUUID UUID]];
    
    [string appendFormat:@"%lf",[NSDate timeIntervalSinceReferenceDate]];
    
    return string;
}

- (NSString *)getAppID{
    return [[NSBundle mainBundle]objectForInfoDictionaryKey:kMarketFoxAppID];
}

- (NSString *)getCustomerID{
    return [[MarketFoxPersistance persistanceInstance] objectForKey:kMFCustomerID];
}

@end
