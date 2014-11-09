//
//  RootViewController.h
//  DuoJoke
//
//  Created by JatWaston on 14-10-14.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMQuiltViewController.h"
#import "JWBaseQuiltViewController.h"

@interface RootViewController : JWBaseQuiltViewController

- (void)requestWithCatalog:(NSUInteger)catalog;

@end
