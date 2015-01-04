//
//  JWBaseTableViewController.h
//  DuoJoke
//
//  Created by JatWaston on 14-10-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWBaseViewController.h"
#import "UIScrollView+MJRefresh.h"

@interface JWBaseTableViewController : JWBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isRefreshing;
    int _currentPage;
    NSMutableArray *_items;
}

@property (nonatomic, strong) UITableView *contentTableView;


- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;

- (void)headerRereshing;
- (void)footerRereshing;
- (void)refresh;

@end
