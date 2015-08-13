//
//  MainViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-16.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MainViewController1.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "UserBackViewController.h"
#import "MessgeCenterViewController.h"
#import "MyUserMangerViewController.h"
#import "RegesterViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@interface MainViewController1 ()
{
    float addHight;
     NSMutableArray *imageArray;
     UIScrollView *scrollView;
     UIPageControl *pageControl;
     UIScrollView *backScrollView;
    NSMutableArray *dataList;
    NSString *flagHub;
  
}
@end

@implementation MainViewController1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationController setNavigationBarHidden:YES];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([flagHub isEqualToString:@"0"]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       // hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [self requestLogin:kBusinessTagGetJRhotproject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }
    
    AppDelegate *delate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if ( [delate.strlogin isEqualToString:@"2"]||[delate.strlogin isEqualToString:@"1"]) {
        _regerster.hidden = YES;
       
         
    } else {
     _regerster.hidden = NO;
    
    }
   
    
    if (delate.logingUser.count > 0) {
        if ([[delate.logingUser objectForKey:@"success"] boolValue] == YES) {
           _titleLab.text = [[delate.logingUser objectForKey:@"object"]objectForKey:@"username"];
        } else {
        
         _titleLab.text = @"";
        }
        
    } else {
    
    _titleLab.text = @"";
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(ScreenHeight > 568){
        
        _autoSizeScaleY = (ScreenHeight - 64 - 49 - 20)/435;
        
    }else{
        _autoSizeScaleY = 1.0;
    }
    
    
    
    
    flagHub = @"";
    [self.navigationController setNavigationBarHidden:YES];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    
    //[self getUI];
   
    
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + addHight , ScreenWidth,  ScreenHeight - 64  - 49)];
    
    [backScrollView setContentSize:CGSizeMake(ScreenWidth, 455*_autoSizeScaleY)];
    [self.view addSubview:backScrollView];
    
    
    NSArray *arrName = @[@"我的收藏",@"添金投公告",@"添金投新闻"];
    NSArray *arrImg = @[@"xing",@"public_img",@"news_img"];
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,  320*_autoSizeScaleY + 115/3*i*_autoSizeScaleY + 20, ScreenWidth, 115/3*_autoSizeScaleY)];
        view.backgroundColor = [UIColor whiteColor];
        
        //加边框
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        [subView setBackgroundColor:[ColorUtil colorWithHexString:@"dedede"]];
        [view addSubview:subView];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10,(115/3*_autoSizeScaleY - 18)/2, 18, 18)];
        img.image = [UIImage imageNamed:[arrImg objectAtIndex:i]];
        view.tag = 3 + i;
        [view addSubview:img];
        
        //名称
        UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(35, (115/3*_autoSizeScaleY - 15)/2, ScreenWidth - 45, 15)];
        labName.text = [arrName objectAtIndex:i];
        labName.font = [UIFont boldSystemFontOfSize:15];
        labName.textColor = [ColorUtil colorWithHexString:@"333333"];
        [view addSubview:labName];
        
        UIImageView *imgTip = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 35, (115/3*_autoSizeScaleY - 20)/2, 20, 20)];
        imgTip.image = [UIImage imageNamed:@"我的账户_06"];
        [view addSubview:imgTip];
        
        
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        
        singleTap2.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
        singleTap2.numberOfTapsRequired = 1;
        [view addGestureRecognizer:singleTap2];
        
        [backScrollView addSubview:view];
    }
    
   
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //[self requestLogin:kBusinessTagGetJRhotproject];
        [self requestUpdateLinkMan];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud1.dimBackground = YES; //加层阴影
    hud1.mode = MBProgressHUDModeIndeterminate;
    hud1.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self requestLogin:kBusinessTagGetJRhotproject];
        //[self requestUpdateLinkMan];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

    
}


- (void)requestUpdateLinkMan
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求修改联系人");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:@"ios" forKey:@"client"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRcarouselImgUrl owner:self];
    
}

