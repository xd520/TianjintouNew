//
//  FoggterViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoggterViewController : UIViewController{

   NSString *seddionId;
}


@property (nonatomic,strong) NSString *phoneNumStr;


- (IBAction)back:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
- (IBAction)sureMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *sheetBtn;
- (IBAction)sheetMehtods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
