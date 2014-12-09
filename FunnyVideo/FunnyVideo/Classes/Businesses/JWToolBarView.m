//
//  JWToolBarView.m
//  FunnyVideo
//
//  Created by JatWaston on 14-12-9.
//  Copyright (c) 2014年 JatWaston. All rights reserved.
//

#import "JWToolBarView.h"
#import "FMDatabase.h"

typedef NS_ENUM(NSUInteger,JWToolButtonTag) {
    JWToolButtonLike = 1, //喜欢
    JWToolButtonUnlike,   //不喜欢
};

static FMDatabase *_db = nil;


@interface JWToolBarView () {
    UIButton *_likeBtn;
    UIButton *_unlikeBtn;
    UIButton *_shareBtn;
}

@property (nonatomic, strong) NSString *infoID;
@property (nonatomic) NSUInteger likeCount;
@property (nonatomic) NSUInteger unlikeCount;

@end

@implementation JWToolBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        if (_db == nil) {
            NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"record.db"];
            _db = [FMDatabase databaseWithPath:dbPath];
            if (![_db open])
            {
                NSLog(@"Could not open db.");
            }
        }
        
        UIImage *like_unpress = [UIImage imageNamed:@"icon_like_unpressed"];
        UIImage *like_press = [UIImage imageNamed:@"icon_like_pressed"];
        UIImage *like_disabled = [UIImage imageNamed:@"icon_like_disabled"];
        
        UIImage *unlike_unpress = [UIImage imageNamed:@"icon_unlike_unpressed"];
        UIImage *unlike_press = [UIImage imageNamed:@"icon_unlike_pressed"];
        UIImage *unlike_disabled = [UIImage imageNamed:@"icon_unlike_disabled"];
        
        //UIImage *shareImage = [UIImage imageNamed:@"icon_more"];
        
        self.backgroundColor = [UIColor clearColor];
        
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //likeBtn.backgroundColor = [UIColor skyBlueColor];
        //likeBtn.frame = CGRectMake(10, heightOffset, 80, 30);
        _likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_likeBtn setImage:like_unpress forState:UIControlStateNormal];
        [_likeBtn setImage:like_press forState:UIControlStateHighlighted];
        [_likeBtn setImage:like_press forState:UIControlStateSelected];
        [_likeBtn setImage:like_disabled forState:UIControlStateDisabled];
        //likeBtn.titleLabel.font = font;
        [_likeBtn setTitleColor:kToolButtonTitleColor forState:UIControlStateNormal];
        [_likeBtn setTitleColor:kToolButtonTitleSelectedColor forState:UIControlStateHighlighted];
        [_likeBtn setTitleColor:kToolButtonTitleDisableColor forState:UIControlStateDisabled];
        [_likeBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.tag = JWToolButtonLike;
        //[_likeBtn setTitle:@"1000" forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = kToolButtonFont;
        [self addSubview:_likeBtn];
        
        _unlikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //unlikeBtn.backgroundColor = [UIColor skyBlueColor];
        //unlikeBtn.frame = CGRectMake(100, heightOffset, 80, 30);
        _unlikeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _unlikeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_unlikeBtn setImage:unlike_unpress forState:UIControlStateNormal];
        [_unlikeBtn setImage:unlike_press forState:UIControlStateHighlighted];
        [_unlikeBtn setImage:unlike_press forState:UIControlStateSelected];
        [_unlikeBtn setImage:unlike_disabled forState:UIControlStateDisabled];
        _unlikeBtn.titleLabel.font = kToolButtonFont;
        [_unlikeBtn setTitleColor:kToolButtonTitleColor forState:UIControlStateNormal];
        [_unlikeBtn setTitleColor:kToolButtonTitleSelectedColor forState:UIControlStateHighlighted];
        [_unlikeBtn setTitleColor:kToolButtonTitleDisableColor forState:UIControlStateDisabled];
        //[_unlikeBtn setTitle:@"1000" forState:UIControlStateNormal];
        _unlikeBtn.tag = JWToolButtonUnlike;
        [_unlikeBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_unlikeBtn];
        
//        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        //shareBtn.backgroundColor = [UIColor skyBlueColor];
//        //shareBtn.frame = CGRectMake(220, heightOffset, 80, 30);
//        _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        [_shareBtn setImage:shareImage forState:UIControlStateNormal];
//        _shareBtn.titleLabel.font = kToolButtonFont;
//        [_shareBtn setTitleColor:kToolButtonTitleColor forState:UIControlStateNormal];
//        [_shareBtn setTitleColor:kToolButtonTitleColor forState:UIControlStateNormal];
//        //[_shareBtn setTitle:@"1000" forState:UIControlStateNormal];
//        [self addSubview:_shareBtn];
        
        _likeBtn.frame = CGRectMake(30, 0, 80, 30);
        _unlikeBtn.frame = CGRectMake(200, 0, 80, 30);
        //_shareBtn.frame = CGRectMake(220, 0, 80, 30);
    }
    return self;
}

