//
//  JWReportManager.h
//  FunnyVideo
//
//  Created by JatWaston on 14-12-9.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWReportManager : NSObject

+ (JWReportManager*)defaultManager;

- (void)updatePlayCountWithRecord:(NSString*)recordId contentType:(JWContentType)type;
- (void)updateLikeCountWithRecord:(NSString*)recordId contentType:(JWContentType)type;
- (void)updateUnlikeCountWithRecord:(NSString*)recordId contentType:(JWContentType)type;

@end
