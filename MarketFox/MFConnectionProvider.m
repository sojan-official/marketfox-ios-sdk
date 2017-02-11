//
//  MFConnectionProvider.m
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "MFConnectionProvider.h"
#import "MFConnectionProviderConstants.h"

@interface MFURLSession : NSURLSession

@end

@implementation MFURLSession

@end

@interface MFConnectionProvider ()

@end

@implementation MFConnectionProvider

+ (instancetype)instance{
    static  MFConnectionProvider    *provider=nil;
    
    static  dispatch_once_t dispatcher  =   0;
    
    dispatch_once(&dispatcher, ^{
       
        provider    =   [[MFConnectionProvider alloc]init];
        
    });
    
    return provider;
}

- (id)init{
    self    =   [super init];
    return self;
}

- (void)postRequest:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id data))success failure:(void(^)(NSError *))failure{
    
    NSMutableURLRequest *request    =   [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url relativeToURL:[NSURL URLWithString:BASE_URL]]];
    
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[self convertToJson:parameters]];

    [[[MFURLSession  sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(!error){
            if([data length]>=1){
                success([self convertToFoundationObject:data]);
            }
        }
        else{
            failure(error);
        }
        
    }] resume];
    
    
}

- (NSData *)convertToJson:(id)parameters{
    return [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
}

- (id)convertToFoundationObject:(NSData *)data{
    
    NSError *error;
    
    return [NSJSONSerialization JSONObjectWithData:data options:2 error:nil];
}

@end
