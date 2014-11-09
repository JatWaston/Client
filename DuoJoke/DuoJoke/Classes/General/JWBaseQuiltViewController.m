//
//  JWBaseQuiltViewController.m
//  DuoJoke
//
//  Created by JatWaston on 14-10-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "JWBaseQuiltViewController.h"
#import "TMQuiltView.h"
#import "TMQuiltViewCell.h"
#import "UIScrollView+MJRefresh.h"

@interface JWBaseQuiltViewController () <TMQuiltViewDataSource, TMQuiltViewDelegate>
{
    NSMutableArray *_items;
    JWTableRefreshStyle _refreshStyle;
}

- (void)headerRereshing;
- (void)footerRereshing;

@end

@implementation JWBaseQuiltViewController

@synthesize quiltView = _quiltView;

- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle
{
    self = [super init];
    if (self) {
        _refreshStyle = refreshStyle;
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadView
{
    _quiltView = [[TMQuiltView alloc] initWithFrame:CGRectZero];
    _quiltView.delegate = self;
    _quiltView.dataSource = self;
    _quiltView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    switch (_refreshStyle) {
        case JWTableRefreshStyleMaskHeader:
            {
                [_quiltView addHeaderWithTarget:self action:@selector(headerRereshing)];
            }
            break;
        case JWTableRefreshStyleMaskFooter:
            {
                [_quiltView addFooterWithTarget:self action:@selector(footerRereshing)];
            }
            break;
        case JWTableRefreshStyleMaskAll:
            {
                [_quiltView addHeaderWithTarget:self action:@selector(headerRereshing)];
                [_quiltView addFooterWithTarget:self action:@selector(footerRereshing)];
            }
            break;
        case JWTableRefreshStyleMaskNone:
            break;
        default:
            break;
    }
    
    self.view = _quiltView;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.quiltView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.quiltView = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.quiltView reloadData];
}

- (void)dealloc
{
    self.quiltView = nil;
}

#pragma mark -
#pragma mark TMQuiltViewDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)quiltView
{
    return 0;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    TMQuiltViewCell *cell = [self.quiltView dequeueReusableCellWithReuseIdentifier:nil];
    if (!cell)
    {
        cell = [[TMQuiltViewCell alloc] initWithReuseIdentifier:nil];
    }
    return cell;
}

@end
