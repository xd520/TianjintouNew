//
//  FirstViewCtrl.m
//  添金投
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "FirstViewCtrl.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "DetailViewController.h"

@interface FirstViewCtrl ()
{
    float addHight;
    UIScrollView *scrollViewImage;
    UIPageControl *pageControl;
    NSMutableArray *imageArray;
    NSString *flagHub;
    NSMutableArray *dataListFirst;
    
    UIScrollView *backScrollView;
    
    float sizeScaleX;
    
    
}

@end

@implementation FirstViewCtrl


CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
     float autoSizeScaleX;
    
    if(ScreenWidth > 320){
        
        autoSizeScaleX = ScreenWidth/320;
        
        
    }else{
        autoSizeScaleX = 1.0;
    }
    
    
    
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX; rect.origin.y = y * autoSizeScaleX;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleX;
    return rect;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([flagHub isEqualToString:@"0"]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [self requestLogin:kBusinessTagGetJRwdtzloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor = [ColorUtil colorWithHexString:@"f6c209"];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    
    if(ScreenWidth > 320){
        
        sizeScaleX = ScreenWidth/320;
        
        
    }else{
        sizeScaleX = 1.0;
    }
    
    
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addHight , ScreenWidth, ScreenHeight - 20  - 49)];
    
    backScrollView.showsVerticalScrollIndicator = FALSE;
    backScrollView.showsHorizontalScrollIndicator = FALSE;
   // backScrollView.delegate = self;
    backScrollView.bounces = NO;
     backScrollView.pagingEnabled = YES;
    //backScrollView.contentInset = UIEdgeInsetsZero;
    backScrollView.scrollEnabled = YES;
    if (ScreenWidth == 320) {
        [backScrollView setContentSize:CGSizeMake(ScreenWidth, 568 - 20 - 49)];
    } else {
        [backScrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight - 20 - 49)];
    }
    
    [self.view addSubview:backScrollView];
    
    
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud1.dimBackground = YES; //加层阴影
    hud1.mode = MBProgressHUDModeIndeterminate;
    hud1.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //[self requestLogin:kBusinessTagGetJRhotproject];
        [self requestUpdateLinkMan];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self requestLogin:kBusinessTagGetJRhotproject];
        
       // [self requestLogin:kBusinessTagGetJRwdtzloadData];
        
        //[self requestUpdateLinkMan];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
}

/*
-(void)viewDidLayoutSubviews
{
    
    if (ScreenWidth == 320) {
        [backScrollView setContentSize:CGSizeMake(ScreenWidth, 568 - 20 -49)];
    } else {
        [backScrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight - 20 - 49)];
    }

    
   // backScrollView.contentSize = CGSizeMake(ScreenWidth,568);
}
*/

#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    //[paraDic setObject:_userN forKey:@"username"];
    
    //[paraDic setObject:_sort forKey:@"sortName"];
    //[paraDic setObject:_val forKey:@"sortVal"];
    [paraDic setObject:@"1" forKey:@"pageSize"];
    [paraDic setObject:@"1" forKey:@"pageIndex"];
    
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}


- (void)requestUpdateLinkMan
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求修改联系人");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:@"ios" forKey:@"client"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRcarouselImgUrl owner:self];
    
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
    CGRect bound=CGRectMake(0, 0, ScreenWidth, 150*sizeScaleX);
    
    scrollViewImage = [[UIScrollView alloc] initWithFrame:bound];
    
    //scrollView.bounces = YES;
    scrollViewImage.pagingEnabled = YES;
    scrollViewImage.delegate = self;
    scrollViewImage.userInteractionEnabled = YES;
    //隐藏水平滑动条
    scrollViewImage.showsVerticalScrollIndicator = FALSE;
    scrollViewImage.showsHorizontalScrollIndicator = FALSE;
    [scrollViewImage flashScrollIndicators];
    [backScrollView addSubview:scrollViewImage];
    
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth - 90,150*sizeScaleX - 20,80,10)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[ColorUtil colorWithHexString:@"e3a325"]];
    [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    pageControl.numberOfPages = [imageArray count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [backScrollView addSubview:pageControl];
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * i) + ScreenWidth, 0, ScreenWidth, 150*sizeScaleX)];
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
        
        [scrollViewImage addSubview:imageView1];
        
        
    }
    
    
    // 取数组最后一张图片 放在第0页
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150*sizeScaleX)];
    imgView.tag = 4 + 10000;
    [imgView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageArray.count - 1]]
            placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                     success:^(UIImage *image) {
                         
                     }
     
                     failure:^(NSError *error) {
                         
                         UIImageView *icon = (UIImageView *)[(UIImageView *)self.view viewWithTag:4 + 10000];
                         icon.image = [UIImage imageNamed:@"xd1"];
                         
                         
                     }];
    
    [scrollViewImage addSubview:imgView];
    
    // 取数组第一张图片 放在最后1页
    
    UIImageView *imgViewl = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 150*sizeScaleX)];
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
    [scrollViewImage addSubview:imgViewl];
    
    [scrollViewImage setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 150*sizeScaleX)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [scrollViewImage setContentOffset:CGPointMake(0, 0)];
    [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150*sizeScaleX) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    
}

