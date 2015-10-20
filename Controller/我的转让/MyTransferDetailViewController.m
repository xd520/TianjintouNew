//
//  MyTransferDetailViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-26.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyTransferDetailViewController.h"
#import "AppDelegate.h"
#import "MyTransferViewController.h"

@interface MyTransferDetailViewController ()
{
    NSMutableDictionary *firstDic;
    UIView *changeView;
    UITextField *sureText;
    UILabel *wantMoneyLab;
    UITextField *transferText;
    float addHight;
    UILabel *labStarLab;
   UIScrollView *scrollView;
    
    //基准价
    UILabel *jzjPriceLab;
    //上限
    UILabel *sxPriceLab;
    //下限
    UILabel *xxPriceLab;
    //损失
    UILabel *missPriceLab;
    //标价
    UILabel *markPriceLab;
    
    float _defauleBadgeNumber;
    float _lastNumber;
    UIButton *jianBtn;
    UIButton *addBtn;
    UIButton *jianBtnPast;
    UIButton *addBtnPast;
    
}

@end

@implementation MyTransferDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        firstDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth, ScreenHeight - 44 - addHight)];
    
    [self.view addSubview:scrollView];
    
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestLogin:_gqdm tag:kBusinessTagGetJRGetSelling];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
}

#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)gqdm tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:gqdm forKey:@"gqdm"];
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
    
    if (tag== kBusinessTagGetJRGetSelling) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            firstDic = dataArray;
            [self reloadViewUIData:dataArray];
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

-(void)changeUI:(UIButton *)btn{
    
    NSLog(@"%.2f %.2f",[transferText.text floatValue],[[firstDic objectForKey:@"jgxx"] floatValue]);
    
    
    if (btn.tag == 10001) {
        
        changeView.hidden = NO;
        
    } else if (btn.tag == 10002){
        
        changeView.hidden = YES;
        _transferBtn.hidden = NO;
        
    }else if (btn.tag == 10003){
       [self.view endEditing:YES];
        
        
        if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]) {
            
            NSLog(@"%ld  %ld",[sureText.text integerValue],[[firstDic objectForKey:@"dzsl"] integerValue]);
            
            if ([sureText.text isEqualToString:@""]) {
                [self.view makeToast:@"请输入转让数量" duration:1.0 position:@"center"];
            }else if ([sureText.text integerValue] % [[firstDic objectForKey:@"dzsl"] integerValue] != 0){
                
                [self.view makeToast:@"请输入递增数量的整数倍" duration:2 position:@"center"];
                
            } else if ([sureText.text floatValue] > [transferText.text floatValue] + [[firstDic objectForKey:@"wslx"] floatValue]) {
                [self.view makeToast:@"您的转让价格导致投资收益率为负，请重新输入。" duration:1.0 position:@"center"];
            }else if ([transferText.text isEqualToString:@""]) {
                [self.view makeToast:@"请输入转让价格" duration:1.0 position:@"center"];
            }else {
                
                MyTransferViewController *vc = [[MyTransferViewController alloc] init];
                vc.dic = firstDic;
                vc.str = sureText.text;
                vc.transferStr = transferText.text;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        
        }else {
        
        
       if ([sureText.text isEqualToString:@""]) {
            [self.view makeToast:@"请输入转让价格" duration:1.0 position:@"center"];
       }else if (([sureText.text intValue] % [[firstDic objectForKey:@"jaje"] intValue] != 0)){
       
           [self.view makeToast:@"请输入递增金额的整数倍" duration:2 position:@"center"];
           
       
       } else if ([sureText.text floatValue] > [transferText.text floatValue] + [[firstDic objectForKey:@"wslx"] floatValue]) {
           [self.view makeToast:@"您的转让价格导致投资收益率为负，请重新输入。" duration:1.0 position:@"center"];
       }else if ([transferText.text isEqualToString:@""]) {
           [self.view makeToast:@"请输入转让本金" duration:1.0 position:@"center"];
       }else {
                        
            MyTransferViewController *vc = [[MyTransferViewController alloc] init];
            vc.dic = firstDic;
            vc.str = sureText.text;
           vc.transferStr = transferText.text;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
                        
            }
        }
    }
}





