//
//  CatalogMenuViewController.m
//  DuoJoke
//
//  Created by JatWaston on 14-11-1.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "CatalogMenuViewController.h"
#import "JWCacheManager.h"
#import "UIButton+Bootstrap.h"
#import "RootViewController.h"
#import "REFrostedViewController.h"
#import "AppDelegate.h"
#import "MenuButton.h"

#define kScrollViewWidth 240
#define kDataKey @"data"
#define kNameKey @"name"
#define kCatalogKey @"catalog"

@interface CatalogMenuViewController()
{
    UIScrollView *_scrollView;
    NSMutableArray *_items;
    MenuButton *_selectedButton;
}

@end

@implementation CatalogMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _items = [[NSMutableArray alloc] init];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    [self loadDataFromCache];
    [self requestURLWithPath:kJokeListURL forceRequest:YES showHUD:NO];
}

- (void)loadDataFromCache
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    [JWCacheManager readDictonary:kCatalogCachePath key:kCacheRootKey dictionary:resultDic];
    [self handleResult:resultDic];
}

- (void)reloadScrollView
{
    NSArray *subviews = [_scrollView subviews];
    for (UIView *subview in subviews)
    {
        if ([subview isKindOfClass:[MenuButton class]])
        {
            [subview removeFromSuperview];
        }
    }
}


- (void)handleResult:(NSDictionary *)result
{
    NSLog(@"result = %@",result);
    if ([[result valueForKey:kDataKey] count] > 0) {
        [_items removeAllObjects];
        [_items addObjectsFromArray:[result valueForKey:kDataKey]];
        [self reloadScrollView];
        float viewWidth = _scrollView.bounds.size.width;
        int count = (int)[_items count];
        int offY = 0;
        for (int i = 0; i < count; i++) {
            NSDictionary *info = [_items objectAtIndex:i];
            MenuButton *button = [MenuButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake((viewWidth-100)/2.0f, offY, 100, 30);
            button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin; //左右距离固定，居中对齐
            [button setTitle:[info valueForKey:kNameKey] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [button translucencyStyle];
            if ([[info valueForKey:kCatalogKey] integerValue] == kDefaultCatalog) {
                _selectedButton = button;
                _selectedButton.selected = YES;
            }
            [_scrollView addSubview:button];
            offY += 40;
        }
        [_scrollView setContentSize:CGSizeMake(viewWidth, offY)];
        [JWCacheManager writeDictionaryWithContent:result name:kCatalogCachePath key:kCacheRootKey];
    }
    
}

- (void)handlePress:(id)sender
{
    MenuButton *button = (MenuButton*)sender;
    if (_selectedButton != button) {
        _selectedButton.selected = NO;
        _selectedButton = button;
        _selectedButton.selected = YES;
        RootViewController *rootViewController = (RootViewController*)((AppDelegate*)[UIApplication sharedApplication].delegate).viewController;
        NSDictionary *info = [_items objectAtIndex:button.tag];
        rootViewController.title = [info valueForKey:kNameKey];
        [rootViewController requestWithCatalog:[[info valueForKey:kCatalogKey] intValue]];
    }
    [(REFrostedViewController*)self.frostedViewController hideMenuViewController];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
