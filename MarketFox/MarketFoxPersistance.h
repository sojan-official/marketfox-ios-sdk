//
//  MarketFoxPersistance.h
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketFoxPersistance : NSObject

+ (instancetype)persistanceInstance;

- (void)saveObject:(NSString *)value forKey:(NSString *)key;

- (NSString *)objectForKey:(NSString *)key;

@end