-(void)reloadViewUIData:(NSDictionary *)_dic {
    
    UILabel *descPriceLabel = [[UILabel alloc] init];
    descPriceLabel.text = [_dic objectForKey:@"xmmc"];
    //使用自定义字体
    descPriceLabel.font = [UIFont systemFontOfSize:15];    //设置字体颜色
    //descPriceLabel.textColor = [ColorUtil colorWithHexString:@"1b1b1b"];
    descPriceLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
    
    CGSize titleSize = [descPriceLabel.text sizeWithFont:descPriceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    
    descPriceLabel.frame = CGRectMake(10, 15, titleSize.width, 15);
    int descHeight = 15;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"icon_transfer"];
    // [scrollView addSubview:imgView];
    
    [scrollView addSubview:descPriceLabel];
    
    
    UILabel *numYQH = [[UILabel alloc] init];
    numYQH.text = [_dic objectForKey:@"gzll"];
    numYQH.font = [UIFont systemFontOfSize:25];
    numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    numYQH.frame = CGRectMake(10,10 + descHeight + 17.5, titleSize.width, 25);
    [scrollView addSubview:numYQH];
   
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, descHeight + 52.5 - 13, 15, 13)];
    lab.text = @"%";
    lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    lab.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:lab];
    
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 + 23, descHeight + 50 - 14, 70, 14)];
    tip.text = @"可转让本金";
    tip.textColor = [ColorUtil colorWithHexString:@"999999"];
    tip.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:tip];
    
    
    
    
    UILabel *tip1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 + 98, descHeight + 50 - 14, 200, 14)];
    tip1.text = [NSString stringWithFormat:@"%.2f元",[[_dic objectForKey:@"kmcsl"] floatValue]];
    tip1.textColor = [ColorUtil colorWithHexString:@"333333"];
    tip1.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:tip1];
    
    NSArray *titleArr = @[@"已收本金",@"未收本金",@"收益方式",@"到期日期",@"已收利息",@"未收利息"];
   
     NSArray *valueArr = @[[NSString stringWithFormat:@"%@元",[_dic objectForKey:@"ysbj"]],[NSString stringWithFormat:@"%@元",[_dic objectForKey:@"wsbj"]],[_dic objectForKey:@"syfs"],[_dic objectForKey:@"dqrq"],[NSString stringWithFormat:@"%@元",[_dic objectForKey:@"yslx"]],[NSString stringWithFormat:@"%@元",[_dic objectForKey:@"wslx"]]];
    
    for (int i = 0; i < 6; i++) {
        if (i < 4) {
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 72 + 24*i, 60, 14)];
            tip.text =[titleArr objectAtIndex:i];
            tip.textColor = [ColorUtil colorWithHexString:@"999999"];
            tip.font = [UIFont systemFontOfSize:14];
            [scrollView addSubview:tip];
            
            UILabel *tiplab = [[UILabel alloc] initWithFrame:CGRectMake(75, descHeight + 72 + 24*i, ScreenWidth/ 2 - 75, 14)];
            tiplab.text =[valueArr objectAtIndex:i];
            tiplab.textColor = [ColorUtil colorWithHexString:@"333333"];
            tiplab.font = [UIFont systemFontOfSize:14];
            [scrollView addSubview:tiplab];
            
        } else {
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 10, descHeight + 72 + 24*(i - 4), 60, 14)];
            tip.text =[titleArr objectAtIndex:i];
            tip.textColor = [ColorUtil colorWithHexString:@"999999"];
            tip.font = [UIFont systemFontOfSize:14];
            [scrollView addSubview:tip];
            
            UILabel *tiplab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 +75, descHeight + 72 + 24*(i - 4), ScreenWidth/ 2 - 75, 14)];
            tiplab.text =[valueArr objectAtIndex:i];
            tiplab.textColor = [ColorUtil colorWithHexString:@"333333"];
            tiplab.font = [UIFont systemFontOfSize:14];
            [scrollView addSubview:tiplab];
        
        }
    }
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, descHeight + 72 + 24*4, ScreenWidth, 10)];
    backView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [scrollView addSubview:backView];
    
    
    if ([[_dic objectForKey:@"gqlb"] isEqualToString:@"98"]) {
        
        
        UILabel *tipPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 180, 60, 15)];
        tipPrice.text =@"转让价格";
        tipPrice.textColor = [ColorUtil colorWithHexString:@"333333"];
        tipPrice.font = [UIFont systemFontOfSize:15];
        [scrollView addSubview:tip];
        
        UILabel *tipBen = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 190 + 10.5, 60, 14)];
        tipBen.text =@"转让数量";
        tipBen.textColor = [ColorUtil colorWithHexString:@"999999"];
        tipBen.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:tipBen];
        
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(70, descHeight + 190, ScreenWidth - 140, 35)];
        btnView.layer.cornerRadius = 4;
        btnView.layer.borderWidth = 1;
        btnView.layer.borderColor = [ColorUtil colorWithHexString:@"dedede"].CGColor;
        btnView.layer.masksToBounds = YES;
        
        jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jianBtn.frame = CGRectMake(5, 5, 25, 25);
        [jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
        
        [jianBtn addTarget:self action:@selector(subtractButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView addSubview:jianBtn];
        
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(ScreenWidth - 140 - 30, 5, 25, 25);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
        
        [addBtn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView addSubview:addBtn];
        
        sureText = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, ScreenWidth - 140 - 70, 35)];
        sureText.backgroundColor = [UIColor whiteColor];
        sureText.placeholder = @"输入转让数量";
        sureText.text = [NSString stringWithFormat:@"%.2f",[[_dic objectForKey:@"kmcsl_sl"] floatValue]];
        _defauleBadgeNumber = [sureText.text floatValue];
        
        sureText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        sureText.clearButtonMode = UITextFieldViewModeWhileEditing;
        sureText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        sureText.font = [UIFont systemFontOfSize:15];
        
        sureText.delegate = self;
        
        [btnView addSubview:sureText];
        
        
        
        [scrollView addSubview:btnView];
        
        UILabel *labLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 190 + 40, ScreenWidth - 20, 12)];
        
        labLab.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        labLab.font = [UIFont systemFontOfSize:12];
        
        labLab.backgroundColor = [UIColor clearColor];
        
        labLab.text = [NSString stringWithFormat:@"最小转让数量为  %.2f元,递增数量为 %.2f元",[[_dic objectForKey:@"zxzrsl"] floatValue],[[_dic objectForKey:@"dzsl"] floatValue]];//jzj
        
        [scrollView addSubview:labLab];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, descHeight + 190 + 40 + 22, ScreenWidth, 1)];
        view1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
        [scrollView addSubview:view1];
        
        
        UILabel *jzjLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 190 + 62 + 15, 70, 14)];
        jzjLab.text =@"结算价格";
        jzjLab.textColor = [ColorUtil colorWithHexString:@"999999"];
        jzjLab.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:jzjLab];
        
        //结算价格
        jzjPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(85, descHeight + 190 + 62 + 15, 150, 14)];
        jzjPriceLab.text =[NSString stringWithFormat:@"%.2f",[[_dic  objectForKey:@"fxj"] floatValue] + [[_dic  objectForKey:@"zxlx"] floatValue]*([[_dic  objectForKey:@"jjjybz"] floatValue])];
        
        
        
        jzjPriceLab.textColor = [ColorUtil colorWithHexString:@"333333"];
        jzjPriceLab.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:jzjPriceLab];
        
        
        
        
        UILabel *zrLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 190 + 62 + 39, 60, 14)];
        zrLab.text =@"转让价格";
        zrLab.textColor = [ColorUtil colorWithHexString:@"999999"];
        zrLab.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:zrLab];
        //上限
        UILabel *sxLab = [[UILabel alloc] initWithFrame:CGRectMake(85, descHeight + 190 + 62 + 39, 28, 14)];
        sxLab.text =@"上限";
        sxLab.textColor = [ColorUtil colorWithHexString:@"999999"];
        sxLab.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:sxLab];
        
        sxPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(98 + 15, descHeight + 190 + 62 + 39, 150, 14)];
        sxPriceLab.text =[NSString stringWithFormat:@"%.2f元",[[_dic  objectForKey:@"zgbj"] floatValue]];
        sxPriceLab.textColor = [ColorUtil colorWithHexString:@"333333"];
        sxPriceLab.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:sxPriceLab];
        
        
        
        //下限
        UILabel *xxLab = [[UILabel alloc] initWithFrame:CGRectMake(85, descHeight + 190 + 62 + 39 + 24, 28, 14)];
        xxLab.text =@"下限";
        xxLab.textColor = [ColorUtil colorWithHexString:@"999999"];
        xxLab.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:xxLab];
        
        xxPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(98 + 15, descHeight + 190 + 62 + 39 + 24, 150, 14)];
        xxPriceLab.text =[NSString stringWithFormat:@"%.2f元",[[_dic  objectForKey:@"zdbj"] floatValue]];
        xxPriceLab.textColor = [ColorUtil colorWithHexString:@"333333"];
        xxPriceLab.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:xxPriceLab];
        
        
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0,descHeight + 190 + 62 + 39 + 48, ScreenWidth, 1)];
        viewLine.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
        [scrollView addSubview:viewLine];
        
        //转让价格
        
        UILabel *zrLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 350 + 10, 60, 14)];
        zrLabTip.text =@"转让价格";
        zrLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
        zrLabTip.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:zrLabTip];
        
        
        UIView *lastV = [[UIView alloc] initWithFrame:CGRectMake(70,descHeight + 350, ScreenWidth - 140, 35)];
        lastV.layer.cornerRadius = 4;
        lastV.layer.borderWidth = 1;
        lastV.layer.borderColor = [ColorUtil colorWithHexString:@"dedede"].CGColor;
        lastV.layer.masksToBounds = YES;
        
        jianBtnPast = [UIButton buttonWithType:UIButtonTypeCustom];
        jianBtnPast.frame = CGRectMake(5, 5, 25, 25);
        [jianBtnPast setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
        
        [jianBtnPast addTarget:self action:@selector(subtractButtonClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        [lastV addSubview:jianBtnPast];
        
        addBtnPast = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtnPast.frame = CGRectMake(ScreenWidth - 140 - 30, 5, 25, 25);
        [addBtnPast setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
        
        [addBtnPast addTarget:self action:@selector(addButtonClick1:) forControlEvents:UIControlEventTouchUpInside];
        
        [lastV addSubview:addBtnPast];
        
        transferText = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, ScreenWidth - 140 - 70, 35)];
        transferText.backgroundColor = [UIColor whiteColor];
        transferText.placeholder = @"输入转让价格";
        transferText.text = [NSString stringWithFormat:@"%.2f",[[_dic  objectForKey:@"fxj"] floatValue]];
        _lastNumber = [transferText.text floatValue];
        transferText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        transferText.clearButtonMode = UITextFieldViewModeWhileEditing;
        transferText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        transferText.font = [UIFont systemFontOfSize:15];
        
        transferText.delegate = self;
        
        [lastV addSubview:transferText];
        
        [scrollView addSubview:lastV];
        
        
        missPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(70, descHeight + 350 + 45, ScreenWidth - 80, 14)];
        missPriceLab.text = [NSString stringWithFormat:@"您可能收益约为%.2f元",[[_dic  objectForKey:@"zxlx"] doubleValue]*([[_dic  objectForKey:@"jjjybz"] doubleValue])*[sureText.text doubleValue]];
        missPriceLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        missPriceLab.font = [UIFont systemFontOfSize:14];
        [scrollView addSubview:missPriceLab];
        
        //标价
        markPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 350 + 70, ScreenWidth - 20, 12)];
        markPriceLab.text =[NSString stringWithFormat:@"价格只能在%@ - %@之间",xxPriceLab.text,sxPriceLab.text];
        
        markPriceLab.textColor = [ColorUtil colorWithHexString:@"999999"];
        markPriceLab.font = [UIFont systemFontOfSize:12];
        [scrollView addSubview:markPriceLab];
        
        //认购
        
        UIButton *sureBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        sureBtn1.frame = CGRectMake(10, descHeight + 350 + 70 + 27, ScreenWidth - 20, 35);
        
        sureBtn1.tag = 10003;
        
        sureBtn1.layer.masksToBounds = YES;
        
        sureBtn1.layer.cornerRadius = 4;
        
        sureBtn1.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
        
        [sureBtn1 setTitle:@"下一步" forState:UIControlStateNormal];
        
        [sureBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        sureBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [sureBtn1 addTarget:self action:@selector(changeUI:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:sureBtn1];
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
            [scrollView setContentSize:CGSizeMake(ScreenWidth, 504)];
        } else {
            
            [scrollView setContentSize:CGSizeMake(ScreenWidth, descHeight + 350 + 70 + 27 + 45 + 40)];
        }
        
        [self refershBtn];
        
    } else {
    
    
    UILabel *tipPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 180, 60, 15)];
    tipPrice.text =@"转让价格";
    tipPrice.textColor = [ColorUtil colorWithHexString:@"333333"];
    tipPrice.font = [UIFont systemFontOfSize:15];
    [scrollView addSubview:tip];
    
    UILabel *tipBen = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 190 + 10.5, 60, 14)];
    tipBen.text =@"转让本金";
    tipBen.textColor = [ColorUtil colorWithHexString:@"999999"];
    tipBen.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:tipBen];
    
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(70, descHeight + 190, ScreenWidth - 140, 35)];
    btnView.layer.cornerRadius = 4;
    btnView.layer.borderWidth = 1;
    btnView.layer.borderColor = [ColorUtil colorWithHexString:@"dedede"].CGColor;
    btnView.layer.masksToBounds = YES;
    
    jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jianBtn.frame = CGRectMake(5, 5, 25, 25);
    [jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
    
    [jianBtn addTarget:self action:@selector(subtractButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:jianBtn];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(ScreenWidth - 140 - 30, 5, 25, 25);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
    
    [addBtn addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:addBtn];
    
    sureText = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, ScreenWidth - 140 - 70, 35)];
    sureText.backgroundColor = [UIColor whiteColor];
    sureText.placeholder = @"输入转让本金";
    sureText.text = [NSString stringWithFormat:@"%.2f",[[_dic objectForKey:@"kmcsl"] floatValue]];
     _defauleBadgeNumber = [sureText.text floatValue];
    
    sureText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureText.clearButtonMode = UITextFieldViewModeWhileEditing;
     sureText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    sureText.font = [UIFont systemFontOfSize:15];
    
    sureText.delegate = self;
    
    [btnView addSubview:sureText];

    
    
    [scrollView addSubview:btnView];
    
    UILabel *labLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 190 + 40, ScreenWidth - 20, 12)];
    
    labLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    
    labLab.font = [UIFont systemFontOfSize:12];
    
    labLab.backgroundColor = [UIColor clearColor];
    
    labLab.text = [NSString stringWithFormat:@"最小转让本金为  %.2f元,递增金额为 %.2f元",[[_dic objectForKey:@"zxzrbj"] floatValue],[[_dic objectForKey:@"jaje"] floatValue]];//jzj
    
    [scrollView addSubview:labLab];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, descHeight + 190 + 40 + 22, ScreenWidth, 1)];
    view1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [scrollView addSubview:view1];
    
    
    UILabel *jzjLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 190 + 62 + 15, 70, 14)];
    jzjLab.text =@"转让基准价";
    jzjLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    jzjLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:jzjLab];
    
    //基准价
    jzjPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(85, descHeight + 190 + 62 + 15, 150, 14)];
    jzjPriceLab.text =[NSString stringWithFormat:@"%.2f",[sureText.text floatValue]*([[_dic  objectForKey:@"fxj"] floatValue] + [[_dic  objectForKey:@"zxlx"] floatValue])];
    
   
    
    jzjPriceLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    jzjPriceLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:jzjPriceLab];
    
    
    
    
    UILabel *zrLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 190 + 62 + 39, 60, 14)];
    zrLab.text =@"转让价格";
    zrLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    zrLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:zrLab];
  //上限
    UILabel *sxLab = [[UILabel alloc] initWithFrame:CGRectMake(85, descHeight + 190 + 62 + 39, 28, 14)];
    sxLab.text =@"上限";
    sxLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    sxLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:sxLab];
    
    sxPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(98 + 15, descHeight + 190 + 62 + 39, 150, 14)];
    sxPriceLab.text =[NSString stringWithFormat:@"%.2f元",[sureText.text floatValue]*([[_dic  objectForKey:@"fxj"] floatValue] + [[_dic  objectForKey:@"zxlx"] floatValue])*(1 + 0.05)];
    sxPriceLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    sxPriceLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:sxPriceLab];
    
    
    
