//
//  AccountInfoViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AppDelegate.h"
#import "BindCardViewController.h"
#import "UnBindCardViewController.h"
#import "NoBindCardViewController.h"
#import "LoginPassWordViewController.h"

@interface AccountInfoViewController ()
{
    UIScrollView *scrollView;
    NSMutableDictionary *dic;
    float addHight;
    UIImageView *imgHeadVeiw;
    BOOL success;
    BOOL hasLoadedCamera;
    
    UIView *lastView;
    UIView *nameView;
    UIView *lastViewFirst;
    int count;
}
@end

@implementation AccountInfoViewController
@synthesize dicData,headImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (count == 1) {
        [self getBankBindCardMethods];
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    count = 0;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
         statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
     addHight = 0;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth, ScreenHeight - 64)];
    scrollView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    
    //头像
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.tag = 100001;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    //单点触摸
    headTap.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    headTap.numberOfTapsRequired = 1;
    [headView addGestureRecognizer:headTap];
    
    
    UILabel *headImage = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 70, 20)];
    headImage.font = [UIFont systemFontOfSize:15];
    headImage.textColor = [ColorUtil colorWithHexString:@"333333"];
    //headImage.textAlignment = NSTextAlignmentRight;
    headImage.text = @"头像";
    [headView addSubview:headImage];
    
    imgHeadVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 70 - 15, 10, 70, 70)];
    imgHeadVeiw.backgroundColor = [UIColor redColor];
    
    imgHeadVeiw.layer.cornerRadius = imgHeadVeiw.frame.size.width / 2;
    imgHeadVeiw.clipsToBounds = YES;
    imgHeadVeiw.layer.borderWidth = 2.0f;
    imgHeadVeiw.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    imgHeadVeiw.image = headImg;
    [headView addSubview:imgHeadVeiw];
    
    
    UIImageView *headTip = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 35, 20, 20)];
    headTip.image = [UIImage imageNamed:@"next_icon"];
    [headView addSubview:headTip];
    
   UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 89, ScreenWidth - 30, 1)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [headView addSubview:lineView];
    
    
    [scrollView addSubview:headView];
    scrollView.bounces = NO;
    
     
    [self.view addSubview:scrollView];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
         [self requestLogin:kBusinessTagGetJRupdateUserInfoAgain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}


-(void)reloadDataWith:(NSMutableDictionary *)dictiongary{
    dic = dictiongary;
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, ScreenWidth , 150)];
    baseView.backgroundColor = [UIColor whiteColor];
