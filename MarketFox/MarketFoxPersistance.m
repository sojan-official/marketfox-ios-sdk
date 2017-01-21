//
//  MarketFoxPersistance.m
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MarketFoxPersistance.h"

@implementation MarketFoxPersistance

+ (instancetype)persistanceInstance{
    static  MarketFoxPersistance    *persistanceInstance    =   nil;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        persistanceInstance =   [[MarketFoxPersistance   alloc]init];
    });
    return persistanceInstance;
}

- (void)saveObject:(NSString *)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSString *)objectForKey:(NSString *)key{
     return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