//下限
    UILabel *xxLab = [[UILabel alloc] initWithFrame:CGRectMake(85, descHeight + 190 + 62 + 39 + 24, 28, 14)];
    xxLab.text =@"下限";
    xxLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    xxLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:xxLab];
    
    xxPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(98 + 15, descHeight + 190 + 62 + 39 + 24, 150, 14)];
    xxPriceLab.text =[NSString stringWithFormat:@"%.2f元",[sureText.text floatValue]*([[_dic  objectForKey:@"fxj"] floatValue] + [[_dic  objectForKey:@"zxlx"] floatValue])*(1 - 0.05)];
    xxPriceLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    xxPriceLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:xxPriceLab];
   
   
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0,descHeight + 190 + 62 + 39 + 48, ScreenWidth, 1)];
    viewLine.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [scrollView addSubview:viewLine];
    
//转让价格
    
    UILabel *zrLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 350 + 10, 60, 14)];
    zrLabTip.text =@"转让价格";
    zrLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
    zrLabTip.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:zrLabTip];
    
    
    UIView *lastV = [[UIView alloc] initWithFrame:CGRectMake(70,descHeight + 350, ScreenWidth - 140, 35)];
    lastV.layer.cornerRadius = 4;
    lastV.layer.borderWidth = 1;
    lastV.layer.borderColor = [ColorUtil colorWithHexString:@"dedede"].CGColor;
    lastV.layer.masksToBounds = YES;
    
    jianBtnPast = [UIButton buttonWithType:UIButtonTypeCustom];
    jianBtnPast.frame = CGRectMake(5, 5, 25, 25);
    [jianBtnPast setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
    
    [jianBtnPast addTarget:self action:@selector(subtractButtonClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    [lastV addSubview:jianBtnPast];
    
    addBtnPast = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtnPast.frame = CGRectMake(ScreenWidth - 140 - 30, 5, 25, 25);
    [addBtnPast setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
    
    [addBtnPast addTarget:self action:@selector(addButtonClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    [lastV addSubview:addBtnPast];
    
    transferText = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, ScreenWidth - 140 - 70, 35)];
    transferText.backgroundColor = [UIColor whiteColor];
    transferText.placeholder = @"输入转让本金";
    transferText.text = [NSString stringWithFormat:@"%.2f",[sureText.text floatValue]*([[_dic  objectForKey:@"fxj"] floatValue] + [[_dic  objectForKey:@"zxlx"] floatValue])];
    _lastNumber = [transferText.text floatValue];
    transferText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    transferText.clearButtonMode = UITextFieldViewModeWhileEditing;
     transferText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    transferText.font = [UIFont systemFontOfSize:15];
    
    transferText.delegate = self;
    
    [lastV addSubview:transferText];
    
    [scrollView addSubview:lastV];
    
    
    missPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(70, descHeight + 350 + 45, ScreenWidth - 80, 14)];
    missPriceLab.text =@"您可能收益0.00元";
    missPriceLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    missPriceLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:missPriceLab];
    
   //标价
    markPriceLab  = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 350 + 70, ScreenWidth - 20, 12)];
    markPriceLab.text =[NSString stringWithFormat:@"价格只能在%@ - %@之间",xxPriceLab.text,sxPriceLab.text];

    markPriceLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    markPriceLab.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:markPriceLab];
    
    //认购
    
    UIButton *sureBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sureBtn1.frame = CGRectMake(10, descHeight + 350 + 70 + 27, ScreenWidth - 20, 35);
    
    sureBtn1.tag = 10003;
    
    sureBtn1.layer.masksToBounds = YES;
    
    sureBtn1.layer.cornerRadius = 4;
    
    sureBtn1.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    
    [sureBtn1 setTitle:@"下一步" forState:UIControlStateNormal];
    
    [sureBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    sureBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [sureBtn1 addTarget:self action:@selector(changeUI:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:sureBtn1];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
         [scrollView setContentSize:CGSizeMake(ScreenWidth, 504)];
    } else {
    
  [scrollView setContentSize:CGSizeMake(ScreenWidth, descHeight + 350 + 70 + 27 + 45 + 40)];
    }
    [self refershBtn];
    
    }
}