/*
//轮播图
-(void)getUI {
    
    NSString *imageStr1 = [NSString stringWithFormat:@"%@/res/images/xm/slide/slide1.jpg",SERVERURL];
    NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",SERVERURL,@"/res/images/xm/slide/slide2.jpg"];
    NSString *imageStr3 = [NSString stringWithFormat:@"%@/res/images/xm/slide/slide3.jpg",SERVERURL];
    NSString *imageStr4 = [NSString stringWithFormat:@"%@/res/images/xm/slide/slide4.jpg",SERVERURL];
    NSString *imageStr5 = [NSString stringWithFormat:@"%@%@",SERVERURL,@"/res/images/xm/slide/slide5.jpg"];
    
    
    imageArray = @[imageStr1,imageStr2,imageStr3,imageStr4,imageStr5];
    CGRect bound=CGRectMake(0, 44 + addHight, ScreenWidth, 120);
    
    scrollView = [[UIScrollView alloc] initWithFrame:bound];
   
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    //隐藏水平滑动条
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    [scrollView flashScrollIndicators];
    [self.view addSubview:scrollView];
    
    
    
    
    
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth/4 ,44 + addHight +100,ScreenWidth,10)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    pageControl.numberOfPages = [imageArray count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self.view addSubview:pageControl];
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * i) + ScreenWidth, 0, ScreenWidth, 120)];
        [imageView1 setTag:i + 10000];
        [imageView1 setImageWithURL:[imageArray objectAtIndex:i]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            success:^(UIImage *image) {
                                
                                //[[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"myCacheKey%d",i]];
                                
                            }
         
                            failure:^(NSError *error) {
                                
                                UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:i + 10000];
                                icon.image = [UIImage imageNamed:@"xd1"];
                                
                            }];
        
        [scrollView addSubview:imageView1];
        
        
    }
    
    
    // 取数组最后一张图片 放在第0页
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    imgView.tag = 4 + 10000;
    [imgView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageArray.count - 1]]
            placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                     success:^(UIImage *image) {
                         
                     }
     
                     failure:^(NSError *error) {
                         
                         UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:4 + 10000];
                         icon.image = [UIImage imageNamed:@"xd1"];
                         
                         
                     }];
    
    [scrollView addSubview:imgView];
    
    // 取数组第一张图片 放在最后1页
    
    UIImageView *imgViewl = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 120)];
    imgViewl.tag = 5 + 10000;
    [imgViewl setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]]
             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                      success:^(UIImage *image) {
                          
                      }
     
                      failure:^(NSError *error) {
                          
                          UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:5 + 10000];
                          icon.image = [UIImage imageNamed:@"xd1"];
                          
                      }];
    
    // 添加第1页在最后 循环
    [scrollView addSubview:imgViewl];
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 120)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,120) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页


}

*/



