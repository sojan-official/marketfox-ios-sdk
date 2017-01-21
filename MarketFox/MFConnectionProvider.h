//
//  MFConnectionProvider.h
//  MarketFox
//
//  Created by user on 21/01/17.
//  Copyright © 2017 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFConnectionProvider : NSObject

+ (instancetype)instance;

- (void)postRequest:(NSString *)url parameters:(NSDictionary *)parameters success:(void(^)(id data))success failure:(void(^)(NSError *))failure;

@end
