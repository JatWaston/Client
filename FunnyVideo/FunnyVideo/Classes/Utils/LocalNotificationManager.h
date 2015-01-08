//
//  LocalNotificationManager.h
//  ScheduleLocalNotification
//
//  Created by JatWaston on 15-1-8.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LocalNotificationManager : NSObject

+ (LocalNotificationManager*)defaultManager;

- (void)pushNotificationMessage:(NSString*)message
                       userInfo:(NSDictionary*)info
                       pushTime:(NSDate*)time
                       pushRate:(NSCalendarUnit)repeatInterval;
- (NSDate*)createTimeWithString:(NSString*)timeStr;

@end