- (void)recivedCategoryList:(NSMutableArray *)dataArray
{
    dataList = dataArray;
    
    for (int i = 0; i < 3; i++) {
        UIView *dayview;
        UILabel *numYQH;
        UILabel *lab;
        UILabel *nameLab;
        if (i == 1) {
          dayview = [[UIView alloc] initWithFrame:CGRectMake(0, 150*_autoSizeScaleY, ScreenWidth/2 - 1, 90*_autoSizeScaleY)];
            dayview.backgroundColor = [UIColor whiteColor];
            dayview.tag = 1;
           numYQH = [[UILabel alloc] init];
            lab = [[UILabel alloc] init];
            //续存期
             nameLab = [[UILabel alloc] initWithFrame:CGRectMake(64.5, 13 + 90*(_autoSizeScaleY - 1)/2, ScreenWidth/2 - 70, 14)];
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, 70 + 90*(_autoSizeScaleY - 1)/2, 40, 12)];
            dateLabel.text = [NSString stringWithFormat:@"%@天",[[dataList objectAtIndex:i] objectForKey:@"ZRRQ"]];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
            // dateLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:dateLabel];
            
            UILabel *tipdate = [[UILabel alloc] initWithFrame:CGRectMake( 50, 70 + 90*(_autoSizeScaleY - 1)/2, 110, 12)];
            tipdate.text = [[dataList objectAtIndex:i] objectForKey:@"FXMS"];
            tipdate.font = [UIFont systemFontOfSize:12];
            tipdate.textColor = [ColorUtil colorWithHexString:@"333333"];
            // moneyLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:tipdate];
            
            //加边框
            UIView *viewBack1 = [[UIView alloc] initWithFrame:CGRectMake(0,dayview.frame.size.height - 0.5, ScreenWidth/2 - 1, 0.5)];
            viewBack1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
            [dayview addSubview:viewBack1];
            
        } else if (i == 2) {
            dayview = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 150*_autoSizeScaleY, ScreenWidth/2, 90*_autoSizeScaleY)];
            dayview.backgroundColor = [UIColor whiteColor];
            dayview.tag = 2;
            numYQH = [[UILabel alloc] init];
            lab = [[UILabel alloc] init];
             nameLab = [[UILabel alloc] initWithFrame:CGRectMake(64.5, 13 + 90*(_autoSizeScaleY - 1)/2, ScreenWidth/2 - 70, 14)];
            //续存期
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 10, 70 + 90*(_autoSizeScaleY - 1)/2, 40, 12)];
            dateLabel.text = [NSString stringWithFormat:@"%@天",[[dataList objectAtIndex:i] objectForKey:@"ZRRQ"]];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
            // dateLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:dateLabel];
            
            UILabel *tipdate = [[UILabel alloc] initWithFrame:CGRectMake( 50, 70 + 90*(_autoSizeScaleY - 1)/2, ScreenWidth/2 - 50, 12)];
            tipdate.text = [[dataList objectAtIndex:i] objectForKey:@"FXMS"];
            tipdate.font = [UIFont systemFontOfSize:12];
            tipdate.textColor = [ColorUtil colorWithHexString:@"333333"];
            // moneyLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:tipdate];
            
            
            //加边框
            UIView *viewBack1 = [[UIView alloc] initWithFrame:CGRectMake(0, dayview.frame.size.height - 0.5, ScreenWidth/2, 0.5)];
            viewBack1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
            [dayview addSubview:viewBack1];
            
            
            
            
        } else if (i == 0) {
       dayview =  [[UIView alloc] initWithFrame:CGRectMake(0, 10 +  90*_autoSizeScaleY + 150*_autoSizeScaleY, ScreenWidth, 80*_autoSizeScaleY)];
            dayview.backgroundColor = [UIColor whiteColor];
            
           //加边框
            UIView *viewBack1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            viewBack1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
            [dayview addSubview:viewBack1];
            
            UIView *viewBack2 = [[UIView alloc] initWithFrame:CGRectMake(0, dayview.frame.size.height - 0.5, ScreenWidth, 0.5)];
            viewBack2.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
            [dayview addSubview:viewBack2];
            
            
            dayview.tag = i;
            numYQH = [[UILabel alloc] init];
            lab = [[UILabel alloc] init];
            
             nameLab = [[UILabel alloc] initWithFrame:CGRectMake(64.5, 13+ 90*(_autoSizeScaleY - 1)/2, ScreenWidth - 75, 14)];
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 95, 40+ 90*(_autoSizeScaleY - 1)/2, 40, 12)];
            dateLabel.text = [NSString stringWithFormat:@"%@天",[[dataList objectAtIndex:i] objectForKey:@"ZRRQ"]];
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
            // dateLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:dateLabel];
            
            UILabel *tipdate = [[UILabel alloc] initWithFrame:CGRectMake( 135, 40+ 90*(_autoSizeScaleY - 1)/2, 110, 12)];
            tipdate.text = [[dataList objectAtIndex:i] objectForKey:@"FXMS"];
            tipdate.font = [UIFont systemFontOfSize:12];
            tipdate.textColor = [ColorUtil colorWithHexString:@"333333"];
            // moneyLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:tipdate];
          
  //赠送
            UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake( 95, 70 - 13 + 90*(_autoSizeScaleY - 1)/2, ScreenWidth - 120, 13)];
            giveLabel.text = @"赠1万体验金   享7天收益";
            giveLabel.font = [UIFont systemFontOfSize:13];
            giveLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
            // dateLabel.textAlignment = NSTextAlignmentCenter;
            [dayview addSubview:giveLabel];
            
            
            
            
            
            
            CGRect frame = CGRectMake(ScreenWidth - 60, 30+ 90*(_autoSizeScaleY - 1)/2, 44, 44);
            MDRadialProgressTheme *newTheme12 = [[MDRadialProgressTheme alloc] init];
            newTheme12.centerColor = [UIColor clearColor];
            newTheme12.sliceDividerHidden = NO;
            newTheme12.labelColor = [UIColor blackColor];
            newTheme12.labelShadowColor = [UIColor whiteColor];
            
            
            MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme12];
            radialView.progressTotal = 100;
            radialView.startingSlice = 75;
            radialView.theme.thickness = 10;
            radialView.theme.sliceDividerHidden = YES;
            
            int kt;
        if ([[[dataList objectAtIndex:i] objectForKey:@"flag"] boolValue]) {
            kt = [[[dataList objectAtIndex:i] objectForKey:@"TZJD"] intValue];
            
            } else {
             kt = 100;
            }
            radialView.progressCounter = kt;
         
            radialView.theme.sliceDividerHidden = YES;
            radialView.theme.incompletedColor = [ColorUtil colorWithHexString:@"eeeeee"];
            
            if (kt == 0) {
              radialView.theme.completedColor = [ColorUtil colorWithHexString:@"eeeeee"];
            } else{
            radialView.theme.completedColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
            }
            [dayview addSubview:radialView];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 85, -6, 75 , 25)];
            img.image = [UIImage imageNamed:@"首页03_03"];
            [dayview addSubview:img];
            
            
            
            
        }
        UILabel *labF1 = [[UILabel  alloc] initWithFrame:CGRectMake(10, 10+ 90*(_autoSizeScaleY - 1)/2, 17, 17)];
        labF1.font = [UIFont boldSystemFontOfSize:17];
        labF1.text = @"稀";
        labF1.textColor = [UIColor redColor];
        [dayview addSubview:labF1];
        
        UILabel *labF2 = [[UILabel  alloc] initWithFrame:CGRectMake(27, 12+ 90*(_autoSizeScaleY - 1)/2, 37.5, 15)];
        labF2.font = [UIFont boldSystemFontOfSize:15];
        labF2.text = @"金保-";
        labF2.textColor = [UIColor blackColor];
        [dayview addSubview:labF2];
        
        
       // NSString *string = [[[dataList objectAtIndex:1] objectForKey:@"GQMC"] substringFromIndex:5];//截取下标7之后的字符串
       // NSString *string = [[dataList objectAtIndex:1] objectForKey:@"GQMC"];
        //名称
        NSString *b;
        if ([[[dataList objectAtIndex:i] objectForKey:@"GQMC"] length] >5 ) {
         b = [[[dataList objectAtIndex:i] objectForKey:@"GQMC"] substringFromIndex:5];
        } else {
        
            b = [[dataList objectAtIndex:i] objectForKey:@"GQMC"];
        }
        
       
        nameLab.text = b;
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.textColor = [ColorUtil colorWithHexString:@"333333"];
        [dayview addSubview:nameLab];
        
        
       // numYQH = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 65, 25)];
        numYQH.text = [[dataArray objectAtIndex:i] objectForKey:@"SYL"];
        numYQH.font = [UIFont systemFontOfSize:25];
        numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
        if (i == 0) {
        numYQH.frame = CGRectMake(10, 40 + 90*(_autoSizeScaleY - 1)/2, titleSize.width, 25);
             lab.frame = CGRectMake(10 + titleSize.width, 40 + 90*(_autoSizeScaleY - 1)/2 + 12, 15, 13);
        } else {
        numYQH.frame = CGRectMake(10, 35 + 90*(_autoSizeScaleY - 1)/2, titleSize.width, 25);
            lab.frame = CGRectMake(10 + titleSize.width, 60 - 13 + 90*(_autoSizeScaleY - 1)/2, 15, 13);
        }
        [dayview addSubview:numYQH];
        
        
        lab.text = @"%";
        lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        lab.font = [UIFont systemFontOfSize:13];
        [dayview addSubview:lab];
        
        
       
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
        
        singleTap.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
        singleTap.numberOfTapsRequired = 1;
        [dayview addGestureRecognizer:singleTap];
        [backScrollView addSubview:dayview];
        
        
    }
    
    
    
    
    
    
    
