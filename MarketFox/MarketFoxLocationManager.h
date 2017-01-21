//
//  MarketFoxLocationManager.h
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MarketFoxLocationManagerDelegate <NSObject>

- (void)updateLocation:(double)latitude longitude:(double)longitude;

@end

@interface MarketFoxLocationManager : NSObject

@property   (nonatomic,strong)  id<MarketFoxLocationManagerDelegate>    delegate;

+ (instancetype)locationManagerInstance;

@end
