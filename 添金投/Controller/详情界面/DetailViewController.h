//
//  DetailViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *strGqdm;
@property (assign, nonatomic) BOOL flagbtn;
@property (strong, nonatomic) NSString *flagStr;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
- (IBAction)hideMethods:(id)sender;

@property float autoSizeScaleY;

@end
