//
//  VVommonTextField.h
//  VVlientV3
//
//  Created by TZ_JSKFZX_CAOQ on 13-5-26.
//
//

#import <UIKit/UIKit.h>

@interface VVCommonTextField : UITextField


@property (nonatomic,retain) UIColor *placeHolderColor;

// 是否可以开始编辑，默认YES，可以编辑。
@property (nonatomic,assign) BOOL canBeginEditting;


@property (nonatomic,copy) NSString *leftText;

@property (nonatomic, assign) NSInteger maxlength;

@property (nonatomic, retain) UIImage *leftImage;

@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,assign)CGFloat lineHeight;

@property(nonatomic,strong) NSString * type;

@end


@interface VVPhoneNumberTextField : VVCommonTextField

@end

@interface VVRoundCornerTextField : VVCommonTextField

@end