//日金宝
//名称
   // nameLab.text = [[dataArray objectAtIndex:1] objectForKey:@"GQMC"];
   
//百分比
   
    //yearLab.text = [[dataArray objectAtIndex:1] objectForKey:@"SYWZ"];

    
// 洗金宝
//名称
   
    //nameyueLab.text = [[dataArray objectAtIndex:2] objectForKey:@"GQMC"];
    
    
//百分比
      // yueLab.text = [[dataArray objectAtIndex:2] objectForKey:@"SYWZ"];
   
    
//名称
   
   // newLab.text = [[dataArray objectAtIndex:0] objectForKey:@"GQMC"];
    
//百分比
  
    //newlab.text = [[dataArray objectAtIndex:0] objectForKey:@"SYWZ"];
  
    
}


- (IBAction)callPhone:(UITouch *)sender
{
    UIView *view = [sender view];
    if (view.tag == 3) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (delegate.logingUser.count > 0) {
            if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
                MessgeCenterViewController *cv = [[MessgeCenterViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            } else {
               // delegate.strlogin = @"2";
                LoginViewController *VC = [[LoginViewController alloc] init];
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
                

            }
            
        } else {
           // delegate.strlogin = @"2";
            LoginViewController *VC = [[LoginViewController alloc] init];
            
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            
        }
        
    } else if (view.tag == 4) {
        UserBackViewController *cv = [[UserBackViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    } else if (view.tag == 5) {
        MyUserMangerViewController *cv = [[MyUserMangerViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    } else {
    
    DetailViewController *cv = [[DetailViewController alloc] init];
    cv.flagbtn = NO;
    
    
    cv.title = [[dataList objectAtIndex:view.tag] objectForKey:@"GQMC"];
    cv.strGqdm = [[dataList objectAtIndex:view.tag] objectForKey:@"GQDM"];
    cv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cv animated:YES];
    
    }
    
}

#pragma mark - Recived Methods
//处理修改联系人
- (void)recivedUpdateLinkMan:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"修改联系人");
    
    if ([imageArray count] > 0) {
        [imageArray removeAllObjects];
        for (NSDictionary *object in dataArray) {
            [imageArray addObject:object];
        }
    } else {
        imageArray = dataArray;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //保存数组的个数
    
    NSNumber *num = [NSNumber numberWithInteger:imageArray.count];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:num forKey:@"arrCount"];
    [userDefault synchronize];
    
    
    //imageArray = @[imageStr1,imageStr2,imageStr3,imageStr4,imageStr5];
    CGRect bound=CGRectMake(0, 0, ScreenWidth, 150*_autoSizeScaleY);
    
    scrollView = [[UIScrollView alloc] initWithFrame:bound];
   
    //scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    //隐藏水平滑动条
    scrollView.showsVerticalScrollIndicator = FALSE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    [scrollView flashScrollIndicators];
    [backScrollView addSubview:scrollView];
    
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth*3/4,150*_autoSizeScaleY - 20,ScreenWidth/4,10)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.38]];
    pageControl.numberOfPages = [imageArray count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [backScrollView addSubview:pageControl];
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * i) + ScreenWidth, 0, ScreenWidth, 150*_autoSizeScaleY)];
        [imageView1 setTag:i + 10000];
        [imageView1 setImageWithURL:[imageArray objectAtIndex:i]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            success:^(UIImage *image) {
                                
                                [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"myCacheKey%d",i]];
                                
                            }
         
                            failure:^(NSError *error) {
                                
                                UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:i + 10000];
                                icon.image = [UIImage imageNamed:@"xd1"];
                                
                            }];
        
        [scrollView addSubview:imageView1];
        
        
    }
    
    
    // 取数组最后一张图片 放在第0页
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150*_autoSizeScaleY)];
    imgView.tag = 4 + 10000;
    [imgView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageArray.count - 1]]
            placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                     success:^(UIImage *image) {
                         
                     }
     
                     failure:^(NSError *error) {
                         
                         UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:4 + 10000];
                         icon.image = [UIImage imageNamed:@"xd1"];
                         
                         
                     }];
    
    [scrollView addSubview:imgView];
    
    // 取数组第一张图片 放在最后1页
    
    UIImageView *imgViewl = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 150*_autoSizeScaleY)];
    imgViewl.tag = 5 + 10000;
    [imgViewl setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]]
             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                      success:^(UIImage *image) {
                          
                      }
     
                      failure:^(NSError *error) {
                          
                          UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:5 + 10000];
                          icon.image = [UIImage imageNamed:@"xd1"];
                          
                      }];
    
    // 添加第1页在最后 循环
    [scrollView addSubview:imgViewl];
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 150*_autoSizeScaleY)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150*_autoSizeScaleY) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    
}


