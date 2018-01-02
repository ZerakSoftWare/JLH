//
//  OnlineServiceViewController.m
//  JieLeHua
//
//  Created by admin on 2017/11/13.
//Copyright © 2017年 Vcredit. All rights reserved.
//

#import "OnlineServiceViewController.h"
#import "AppDelegate+HelpDesk.h"
#import "SCLoginManager.h"
#import "HDMessageReadManager.h"
#import "HFileViewController.h"
#import "HDLeaveMsgViewController.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface OnlineServiceViewController ()<UIAlertViewDelegate,HChatClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    BOOL isLogin;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) HDSelectAtTargetCallback selectedCallback;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation OnlineServiceViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    NSLog(@"第二通道已经关闭");
    [[HChatClient sharedClient].chatManager unbind];
}


#pragma mark - Public Methods

+ (id)allocWithRouterParams:(NSDictionary *)params {
    OnlineServiceViewController *instance = [[OnlineServiceViewController alloc] init];
    return instance;
}

#pragma mark - HDMessageViewControllerDelegate

- (BOOL)messageViewController:(HDMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)messageViewController:(HDMessageViewController *)viewController fileMessageCellSelected:(id<HDIMessageModel>)model {
    HFileViewController *fileVC = [[HFileViewController alloc] init];
    fileVC.model = model;
    [self.navigationController pushViewController:fileVC animated:YES];
}