- (IBAction)addButtonClick:(UIButton *)sender {
    
    if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]){
        
        _defauleBadgeNumber += [[firstDic objectForKey:@"dzsl"] floatValue];
        NSLog(@"%.2f  ,%.2f",_defauleBadgeNumber,[[firstDic objectForKey:@"dzsl"] floatValue]);
        
        
        if (_defauleBadgeNumber >= [[firstDic objectForKey:@"kmcsl_sl"] floatValue]) {
            _defauleBadgeNumber = [[firstDic objectForKey:@"kmcsl_sl"] floatValue];
            sender.enabled = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"add_not_btn"] forState:UIControlStateNormal];
            sureText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"kmcsl_sl"] floatValue]];
        } else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
            sureText.text = [NSString stringWithFormat:@"%.2f",_defauleBadgeNumber];
            
        }
        
        [self refershBtn];
        [self refreshPrice];
    }else {
    
    _defauleBadgeNumber += [[firstDic objectForKey:@"jaje"] floatValue];
    NSLog(@"%.2f  ,%.2f",_defauleBadgeNumber,[[firstDic objectForKey:@"jaje"] floatValue]);
    
    
    if (_defauleBadgeNumber >= [[firstDic objectForKey:@"kmcsl"] floatValue]) {
        _defauleBadgeNumber = [[firstDic objectForKey:@"kmcsl"] floatValue];
        sender.enabled = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"add_not_btn"] forState:UIControlStateNormal];
        sureText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"kmcsl"] floatValue]];
    } else {
    
        [sender setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
        sureText.text = [NSString stringWithFormat:@"%.2f",_defauleBadgeNumber];
    
    }
    
    [self refershBtn];
    [self refreshPrice];
    }
}

