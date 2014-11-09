//
//  SettingViewController.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-11.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "UMFeedback.h"
#import "SDImageCache.h"
#import "MobClick.h"

typedef NS_ENUM(NSInteger, UISettingFunction)
{
    //UISettingTheme = 0,
    UISettingClearCache = 0,
    //UISettingClearMode,
    //UISettingPlayTime,
    UISettingFeedback,
    //UISettingRateApp,
    UISettingCheckUpdate,
    //UISettingPaid,
    //UISettingClearHistory,
    //UISettingClearDownload,
    //UISettingClearMark,
};



@interface SettingViewController ()
{
    UITableView *_settingTableView;
    NSMutableArray *_item;
}

@property (nonatomic, strong) NSMutableArray *item;

- (void)initSettingOptions;

@end

@implementation SettingViewController
@synthesize item = _item;

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
    
    [self initSettingOptions];
    
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 200, 250, self.view.frame.size.height-50)];
    _settingTableView.scrollEnabled = NO;
    [_settingTableView setBackgroundView:nil];
    [_settingTableView setBackgroundView:[[UIView alloc] init]];
    _settingTableView.backgroundView.backgroundColor = [UIColor clearColor];
    _settingTableView.backgroundColor = [UIColor clearColor];
    _settingTableView.dataSource = self;
    _settingTableView.delegate = self;
    _settingTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_settingTableView];
}


- (void)initSettingOptions
{
    self.item = [[NSMutableArray alloc] init];
    
    //NSDictionary *theme = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_theme",kIconKey,@"主题设置",kTitleKey,@"",kDescriptionKey, nil];
    NSDictionary *clearCashe = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_clearcache",kIconKey,@"清除图片缓存",kTitleKey,[self cacheSize],kDescriptionKey, nil];
    //NSDictionary *casheMode = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_cachemode",kIconKey,@"缓存模式",kTitleKey,@"",kDescriptionKey, nil];
    //NSDictionary *playTime = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_play",kIconKey,@"播放时间",kTitleKey,@"",kDescriptionKey, nil];
    NSDictionary *feedback = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_feedback",kIconKey,@"反馈",kTitleKey,@"",kDescriptionKey, nil];
    //NSDictionary *rate = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_rate",kIconKey,@"给予评价",kTitleKey,@"",kDescriptionKey, nil];
    NSDictionary *checkUpdate = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_checkupdate",kIconKey,@"检查更新",kTitleKey,[self version],kDescriptionKey, nil];
    //NSDictionary *paid = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_upgrade",kIconKey,@"付费升级",kTitleKey,@"",kDescriptionKey, nil];
    //NSDictionary *clearBrowse = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_clearhistory",kIconKey,@"清除浏览历史",kTitleKey,@"",kDescriptionKey, nil];
    //NSDictionary *clearDownload = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_clearsaved",kIconKey,@"清除下载历史",kTitleKey,@"",kDescriptionKey, nil];
    //NSDictionary *clearMark = [NSDictionary dictionaryWithObjectsAndKeys:@"icon_setting_clearfav",kIconKey,@"清除收藏历史",kTitleKey,@"",kDescriptionKey, nil];
    
    //[self.item addObject:theme];
    [self.item addObject:clearCashe];
    //[self.item addObject:casheMode];
    //[self.item addObject:playTime];
    [self.item addObject:feedback];
    //[self.item addObject:rate];
    [self.item addObject:checkUpdate];
    //[self.item addObject:paid];
    //[self.item addObject:clearBrowse];
    //[self.item addObject:clearDownload];
    //[self.item addObject:clearMark];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark function of setting

- (void)handlePressEvent:(NSUInteger)index
{
    switch ((UISettingFunction)index)
    {
//        case UISettingTheme:
//            [self cacheSize];
//            break;
        case UISettingClearCache:
            [self clearCache];
            break;
//        case UISettingClearMode:
//            break;
//        case UISettingPlayTime:
//            break;
        case UISettingFeedback:
            [self feedback];
            break;
//        case UISettingRateApp:
//            break;
        case UISettingCheckUpdate:
            [self checkUpdate];
            break;
//        case UISettingPaid:
//            break;
//        case UISettingClearHistory:
//            break;
//        case UISettingClearDownload:
//            break;
//        case UISettingClearMark:
//            break;
        default:
            break;
    }
}

- (void)updateCacheSize
{
    if (_settingTableView)
    {
        SettingCell *cell = (SettingCell*)[_settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(int)UISettingClearCache inSection:0]];
        [cell updateDescription:[self cacheSize]];
    }
}

- (NSString*)version
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [NSString stringWithFormat:@"V %@",[infoDic valueForKey:@"CFBundleVersion"]];
}

- (NSString*)cacheSize
{
    int cacheSize = (int)[[SDImageCache sharedImageCache] getSize];
    NSLog(@"size = %d",cacheSize);
    if (cacheSize >= 1024*1024*1024.0f)
    {
        return [NSString stringWithFormat:@"%.1fG",cacheSize/(1024*1024*1024.0f)];
    }
    else if (cacheSize >= 1024*1024.0f)
    {
        return [NSString stringWithFormat:@"%.1fM",cacheSize/(1024*1024.0f)];
    }
    else if (cacheSize >= 1024.0f)
    {
        return [NSString stringWithFormat:@"%.1fK",cacheSize/1024.0f];
    }
    return [NSString stringWithFormat:@"%d Byte",cacheSize];
}

- (void)clearCache
{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        SettingCell *cell = (SettingCell*)[_settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(int)UISettingClearCache inSection:0]];
        [cell updateDescription:[self cacheSize]];
    }];
}

- (void)feedback
{
    [UMFeedback showFeedback:self withAppkey:kUmengKey];
}

- (void)checkUpdate
{
    [MobClick checkUpdate:@"新版本" cancelButtonTitle:@"忽略该版本" otherButtonTitles:@"点击下载"];
}

- (void)rateApp
{
    
}

#pragma mark -
#pragma mark UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.item count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cell";
    
    SettingCell *cell = (SettingCell*)[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil)
    {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        cell.backgroundColor = [UIColor clearColor];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    }
    NSDictionary *dic = [self.item objectAtIndex:[indexPath row]];
    [cell updateData:dic];
//    cell.textLabel.text = [dic valueForKey:kTitleKey];
    return cell;
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handlePressEvent:[indexPath row]];
    NSLog(@"");
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 155.0f;
//}

@end
