//
//  PushContentViewController.h
//  FunnyVideo
//
//  Created by JatWaston on 15-1-9.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWBaseViewController.h"

@interface PushContentViewController : JWBaseViewController

- (id)initWithNotification:(UILocalNotification*)notification;
@end
