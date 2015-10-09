//
//  MyAuthorityViewController.m
//  添金投
//
//  Created by mac on 15/10/9.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MyAuthorityViewController.h"

@interface MyAuthorityViewController ()

@end

@implementation MyAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