- (IBAction)addButtonClick1:(UIButton *)sender {
    
    if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]) {

        _lastNumber += 1;
        
        if (_lastNumber >= [[firstDic objectForKey:@"zgbj"] floatValue]) {
            transferText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"zgbj"] doubleValue]];
            _lastNumber = [transferText.text floatValue];
            sender.enabled = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"add_not_btn"] forState:UIControlStateNormal];
            
        } else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
            transferText.text = [NSString stringWithFormat:@"%.2f",_lastNumber];
            _lastNumber = [transferText.text floatValue];
        }
        
        [self refershBtn1];
        [self refreshPrice1];
    }else {
    
    NSString *sxjizhunjia = [NSString stringWithFormat:@"%.2f",[jzjPriceLab.text floatValue]*(1 + 0.05)];
    _lastNumber += [[firstDic objectForKey:@"jaje"] floatValue];
   
    if (_lastNumber >= [sxjizhunjia floatValue]) {
         transferText.text = sxjizhunjia;
        _lastNumber = [transferText.text floatValue];
        sender.enabled = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"add_not_btn"] forState:UIControlStateNormal];
       
    } else {
        
        [sender setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
        transferText.text = [NSString stringWithFormat:@"%.2f",_lastNumber];
        _lastNumber = [transferText.text floatValue];
    }
    
    [self refershBtn1];
    [self refreshPrice1];
    }
}

