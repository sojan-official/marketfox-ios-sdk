//
//  MarketFoxAPI.h
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketFoxAPI : NSObject

- (void)addCustomer:(NSDictionary *)parameters success:(void(^)())sucess failure:(void(^)())failure;

@end
