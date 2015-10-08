//
//  MyTransferPrococalViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-24.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTransferPrococalViewController : UIViewController
- (IBAction)back:(id)sender;
@property(nonatomic,strong)NSString *str;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
