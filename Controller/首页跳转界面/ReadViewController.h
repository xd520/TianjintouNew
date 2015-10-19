//
//  ReadViewController.h
//  添金投
//
//  Created by mac on 15/10/19.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadViewController : UIViewController<UIDocumentInteractionControllerDelegate>

@property(nonatomic,strong)NSString *path;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)openIN:(id)sender;

@end
