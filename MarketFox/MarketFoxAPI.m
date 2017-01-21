//
//  MarketFoxAPI.m
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MarketFoxAPI.h"
#import "MFConnectionProvider.h"

@implementation MarketFoxAPI

- (void)addCustomer:(NSDictionary *)parameters success:(void(^)())sucess failure:(void(^)())failure{
    
    [[MFConnectionProvider instance] postRequest:@"customer" parameters:parameters success:^(id data) {
        
        sucess();
        
    } failure:^(NSError *error) {
        
        failure();
        
    }];
    
}

@end
