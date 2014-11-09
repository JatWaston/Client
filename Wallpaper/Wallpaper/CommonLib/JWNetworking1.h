//
//  JWNetworking.h
//  NetworkDemo
//
//  Created by JatWaston on 14-7-18.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    METHOD_GET = 0,
    METHOD_POST,
}REQUEST_TYPE;

@interface JWNetworking : NSObject
{
    NSString *_contentType;
}

@property (nonatomic, copy) void (^completeBlock)(NSData *data, NSError *error);
@property (nonatomic, copy) NSString *contentType;

- (void)requestWithURL:(NSURL*)url requestType:(REQUEST_TYPE)type dict:(NSDictionary*)dict completeHandler:(void (^)(NSData *data, NSError *error))handler;
- (void)postDataToURL:(NSURL*)url dict:(NSDictionary*)dict completeHandler:(void (^)(NSData *data, NSError *error))handler;

@end
