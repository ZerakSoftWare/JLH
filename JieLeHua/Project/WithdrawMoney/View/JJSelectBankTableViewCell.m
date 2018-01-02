//
//  JJSelectBankTableViewCell.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJSelectBankTableViewCell.h"
#import "IQUIView+Hierarchy.h"
#import "VVPickerView.h"
#import "JJBankCardRequest.h"

@interface JJSelectBankTableViewCell ()<UITextFieldDelegate,VVPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (nonatomic, copy) NSArray *cardArray;
@end

@implementation JJSelectBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSelectBankCell];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSelectBankCell
{
    self.bankWidthConstraint.constant = 0;
    self.modifyBtn.hidden = YES;
    self.bankNameField.delegate = self;
    //获取银行卡列表，一天获取一次即可
    NSString *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"newbanklistDate"];
    NSString *today = [VVCommonFunc stringformatDate:[NSDate date] formatter:@"yyyy-MM-dd"];
    if ([today isEqualToString:date] && date != nil) {
        //加载沙盒数组
        NSString *plistPath = [VVPathUtils bankCardPlistPath];
        NSDictionary *bankDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        JJBankCardModel *model = [JJBankCardModel mj_objectWithKeyValues:bankDict];
        self.cardArray = model.data;
        
    }else{
        [self getBankCardList];
    }
}

- (IBAction)mofifyAction:(id)sender {
    [self.bankNameField becomeFirstResponder];
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField.canBecomeFirstResponder == NO) {
        [self.viewController.view endEditing:YES];
        if (self.cardArray.count == 0) {
            [self getBankCardList];
            return NO;
        }
        //选择期限
        textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
        VVPickerView *vvPickerView = [[VVPickerView alloc]initWithFrame:self.viewController.view.bounds];
        vvPickerView.upViewColor = [UIColor colorWithHexString:@"f1f4f6"];
        vvPickerView.title = @"请点击选择银行类别";
        vvPickerView.rightBtnColor = [UIColor globalThemeColor];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (int i = 0; i<self.cardArray.count; i++) {
            [titleArray addObject:[[self.cardArray objectAtIndex:i] bankName]];
        }
        vvPickerView.showDataArr = titleArray;
        vvPickerView.myTextField = textField;
        vvPickerView.delegate = self;
        [self.viewController.view addSubview:vvPickerView];
        return NO;
//    }
    return NO;
}

#pragma mark - 获取银行卡列表
- (void)getBankCardList
{
    JJBankCardRequest *request = [[JJBankCardRequest alloc] init];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc]initWithShowView:self.viewController.view];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJBankCardModel *model = [(JJBankCardRequest *)request response];
        VVLog(@"%@",model.code);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.cardArray = model.data;
        if (model.success) {
            //保存至沙盒
            NSString *plistPath = [VVPathUtils bankCardPlistPath];
            [request.responseJSONObject writeToFile:plistPath atomically:YES];
            
            NSString *today = [VVCommonFunc stringformatDate:[NSDate date] formatter:@"yyyy-MM-dd"];
            [[NSUserDefaults standardUserDefaults] setObject:today forKey:@"newbanklistDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
             [MBProgressHUD bwm_showTitle:@"获取银行卡列表失败" toView:self.viewController.view hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
        }
        
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD bwm_showTitle:@"获取银行卡列表失败" toView:self.viewController.view hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
    }];
}

#pragma mark - VVPickerViewDelegate
-(void)didFinishPickViewWithTextField:(UITextField*)myTextField text:(NSString*)text row:(NSInteger)row
{
    JJBankCardDataModel *model = [self.cardArray objectAtIndex:row];
    myTextField.text = model.bankName;
    self.bankWidthConstraint.constant = 27;
    [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    self.modifyBtn.hidden = NO;
    self.endSelectBlock(model.bankName,model.fullKey);
}

@end
