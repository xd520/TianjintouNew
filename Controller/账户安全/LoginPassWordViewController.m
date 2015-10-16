//
//  LoginPassWordViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "LoginPassWordViewController.h"
#import "AppDelegate.h"
#import "AddreesssViewController.h"
#import "PassWordMangerViewController.h"
#import "Child.h"
#import "NameRealSuccessViewController.h"

@interface LoginPassWordViewController ()
{
    UILabel *sheetLab;
    int count;
     UITextField *SelectLable;
     UIImageView *isOpenView;
    float addHight;
    Child *child;
    
    NSString *notStarDate;
    NSString *notEddDate;
}
@end

@implementation LoginPassWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

    
    for (int i = 0; i < 6; i++) {
        UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(10, addHight + 44 + 80 + 40*i, ScreenWidth - 10, 1)];
        viewline.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
        [self.view addSubview:viewline];
    }
    
    //_realName.text = @"熊永辉";
    
    //_sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //_sureBtn.layer.borderWidth = 1;
    
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    
    
    //self.sheetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[self.sheetBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    // _sheetBtn.titleLabel.text = @"获取验证码";
    
    self.sheetBtn.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
   // self.sheetBtn.enabled = NO;
    //self.sheetBtn.layer.borderWidth = 1;
    
    self.sheetBtn.layer.masksToBounds = YES;
    
    self.sheetBtn.layer.cornerRadius = 2;
    
    _address.text = @"请选择地址";
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetBtn.frame.size.width, self.sheetBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.textAlignment = NSTextAlignmentCenter;
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [UIColor whiteColor];
    sheetLab.backgroundColor = [UIColor clearColor];
    [_sheetBtn addSubview:sheetLab];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    //lastView.tag = 1;
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    self.falemLab.userInteractionEnabled = YES;
    [self.falemLab addGestureRecognizer:singleTap1];
    
   UIButton *bankNumTF = [[UIButton alloc] initWithFrame:CGRectMake(250, 5, 60, 30)];
    bankNumTF.layer.borderWidth = 1;
    bankNumTF.layer.borderColor = [[UIColor blackColor] CGColor];
    //bankNumTF.layer.cornerRadius = 5;
    bankNumTF.backgroundColor = [UIColor whiteColor];
    //[bankNumTF setTitle:@"请输入银行" forState:UIControlStateNormal];
    [bankNumTF addTarget:self action:@selector(showDDList:) forControlEvents:UIControlEventTouchUpInside];
    SelectLable = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,45, 30)];
    SelectLable.font = [UIFont systemFontOfSize:15];
    SelectLable.textAlignment = NSTextAlignmentLeft;
    //SelectLable.textColor = [ColorUtil colorWithHexString:@"7f7f7f"];
    //SelectLable.backgroundColor = [UIColor grayColor];
   // SelectLable.placeholder = @"男";
    SelectLable.enabled = NO;
     SelectLable.text = @"男";
    SelectLable.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [bankNumTF addSubview:SelectLable];
    isOpenView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 5/2 + 5, 15, 15)];
    isOpenView.image = [UIImage imageNamed:@"dropdown.png"];
    [bankNumTF addSubview:isOpenView];
    
    
    //[_firstMaileView addSubview:bankNumTF];
    
    _realName.clearButtonMode = UITextFieldViewModeWhileEditing;
     _passNum.clearButtonMode = UITextFieldViewModeWhileEditing;
     _detailAdd.clearButtonMode = UITextFieldViewModeWhileEditing;
     _oldPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldPassWord.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
     _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWord.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
     _passWordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordAgain.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
}

//身份证号码验证
#pragma mark - 身份证识别
-(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}





