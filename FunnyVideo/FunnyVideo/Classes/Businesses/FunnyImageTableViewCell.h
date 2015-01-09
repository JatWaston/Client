//
//  FunnyImageTableViewCell.h
//  FunnyVideo
//
//  Created by JatWaston on 14/12/22.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunnyImageTableViewCell : UITableViewCell

- (void)initCellData:(NSDictionary*)info indexPath:(NSIndexPath*)index;
- (void)registerToolBarDelegate:(id)delegate;

- (UIImage*)funnyImage;

@end
