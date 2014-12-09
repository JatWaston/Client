//
//  JWVersionUpdateManager.h
//  FunnyVideo
//
//  Created by JatWaston on 14-12-5.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWVersionUpdateManager : NSObject

+ (JWVersionUpdateManager*)defaultManager;

- (void)checkVersionUpdate:(NSString*)updateURL requestComplete:(void (^)(NSData *data, NSError *error))completeHandle;
- (void)showUpdateAlertView:(NSDictionary*)messageInfo;

@end
