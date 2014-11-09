//
//  JWNetworking.h
//  JWWidgetFramework
//
//  Created by JatWaston on 14-9-18.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JWRequestMethod)
{
    JWRequestMethodGet = 0,
    JWRequestMethodPost,
};

@interface JWNetworking : NSObject

- (void)requestWithURL:(NSString*)url requestMethod:(JWRequestMethod)method params:(NSDictionary*)paramsDic requestComplete:(void (^)(NSData *data, NSError *error))completeHandle;

- (void)cancelRequest;

@end
