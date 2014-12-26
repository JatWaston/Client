//
//  JokeTableViewCell.h
//  FunnyVideo
//
//  Created by JatWaston on 14/12/2.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JokeTableViewCell : UITableViewCell

- (void)initCellData:(NSDictionary*)info indexPath:(NSIndexPath*)index;
- (void)registerToolBarDelegate:(id)delegate;

@end
