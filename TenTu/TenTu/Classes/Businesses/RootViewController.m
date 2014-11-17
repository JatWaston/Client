//
//  RootViewController.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "RootViewController.h"
#import "UIImageView+WebCache.h"
#import "JWImageTableViewCell.h"

@implementation RootViewController


- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"今日十图";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_home"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentTableView.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self requestURLWithPath:kDailyContentURL forceRequest:YES showHUD:YES];
}

- (void)handleResult:(NSDictionary *)result
{
    NSLog(@"result = %@",result);
    if ([[result valueForKey:kCode] integerValue] == 0)
    {
        [_items removeAllObjects];
        [_items addObjectsFromArray:[result valueForKey:kData]];
        [self.contentTableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"Cell";
    JWImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[JWImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    if (info) {
        [cell initCellData:info];
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
