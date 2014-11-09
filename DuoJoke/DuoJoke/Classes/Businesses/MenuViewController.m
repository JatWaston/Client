//
//  MenuViewController.m
//  DuoJoke
//
//  Created by JatWaston on 14-10-16.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "MenuViewController.h"
#import "REFrostedViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"

#define kDataKey @"data"
#define kNameKey @"name"
#define kCatalogKey @"catalog"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentTableView.backgroundColor = [UIColor clearColor];
    [self requestURLWithPath:kJokeListURL forceRequest:YES showHUD:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleResult:(NSDictionary *)result
{
    NSLog(@"result = %@",result);
    _items = [result valueForKey:kDataKey];
    [self.contentTableView reloadData];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    cell.textLabel.text = [info valueForKey:kNameKey];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    RootViewController *rootViewController = (RootViewController*)((AppDelegate*)[UIApplication sharedApplication].delegate).viewController;
    NSDictionary *info = [_items objectAtIndex:[indexPath row]];
    rootViewController.title = [info valueForKey:kNameKey];
    [rootViewController requestWithCatalog:[[info valueForKey:kCatalogKey] intValue]];
    [(REFrostedViewController*)self.frostedViewController hideMenuViewController];
}

@end