- (void)recivedCategoryListFirst:(NSMutableArray *)dataArray
{
    dataListFirst = dataArray;
   
    UIImageView *backimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150*sizeScaleX + 10, ScreenWidth,ScreenWidth*400/320)];
    backimgView.image = [UIImage imageNamed:@"big_bg-1"];
    backimgView.userInteractionEnabled = YES;
    
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake1(160 + 45, 20, 50, 20)];
    lab.text = [NSString stringWithFormat:@"%@天",[[dataListFirst objectAtIndex:0] objectForKey:@"QX"]];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15*sizeScaleX];
    lab.backgroundColor = [UIColor clearColor];
    [backimgView addSubview:lab];
    
     UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = [[dataArray objectAtIndex:0] objectForKey:@"SYL"];
    lab1.textColor = [ColorUtil colorWithHexString:@"f08200"];
   // lab1.textAlignment = NSTextAlignmentCenter;
    
    
    
     CGSize titleSize = [lab1.text sizeWithFont:[UIFont systemFontOfSize:45] constrainedToSize:CGSizeMake(MAXFLOAT, 55)];
    lab1.frame = CGRectMake1(100, 55, titleSize.width, 45);
    lab1.font = [UIFont systemFontOfSize:45*sizeScaleX];
    lab1.backgroundColor = [UIColor clearColor];
    [backimgView addSubview:lab1];
    
     UILabel *labBai = [[UILabel alloc] initWithFrame:CGRectMake1(100 + titleSize.width, 100 - 19 , 14, 14)];
    labBai.text = @"%";
    labBai.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    labBai.font = [UIFont systemFontOfSize:14*sizeScaleX];
    [backimgView addSubview:labBai];
    
    
 //投资进度
    UILabel *labgress = [[UILabel alloc] initWithFrame:CGRectMake1(60, 150, 70, 25)];
    labgress.text = @"投资进度";
    labgress.textColor = [ColorUtil colorWithHexString:@"898989"];
    labgress.textAlignment = NSTextAlignmentCenter;
    labgress.font = [UIFont systemFontOfSize:13*sizeScaleX];
    lab.backgroundColor = [UIColor clearColor];
    [backimgView addSubview:labgress];
    
    
    UILabel *labgressTip = [[UILabel alloc] initWithFrame:CGRectMake1(60, 170, 70, 25)];
    
    float kt;
    if ([[[dataListFirst objectAtIndex:0] objectForKey:@"flag"] boolValue]) {
        kt = [[[dataListFirst objectAtIndex:0] objectForKey:@"TZJD"] floatValue];
        
    } else {
        kt = 100;
    }
   
    
    labgressTip.text = [NSString stringWithFormat:@"%.2f%@",kt,@"%"];
    labgressTip.textColor = [ColorUtil colorWithHexString:@"898989"];
    labgressTip.textAlignment = NSTextAlignmentCenter;
    labgressTip.font = [UIFont systemFontOfSize:15*sizeScaleX];
    lab.backgroundColor = [UIColor clearColor];
    [backimgView addSubview:labgressTip];
    
 //认购起点
    UILabel *labStar = [[UILabel alloc] initWithFrame:CGRectMake1(320 - 130, 150, 70, 25)];
    labStar.text = @"认购起点";
    labStar.textColor = [ColorUtil colorWithHexString:@"898989"];
    labStar.textAlignment = NSTextAlignmentCenter;
    labStar.font = [UIFont systemFontOfSize:15*sizeScaleX];
    lab.backgroundColor = [UIColor clearColor];
    [backimgView addSubview:labStar];
    
    
    UILabel *labStarTip = [[UILabel alloc] initWithFrame:CGRectMake1(320 - 130, 170, 320 - 130 -20, 25)];
    labStarTip.text = [NSString stringWithFormat:@"%@元",[[dataListFirst objectAtIndex:0] objectForKey:@"QDJE"]];
    labStarTip.textColor = [ColorUtil colorWithHexString:@"898989"];
   // labStarTip.textAlignment = NSTextAlignmentCenter;
    labStarTip.font = [UIFont systemFontOfSize:15*sizeScaleX];
    labStarTip.backgroundColor = [UIColor clearColor];
    [backimgView addSubview:labStarTip];
    
    
    UILabel *labNew = [[UILabel alloc] initWithFrame:CGRectMake1(50, 210, 320 - 100, 25)];
    labNew.text = @"新用户注册15元添金币活动券";
    labNew.textColor = [ColorUtil colorWithHexString:@"f08200"];
    labNew.textAlignment = NSTextAlignmentCenter;
    labNew.font = [UIFont systemFontOfSize:16*sizeScaleX];
    lab.backgroundColor = [UIColor clearColor];
    //[backimgView addSubview:labNew];
    
    
    UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake1(30, 225,260 , 35)];
    buyBtn.backgroundColor = [ColorUtil colorWithHexString:@"f6c209"];
    buyBtn.layer.cornerRadius = 17.5*sizeScaleX;
    buyBtn.layer.masksToBounds = YES;
    [buyBtn setTintColor:[UIColor whiteColor]];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(pushDetail) forControlEvents:UIControlEventTouchUpInside];
     [backimgView addSubview:buyBtn];
    
    
    UILabel *labVersons = [[UILabel alloc] initWithFrame:CGRectMake1(50, 300, 320 - 100, 15)];
    labVersons.text = @"版权所有 © 天津股权交易所";
    labVersons.textColor = [ColorUtil colorWithHexString:@"9a9a9a"];
    labVersons.textAlignment = NSTextAlignmentCenter;
    labVersons.font = [UIFont systemFontOfSize:12*sizeScaleX];
    lab.backgroundColor = [UIColor clearColor];
    [backimgView addSubview:labVersons];
    
    
    UILabel *labHao = [[UILabel alloc] initWithFrame:CGRectMake1(50, 315, 320 - 100, 15)];
    labHao.text = @"津ICP备08102316号";
    labHao.textColor = [ColorUtil colorWithHexString:@"9a9a9a"];
    labHao.textAlignment = NSTextAlignmentCenter;
    labHao.font = [UIFont systemFontOfSize:12*sizeScaleX];
    lab.backgroundColor = [UIColor clearColor];
    [backimgView addSubview:labHao];
    
    
    [backScrollView addSubview:backimgView];
    
}