-(void)refershBtn1{
    
    if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]) {
        
        NSString *sxjzj = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"zgbj"] doubleValue]];
        NSString *xxjzj = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"zdbj"] doubleValue]];
        
        if ([transferText.text floatValue] == [xxjzj floatValue]) {
            jianBtnPast.enabled = NO;
            [jianBtnPast setBackgroundImage:[UIImage imageNamed:@"jian_not_btn"] forState:UIControlStateNormal];
        } else {
            jianBtnPast.enabled = YES;
            [jianBtnPast setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
            
        }
        
        if ([transferText.text floatValue] == [sxjzj floatValue]) {
            addBtnPast.enabled = NO;
            [addBtnPast setBackgroundImage:[UIImage imageNamed:@"add_not_btn"] forState:UIControlStateNormal];
        } else {
            addBtnPast.enabled = YES;
            [addBtnPast setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
            
        }
    }else {
    
    
    NSString *sxjzj = [NSString stringWithFormat:@"%.2f",[jzjPriceLab.text floatValue]*(1 + 0.05)];
    NSString *xxjzj = [NSString stringWithFormat:@"%.2f",[jzjPriceLab.text floatValue]*(1 - 0.05)];
    
    if ([transferText.text floatValue] == [xxjzj floatValue]) {
        jianBtnPast.enabled = NO;
        [jianBtnPast setBackgroundImage:[UIImage imageNamed:@"jian_not_btn"] forState:UIControlStateNormal];
    } else {
        jianBtnPast.enabled = YES;
        [jianBtnPast setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
        
    }
    
    if ([transferText.text floatValue] == [sxjzj floatValue]) {
        addBtnPast.enabled = NO;
        [addBtnPast setBackgroundImage:[UIImage imageNamed:@"add_not_btn"] forState:UIControlStateNormal];
    } else {
        addBtnPast.enabled = YES;
        [addBtnPast setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
        
    }
    }
    
}

-(void)refreshPrice1{
    
    if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]) {
       
       double price = [transferText.text doubleValue] + [[firstDic  objectForKey:@"zxlx"] doubleValue]*([[firstDic  objectForKey:@"jjjybz"] doubleValue]);
            jzjPriceLab.text =[NSString stringWithFormat:@"%.2f",[transferText.text doubleValue] + [[firstDic  objectForKey:@"zxlx"] doubleValue]*[[firstDic  objectForKey:@"jjjybz"] doubleValue]];
        
             if (price < [[firstDic  objectForKey:@"fxj"] floatValue]) {
            missPriceLab.text = [NSString stringWithFormat:@"您可能损失约为%.2f元",([[firstDic  objectForKey:@"fxj"] doubleValue] - price)*[sureText.text doubleValue]];
        
        }else {
        
     missPriceLab.text = [NSString stringWithFormat:@"您可能收益约为%.2f元",(price - [[firstDic  objectForKey:@"fxj"] doubleValue])*[sureText.text doubleValue]];
        }
    
    } else {
    
    if ([transferText.text floatValue] < [jzjPriceLab.text floatValue]) {
        
      missPriceLab.text = [NSString stringWithFormat:@"您可能损失%.2f元",[jzjPriceLab.text floatValue] - [transferText.text floatValue]];
        
    } else {
    
     missPriceLab.text = [NSString stringWithFormat:@"您可能收益%.2f元",[transferText.text floatValue] - [jzjPriceLab.text floatValue]];
    
        }
    }
     // _lastNumber = [transferText.text floatValue];
}



- (IBAction)subtractButtonClick1:(UIButton *)sender {
    
    if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]) {
        
        float xxjizhunjia = [[firstDic objectForKey:@"zdbj"] floatValue];
        _lastNumber -= 1;
        if (_lastNumber <= xxjizhunjia) {
            
            sender.enabled = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"jian_not_btn"] forState:UIControlStateNormal];
            transferText.text = [NSString stringWithFormat:@"%.2f",xxjizhunjia];
            _lastNumber = [transferText.text floatValue];
        } else {
            [sender setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
            transferText.text = [NSString stringWithFormat:@"%.2f",_lastNumber];
            _lastNumber = [transferText.text floatValue];
        }
        [self refershBtn1];
        [self refreshPrice1];
        
    } else {
    float xxjizhunjia = [jzjPriceLab.text floatValue]*(1 - 0.05);
    _lastNumber -= [[firstDic objectForKey:@"jaje"] floatValue];
    if (_lastNumber <= xxjizhunjia) {
        
        sender.enabled = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"jian_not_btn"] forState:UIControlStateNormal];
        transferText.text = [NSString stringWithFormat:@"%.2f",xxjizhunjia];
        _lastNumber = [transferText.text floatValue];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
        transferText.text = [NSString stringWithFormat:@"%.2f",_lastNumber];
        _lastNumber = [transferText.text floatValue];
    }
    [self refershBtn1];
    [self refreshPrice1];
    }
}



