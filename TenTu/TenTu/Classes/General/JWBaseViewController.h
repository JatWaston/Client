//
//  JWBaseViewController.h
//  DuoJoke
//
//  Created by JatWaston on 14-10-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JWTableRefreshStyle)
{
    JWTableRefreshStyleMaskNone = 0,
    JWTableRefreshStyleMaskHeader,
    JWTableRefreshStyleMaskFooter,
    JWTableRefreshStyleMaskAll,
};

@interface JWBaseViewController : UIViewController
{
    BOOL _isRequesting;
}

- (id)initWithRequestURL:(NSString*)requestURL;
- (id)initWithRequestURL:(NSString*)requestURL cachePath:(NSString*)cachePath;

- (void)requestURLWithPath:(NSString*)urlPath forceRequest:(BOOL)isForce showHUD:(BOOL)show;
- (void)handleResult:(NSDictionary*)result;

@end