-(void)pushDetail{
    DetailViewController *cv = [[DetailViewController alloc] init];
    
        cv.flagbtn = [[dataListFirst objectAtIndex:0] objectForKey:@"flag"];
        
    
   // cv.flagStr = [[dataListFirst objectAtIndex:0] objectForKey:@"flag"];
    
    cv.title = [[dataListFirst objectAtIndex:0] objectForKey:@"GQMC"];
    cv.strGqdm = [[dataListFirst objectAtIndex:0] objectForKey:@"GQDM"];
     cv.hidesBottomBarWhenPushed = YES;
    //  [menuController pushViewController:cv animated:YES];
    
    // cv.modalTransitionStyle = UIModalTransitionStyle;
    
    // [self presentViewController:cv animated:YES completion:nil];
    [self.navigationController pushViewController:cv animated:YES];

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
            if (tag== kBusinessTagGetJRhotproject) {
            NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
            
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2.0 position:@"center"];
                //            subing = NO;
            } else {
                // [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:@"登录成功!"];
                flagHub = @"1";
               
                [self recivedCategoryListFirst:dataArray];
                
            }
            
        }else if (tag==kBusinessTagGetJRcarouselImgUrl ) {
            NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                // [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:@"下载图片失败"];
                //            subing = NO;
            } else {
                if (dataArray.count == 0 || dataArray == nil) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                } else{
                
                [self recivedUpdateLinkMan:dataArray];
                }
            }
        }
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     [[NetworkModule sharedNetworkModule] cancel:tag];
    }
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
                
                CGRect bound=CGRectMake(0, 0, ScreenWidth, 150*sizeScaleX);
                
                scrollViewImage = [[UIScrollView alloc] initWithFrame:bound];
                [scrollViewImage setBackgroundColor:[UIColor grayColor]];
                scrollViewImage.bounces = YES;
                scrollViewImage.pagingEnabled = YES;
                scrollViewImage.delegate = self;
                scrollViewImage.userInteractionEnabled = YES;
                scrollViewImage.showsVerticalScrollIndicator = FALSE;
                scrollViewImage.showsHorizontalScrollIndicator = FALSE;
                [backScrollView addSubview:scrollViewImage];
                
                // 初始化 pagecontrol
                //pageControl =  [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth*3/4 ,150 - 20,ScreenWidth/4,10)];
                
                pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth - 90,150*sizeScaleX - 20,80,10)]; // 初始化mypagecontrol
                [pageControl setCurrentPageIndicatorTintColor:[ColorUtil colorWithHexString:@"e3a325"]];
                [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
                
                
                // 初始化mypagecontrol
                //[pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
                //[pageControl setPageIndicatorTintColor:[UIColor blackColor]];
                //[pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
                //[pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:1 alpha:0.38]];
                pageControl.numberOfPages = imageArray.count;
                pageControl.currentPage = 0;
                [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
                [backScrollView addSubview:pageControl];
                
                
                for (int i = 0; i < imageArray.count; i++) {
                    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * i) + ScreenWidth, 0, ScreenWidth, 150*sizeScaleX)];
                    imageView1.image = [imageArray objectAtIndex:i];
                    [scrollViewImage addSubview:imageView1];
                    
                }
                
                
                // 取数组最后一张图片 放在第0页
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150*sizeScaleX)];
                // UIImageView *icon = [slideImages objectAtIndex:slideImages.count -1];
                imgView.image = [imageArray objectAtIndex:imageArray.count -1];
                [scrollViewImage addSubview:imgView];
                
                // 取数组第一张图片 放在最后1页
                
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 150*sizeScaleX)];
                
                //icon = [slideImages objectAtIndex:0];
                imgView.image = [imageArray objectAtIndex:0];
                
                // 添加第1页在最后 循环
                [scrollViewImage addSubview:imgView];
                
                [scrollViewImage setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 150*sizeScaleX)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
                [scrollViewImage setContentOffset:CGPointMake(0, 0)];
                [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150*sizeScaleX) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
                
            }
        }
        
    }else if (tag == kBusinessTagUserGetList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }  else if (tag == kBusinessTagGetStatus) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else if (tag == kBusinessTagGetIndustry) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else if (tag == kBusinessTagGetProvince) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else if (tag == kBusinessTagGetCity) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = scrollViewImage.frame.size.width;
    int page = floor((scrollViewImage.contentOffset.x - pagewidth/([imageArray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}


// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    CGFloat pagewidth = scrollViewImage.frame.size.width;
    int currentPage = floor((scrollViewImage.contentOffset.x - pagewidth/ ([imageArray count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth * [imageArray count],0,ScreenWidth,150*sizeScaleX) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([imageArray count]+1))
    {
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150) animated:NO]; // 最后+1,循环第1页
    }
    //pageControl.currentPage = currentPage;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth*(page+1),0,ScreenWidth,150*sizeScaleX) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc {
    
   [scrollViewImage removeFromSuperview];
    scrollViewImage = nil;
    
    [pageControl removeFromSuperview];
    pageControl = nil;
    [imageArray removeAllObjects];
    imageArray = nil;
    [dataListFirst removeAllObjects];
    dataListFirst = nil;
    
    [backScrollView removeFromSuperview];
    backScrollView = nil;
   

}

@end