- (IBAction)subtractButtonClick:(UIButton *)sender {
    
    if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]){
        
        _defauleBadgeNumber -= [[firstDic objectForKey:@"dzsl"] floatValue];
        if (_defauleBadgeNumber <= [[firstDic objectForKey:@"dzsl"] floatValue]) {
            _defauleBadgeNumber = [[firstDic objectForKey:@"dzsl"] floatValue];
            sender.enabled = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"jian_not_btn"] forState:UIControlStateNormal];
            sureText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"zxzrsl"] floatValue]];
        } else {
            [sender setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
            sureText.text = [NSString stringWithFormat:@"%.2f",_defauleBadgeNumber];
            
        }
        [self refershBtn];
        [self refreshPrice];
    } else {
        
    _defauleBadgeNumber -= [[firstDic objectForKey:@"jaje"] floatValue];
    if (_defauleBadgeNumber <= [[firstDic objectForKey:@"jaje"] floatValue]) {
        _defauleBadgeNumber = [[firstDic objectForKey:@"jaje"] floatValue];
        sender.enabled = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"jian_not_btn"] forState:UIControlStateNormal];
        sureText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"zxzrbj"] floatValue]];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
        sureText.text = [NSString stringWithFormat:@"%.2f",_defauleBadgeNumber];
    
        }
    [self refershBtn];
    [self refreshPrice];
    }
}



