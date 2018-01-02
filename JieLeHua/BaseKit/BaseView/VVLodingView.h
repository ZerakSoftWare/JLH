//
//  VVLodingView.h
//  O2oApp
//
//  Created by chenlei on 16/5/13.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VVLodingView : UIView
{
    UIImageView* _activityView;
    UIImageView* _bigActivityView;

    UIImageView*   _dialogView;
    CGFloat _angle;
    BOOL _stop;
}
- (void)show;
- (void)hide;

@end