#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    //[paraDic setObject:_userN forKey:@"username"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    if ([[jsonDic objectForKey:@"object"] isKindOfClass:[NSString class]]) {
        
        if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.logingUser removeAllObjects];
            [delegate.dictionary removeAllObjects];
            [ASIHTTPRequest setSessionCookies:nil];
           // LogOutViewController *cv = [[LogOutViewController alloc] init];
           // cv.hidesBottomBarWhenPushed = YES;
            //[self.navigationController pushViewController:cv animated:YES];
        }
    }else {
    
    
    
    
    NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
	if (tag== kBusinessTagGetJRhotproject) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2.0 position:@"center"];
            //            subing = NO;
        } else {
           // [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"登录成功!"];
            flagHub = @"1";
            [self recivedCategoryList:dataArray];
        
        }
    }else if (tag==kBusinessTagGetJRcarouselImgUrl ) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
           // [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"下载图片失败"];
            //            subing = NO;
        } else {
            [self recivedUpdateLinkMan:dataArray];
        }
    }
}
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   // [[NetworkModule sharedNetworkModule] cancel:tag];
}
-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
   
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alert show];
    
    [self.view makeToast:@"您所在地的网络信号微弱，无法连接到服务" duration:1 position:@"center"];
    
    flagHub = @"0";
     if (tag==kBusinessTagGetJRcarouselImgUrl) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (imageArray.count == 0) {
             
             imageArray = [[NSMutableArray alloc] init];
             NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
             NSNumber *arr = [userDefault objectForKey:@"arrCount"];
             NSInteger count = [arr integerValue];
             if (count > 0) {
                 
                 for (int i = 0; i < count; i++) {
                     UIImage *icon = [[SDImageCache sharedImageCache] imageFromKey:[NSString stringWithFormat:@"myCacheKey%d",i]];
                     if (icon == nil) {
                         icon = [UIImage imageNamed:@"xd1"];
                         [imageArray addObject:icon];
                     } else {
                         
                         [imageArray addObject:icon];
                     }
                 }
                 
                CGRect bound=CGRectMake(0, 0, ScreenWidth, 150*_autoSizeScaleY);
                 
                 scrollView = [[UIScrollView alloc] initWithFrame:bound];
                 [scrollView setBackgroundColor:[UIColor grayColor]];
                 scrollView.bounces = YES;
                 scrollView.pagingEnabled = YES;
                 scrollView.delegate = self;
                 scrollView.userInteractionEnabled = YES;
                 scrollView.showsVerticalScrollIndicator = FALSE;
                 scrollView.showsHorizontalScrollIndicator = FALSE;
                 [backScrollView addSubview:scrollView];
                 
                 // 初始化 pagecontrol
                 pageControl =  [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth*3/4 ,150*_autoSizeScaleY - 20,ScreenWidth/4,10)]; // 初始化mypagecontrol
                 //[pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
                 //[pageControl setPageIndicatorTintColor:[UIColor blackColor]];
                 [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
                 [pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.38]];
                 pageControl.numberOfPages = imageArray.count;
                 pageControl.currentPage = 0;
                 [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
                 [backScrollView addSubview:pageControl];
                 
                 
                 for (int i = 0; i < imageArray.count; i++) {
                     UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * i) + ScreenWidth, 0, ScreenWidth, 150*_autoSizeScaleY)];
                     imageView1.image = [imageArray objectAtIndex:i];
                     [scrollView addSubview:imageView1];
                     
                 }
                 
                 
                 // 取数组最后一张图片 放在第0页
                 
                 UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150*_autoSizeScaleY)];
                 // UIImageView *icon = [slideImages objectAtIndex:slideImages.count -1];
                 imgView.image = [imageArray objectAtIndex:imageArray.count -1];
                 [scrollView addSubview:imgView];
                 
                 // 取数组第一张图片 放在最后1页
                 
                 imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 150*_autoSizeScaleY)];
                 
                 //icon = [slideImages objectAtIndex:0];
                 imgView.image = [imageArray objectAtIndex:0];
                 
                 // 添加第1页在最后 循环
                 [scrollView addSubview:imgView];
                 
                 [scrollView setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 150*_autoSizeScaleY)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
                 [scrollView setContentOffset:CGPointMake(0, 0)];
                 [scrollView scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150*_autoSizeScaleY) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
                 
             }
         }
         
     }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   // [[NetworkModule sharedNetworkModule] cancel:tag];
}





- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pagewidth/([imageArray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pagewidth/ ([imageArray count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [scrollView scrollRectToVisible:CGRectMake(ScreenWidth * [imageArray count],0,ScreenWidth,150*_autoSizeScaleY) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([imageArray count]+1))
    {
        [scrollView scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150*_autoSizeScaleY) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    [scrollView scrollRectToVisible:CGRectMake(ScreenWidth*(page+1),0,ScreenWidth,150*_autoSizeScaleY) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    page++;
    page = page > (imageArray.count - 1) ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
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

- (IBAction)regerster:(id)sender {
    RegesterViewController *cv = [[RegesterViewController alloc] init];
    cv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cv animated:YES];
    
}
@end