//    baseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    
//    baseView.layer.borderWidth = 1;
//    
//    baseView.layer.masksToBounds = YES;
//    
//    baseView.layer.cornerRadius = 4;
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth - 30, 1)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [baseView addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, ScreenWidth - 30, 1)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [baseView addSubview:lineView];
    
    NSArray *titleArr = @[@"真实姓名",@"身份证号",@"手机号码"];
    NSRange range,range1;
    NSString *strZJBH;
    if ([dictiongary objectForKey:@"FID_ZJBH"] == [NSNull null]){
        strZJBH = @"";
    }else {
        
        range.length = [[dictiongary objectForKey:@"FID_ZJBH"] length] - 10;
        range.location = 6;
        strZJBH  = [[dictiongary objectForKey:@"FID_ZJBH"] stringByReplacingCharactersInRange:range withString:@"******"];
    }
    
    
    
    NSString *strPhoneNum = [dictiongary objectForKey:@"MOBILEPHONE"];
    range1.length = strPhoneNum.length - 7;
    range1.location = 3;
    
    
    NSString *sr;
    NSRange range2;
    if ([dictiongary objectForKey:@"KHXM"] == [NSNull null]) {
        sr = @"**";
    } else {
        
        NSString *string = [dictiongary objectForKey:@"KHXM"];
        
        
        range2.length = [string length] - 1;
        range2.location = 0;
        sr = [string stringByReplacingCharactersInRange:range2 withString:@"**"];
    }
    
    
    
    NSArray *realArr = @[sr,strZJBH,[strPhoneNum stringByReplacingCharactersInRange:range1 withString:@"****"]];
    for (int i = 0; i < 3; i++) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 50*i + 17, 100, 15)];
        lab.text = [titleArr objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:15];
        
        // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        lab.textAlignment = NSTextAlignmentLeft;
        [baseView addSubview:lab];
        
        
        UILabel *labReal = [[UILabel alloc] initWithFrame:CGRectMake(120 , 50*i + 17, ScreenWidth - 10 - 110 -10, 15)];
        labReal.text = [realArr objectAtIndex:i];
        labReal.font = [UIFont systemFontOfSize:15];
        
        lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        labReal.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:labReal];
        
    }
    
    [scrollView addSubview:baseView];
    //交易账户
    UILabel *buyTip = [[UILabel alloc] initWithFrame:CGRectMake(10 ,90 + 155 + 17.5, 60, 15)];
    buyTip.text = @"交易账户";
    buyTip.backgroundColor = [UIColor clearColor];
    buyTip.font = [UIFont systemFontOfSize:15];
    
    // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    buyTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    buyTip.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:buyTip];
    
    UILabel *litterLab = [[UILabel alloc] initWithFrame:CGRectMake(75 ,90 + 155 + 19 , ScreenWidth - 80, 12)];
    litterLab.text = @"下列信息可提供给银行绑定银行账户";
    litterLab.font = [UIFont systemFontOfSize:12];
    litterLab.backgroundColor = [UIColor clearColor];
    
    litterLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    litterLab.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:litterLab];
    
    //
    UIView *base = [[UIView alloc] initWithFrame:CGRectMake(0,90 + 205, ScreenWidth, 100)];
    base.backgroundColor = [UIColor whiteColor];
//    base.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    
//    base.layer.borderWidth = 1;
//    
//    base.layer.masksToBounds = YES;
//    
//    base.layer.cornerRadius = 4;
    
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth - 30, 1)];
    lineV.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [base addSubview:lineV];
    
    NSArray *arr = @[@"客户号",@"交易资金帐号"];
    NSString *khhStr,*zjzhStr;
    if (dictiongary.count > 0) {
        
        if ([dictiongary  objectForKey:@"FID_KHH"] == [NSNull null]) {
            khhStr = @"";
        } else {
            khhStr = [dictiongary  objectForKey:@"FID_KHH"];
        }
        
        if ([dictiongary  objectForKey:@"FID_ZJZH"] == [NSNull null]) {
            zjzhStr = @"";
        } else {
            zjzhStr = [dictiongary  objectForKey:@"FID_ZJZH"];
        }
        
    } else {
        
        khhStr = @"";
        zjzhStr = @"";
    }
    
    NSArray *vauleArr = @[khhStr,zjzhStr];
    for (int i = 0; i < 2; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 50*i + 17, 100, 15)];
        lab.text = [arr objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:15];
        // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab.textAlignment = NSTextAlignmentLeft;
        [base addSubview:lab];
        
        
        UILabel *labReal = [[UILabel alloc] initWithFrame:CGRectMake(120 , 50*i + 17, ScreenWidth - 10 - 110 -10, 15)];
        labReal.text = [vauleArr objectAtIndex:i];
        labReal.font = [UIFont systemFontOfSize:15];
        
        lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        labReal.textAlignment = NSTextAlignmentRight;
        [base addSubview:labReal];
        
        
        
    }
    [scrollView addSubview:base];
    
    
    //银行账户
    UILabel *accountTip = [[UILabel alloc] initWithFrame:CGRectMake(10 ,90 + 305 + 17.5, 60, 15)];
    accountTip.text = @"银行账户";
    accountTip.font = [UIFont systemFontOfSize:15];
    accountTip.backgroundColor = [UIColor clearColor];
    // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    accountTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    accountTip.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:accountTip];
    
    //[scrollView setContentSize:CGSizeMake(ScreenWidth, 410)];
    
    [self getBankBindCardMethods];
    
    count = 1;
}