-(void)showDDList:(UIButton *)btn {
    if (count%2 == 0) {
        if (_ddList) {
            [_ddList removeFromParentViewController];
            
        }
        [self reloadDDList];
        isOpenView.image = [UIImage imageNamed:@"dropup.png"];
        [self setDDListHidden:NO];
        
    } else {
        isOpenView.image = [UIImage imageNamed:@"dropdown.png"];
        [self setDDListHidden:YES];
    }
    count++;
    
}


-(void)reloadDDList {
    _ddList = [[DDList alloc] initWithStyle:UITableViewStylePlain];
    _ddList._delegate = self;
    
    [self.view addSubview:_ddList.view];
    [_ddList.view setFrame:CGRectMake(ScreenWidth - 90, 65 + addHight, 80, 0)];
    //[self setDDListHidden:YES];
    count = 0;
    
}


- (void)setDDListHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0 : 70;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [_ddList.view setFrame:CGRectMake(ScreenWidth - 90, 65 + addHight, 80, height)];
    [UIView commitAnimations];
}

#pragma mark PassValue protocol
- (void)passValue:(NSString *)value{
    if (value) {
        SelectLable.text = value;
        [self setDDListHidden:YES];
        isOpenView.image = [UIImage imageNamed:@"dropdown.png"];
        count = 0;
    }
    else {
        
    }
}


- (void)passBankCode:(NSString *)value{
   // bankName = value;
}



- (IBAction)callPhone:(UITouch *)sender
{
    AddreesssViewController *cv = [[AddreesssViewController alloc] init];
    cv.logiVC = self;
    cv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cv animated:YES];
}


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark-文本框代理方法


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = textField.frame;
   
    int offset = frame.origin.y + 76 - (self.view.frame.size.height - 256.0);//键盘高度216
    //动画
    /*
     NSTimeInterval animationDuration = 0.3f;
     [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
     [UIView setAnimationDuration:animationDuration];
     */
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}



- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if (IOS_VERSION_7_OR_ABOVE) {
    //        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    //    }else{
    // [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    }
    
    if (textField == _realName) {
        NSString *emailRegex = @"^[\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if (!sfzNo) {
            //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
            [self.view makeToast:@"请输入正确的用户名" duration:1.0 position:@"center"];
            _realName.text = @"";
        }

    } else if(textField == _passNum){
            if (_passNum.text.length == 18 || _passNum.text.length == 15) {
                NSString *emailRegex = @"^[0-9]*$";
                NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
                bool sfzNo = [emailTest evaluateWithObject:[_passNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                
                if (_passNum.text.length == 15) {
                    if (!sfzNo) {
                        //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
                        [self.view makeToast:@"请输入正确的身份证号" duration:1.0 position:@"center"];
                        _passNum.text = @"";
                    }
                } else if (_passNum.text.length == 18) {
                    bool sfz18NO = [self checkIdentityCardNo:_passNum.text];
                    if (!sfz18NO) {
                        //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
                        [self.view makeToast:@"请输入正确的身份证号" duration:1.0 position:@"center"];
                        _passNum.text = @"";
                   
                }
                
            } else {
                //证件验证
                [self.view makeToast:@"请输入正确身份证号" duration:1.0 position:@"center"];
                _passNum.text = @"";
            }
            
            } else {
                [self.view makeToast:@"请输入正确身份证号" duration:1.0 position:@"center"];
                _passNum.text = @"";
            
            }
    
    } else if (textField == _oldPassWord) {
        if (_oldPassWord.text.length != 6) {
            [self.view makeToast:@"请输入6位数交易密码" duration:1.0 position:@"center"];
        }
    
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == _oldPassWord ||textField == _passWord)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
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
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}




//监听方法

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"%@",change);
    
     if ([[change objectForKey:@"new"] integerValue] <= 0) {
        
        sheetLab.text = @"获取验证码";
        
        _sheetBtn.enabled = YES;
         _sheetBtn.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
          [child removeObserver:self forKeyPath:@"age"];
        
    } else {
        
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        
        _sheetBtn.enabled = NO;
        _sheetBtn.backgroundColor = [UIColor grayColor];
        
    }
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
    
    if (tag== kBusinessTagGetJRsmrzsendVcode) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:1.0 position:@"center"];
            //[self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"登录成功!"];
            //注册观察者
            child = [[Child alloc] init];
            child.age = [[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue];
            [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];
           
        }
    } else if (tag== kBusinessTagGetJRsmrzRealNameAuthentication) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        child.age = 0;
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:1.0 position:@"center"];
            //            subing = NO;
        } else {
            
            
//                        NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//                        //删除最后一个，也就是自己
//                        UIViewController *vc = [array objectAtIndex:array.count-3];
//                        if (vc.view.tag != 9) {
                            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            [delegate.dictionary setValue:[NSNumber numberWithBool:1] forKey:@"isSetCert"];
                            [delegate.dictionary setValue:[NSNumber numberWithBool:1] forKey:@"isSetDealpwd"];
                      //  }
                        
            NameRealSuccessViewController *nameVC = [[NameRealSuccessViewController alloc] initWithNibName:@"NameRealSuccessViewController" bundle:nil];
            nameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nameVC animated:YES];
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
    _sheetBtn.enabled = NO;
    
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

