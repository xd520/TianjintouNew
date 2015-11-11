//
//  WebDetailViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-23.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MddDownLoadTask.h"
//#import <QuickLook/QuickLook.h>

@interface WebDetailViewController : UIViewController<MddDownLoadTaskDelegate>


@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *Id;


- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