-(void)refershBtn{
    if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]) {
        if ([sureText.text floatValue] == [[firstDic objectForKey:@"zxzrsl"] floatValue]) {
            jianBtn.enabled = NO;
            [jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_not_btn"] forState:UIControlStateNormal];
        } else {
            jianBtn.enabled = YES;
            [jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
            
        }
        
        if ([sureText.text floatValue] == [[firstDic objectForKey:@"kmcsl_sl"] floatValue]) {
            addBtn.enabled = NO;
            [addBtn setBackgroundImage:[UIImage imageNamed:@"add_not_btn"] forState:UIControlStateNormal];
        } else {
            addBtn.enabled = YES;
            [addBtn setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
            
        }
        
    } else {
    if ([sureText.text floatValue] == [[firstDic objectForKey:@"zxzrbj"] floatValue]) {
        jianBtn.enabled = NO;
        [jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_not_btn"] forState:UIControlStateNormal];
    } else {
        jianBtn.enabled = YES;
        [jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
    
    }
    
    if ([sureText.text floatValue] == [[firstDic objectForKey:@"kmcsl"] floatValue]) {
        addBtn.enabled = NO;
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add_not_btn"] forState:UIControlStateNormal];
    } else {
        addBtn.enabled = YES;
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add_btn"] forState:UIControlStateNormal];
        
        }
    }

}

-(void)refreshPrice{
    
    if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]) {
        
        
            jzjPriceLab.text =[NSString stringWithFormat:@"%.2f",[transferText.text doubleValue] + [[firstDic  objectForKey:@"zxlx"] doubleValue]*([[firstDic  objectForKey:@"jjjybz"] doubleValue])];
        
            if ([jzjPriceLab.text doubleValue] < [[firstDic  objectForKey:@"fxj"] doubleValue]) {
            missPriceLab.text = [NSString stringWithFormat:@"您可能损失约为%.2f元",([[firstDic  objectForKey:@"fxj"] doubleValue] - [jzjPriceLab.text doubleValue])*[sureText.text doubleValue]];
            
            
        }else {
        
         missPriceLab.text = [NSString stringWithFormat:@"您可能收益约为%.2f元",([jzjPriceLab.text doubleValue] - [[firstDic  objectForKey:@"fxj"] doubleValue])*[sureText.text doubleValue]];
        }
    }else {
    
     jzjPriceLab.text =[NSString stringWithFormat:@"%.2f",[sureText.text floatValue]*([[firstDic  objectForKey:@"fxj"] floatValue] + [[firstDic  objectForKey:@"zxlx"] floatValue])];
     sxPriceLab.text =[NSString stringWithFormat:@"%.2f元",[sureText.text floatValue]*([[firstDic  objectForKey:@"fxj"] floatValue] + [[firstDic  objectForKey:@"zxlx"] floatValue])*(1 + 0.05)];
     xxPriceLab.text =[NSString stringWithFormat:@"%.2f元",[sureText.text floatValue]*([[firstDic  objectForKey:@"fxj"] floatValue] + [[firstDic  objectForKey:@"zxlx"] floatValue])*(1 - 0.05)];
     transferText.text = [NSString stringWithFormat:@"%.2f",[sureText.text floatValue]*([[firstDic  objectForKey:@"fxj"] floatValue] + [[firstDic  objectForKey:@"zxlx"] floatValue])];
    
    missPriceLab.text = @"您可能收益0.00元";
    markPriceLab.text =[NSString stringWithFormat:@"价格只能在%@ - %@之间",xxPriceLab.text,sxPriceLab.text];
    _lastNumber = [transferText.text floatValue];
    }
}


#pragma mark-文本框代理方法


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // sureText = textField;
    scrollView.contentSize = CGSizeMake(ScreenWidth,500 +216);//原始滑动距离增加键盘高度
    CGPoint pt = [textField convertPoint:CGPointMake(0, 0) toView:scrollView];//把当前的textField的坐标映射到scrollview上
    if(scrollView.contentOffset.y-pt.y+64<=0)//判断最上面不要去滚动
        [scrollView setContentOffset:CGPointMake(0, pt.y-64) animated:YES];//华东
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    
    [theTextField resignFirstResponder];
    
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.3];
    scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    scrollView.contentSize = CGSizeMake(ScreenWidth,500);
    //动画结束
    [UIView commitAnimations];
    
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == sureText) {
        
            if([self rangeString:sureText.text] > 1){
                [self.view makeToast:@"请输入正确的金额" duration:2.0 position:@"center"];
                
            } else {
                sureText.text = [NSString stringWithFormat:@"%d",[textField.text intValue]];
                if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]){
                    
                    if ([sureText.text intValue] % [[firstDic objectForKey:@"dzsl"] intValue] == 0) {
                        if ([sureText.text floatValue] < [[firstDic objectForKey:@"zxzrsl"] floatValue]) {
                            sureText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"zxzrsl"] floatValue]];
                        }else if ([sureText.text floatValue] > [[firstDic objectForKey:@"kmcsl_sl"] floatValue]){
                            
                            sureText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"kmcsl_sl"] floatValue]];
                            
                        }
                    }
                    else {
                        
                        [self.view makeToast:@"请输入递增数量的整数倍" duration:2 position:@"center"];
                    }
                } else{
                
                if ([sureText.text intValue] % [[firstDic objectForKey:@"jaje"] intValue] == 0) {
                    if ([sureText.text floatValue] < [[firstDic objectForKey:@"zxzrbj"] floatValue]) {
                        sureText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"zxzrbj"] floatValue]];
                    }else if ([sureText.text floatValue] > [[firstDic objectForKey:@"kmcsl"] floatValue]){
                        
                        sureText.text = [NSString stringWithFormat:@"%.2f",[[firstDic objectForKey:@"kmcsl"] floatValue]];
                        
                    }
                }
                else {
                
                [self.view makeToast:@"请输入递增金额的整数倍" duration:2 position:@"center"];
                }
            }
        
        [self refershBtn];
        [self refreshPrice];
        }
    } else if (textField == transferText){
        
        if([self rangeString:sureText.text] > 1){
            [self.view makeToast:@"请输入正确的金额" duration:2.0 position:@"center"];
            
        } else {
            transferText.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
         
            if ([[firstDic objectForKey:@"gqlb"] isEqualToString:@"98"]) {
                
                NSString *sxjizhunjia = [NSString stringWithFormat:@"%.2f",[[firstDic  objectForKey:@"zgbj"]  floatValue]];
                NSString *xxjizhunjia = [NSString stringWithFormat:@"%.2f",[[firstDic  objectForKey:@"zdbj"] floatValue]];
                if ([transferText.text floatValue] > [sxjizhunjia floatValue]) {
                    transferText.text = sxjizhunjia;
                } else if([transferText.text floatValue] < [xxjizhunjia floatValue]){
                    
                    transferText.text = xxjizhunjia;
                    
                }
            } else {
            
     NSString *sxjizhunjia = [NSString stringWithFormat:@"%.2f",[[firstDic  objectForKey:@"zgbj"] floatValue]];
       NSString *xxjizhunjia = [NSString stringWithFormat:@"%.2f",[[firstDic  objectForKey:@"zdbj"] floatValue]];
        if ([transferText.text floatValue] > [sxjizhunjia floatValue]) {
            transferText.text = sxjizhunjia;
        } else if([transferText.text floatValue] < [xxjizhunjia floatValue]){
        
         transferText.text = xxjizhunjia;
        
        }
        }
    }
        [self refershBtn1];
        [self refreshPrice1];
    }

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    
    if(!basicTest)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入数字"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
        return NO;
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}


- (NSInteger)rangeString:(NSString *)string {
    int Num = 0;
    NSString *lastStr = @".";
    for (int i = 0; i < string.length; i++) {
        NSString *newStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([lastStr isEqualToString:newStr]) {
            Num ++;
            //lastStr = newStr;
            NSLog(@"%@",newStr);
        }
    }
    return Num;
}



#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //[changeView endEditing:YES];
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

- (IBAction)transferMethods:(id)sender {
    if (firstDic.count != 0) {
        AppDelegate *deletate =(AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([[deletate.dictionary objectForKey:@"isSetCert"] boolValue]) {
            
            if ([[deletate.dictionary objectForKey:@"isBingingCard"] boolValue]) {
                if ([[deletate.dictionary objectForKey:@"isSetDealpwd"] boolValue]) {
                    changeView.hidden = NO;
                    _transferBtn.hidden = YES;
                }else {
                    
                    [self.view makeToast:@"请先设置交易密码" duration:1 position:@"center"];
                }
                
            } else {
                
                [self.view makeToast:@"请先绑定银行卡" duration:1 position:@"center"];
                
            }
        } else {
            
            [self.view makeToast:@"请完善实名认证" duration:1 position:@"center"];
            
        }
        
    }
   
}
- (IBAction)back:(id)sender {
   // AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   // delegate.isON = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