- (IBAction)sheetMethods:(id)sender {
    
    _sheetBtn.enabled = NO;
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRsmrzsendVcode owner:self];
}

- (IBAction)back:(id)sender {
    
    
       [self.navigationController popViewControllerAnimated:YES];
   
    
    
}
- (IBAction)sureMethods:(id)sender {
    
     
    [self.view endEditing:YES];
    
    if ([_realName.text isEqualToString:@""]) {
      [self.view makeToast:@"请输入正确的姓名" duration:1.0 position:@"center"];
    } else if ([_passNum.text isEqualToString:@""]){
      [self.view makeToast:@"请输入正确的身份证号码" duration:1.0 position:@"center"];
    } else if ([_oldPassWord.text isEqualToString:@""]){
      [self.view makeToast:@"请输入正确的交易密码" duration:1.0 position:@"center"];
    }else if (_oldPassWord.text.length != 6){
        [self.view makeToast:@"请输入6位数的交易密码" duration:1.0 position:@"center"];
    }else if ([_falemLab.text isEqualToString:@""]||_falemLab.text == nil){
        [self.view makeToast:@"请选择性别" duration:1.0 position:@"center"];
    }else if (![_passWord.text isEqualToString:_oldPassWord.text]){
      [self.view makeToast:@"请输入正确的交易密码" duration:1.0 position:@"center"];
        _passWord.text = @"";
    }else if ([_passWordAgain.text isEqualToString:@""]){
       [self.view makeToast:@"请输入正确的手机验证码" duration:1.0 position:@"center"];
    } else if (_oldPassWord.text.length != 6) {
        [self.view makeToast:@"请输入6位数交易密码" duration:1.0 position:@"center"];
    } else {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        
        [paraDic setObject:_passNum.text forKey:@"idCard"];
        [paraDic setObject:_realName.text forKey:@"name"];
        [paraDic setObject:@"" forKey:@"province"];
        [paraDic setObject:@"" forKey:@"city"];
        [paraDic setObject:[[Base64XD encodeBase64String:_oldPassWord.text] strBase64] forKey:@"password"];
        [paraDic setObject:_passWordAgain.text forKey:@"phoneCaptcha"];
        if ([_falemLab.text isEqualToString:@"男"]) {
            [paraDic setObject:@"1" forKey:@"xb"];
        } else {
        [paraDic setObject:@"2" forKey:@"xb"];
        }
        
        [paraDic setObject:@"" forKey:@"dz"];
        [paraDic setObject:@"" forKey:@"zjlb"];
        
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRsmrzRealNameAuthentication owner:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    }
}


-(void)dealloc {

    [child removeObserver:self forKeyPath:@"age"];
    
}



@end
