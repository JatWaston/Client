//
//  SettingViewController.m
//  TenTu
//
//  Created by JatWaston on 14-11-16.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "SettingViewController.h"
#import "UMFeedback.h"
#import "SDImageCache.h"

@interface SettingViewController()

- (void)shareToFriends;
- (void)clearCache;
- (void)feedback;
- (void)checkVersionUpdate;
- (void)rateForApp;

@end

@implementation SettingViewController


- (id)initWithRefreshStyle:(JWTableRefreshStyle)refreshStyle tableViewStyle:(UITableViewStyle)style;
{
    self = [super initWithRefreshStyle:refreshStyle tableViewStyle:style];
    if (self) {
        self.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_setting"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *section0 = [NSArray arrayWithObjects:@"分享给朋友", nil];
    NSArray *section1 = [NSArray arrayWithObjects:@"清除缓存",@"反馈问题",@"检查更新", nil];
    NSArray *section2 = [NSArray arrayWithObjects:@"给我评分", nil];
    [_items addObject:section0];
    [_items addObject:section1];
    [_items addObject:section2];
    [self.contentTableView reloadData];
}

- (void)shareToFriends
{
    NSLog(@"%s",__func__);
}

- (void)clearCache
{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
}

- (void)feedback
{
    NSLog(@"%s",__func__);
    [UMFeedback showFeedback:self withAppkey:kUmengKey];
}

- (void)checkVersionUpdate
{
    NSLog(@"%s",__func__);
}

- (void)rateForApp
{
    NSLog(@"%s",__func__);
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"sections = %d",[_items count]);
    return [_items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_items objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellStr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = [[_items objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                    [self shareToFriends];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch ([indexPath row]) {
                case 0:
                    [self clearCache];
                    break;
                case 1:
                    [self feedback];
                    break;
                case 2:
                    [self checkVersionUpdate];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ([indexPath row]) {
                case 0:
                    [self rateForApp];
                default:
                    break;
            }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
