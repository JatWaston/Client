//
//  JWPhotoBrowserViewController.h
//  图片浏览器示例
//
//  Created by JatWaston on 14-10-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWPhotoBrowserDelegate <NSObject>

- (void)photoBrowserDidEndZoomIn;

@end


@interface JWPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic) NSUInteger currentPhotoIndex;
@property (nonatomic, weak) id<JWPhotoBrowserDelegate> delegate;

- (void)showBrowser;

@end


