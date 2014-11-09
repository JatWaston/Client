//
//  CatalogViewController.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-11.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "CatalogViewController.h"
#import "JWNetworking.h"
#import "UIViewController+Compatibility.h"
#import "WallpaperTypeButton.h"
#import "UIButton+Bootstrap.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "JWCacheManager.h"
#import "UtilManager.h"



#define kScrollViewWidth 240

#define kGiftLineColor [UIColor colorWithRed:0xef/255.0 green:0x3d/255.0 blue:0x3d/255.0 alpha:1.0]



@interface CatalogViewController ()
{
    JWNetworking *netWork;
    UIScrollView *_scrollView;
    WallpaperTypeButton *_selectButton;
    NSMutableDictionary *_catalogDic;
}

@end

@implementation CatalogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self setLayoutCompatibleWithLowerVersion];

    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScrollViewWidth, self.view.bounds.size.height)];
    _scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_scrollView];
    
    [self loadDataFromCache];
    
    netWork = [[JWNetworking alloc] init];
    NSString *requestURL = [[UtilManager shareManager] additionlParamURL:kWallpaperCatalogURL];
    [netWork requestWithURL:requestURL requestMethod:JWRequestMethodGet params:nil requestComplete:^(NSData *data, NSError *error) {
        if (error)
        {
            NSLog(@"error=%@",[error localizedDescription]);
        }
        else
        {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            [JWCacheManager writeDictionaryWithContent:result name:kCatalogCachePath key:kCacheRootKey];
            [self reloadScrollView];
            [self initCatalog:result];
        }
    }];
}

- (void)reloadScrollView
{
    NSArray *subviews = [_scrollView subviews];
    for (UIView *subview in subviews)
    {
        if ([subview isKindOfClass:[WallpaperTypeButton class]])
        {
            [subview removeFromSuperview];
        }
        else if ([subview isKindOfClass:[UILabel class]] && subview.tag == 200)
        {
            [subview removeFromSuperview];
        }
        else if (subview.tag == 100)
        {
            [subview removeFromSuperview];
        }
    }
}

- (void)loadDataFromCache
{
    _catalogDic = [[NSMutableDictionary alloc] init];
    [JWCacheManager readDictonary:kCatalogCachePath key:kCacheRootKey dictionary:_catalogDic];
    [self initCatalog:_catalogDic];
}

- (void)initCatalog:(NSDictionary*)catalogInfo
{
    //NSLog(@"result = %@",catalogInfo);
    
    float offY = 25.0f;
    if ([[catalogInfo valueForKey:kCode] integerValue] == 0)
    {
        NSArray *dataArray = [catalogInfo valueForKey:kData];
        int count = (int)[dataArray count];
        
        for (int i = 0; i < count; i++)
        {
            NSDictionary *dic = [dataArray objectAtIndex:i];
            NSArray *listArray = [dic valueForKey:kListKey];
            if (!listArray || [listArray count] == 0)
            {
                continue;
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(2, offY, 3, 25)];
            lineView.tag = 100;
            lineView.backgroundColor = kGiftLineColor;
            [_scrollView addSubview:lineView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,offY+2, self.view.frame.size.width, 20)];
            label.tag = 200;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.text = [dic valueForKey:kName];
            [_scrollView addSubview:label];
            
//            offY += 25;
            
            int listCount = (int)[listArray count];
            int num = 1;
            for (int j = 0; j < listCount; j++)
            {
                float offX = 10;
                if (num%2 == 1)
                {
                    offY += 40;
                }
                else
                {
                    offX = 120;
                }
                
                NSDictionary *listDic = [listArray objectAtIndex:j];
                WallpaperTypeButton *button = [WallpaperTypeButton buttonWithType:UIButtonTypeCustom];
                button.catalog = [[dic valueForKey:kCatalogKey] integerValue];
                button.type = [[listDic valueForKey:kType] integerValue];
                if (button.catalog == 100 && button.type == 101)
                {
                    _selectButton = button;
                    _selectButton.selected = YES;
                }
                [button addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(offX, offY, 100, 30);
                [button setTitle:[listDic valueForKey:kName] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                [button translucencyStyle];
                [_scrollView addSubview:button];
                num++;
            }
            
            offY += 50;
        }
    }
    
    _scrollView.contentSize = CGSizeMake(kScrollViewWidth, MAX(offY+10, self.view.frame.size.height));
}

- (void)handlePress:(id)sender
{
    WallpaperTypeButton *button = (WallpaperTypeButton*)sender;
    if (_selectButton)
    {
        _selectButton.selected = NO;
    }
    _selectButton = button;
    button.selected = YES;
    RootViewController *rootViewController = ((AppDelegate*)[UIApplication sharedApplication].delegate).viewController;
    RESideMenu *sideMenu = ((AppDelegate*)[UIApplication sharedApplication].delegate).sideMenuViewController;
    rootViewController.title = button.titleLabel.text;
    [rootViewController requestDataWithCatalog:button.catalog type:button.type];
    [sideMenu hideMenuViewController];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
