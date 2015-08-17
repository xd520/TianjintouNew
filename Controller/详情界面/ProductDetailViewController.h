//
//  ProductDetailViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController

@property(nonatomic,strong)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *priceGive;
@property (weak, nonatomic) IBOutlet UILabel *myLife;
@property (weak, nonatomic) IBOutlet UILabel *shouYi;
@property (weak, nonatomic) IBOutlet UILabel *yearLL;
@property (weak, nonatomic) IBOutlet UILabel *addPrice;
@property (weak, nonatomic) IBOutlet UILabel *nextDate;
@property (weak, nonatomic) IBOutlet UIButton *timeTouzi;
- (IBAction)timeTouziMethods:(id)sender;

- (IBAction)back:(id)sender;

@end
