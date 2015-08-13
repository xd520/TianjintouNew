//
//  NoBindCardViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-1.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NoBindCardViewController : UIViewController
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *account;

@property (weak, nonatomic) IBOutlet UITextField *codeNum;
@property (weak, nonatomic) IBOutlet UIButton *sheetBtn;
- (IBAction)sheetMethods:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *jiaoyiPW;
- (IBAction)commitBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *commit;
- (IBAction)back:(id)sender;

@end