//判定是否绑定银行卡
-(void)getBankBindCardMethods{

    if (lastViewFirst) {
        [lastViewFirst removeFromSuperview];
    }
    
    if (lastView) {
        [lastView removeFromSuperview];
    }
    
    if (nameView) {
        [nameView removeFromSuperview];
    }
    
    // 尚未绑定银行账户
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[delegate.dictionary objectForKey:@"isBingingCard"] boolValue] == NO) {
        
        lastViewFirst = [[UIView alloc] initWithFrame:CGRectMake(0,90 + 355, ScreenWidth , 50)];
        lastViewFirst.backgroundColor = [UIColor whiteColor];
        
        UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        tipImg.image = [UIImage imageNamed:@"icon_nof2"];
        [lastViewFirst addSubview:tipImg];
        
        UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 ,17.5, 150, 15)];
        accountLabel.text = @"尚未绑定银行帐号";
        accountLabel.font = [UIFont systemFontOfSize:15];
        
        // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        
        accountLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
        
        accountLabel.textAlignment = NSTextAlignmentLeft;
        [lastViewFirst addSubview:accountLabel];
        lastViewFirst.userInteractionEnabled = YES;
        
        tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 15, 20, 20)];
        tipImg.image = [UIImage imageNamed:@"next_icon"];
        [lastViewFirst addSubview:tipImg];
        
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        lastViewFirst.tag = 0;
        //单点触摸
        singleTap1.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
        singleTap1.numberOfTapsRequired = 1;
        [lastViewFirst addGestureRecognizer:singleTap1];
        [scrollView addSubview:lastViewFirst];
        [scrollView setContentSize:CGSizeMake(ScreenWidth, 500)];
        
    } else {
        
        nameView = [[UIView alloc] initWithFrame:CGRectMake(0,90 + 354, ScreenWidth, 50)];
        nameView.backgroundColor = [UIColor whiteColor];
        //        nameView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //
        //        nameView.layer.borderWidth = 1;
        //
        //        nameView.layer.masksToBounds = YES;
        //
        //        nameView.layer.cornerRadius = 4;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 ,17.5, 100, 15)];
        nameLabel.text = @"开户银行";
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [nameView addSubview:nameLabel];
        
        UILabel *vauleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 ,17.5, ScreenWidth - 20 - 110, 15)];
        if ([[dicData objectForKey:@"FID_YHDM"] isEqualToString:@"JSYH"]) {
            vauleLabel.text = @"建设银行";
        }else if ([[dicData objectForKey:@"FID_YHDM"] isEqualToString:@"JGJS"]) {
            vauleLabel.text = @"建设银行";
        } else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"XYYH"]) {
            
            vauleLabel.text = @"兴业银行";
            
        } else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"ZGYH"]){
            
            vauleLabel.text = @"中国银行";
        } else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"NYYH"]) {
            vauleLabel.text = @"农业银行";
            
        }else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"JGNY"]) {
            vauleLabel.text = @"农业银行";
            
        } else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"GSYH"]) {
            
            vauleLabel.text = @"工商银行";
        }else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"JGGS"]) {
            
            vauleLabel.text = @"工商银行";
        }else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"ZSYH"]) {
            vauleLabel.text = @"招商银行";
            
        }else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"JGZS"]) {
            vauleLabel.text = @"招商银行";
            
        }else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"GDYH"]) {
            vauleLabel.text = @"光大银行";
            
        }else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"JGGD"]) {
            vauleLabel.text = @"光大银行";
            
        }else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"GFYH"]) {
            vauleLabel.text = @"广发银行";
            
        }else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"ZXYH"]) {
            vauleLabel.text = @"中信银行";
            
        } else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"JTYH"]) {
            vauleLabel.text = @"交通银行";
            
        } else if ([[dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"PFYH"]) {
            vauleLabel.text = @"浦发银行";
            
        }
        
        
        
        
        
        vauleLabel.font = [UIFont systemFontOfSize:15];
        vauleLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
        vauleLabel.textAlignment = NSTextAlignmentRight;
        [nameView addSubview:vauleLabel];
        [scrollView addSubview:nameView];
        
        
        
        lastView = [[UIView alloc] initWithFrame:CGRectMake(0,90 + 405, ScreenWidth, 50)];
        lastView.backgroundColor = [UIColor whiteColor];
        //        lastView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //
        //        lastView.layer.borderWidth = 1;
        //
        //        lastView.layer.masksToBounds = YES;
        //
        //        lastView.layer.cornerRadius = 4;
        
        
        UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 ,17.5, 110, 15)];
        accountLabel.text = @"银行卡号";
        accountLabel.font = [UIFont systemFontOfSize:15];
        
        accountLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        accountLabel.textAlignment = NSTextAlignmentLeft;
        [lastView addSubview:accountLabel];
        lastView.userInteractionEnabled = YES;
        
        
        UILabel *cardBandLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 ,17.5, ScreenWidth  - 120 - 30, 15)];
        
        NSString *string =[[dicData objectForKey:@"FID_YHZH"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSRange range;
        NSString *strZJBH;
        
        range.length = [string length] - 9;
        range.location = 5;
        strZJBH  = [string stringByReplacingCharactersInRange:range withString:@"******"];
        
        
        cardBandLabel.text = strZJBH;
        cardBandLabel.font = [UIFont systemFontOfSize:15];
        
        cardBandLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
        
        
        cardBandLabel.textAlignment = NSTextAlignmentRight;
        [lastView addSubview:cardBandLabel];
        
        UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 15, 20, 20)];
        tipImg.image = [UIImage imageNamed:@"next_icon"];
        [lastView addSubview:tipImg];
        
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        lastView.tag = 1;
        //单点触摸
        singleTap1.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
        singleTap1.numberOfTapsRequired = 1;
        [lastView addGestureRecognizer:singleTap1];
        
        
        [scrollView addSubview:lastView];
        
        if (ScreenWidth > 320) {
            [scrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight - 64)];
        } else {
            
            [scrollView setContentSize:CGSizeMake(ScreenWidth, 550)];
        }
        
    }

}


