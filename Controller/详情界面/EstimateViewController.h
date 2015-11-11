//
//  EstimateViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MddDownLoadTask.h"

@interface EstimateViewController : UIViewController<MddDownLoadTaskDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *Id;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