- (void)pressBtn:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSString *sql = @"";
    NSString *title = @"";
    switch (button.tag) {
        case JWToolButtonUnlike:
        {
            _likeBtn.enabled = NO;
            _unlikeBtn.selected = YES;
            self.unlikeCount = [_unlikeBtn.titleLabel.text integerValue]+1;
            title = [NSString stringWithFormat:@"%d",(int)[_unlikeBtn.titleLabel.text integerValue]+1];
            [_unlikeBtn setTitle:title forState:UIControlStateSelected];
            //_unlikeBtn.titleLabel.text = title;
            sql = [NSString stringWithFormat:@"INSERT INTO recordList (id,likeCount,like,unlikeCount,unlike) VALUES ('%@',%d,'0',%d,'1')",self.infoID,(int)self.likeCount,(int)self.unlikeCount];
        }
            break;
        case JWToolButtonLike:
        {
            _unlikeBtn.enabled = NO;
            _likeBtn.selected = YES;
            self.likeCount = [_likeBtn.titleLabel.text integerValue]+1;
            title = [NSString stringWithFormat:@"%d",(int)[_likeBtn.titleLabel.text integerValue]+1];
            [_likeBtn setTitle:title forState:UIControlStateSelected];
            //_likeBtn.titleLabel.text = title;
            sql = [NSString stringWithFormat:@"INSERT INTO recordList (id,likeCount,like,unlikeCount,unlike) VALUES ('%@',%d,'1',%d,'0')",self.infoID,(int)self.likeCount,(int)self.unlikeCount];
        }
            break;
        default:
            break;
    }
    [_db executeUpdate:sql];
}

- (void)fillingData:(NSDictionary*)info {
    self.infoID = [info valueForKey:@"id"];
    self.likeCount = (NSUInteger)[[info valueForKey:@"likeCount"] integerValue];
    self.unlikeCount = (NSUInteger)[[info valueForKey:@"unlikeCount"] integerValue];
    
    _likeBtn.enabled = YES;
    _likeBtn.selected = NO;
    _unlikeBtn.enabled = YES;
    _unlikeBtn.selected = NO;
    [_likeBtn setTitle:[info valueForKey:@"likeCount"] forState:UIControlStateNormal];
    [_likeBtn setTitle:[info valueForKey:@"likeCount"] forState:UIControlStateSelected];
    [_likeBtn setTitle:[info valueForKey:@"likeCount"] forState:UIControlStateDisabled];
    _likeBtn.titleLabel.text = [info valueForKey:@"likeCount"];
    [_unlikeBtn setTitle:[info valueForKey:@"unlikeCount"] forState:UIControlStateNormal];
    [_unlikeBtn setTitle:[info valueForKey:@"unlikeCount"] forState:UIControlStateSelected];
    [_unlikeBtn setTitle:[info valueForKey:@"unlikeCount"] forState:UIControlStateDisabled];
    _unlikeBtn.titleLabel.text = [info valueForKey:@"unlikeCount"];
    //[_shareBtn setTitle:[info valueForKey:@"shareCount"] forState:UIControlStateNormal];
    [self initlizeButtonState:info];
}

- (void)initlizeButtonState:(NSDictionary*)info  {
    NSString *infoid = [info valueForKey:@"id"];
    NSUInteger __likeCount = (NSUInteger)[[info valueForKey:@"likeCount"] integerValue];
    NSUInteger __unlikeCount = (NSUInteger)[[info valueForKey:@"unlikeCount"] integerValue];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM recordList WHERE id = '%@'",infoid];
    FMResultSet *rs = [_db executeQuery:sql];
    if ([rs next]) {
        if ([[rs stringForColumn:@"like"] integerValue] == 1) {
            _unlikeBtn.enabled = NO;
            _likeBtn.selected = YES;
            int maxLikeCount = [rs intForColumn:@"likeCount"] > (int)(__likeCount) ? [rs intForColumn:@"likeCount"] : (int)(__likeCount);
            NSString *title = [NSString stringWithFormat:@"%d",maxLikeCount];
            [_likeBtn setTitle:title forState:UIControlStateSelected];
        } else if ([[rs stringForColumn:@"unlike"] integerValue] == 1) {
            _likeBtn.enabled = NO;
            _unlikeBtn.selected = YES;
            int maxUnlikeCount = [rs intForColumn:@"unlikeCount"] > (int)(__unlikeCount) ? [rs intForColumn:@"unlikeCount"] : (int)(__unlikeCount);
            NSString *title = [NSString stringWithFormat:@"%d",maxUnlikeCount];
            [_likeBtn setTitle:title forState:UIControlStateSelected];
        }
    }
}

@end
