//
//  EstimateViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstimateViewController : UIViewController

@property(nonatomic,strong)NSString *gqdm;
@property(nonatomic,strong)NSString *gqlb;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
