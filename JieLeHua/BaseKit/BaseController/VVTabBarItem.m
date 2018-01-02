//
//  CustomTabBarItem.m
//  ShenhuaNews
//
//  Created by magicmac on 12-9-14.
//  Copyright (c) 2012年 magicpoint. All rights reserved.
//

#import "VVTabBarItem.h"

@implementation VVTabBarItem

@synthesize normalImage = _normalImage;
@synthesize highlightImage = _highlightImage;

@synthesize selected = _selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemImageView = [[UIImageView alloc] initWithFrame:frame];
        _itemImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_itemImageView];
        
//        UIImage *img = VV_GETIMG(@"has_unread");
//        UIImage *img = VV_GETIMG(@"tab_badgeValue_bg");        // 使用大图
//        _badgeBg = [[UIImageView alloc] initWithImage:img];
//        _badgeBg.frame = CGRectMake(frame.size.width/2 + 7, 5, img.size.width, img.size.height);
//        [self addSubview:_badgeBg];
        
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 + 10, 0, 6, 6)];
        _badgeLabel.layer.cornerRadius = 3;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_badgeLabel];
        _badgeLabel.hidden = YES;

        _badgeBg.hidden = YES;
        
        CGRect rect = _badgeBg.frame;
        rect.origin.y += rect.size.height;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 10)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_titleLabel];
        _titleLabel.hidden = YES;
        
        self.selected = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setNormalImage:(UIImage *)normalImage {
    if (_normalImage != normalImage) {
        _normalImage = nil;
        _normalImage = normalImage;
    }
    CGRect frame = CGRectMake((self.frame.size.width-_normalImage.size.width)/2, 0, _normalImage.size.width, _normalImage.size.height);
    _itemImageView.frame = frame;
}

-(void)setHighlightImage:(UIImage *)highlightImage {
    if (_highlightImage != highlightImage) {
        _highlightImage = nil;
        _highlightImage = highlightImage;
    }
    
    if (!_normalImage) {
        CGRect frame = CGRectMake((self.frame.size.width-_highlightImage.size.width)/2, 0, _highlightImage.size.width, _highlightImage.size.height);
        _itemImageView.frame = frame;
    }
}

-(void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
    }
    
    _itemImageView.image = _selected ? (self.highlightImage) : (self.normalImage);
    _titleLabel.textColor = selected ? (VVBASE_OLD_COLOR) : (VV_COL_RGB(0x666666));
}

- (void)setBadgeValue:(NSString *)badgeValue {
    if (_badgeValue != badgeValue) {
        _badgeValue = nil;
        _badgeValue = [badgeValue copy];
    }
    if (_badgeValue) {
        _badgeLabel.text = _badgeValue;
        _badgeBg.hidden = NO;
        if([_badgeValue isEqualToString:@""])
        {
            _badgeBg.image = VV_GETIMG(@"has_unread");
            _badgeBg.frame = CGRectMake(_badgeBg.frame.origin.x, -3, _badgeBg.image.size.width, _badgeBg.image.size.height);
        }else {
            _badgeBg.image = VV_GETIMG(@"tab_badgeValue_bg");
            _badgeBg.frame = CGRectMake(_badgeBg.frame.origin.x, -3, _badgeBg.image.size.width, _badgeBg.image.size.height);
        }
    } else {
        _badgeBg.hidden = YES;
    }
}

-(void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = nil;
        _title = [title copy];
    }
    
    if (_title) {
        _titleLabel.text = _title;
        _titleLabel.hidden = NO;
    } else {
        _titleLabel.hidden = YES;
    }
}

- (void)setShowRed:(BOOL)showRed
{
    _showRed = showRed;
    if (showRed) {
        _badgeLabel.hidden = NO;
    }else{
        _badgeLabel.hidden = YES;
    }
}

@end
