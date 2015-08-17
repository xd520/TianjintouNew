//
//  MyTransferDetailViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-26.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MyTransferDetailViewController : UIViewController<MBProgressHUDDelegate,NetworkModuleDelegate,UITextFieldDelegate>

@property(nonatomic,strong)NSString *gqdm;
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *priceGive;
@property (weak, nonatomic) IBOutlet UILabel *transferEnd;

@property (weak, nonatomic) IBOutlet UILabel *myLife;
@property (weak, nonatomic) IBOutlet UILabel *shouYi;
@property (weak, nonatomic) IBOutlet UILabel *yearLL;
@property (weak, nonatomic) IBOutlet UILabel *addPrice;
@property (weak, nonatomic) IBOutlet UILabel *nextDate;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
- (IBAction)transferMethods:(id)sender;




@end
