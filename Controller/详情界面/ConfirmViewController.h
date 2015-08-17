//
//  ConfirmViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-25.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmViewController : UIViewController<UITextFieldDelegate>
- (IBAction)back:(id)sender;
@property(nonatomic,strong)NSString *str;
@property(nonatomic,strong)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *yearLL;
@property (weak, nonatomic) IBOutlet UILabel *gainStaly;
@property (weak, nonatomic) IBOutlet UILabel *lastDate;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)remberMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *shoushuFei;
@property (weak, nonatomic) IBOutlet UIView *textView;

- (IBAction)sureMehtods:(id)sender;

@end
