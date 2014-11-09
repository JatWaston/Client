//
//  JWBaseQuiltViewController.h
//  DuoJoke
//
//  Created by JatWaston on 14-10-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWBaseViewController.h"

@class TMQuiltView;

@interface JWBaseQuiltViewController : JWBaseViewController
{
    BOOL _isRefreshing;
    int _currentPage;
}

@property (nonatomic, retain) TMQuiltView *quiltView;
@property (nonatomic, strong) NSMutableArray *items;

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle;

- (void)headerRereshing;
- (void)footerRereshing;

@end
