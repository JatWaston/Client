//
//  ProgressImageView.h
//  Wallpaper
//
//  Created by JatWaston on 14-9-22.
//  Copyright (c) 2014年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressImageView : UIImageView

- (void)imageWithURL:(NSURL*)imageURL placeholderImage:(UIImage*)placeholder;

@end