- (IBAction)callPhone:(UITouch *)sender
{
     UIView *view = [sender view];
    if (view.tag == 0) {
       
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        
    if (![[appDelegate.dictionary objectForKey:@"isSetCert"] boolValue]){
        
        LoginPassWordViewController *vc =  [[LoginPassWordViewController alloc] init];
     [self.navigationController pushViewController:vc animated:YES];
        
        
    } else {
      
        BindCardViewController *vc = [[BindCardViewController alloc] init];
       // vc.dic = dic;
        [self.navigationController pushViewController:vc animated:YES];
   
        }
    } else if (view.tag == 1) {
    
    UnBindCardViewController *vc = [[UnBindCardViewController alloc] init];
       // vc.dic = dic;
        vc.cardBankStr = [dicData objectForKey:@"yhzhEncode"];
        vc.bankAccountStr = [dicData objectForKey:@"FID_YHZH"];
         vc.bankcodeStr = [dicData objectForKey:@"FID_YHDM"];
        
       // vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (view.tag == 100001) {
        UIActionSheet *sheet;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
            
        } else {
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        }
        sheet.tag = 255;
        [sheet showInView:self.view];
        
    }
}

#pragma caramer Methods

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:{
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    hasLoadedCamera = YES;
                }
                    break;
                case 2:{
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    // hasLoadedCamera = YES;
                }
                    break;
            }
        }else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        [self showcamera:sourceType];
        
    }
}

