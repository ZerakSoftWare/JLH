//
//  VVTabBar.m
//  VCREDIT
//
//  Created by chenlei on 14-3-27.
//  Copyright (c) 2014年  All rights reserved.
//

#import "VVTabBar.h"

@implementation VVTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
        // Initialization code
        UIImage* image = [VV_GETIMG(@"tab_bg") stretchableImageWithLeftCapWidth:0 topCapHeight:25];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:kLayoutTabbarFrame];
        imageView.image = image;
        imageView.backgroundColor = VV_COL_RGB(0xf9f9f9);
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        NSArray *imageNames = [NSArray arrayWithObjects:@"icon_tab_bar_home",@"icon_tab_bar_home_pre",
                               @"icon_tab_bar_bill",@"icon_tab_bar_bill_pre",
                               @"icon_tab_bar_found",@"icon_tab_bar_found_pre",
                               @"icon_tab_bar_my",@"icon_tab_bar_my_pre",nil];
        
        NSArray *titles = @[@"",@"",@"",@""];
        
    
                // create 4 imageviews for item
        float y = 6,height = kLayoutTabbarItemHeight;
        int width = kScreenWidth/(imageNames.count/2);
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < imageNames.count/2; ++i) {
            UIImage *normalImg = [UIImage imageNamed:[imageNames objectAtIndex:i*2]];
            UIImage *highlightImg = [UIImage imageNamed:[imageNames objectAtIndex:i*2+1]];
            
            CGRect frame = CGRectMake(width*i, y, width, height);
            VVTabBarItem *item = [[VVTabBarItem alloc] initWithFrame:frame];
            item.tag = i;
            item.normalImage = normalImg;
            item.highlightImage = highlightImg;
            item.title = titles[i];
            
            if (i == 0) {
                item.selected = YES;
            }else {
                item.selected = NO;
            }
            [self addSubview:item];
            [arr addObject:item];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        label.backgroundColor = [UIColor colorWithHexString:@"a8b0b8"];
        [self addSubview:label];
        _customTabBarItems = arr;
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


-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[VVTabBarItem class]]) {
            VVTabBarItem *item = (VVTabBarItem *)view;
            if (item.tag == _selectedIndex) {
                //                CustomTabBarItem *item = (CustomTabBarItem *)[self viewWithTag:selectedIndex];
                item.selected = YES;
            }else {
                item.selected = NO;
            }
        }
    }
}

- (VVTabBarItem *)getSelectedTabBarItem {
    return _customTabBarItems[_selectedIndex];
}

@end
