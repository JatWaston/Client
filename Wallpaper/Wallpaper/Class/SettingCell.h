//
//  SettingCell.h
//  Wallpaper
//
//  Created by JatWaston on 14-9-21.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

- (void)updateData:(NSDictionary*)dic;
- (void)updateDescription:(NSString*)description;

@end