- (void)showcamera:(NSInteger)tag {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    //[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setAllowsEditing:YES];
    imagePicker.sourceType = tag;
    [self presentViewController:imagePicker animated:YES completion:^{}];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // NSLog(@"u a is sb");
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [self scaleImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    // 保存图片至本地，方法见下文
    
    
    
    [self saveImage:image withName:@"currentImage.png"];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    //UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        ASIFormDataRequest *requestReport  = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/service/psncenter/userinfo/appUploadPhotoSubmit",SERVERURL]]];
        NSLog(@"%@",requestReport);
        
        
        
        [requestReport setFile:fullPath forKey:@"upfile"];
        
        [requestReport buildPostBody];
        
        requestReport.delegate = self;
        [requestReport setTimeOutSeconds:5];
        [requestReport setDidFailSelector:@selector(urlRequestField:)];
        [requestReport setDidFinishSelector:@selector(urlRequestSueccss:)];
        
        
        [requestReport startAsynchronous];//异步传输
        
       // isFullScreen = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
    // [self.imageView setImage:savedImage];
    
    //self.imageView.tag = 100;
    
}

//图片压缩

- (UIImage *)scaleImage:(UIImage *)image {
    int kMaxResolution = 1000;
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    NSLog(@"boudns image =%@",NSStringFromCGRect(bounds));
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    
    switch(orient) {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
            //        default:
            //            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}





-(void) urlRequestField:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.view makeToast:[NSString stringWithFormat:@"%@",error]];
}

-(void) urlRequestSueccss:(ASIHTTPRequest *)request {
    NSData *data =[request responseData];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    NSLog(@"%@",parser);
    NSLog(@"xml data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [parser setDelegate:self];
    [parser parse];
    
    NSString *strss = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [strss JSONValue];
    if ([[dic objectForKey:@"success"] boolValue]) {
        [self.view makeToast:@"更新图片成功"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSNumber *num = [NSNumber numberWithBool:true];
        
        [[delegate.logingUser objectForKey:@"object"] setObject:num forKey:@"isTX"];
        
        
        /*
        Customer *cuser = [delegate.array objectAtIndex:0];
        cuser.icon = nil;
        UIImage *icon = [[UIImage alloc] initWithContentsOfFile:fullPath];
        cuser.icon = icon;
         */
        imgHeadVeiw.image = [[UIImage alloc] initWithContentsOfFile:fullPath];
        //删除本地化文件
        /*
         NSFileManager *fileMgr = [NSFileManager defaultManager];
         BOOL bRet = [fileMgr fileExistsAtPath:fullPath];
         if (bRet) {
         NSError *err;
         [fileMgr removeItemAtPath:fullPath error:&err];
         }
         */
        
    } else {
        [self.view makeToast:@"更新图片失败"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}




#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    if ([[jsonDic objectForKey:@"object"] isKindOfClass:[NSString class]]) {
        
        if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]&&[[jsonDic objectForKey:@"success"] boolValue] == NO) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.logingUser removeAllObjects];
            [delegate.dictionary removeAllObjects];
            [ASIHTTPRequest setSessionCookies:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }else {
    
	if (tag== kBusinessTagGetJRupdateUserInfoAgain) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
           // [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
           // [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            [self reloadDataWith:dataArray];
            }
        }
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}
-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    // if (tag==kBusinessTagGetProjectDetail) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //}
    [[NetworkModule sharedNetworkModule] cancel:tag];
}





- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
   
   [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc {

    scrollView.delegate = nil;
    [scrollView removeFromSuperview];
    scrollView = nil;
    [dic removeAllObjects];
    dic = nil;
    
    [imgHeadVeiw removeFromSuperview];
    imgHeadVeiw = nil;
   
    headImg = nil;
    dicData = nil;
    
    [lastView removeFromSuperview];
    lastView = nil;
    [nameView removeFromSuperview];
    nameView = nil;
    [lastViewFirst removeFromSuperview];
    lastViewFirst = nil;

}



@end
