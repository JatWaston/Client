//
//  JWBaseTableViewController.m
//  DuoJoke
//
//  Created by JatWaston on 14-10-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWBaseTableViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "UIViewController+REFrostedViewController.h"

static NSString *cellStr = @"cell";

@interface JWBaseTableViewController ()
{
    UITableView *_contentTableView;
    JWTableRefreshStyle _refreshStyle;
    UITableViewStyle _style;
}

@end

@implementation JWBaseTableViewController
@synthesize contentTableView = _contentTableView;

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _refreshStyle = refreshStyle;
        _items = [[NSMutableArray alloc] init];
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_style];
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    _contentTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellStr];
    switch (_refreshStyle) {
        case JWTableRefreshStyleMaskHeader:
            {
                [_contentTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
            }
            break;
        case JWTableRefreshStyleMaskFooter:
            {
                [_contentTableView addFooterWithTarget:self action:@selector(footerRereshing)];
            }
            break;
        case JWTableRefreshStyleMaskAll:
            {
                [_contentTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
                [_contentTableView addFooterWithTarget:self action:@selector(footerRereshing)];
            }
            break;
        case JWTableRefreshStyleMaskNone:
            break;
        default:
            break;
    }
    [self.view addSubview:_contentTableView];
}

- (void)headerRereshing
{
    _currentPage = 1;
    _isRefreshing = YES;
}

- (void)footerRereshing
{
    _isRequesting = YES;
    _currentPage++;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
