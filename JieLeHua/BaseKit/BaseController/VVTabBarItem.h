//
//  CustomTabBarItem.h
//  ShenhuaNews
//
//  Created by magicmac on 12-9-14.
//  Copyright (c) 2012年 magicpoint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVTabBarItem : UIView
{
    UIImageView *_itemImageView;
    UIImageView *_badgeBg;
    UILabel *_badgeLabel;
    
    UILabel *_titleLabel;
}
@property (nonatomic,strong) UIImage *normalImage;
@property (nonatomic,strong) UIImage *highlightImage;

@property (nonatomic,assign) BOOL selected;

@property (nonatomic,copy) NSString *badgeValue;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) BOOL showRed;
@end
