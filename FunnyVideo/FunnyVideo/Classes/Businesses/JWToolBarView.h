//
//  JWToolBarView.h
//  FunnyVideo
//
//  Created by JatWaston on 14-12-9.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JWToolBarDelegate;

@interface JWToolBarView : UIView

@property (nonatomic,assign) JWContentType type;
@property (nonatomic, weak) id<JWToolBarDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)fillingData:(NSDictionary*)info indexPath:(NSIndexPath*)index;

@end

@protocol JWToolBarDelegate <NSObject>

- (void)didSelectShare:(JWToolBarView*)toolBarView;

@end
