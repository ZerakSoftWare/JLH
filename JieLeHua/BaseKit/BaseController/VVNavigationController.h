//
//  UPNavigationController.h
//  CHSP
//
//  Created by wxzhao on 12-11-30.
//
//

#import <UIKit/UIKit.h>

@interface VVNavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic,retain) NSMutableArray *addVCs;
@property (nonatomic,retain) NSMutableArray *removeVCs;

- (void)initControllers;
- (void)presentLoginViewController;

- (void)addTabBarController;
- (void)presentViewC:(id )VC animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissViewC:(id )VC Animated:(BOOL)flag completion:(void (^)(void))completion;
@end
