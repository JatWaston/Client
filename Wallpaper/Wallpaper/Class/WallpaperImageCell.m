//
//  WallpaperImageCell.m
//  Wallpaper
//
//  Created by JatWaston on 14-9-16.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import "WallpaperImageCell.h"
#import "UIImageView+WebCache.h"
#import "WallpaperThumbImageView.h"
#import "AppDelegate.h"
#import "UtilManager.h"

#define kImageWidth 100.0f
#define kImageHeight 150.0f //iPhone5为178
#define kImageHeight_568H 178.0f

#define kTag 100

@implementation WallpaperImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        float height = [[UtilManager shareManager] isiPhone5] ? kImageHeight_568H : kImageHeight;
        for (int i = 0; i < 3; i++)
        {
            WallpaperThumbImageView *imageView = [[WallpaperThumbImageView alloc] initWithFrame:CGRectMake(i*kImageWidth+(i+1)*5, 5, kImageWidth, height)];
//            UIColor *color = [UIColor redColor];
//            switch (i)
//            {
//                case 0:
//                    color = [UIColor redColor];
//                    break;
//                case 1:
//                    color = [UIColor greenColor];
//                    break;
//                case 2:
//                    color = [UIColor blueColor];
//                    break;
//            }
            imageView.backgroundColor = [UIColor grayColor];
            imageView.tag = kTag+i;
            [self.contentView addSubview:imageView];
        }
        
    }
    return self;
}

- (void)setImageCell:(NSArray*)imageArray cellRow:(NSUInteger)row
{
    int count = (int)[imageArray count];
    for (int i = 0; i < 3; i++)
    {
        WallpaperThumbImageView *imageView = (WallpaperThumbImageView*)[self.contentView viewWithTag:kTag+i];
        imageView.hidden = YES;
    }
    for (int i = 0; i < count; i++)
    {
        WallpaperThumbImageView *imageView = (WallpaperThumbImageView*)[self.contentView viewWithTag:kTag+i];
        imageView.downloadURL = [[imageArray objectAtIndex:i] valueForKey:@"downloadURL"];
        imageView.delegate = (id<WallpaperThumbDelegate>)(((AppDelegate*)[UIApplication sharedApplication].delegate).viewController);
        imageView.row = row;
        imageView.index = i;
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[[imageArray objectAtIndex:i] valueForKey:@"thumbURL"]];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
