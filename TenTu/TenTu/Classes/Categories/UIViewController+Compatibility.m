//
//  UIViewController+Compatibility.m
//  PandaSpace
//
//  Created by zhouhong on 9/29/13.
//
//

#import "UIViewController+Compatibility.h"

#ifndef __IPHONE_7_0 

typedef NS_OPTIONS(NSUInteger, UIRectEdge) {
    UIRectEdgeNone   = 0,
    UIRectEdgeTop    = 1 << 0,
    UIRectEdgeLeft   = 1 << 1,
    UIRectEdgeBottom = 1 << 2,
    UIRectEdgeRight  = 1 << 3,
    UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
} NS_ENUM_AVAILABLE_IOS(7_0);

#endif

@implementation UIViewController (Compatibility)

- (void)setLayoutCompatibleWithLowerVersion
{
    if (CURRENT_SYSTEM_VERSION >= 7.0f) {
        
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        [self setEdgesForExtendedLayout:/*UIRectEdgeBottom | */UIRectEdgeLeft | UIRectEdgeRight];
    }
}

@end
