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

+ (instancetype)apiInstance{
    static  MarketFoxAPI    *apiInstance  =   nil;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        apiInstance =   [[MarketFoxAPI alloc]init];
        
    });
    return  apiInstance;
}

- (void)addCustomer:(NSDictionary *)parameters success:(void(^)())sucess failure:(void(^)())failure{
    
    [[MFConnectionProvider instance] postRequest:@"customer" parameters:parameters success:^(id data) {
        
        sucess();
        
    } failure:^(NSError *error) {
        
        failure();
        
    }];
    
}

- (void)addView:(NSDictionary *)parameters success:(void(^)())sucess failure:(void(^)())failure{
    
    [[MFConnectionProvider instance] postRequest:@"push/view" parameters:parameters success:^(id data) {
        
        sucess();
        
    } failure:^(NSError *error) {
        
        failure();
        
    }];
    
}

- (void)addClick:(NSDictionary *)parameters success:(void(^)())sucess failure:(void(^)())failure{
    
    [[MFConnectionProvider instance] postRequest:@"push/click" parameters:parameters success:^(id data) {
        
        sucess();
        
    } failure:^(NSError *error) {
        
        failure();
        
    }];
    
}

- (void)addEvent:(NSDictionary *)parameters success:(void(^)())sucess failure:(void(^)())failure{
    
    [[MFConnectionProvider instance] postRequest:@"event" parameters:parameters success:^(id data) {
        
        sucess();
        
    } failure:^(NSError *error) {
        
        failure();
        
    }];
    
}



@end
