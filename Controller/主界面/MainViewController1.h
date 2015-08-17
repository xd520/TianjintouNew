//
//  MainViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-16.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController1 : UIViewController
- (IBAction)regerster:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *regerster;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property float autoSizeScaleY;



@end
