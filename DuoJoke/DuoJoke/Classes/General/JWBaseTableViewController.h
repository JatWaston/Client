//
//  JWBaseTableViewController.h
//  DuoJoke
//
//  Created by JatWaston on 14-10-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWBaseViewController.h"

@interface JWBaseTableViewController : JWBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isRefreshing;
    BOOL _currentPage;
    NSMutableArray *_items;
}

@property (nonatomic, strong) UITableView *contentTableView;


- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle;

@end
