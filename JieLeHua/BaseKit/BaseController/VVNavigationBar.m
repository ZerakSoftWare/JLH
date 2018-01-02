//
//  VVNavigationBar.m
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-9-6.
//
//

#import "VVNavigationBar.h"


@interface VVNavigationBar()
{

    
}

@end

@implementation VVNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIImage* image = [VV_GETIMG(@"nav_bg") stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//        _imageView = [[UIImageView alloc] initWithImage:image];
//        _imageView.backgroundColor = UP_COL_INT_RGB(251, 66, 59);ff5b4b
        
//        _imageView = [[UIImageView alloc] init];
//        _imageView.backgroundColor = VVBASE_COLOR;
        
//        _imageView.layer.shadowOffset = CGSizeMake(0, 2);
//        _imageView.layer.shadowOpacity = 0.3;
//        _imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:_imageView];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5f, vScreenWidth, 0.5f)];
        _line.backgroundColor = VVColor(211, 218, 222);
        [self addSubview:_line];
    }
    return self;
}



- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (iPhoneX)
    {
        _imageView.frame = CGRectMake(0, 20, frame.size.width, frame.size.height-20);
    }else{
        _imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