- (BOOL)messageViewController:(HDMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        HDMessageCell *cell = (HDMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(HDMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<HDIMessageModel>)messageModel
{
    
}


#pragma mark - HDMessageViewControllerDataSource

//- (id<HDIMessageModel>)messageViewController:(HDMessageViewController *)viewController
//                           modelForMessage:(HMessage *)message
//{
//    id<HDIMessageModel> model = nil;
//    model = [[HDMessageModel alloc] initWithMessage:message];
//    model.avatarImage = [UIImage imageNamed:@"HelpDeskUIResource.bundle/user"];
//    model.avatarURLPath = @"";
//    model.failImageName = @"imageDownloadFail";
//    return model;
//}

- (NSArray*)emotionFormessageViewController:(HDMessageViewController *)viewController
{
    NSMutableArray *rst = [NSMutableArray arrayWithCapacity:0];
    //添加表情数据源
#pragma mark smallpngface
    NSMutableArray *customEmotions = [NSMutableArray array];
    NSMutableArray *customNameArr = [NSMutableArray arrayWithCapacity:0];
    NSString *customName = nil;
    for (int i=1; i<=35; i++) {
        // 把自定义表情图片加到数组中
        customName = [@"HelpDeskUIResource.bundle/e_e_" stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        [customNameArr addObject:customName];
    }
    int i = 0;
    // 取出表情字符
    for (NSString *name in [HDConvertToCommonEmoticonsHelper emotionsArray]) {
        //initWithName是表情底部的显示名，可以传空， emotionId传表情名称  emotionThumbnail和emotionOriginal  是传表情字符对应的图片 在UI上显示
        HDEmotion *emotion = [[HDEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:customNameArr[i] emotionOriginal:customNameArr[i] emotionOriginalURL:@"" emotionType:HDEmotionPng];
        [customEmotions addObject:emotion];
        i++;
    }
    HDEmotion *customTemp = [customEmotions objectAtIndex:0];
    HDEmotionManager *customManagerDefault = [[HDEmotionManager alloc] initWithType:HDEmotionPng emotionRow:4 emotionCol:9 emotions:customEmotions tagImage:[UIImage imageNamed:customTemp.emotionThumbnail]];
    customManagerDefault.emotionName = NSLocalizedString(@"default", @"default");
    [rst addObject:customManagerDefault];
    
    NSArray *emojiPackagesDics =[self emojiValueForKey:@"emojiPackages"];
    for (NSDictionary *dic in emojiPackagesDics) {
        HEmojiPackage *package = [[HEmojiPackage alloc] initWithDictionary:dic];
        if (![[SCLoginManager shareLoginManager].tenantId isEqualToString:package.tenantId]) {
            continue;
        }
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
        NSArray *emojis = [self emojiValueForKey:[NSString stringWithFormat:@"emojis%@",package.packageId]];
        for (NSDictionary *emojiDic in emojis) {
            HEmoji *hemoji = [[HEmoji alloc] initWithDictionary:emojiDic];
            HDEmotion *emotion = [[HDEmotion alloc] initWithName:hemoji.emojiName emotionId:@"123" emotionThumbnail:hemoji.thumbnailUrl emotionOriginal:hemoji.originUrl emotionOriginalURL:hemoji.originUrl emotionType:hemoji.emotionType];
            [marr addObject:emotion];
        }
        if (marr.count > 0) {
            HDEmotion *customTemp = [marr objectAtIndex:0];
            HDEmotionManager *manager = [[HDEmotionManager alloc] initWithType:HDEmotionGif emotionRow:2 emotionCol:4 emotions:marr tagImage:[UIImage imageNamed:customTemp.emotionThumbnail]];
            manager.emotionName = package.packageName;
            [rst addObject:manager];
        }
        
    }
    return rst;
}

- (id)emojiValueForKey:(NSString *)key {
    NSString *path=NSTemporaryDirectory();
    NSString *emojiPath =[path stringByAppendingPathComponent:@"emoji.plist"];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithContentsOfFile:emojiPath];
    return [mDic valueForKey:key];
}

- (BOOL)isEmotionMessageFormessageViewController:(HDMessageViewController *)viewController
                                    messageModel:(id<HDIMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (HDEmotion*)emotionURLFormessageViewController:(HDMessageViewController *)viewController
                                    messageModel:(id<HDIMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    HDEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[HDEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:HDEmotionGif];
    }
    return emotion;
}

#pragma mark - action

/**
 继承于父类，点击左上箭头离开聊天界面时执行。本方法禁止执行可能引起父类方法不能释放的代码。
 */
- (void)backItemDidClicked
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
    NSLog(@"返回会话列表");
    //    if (self.deleteConversationIfNull) {
    //        //判断当前会话是否为空，若符合则删除该会话
    //        HMessage *message = [self.conversation latestMessage];
    //        if (message == nil) {
    //            [[HChatClient sharedClient].chat deleteConversation:self.conversation.conversationId deleteMessages:NO];
    //        }
    //    }
}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *chattingID = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [chattingID isEqualToString:self.conversation.conversationId];
        if (isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompta", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancela", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<HDIMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<HDIMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation removeMessageWithMessageId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    self.menuIndexPath = nil;
}

#pragma mark - private
- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}

- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[HDCDDeviceManager sharedInstance] stopPlaying];
    [[HDCDDeviceManager sharedInstance] disableProximitySensor];
    [HDCDDeviceManager sharedInstance].delegate = self;
    
    HDMessageModel *playingModel = [[HDMessageReadManager defaultManager] stopMessageAudioModel];
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    self.visitorInfo = [self visitorInfo];
    
    [[HChatClient sharedClient].chatManager bindChatWithConversationId:self.conversation.conversationId];

    [self setupBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [SCLoginManager shareLoginManager].curChat = self;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [SCLoginManager shareLoginManager].curChat = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)setupBarButtonItem
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"btn_nav_bar_return")
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(iMBackAction)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)iMBackAction
{
    self.navigationController.navigationBar.hidden = YES;

    [self backItemClicked];
}

//请求视频通话
- (void)moreViewVideoCallAction:(HDChatBarMoreView *)moreView {
    [self stopAudioPlayingWithChangeCategory:YES];
    
    HMessage *message = [HDSDKHelper videoInvitedMessageFormatWithText
                         :NSLocalizedString(@"em_chat_invite_video_call", @"invite customer service making a video call")
                         toUser:self.conversation.conversationId];
    [message addContent:[self visitorInfo]];
    [self _sendMessage:message];
}

// 留言
- (void)moreViewLeaveMessageAction:(HDChatBarMoreView *)moreView
{
    [self stopAudioPlayingWithChangeCategory:YES];
    HDLeaveMsgViewController *leaveMsgVC = [[HDLeaveMsgViewController alloc] init];
    [self.navigationController pushViewController:leaveMsgVC animated:YES];
}

- (HVisitorInfo *)visitorInfo
{
    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
    visitor.name = [UserModel currentUser].customerId;
    return visitor;
}

@end
