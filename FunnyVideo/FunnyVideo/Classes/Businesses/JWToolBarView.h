//
//  JWToolBarView.h
//  FunnyVideo
//
//  Created by JatWaston on 14-12-9.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JWToolBarView : UIView

@property (nonatomic,assign) JWContentType type;

- (void)fillingData:(NSDictionary*)info;

@end

@protocol JWToolBarDelegate <NSObject>

- (void)toolView:(JWToolBarView*)toolView didSelectItem:(UIButton*)item;

@end
