//
//  MyInvestViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-10.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyInvestViewController.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "PorductViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "HMSegmentedControl.h"
#import "TransferDetailsViewController.h"

#define TSEGSCROLLVIEW 10005
@interface MyInvestViewController ()
{
    UITableView *table;
    UITableView *tablePast;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    
    NSString *startPast;
    NSString *startBakPast;
    NSString *limitPast;
    NSMutableArray *dataListPast;
    BOOL hasMorePast;
    UITableViewCell *moreCellPast;
    
    
    SRRefreshView   *_slimeViewPast;
    SRRefreshView   *_slimeView;
    NSString *allGqlb;
    float addHight;
    
    NSInteger count;
    NSInteger indext;
    NSInteger tipcount;
    NSInteger tipindext;
    
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;
    
    
    UILabel *tiplab1;
    UILabel *tiplab2;
    UILabel *tiplab3;
    UILabel *tiplab4;
    
    
    
    UISegmentedControl *segmentedControl;
    
    
    NSString *sortName;
    NSString *sortVal;
    NSString *sortNamePast;
    NSString *sortValPast;
    UISegmentedControl  *segmented;
}


@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation MyInvestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     startBakPast = [NSString stringWithString:startPast];
    startPast = @"1";
    sortNamePast = @"";
    sortValPast = @"";
      [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1Again];
}

-(void) segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %li",(long)Index);
     __weak typeof(self) weakSelf = self;
    if (Seg.selectedSegmentIndex == 0) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
    } else if(Seg.selectedSegmentIndex == 1){
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
       
        
    }
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    start = @"1";
    limit = @"10";
    startBak = @"";
    startPast = @"1";
    limitPast = @"10";
    startBakPast = @"";
    
    sortName = @"";
    sortVal = @"";
    sortNamePast = @"";
    sortValPast = @"";
    
    count = 0;
    indext = 0;
    tipcount = 0;
    tipindext = 0;
    [self.navigationController setNavigationBarHidden:YES];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
    
    addHight = 0;
    }
    
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"投资专区",@"转让专区",nil];
    
  segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    segmented.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    segmented.tintColor= [UIColor whiteColor];
    
    //[segmented setTintColor:[UIColor whiteColor]]; //设置segments的颜色
    //[segmented setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    
    
    
    segmented.frame = CGRectMake(20, 7, ScreenWidth - 40, 30);
    
    
    
    segmented.multipleTouchEnabled = NO;
    segmented.segmentedControlStyle = UISegmentedControlStyleBezeled;
    
    [segmented addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.title_img addSubview:segmented];
    
    
   
    //给segmentedControl添加scrollView的联动事件
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 49;
     /*
    __weak typeof(self) weakSelf = self;
    
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(320 * index, 0, 320, scrollViewHeight) animated:YES];
    }];
    */
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44 + addHight, ScreenWidth, scrollViewHeight)];
     
    self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*2, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 64, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    NSArray *titleArr = @[@"默认",@"预期收益↑",@"投资期限↑",@"起投金额↑"];
    float autoSizeScaleX,autoSizeScaleY;
    if(ScreenHeight > 480){
        autoSizeScaleX = ScreenWidth/320;
        autoSizeScaleY = ScreenHeight/568;
    }else{
        autoSizeScaleX = 1.0;
        autoSizeScaleY = 1.0;
    }
    
    
    //↓
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] init];
       
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];

        if (i == 0) {
            
             btn.frame = CGRectMake(0, 0, 55*autoSizeScaleX, 40);
            
            lab1 = [[UILabel alloc] init];
            lab1.frame = CGRectMake(0, 5, 55*autoSizeScaleX-0.5, 30);
            lab1.text = [titleArr objectAtIndex:i];
            lab1.textAlignment = NSTextAlignmentCenter;
            lab1.font = [UIFont systemFontOfSize:13];
            //lab1.userInteractionEnabled = YES;
            lab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            [btn addSubview:lab1];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(55*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
             } else if(i == 1){
                  btn.frame = CGRectMake(55*autoSizeScaleX, 0, 87.5*autoSizeScaleX, 40);
                 lab2 = [[UILabel alloc] init];
                 lab2.frame = CGRectMake(0, 5, 87.5*autoSizeScaleX - 0.5, 30);
                 lab2.text = [titleArr objectAtIndex:i];
                 lab2.font = [UIFont systemFontOfSize:13];
                 lab2.textAlignment = NSTextAlignmentCenter;
                 lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
                 //lab2.userInteractionEnabled = YES;
                 lab2.textColor = [UIColor grayColor];
                 [btn addSubview:lab2];
                 UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(87.5*autoSizeScaleX -0.5, 12.5, 0.5, 15)];
                 img.image = [UIImage imageNamed:@"line_iocn"];
                 [btn addSubview:img];
             } else if(i == 2){
                  btn.frame = CGRectMake((55 + 87.5)*autoSizeScaleX, 0, 87.5*autoSizeScaleX, 40);
                 lab3 = [[UILabel alloc] init];
                 lab3.frame = CGRectMake(0, 5, 87.5*autoSizeScaleX - 0.5, 30);
                 lab3.text = [titleArr objectAtIndex:i];
                 lab3.font = [UIFont systemFontOfSize:13];
                 lab3.textAlignment = NSTextAlignmentCenter;
                  lab3.textColor = [ColorUtil colorWithHexString:@"999999"];
                 //lab3.userInteractionEnabled = YES;
                 lab3.textColor = [UIColor grayColor];
                 [btn addSubview:lab3];
                 UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(87.5*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
                 img.image = [UIImage imageNamed:@"line_iocn"];
                 [btn addSubview:img];
             }else if(i == 3){
                 btn.frame = CGRectMake((55 + 175)*autoSizeScaleX, 0, 90*autoSizeScaleX, 40);
                 lab4 = [[UILabel alloc] init];
                 lab4.frame = CGRectMake(0, 5, 90*autoSizeScaleX, 30);
                 lab4.text = [titleArr objectAtIndex:i];
                 lab4.font = [UIFont systemFontOfSize:13];
                 lab4.textColor = [ColorUtil colorWithHexString:@"999999"];
                 lab4.textAlignment = NSTextAlignmentCenter;
                 //lab4.userInteractionEnabled = YES;
                 lab4.textColor = [UIColor grayColor];
                 [btn addSubview:lab4];
                
             }
        
       // btn.titleLabel.font = [UIFont systemFontOfSize:13];
        //btn.titleLabel.textColor = [UIColor redColor];
        
        [btn addTarget:self action:@selector(secelectMenthosd:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        
    }
    
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] init];
       // btn.frame = CGRectMake(ScreenWidth + 80*i, 0, 80, 40);
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];
        //[btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        //[btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        // [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (i == 0) {
             btn.frame = CGRectMake(ScreenWidth + 0, 0, 55*autoSizeScaleX, 40);
            tiplab1 = [[UILabel alloc] init];
            tiplab1.frame = CGRectMake(0, 5, 55*autoSizeScaleX - 0.5, 30);
            tiplab1.text = [titleArr objectAtIndex:i];
            tiplab1.textAlignment = NSTextAlignmentCenter;
            tiplab1.font = [UIFont systemFontOfSize:13];
            //lab1.userInteractionEnabled = YES;
            tiplab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            [btn addSubview:tiplab1];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(55*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else if(i == 1){
             btn.frame = CGRectMake(ScreenWidth + 55*autoSizeScaleX, 0, 87.5*autoSizeScaleX, 40);
            tiplab2 = [[UILabel alloc] init];
            tiplab2.frame = CGRectMake(0, 5, 87.5*autoSizeScaleX - 0.5, 30);
            tiplab2.text = [titleArr objectAtIndex:i];
            tiplab2.font = [UIFont systemFontOfSize:13];
            tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
            tiplab2.textAlignment = NSTextAlignmentCenter;
            //lab2.userInteractionEnabled = YES;
            tiplab2.textColor = [UIColor grayColor];
            [btn addSubview:tiplab2];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake( 87.5*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else if(i == 2){
             btn.frame = CGRectMake(ScreenWidth + (55 + 87.5)*autoSizeScaleX, 0, 87.5*autoSizeScaleX, 40);
            tiplab3 = [[UILabel alloc] init];
            tiplab3.frame = CGRectMake(0, 5, 87.5*autoSizeScaleX - 0.5, 30);
            tiplab3.text = [titleArr objectAtIndex:i];
            tiplab3.font = [UIFont systemFontOfSize:13];
            tiplab3.textAlignment = NSTextAlignmentCenter;
            tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
            //lab3.userInteractionEnabled = YES;
            tiplab3.textColor = [UIColor grayColor];
            [btn addSubview:tiplab3];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(87.5*autoSizeScaleX - 0.5, 12.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        }else if(i == 3){
             btn.frame = CGRectMake(ScreenWidth + (55 + 175)*autoSizeScaleX, 0, 90*autoSizeScaleX, 40);
            tiplab4 = [[UILabel alloc] init];
            tiplab4.frame = CGRectMake(0, 5, 90*autoSizeScaleX, 30);
            tiplab4.text = [titleArr objectAtIndex:i];
            tiplab4.font = [UIFont systemFontOfSize:13];
            tiplab4.textAlignment = NSTextAlignmentCenter;
            tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
            //lab4.userInteractionEnabled = YES;
            tiplab4.textColor = [UIColor grayColor];
            [btn addSubview:tiplab4];
            
        }
        
        // btn.titleLabel.font = [UIFont systemFontOfSize:13];
        //btn.titleLabel.textColor = [UIColor redColor];
        
        [btn addTarget:self action:@selector(secelectMenthosd1:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        
    }

    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth,scrollViewHeight - 40)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:table];
    
    //加入下拉刷新
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    [table addSubview:_slimeView];
    
    
    
    
    //添加tableView
    
    tablePast = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth,40, ScreenWidth, scrollViewHeight - 40)];
    [tablePast setDelegate:self];
    [tablePast setDataSource:self];
    tablePast.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tablePast setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
    tablePast.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:tablePast];
    
    //加入下拉刷新
    _slimeViewPast = [[SRRefreshView alloc] init];
    _slimeViewPast.delegate = self;
    _slimeViewPast.upInset = 0;
    _slimeViewPast.slimeMissWhenGoingBack = YES;
    _slimeViewPast.slime.bodyColor = [UIColor blackColor];
    _slimeViewPast.slime.skinColor = [UIColor whiteColor];
    _slimeViewPast.slime.lineWith = 1;
    _slimeViewPast.slime.shadowBlur = 4;
    _slimeViewPast.slime.shadowColor = [UIColor blackColor];
    [tablePast addSubview:_slimeViewPast];
    
    
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadData];
         //投资专区
         [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
        
        //转让专区
        [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    //[self requestCategoryClassList:kBusinessTagGetJRloadData];
  
    //搜索按钮
    //[self.searchBtn addTarget:(DEMONavigationController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


-(void)secelectMenthosd1:(UIButton *)btn {
    
    // NSArray *titleArr = @[@"默认",@"预期收益↑",@"投资期限↑",@"起投金额↑"];
    //↓
    
    if (btn.tag == tipcount) {
        tipindext++;
    } else {
        tipcount = btn.tag;
        tipindext = 0;
    }
    
    if (btn.tag == 0) {
        tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        sortNamePast = @"FID_WTH";
        sortValPast = @"";
        
    } else if (btn.tag == 1) {
        // lab2.textColor = [UIColor grayColor];
        tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        sortNamePast = @"FID_SYL";
        if (tipindext%2 == 0) {
            tiplab2.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab2.text = @"预期收益↑";
            sortValPast = @"ASC";
        } else {
            
            tiplab2.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab2.text = @"预期收益↓";
            sortValPast = @"DESC";
        }
        
        
    } else if (btn.tag == 2){
        tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        //lab3.textColor = [UIColor grayColor];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        sortNamePast = @"FID_SYTS";
        if (tipindext%2 == 0) {
            tiplab3.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab3.text = @"投资期限↑";
             sortValPast = @"ASC";
        } else {
            
            tiplab3.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab3.text = @"投资期限↓";
            sortValPast = @"DESC";
        }
        
    } else if (btn.tag == 3) {
        tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        // lab4.textColor = [UIColor grayColor];
        tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"999999"];
         sortNamePast = @"FID_CJJE";
        if (tipindext%2 == 0) {
            tiplab4.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab4.text = @"起投金额↑";
            sortValPast = @"ASC";
        } else {
            
            tiplab4.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            tiplab4.text = @"起投金额↓";
            sortValPast = @"DESC";
        }
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadDataAgain];
        
        startPast = @"1";
        //转让专区
        [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1Again];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        });
    });
    
   
}


- (void)requestTransferList:(NSString *)_start limit:(NSString *)_limit sortName:(NSString *)_sort val:(NSString *)_val tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求品牌列表");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    //获取类别信息
    [paraDic setObject:_sort forKey:@"sortName"];
    [paraDic setObject:_val forKey:@"sortVal"];
    [paraDic setObject:_limit forKey:@"pageSize"];
    [paraDic setObject:_start forKey:@"pageNo"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}





- (void)requestList:(NSString *)_start limit:(NSString *)_limit sortName:(NSString *)_sort val:(NSString *)_val tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求品牌列表");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    //获取类别信息
    [paraDic setObject:_sort forKey:@"sortName"];
    [paraDic setObject:_val forKey:@"sortVal"];
    [paraDic setObject:_limit forKey:@"pageSize"];
    [paraDic setObject:_start forKey:@"pageIndex"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}




-(void)secelectMenthosd:(UIButton *)btn {
    
    // NSArray *titleArr = @[@"默认",@"预期收益↑",@"投资期限↑",@"起投金额↑"];
    //↓
    
    
    if (btn.tag == count) {
        indext++;
    } else {
    count = btn.tag;
        indext = 0;
    }
    
    
    if (btn.tag == 0) {
       lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        
        sortName = @"";
        sortVal = @"";
        
    } else if (btn.tag == 1) {
       // lab2.textColor = [UIColor grayColor];
        lab4.textColor = [UIColor grayColor];
        lab3.textColor = [UIColor grayColor];
        lab1.textColor = [UIColor grayColor];
        
        sortName = @"pmll";
        
        if (indext%2 == 0) {
            lab2.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab2.text = @"预期收益↑";
             sortVal = @"asc";
            
        } else {
        
        lab2.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab2.text = @"预期收益↓";
            sortVal = @"desc";
        }
        
    
    
     
    } else if (btn.tag == 2){
        lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        //lab3.textColor = [UIColor grayColor];
        lab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        sortName = @"tzqx";
        
        if (indext%2 == 0) {
            lab3.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab3.text = @"投资期限↑";
             sortVal = @"asc";
        } else {
            
            lab3.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab3.text = @"投资期限↓";
             sortVal = @"desc";
        }
    
    } else if (btn.tag == 3) {
        lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
       // lab4.textColor = [UIColor grayColor];
        lab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab1.textColor = [ColorUtil colorWithHexString:@"999999"];
        
         sortName = @"qscpxx";
        if (indext%2 == 0) {
            lab4.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab4.text = @"起投金额↑";
             sortVal = @"asc";
        } else {
            
            lab4.textColor = [ColorUtil colorWithHexString:@"fe8103"];
            lab4.text = @"起投金额↓";
             sortVal = @"desc";
        }
        
    
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //[self requestCategoryList:start limit:limit tag:kBusinessTagGetJRwdtzloadDataAgain];
        
        start = @"1";
        [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadDataAgain];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        });
    });
    
    
}


#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == TSEGSCROLLVIEW) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        segmented.selectedSegmentIndex = page;
       // [self.segmentedControl setSelectedSegmentIndex:page animated:YES];

    }
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView == _slimeView) {
        
        lab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        
        startBak = [NSString stringWithString:start];
        start = @"1";
        
        sortName = @"";
        sortVal = @"";
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
             [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadDataAgain];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
            });
        });
   
    } else if (refreshView == _slimeViewPast){
        
      
        tiplab2.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab4.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab3.textColor = [ColorUtil colorWithHexString:@"999999"];
        tiplab1.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        
        startBakPast = [NSString stringWithString:startPast];
        startPast = @"1";
        sortNamePast = @"";
        sortValPast = @"";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
           
            
             [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1Again];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    
    
    }
    
    
    
}
#pragma mark - UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == table) {
        [_slimeView scrollViewDidScroll];
    } else {
    [_slimeViewPast scrollViewDidScroll];
    
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == table) {
        [_slimeView scrollViewDidEndDraging];
    } else {
    
    [_slimeViewPast scrollViewDidEndDraging];
    }
    
}

- (void)tableView:(UITableView *)tbleView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tbleView == table) {
        
    
    if ([indexPath row] == [dataList count]) {
        if (hasMore) {
            for (UILabel *label in [cell.contentView subviews]) {
                if ([label.text isEqualToString:@"*****正在加载*****"]) {
                    
                } else {
                    
                    label.text = @"*****正在加载*****";
                  
                  [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        }
    }
    }else if (tbleView == tablePast){
     if ([indexPath row] == [dataListPast count]) {
        if (hasMorePast) {
            for (UILabel *label in [cell.contentView subviews]) {
                if ([label.text isEqualToString:@"*****正在加载*****"]) {
                    
                } else {
                    
                    label.text = @"*****正在加载*****";
                    
                     [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        }
    }
    }
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == table) {
        if ([dataList count] == 0) {
            return 1;
        } else if (hasMore) {
            return [dataList count] + 1;
        } else {
            return [dataList count];
        }
    } else {
        
        if ([dataListPast count] == 0) {
            return 1;
        } else if (hasMorePast) {
            return [dataListPast count] + 1;
        } else {
            return [dataListPast count];
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if (tbleView == table) {
    
    if ([dataList count] == 0) {
        if (YES) {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
            [backView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
            //图标
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
            tipLabel.backgroundColor = [UIColor clearColor];
            [tipLabel setText:@"没有任何商品哦~"];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
        }
    } else {
        if ([indexPath row] == [dataList count]) {
            moreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
            moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
            [moreCell setBackgroundColor:[UIColor clearColor]];
            moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
            [toastLabel setFont:[UIFont systemFontOfSize:12]];
            toastLabel.backgroundColor = [UIColor clearColor];
            [toastLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
            toastLabel.numberOfLines = 0;
            toastLabel.text = @"更多...";
            toastLabel.textAlignment = NSTextAlignmentCenter;
            [moreCell.contentView addSubview:toastLabel];
            return moreCell;
        } else {
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 105)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 95)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth - 40, 15)];
                brandLabel.font = [UIFont systemFontOfSize:15];
                [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
               // brandLabel.numberOfLines = 0;
                brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"cpmc"];
                [backView addSubview:brandLabel];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 49, ScreenWidth - 20, 1)];
                lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
                //[backView addSubview:lineView];
                
                /*
                //预期年华
                NSArray *titleArr = @[@"预期年化",@"存续期",@"起购金额",@"进度"];
                for (int i = 0;i < 4;i++) {
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 * i, 55, ScreenWidth/4, 15)];
                    lab.text = [titleArr objectAtIndex:i];
                    lab.font = [UIFont systemFontOfSize:15];
                    lab.textColor = [ColorUtil colorWithHexString:@"666666"];
                    lab.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:lab];
                }
                */
                //数字开始
                UILabel *numYQH = [[UILabel alloc] init];
                numYQH.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"gzll"];
                numYQH.font = [UIFont systemFontOfSize:28];
                numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
               CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 28)];
                numYQH.frame = CGRectMake(10, 45, titleSize.width, 28);
                [backView addSubview:numYQH];
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, 71 - 13, 13, 13)];
                lab.text = @"%";
                lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                lab.font = [UIFont systemFontOfSize:13];
                [backView addSubview:lab];
                
                
                //续存期
                
                UILabel *dateLabel = [[UILabel alloc] init];
                dateLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"tzqx"];
                dateLabel.font = [UIFont systemFontOfSize:12];
                dateLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
                 titleSize = [dateLabel.text sizeWithFont:dateLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 12)];
                
                dateLabel.frame = CGRectMake(ScreenWidth/4 + 20, 43, titleSize.width, 12);
                
                
                 [backView addSubview:dateLabel];
                
              
                UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 20 + titleSize.width, 43, 12, 12)];
                dayLabel.text = @"天";
                dayLabel.font = [UIFont systemFontOfSize:12];
                dayLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:dayLabel];
                
                
                
                
                
                UILabel *tipdate = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 55, 43, 115, 12)];
                tipdate.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"jxfs"];
                tipdate.font = [UIFont systemFontOfSize:12];
                tipdate.textColor = [ColorUtil colorWithHexString:@"333333"];
                // moneyLabel.textAlignment = NSTextAlignmentCenter;
                [backView addSubview:tipdate];
                
                
                
                
                //起购金额
                UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 20, 63, ScreenWidth/2, 17)];
                moneyLabel.text = [NSString stringWithFormat:@"%@元起",[[dataList objectAtIndex:indexPath.row] objectForKey:@"tzje"]];
                moneyLabel.font = [UIFont systemFontOfSize:14];
                moneyLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
               // moneyLabel.textAlignment = NSTextAlignmentCenter;
                [backView addSubview:moneyLabel];
                //剩余可投金额
                //投资进度
               CGRect frame = CGRectMake(ScreenWidth - 70, 35, 44, 44);
                MDRadialProgressTheme *newTheme12 = [[MDRadialProgressTheme alloc] init];
                //newTheme12.completedColor = [UIColor colorWithRed:90/255.0 green:212/255.0 blue:39/255.0 alpha:1.0];
                //newTheme12.incompletedColor = [UIColor colorWithRed:164/255.0 green:231/255.0 blue:134/255.0 alpha:1.0];
                newTheme12.centerColor = [UIColor clearColor];
                //newTheme.centerColor = [UIColor colorWithRed:224/255.0 green:248/255.0 blue:216/255.0 alpha:1.0];
                
                newTheme12.sliceDividerHidden = NO;
                newTheme12.labelColor = [UIColor blackColor];
                newTheme12.labelShadowColor = [UIColor whiteColor];
                
                
                MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme12];
                 radialView.progressTotal = 100;
                radialView.startingSlice = 75;
                radialView.theme.thickness = 10;
                radialView.theme.sliceDividerHidden = YES;
                int kt;
                if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"jyzt"] isEqualToString:@"0"]||[[[dataList objectAtIndex:indexPath.row] objectForKey:@"cz"] isEqualToString:@"1"]||[[[dataList objectAtIndex:indexPath.row] objectForKey:@"flag"] isEqualToString:@"1"]) {
                    kt = 100;
                   radialView.progressCounter = 100;
                   
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 7.5 , 45,35)];
                    imageView.image = [UIImage imageNamed:@"more_icon"];
                    
                    //[backView addSubview:imageView];
                    
                    
                } else{
                    
                    if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"jyzt"] isEqualToString:@"-2"]&& [[[dataList objectAtIndex:indexPath.row] objectForKey:@"cz"] isEqualToString:@"-1"]&& [[[dataList objectAtIndex:indexPath.row] objectForKey:@"cz"] isEqualToString:@"-1"]) {
                        UIView *prowgressView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*3/4 + 20, 80, 40, 18)];
                        prowgressView.layer.borderWidth = 1;
                        prowgressView.layer.borderColor = [UIColor redColor].CGColor;
                        
                         kt =  [[[dataList objectAtIndex:indexPath.row] objectForKey:@"tzjd"] intValue];
                        
                        radialView.progressCounter = kt;
                        
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 7.5 , 45, 35)];
                        
                            imageView.image = [UIImage imageNamed:@"rengou"];
                        
                        //[backView addSubview:imageView];
                        
                        
                        
                    } else {
                       
                    
                        kt =  [[[dataList objectAtIndex:indexPath.row] objectForKey:@"tzjd"] intValue];
                        
                        radialView.progressCounter = kt;
                        
                        
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 45, 7.5 , 45,35)];
                           imageView.image = [UIImage imageNamed:@"jieshu"];
                                               
                        //[backView addSubview:imageView];
                        
                        
                    }
                }
                
                radialView.theme.sliceDividerHidden = YES;
                radialView.theme.incompletedColor = [ColorUtil colorWithHexString:@"eeeeee"];
                if (kt == 0) {
                    radialView.theme.completedColor = [ColorUtil colorWithHexString:@"eeeeee"];
                } else{
                    radialView.theme.completedColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
                }
                [backView addSubview:radialView];
                
                /*
                NSArray *preasent = @[@"%",@"天",@"元"];
                
                for (int i = 0; i< 3; i++) {
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 * i, 80 + 17 + 5, ScreenWidth/4, 13)];
                    lab.text = [preasent objectAtIndex:i];
                    lab.font = [UIFont systemFontOfSize:13];
                    if (i == 0) {
                        lab.textColor = [ColorUtil colorWithHexString:@"c41e1e"];
                    } else {
                        lab.textColor = [ColorUtil colorWithHexString:@"666666"];
                    }
                    lab.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:lab];
                }
                */
                
                [cell.contentView addSubview:backView];
            }
        }
        return cell;
    }
    return cell;
        
    } else if (tablePast == tbleView){
        if ([dataListPast count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
                [backView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [backView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                [tipLabel setText:@"没有任何商品哦~"];
                tipLabel.backgroundColor = [UIColor clearColor];
                [backView addSubview:tipLabel];
                [cell.contentView addSubview:backView];
                
            }
        } else {
            if ([indexPath row] == [dataListPast count]) {
                moreCellPast = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                moreCellPast = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [moreCellPast setBackgroundColor:[UIColor clearColor]];
                moreCellPast.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [moreCellPast.contentView addSubview:toastLabel];
                return moreCellPast;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 105)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 95)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    backView.layer.cornerRadius = 2;
                    backView.layer.masksToBounds = YES;
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] init];
                    brandLabel.font = [UIFont systemFontOfSize:15];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CPMC"];
                    CGSize titleSize = [brandLabel.text sizeWithFont:brandLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
                    
                    brandLabel.frame = CGRectMake(10, 15, titleSize.width, 15);
                    
                    [backView addSubview:brandLabel];
                    
                    
                    if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_KHH"] isEqualToString:[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"khh"]]) {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 15 , 15, 15)];
                        
                        imageView.image = [UIImage imageNamed:@"icon_my"];
                        [backView addSubview:imageView];
                        
                        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(35 + titleSize.width, 15 , 15, 15)];
                        
                        imageView1.image = [UIImage imageNamed:@"icon_buy"];
                        
                        [backView addSubview:imageView1];
                        
                    
                        
                        
                        
                    } else {
                    
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 15 , 15, 15)];
                        
                        imageView.image = [UIImage imageNamed:@"icon_buy"];
                        
                        [backView addSubview:imageView];
                        
                    
                    
                    }
                    

                    
                    //预期年化收益率
                    UILabel *yuqiLabel = [[UILabel alloc] init];
                    yuqiLabel.font = [UIFont systemFontOfSize:28];
                    [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"fe8103"]];
                   // yuqiLabel.textAlignment = NSTextAlignmentRight;
                    yuqiLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_SYL"];
                     titleSize = [yuqiLabel.text sizeWithFont:yuqiLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 28)];
                    
                    yuqiLabel.frame = CGRectMake(10, 48, titleSize.width, 28);
                    
                    [backView addSubview:yuqiLabel];
                    
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, 74 - 13, 15, 13)];
                    lab.text = @"%";
                    lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    lab.font = [UIFont systemFontOfSize:13];
                    [backView addSubview:lab];
                    
                   
                    
                    
                    // 剩余时间
                    
                    UILabel *syLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 30, 42, 60, 17)];
                    syLabel.font = [UIFont systemFontOfSize:13];
                    [syLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                   // syLabel.textAlignment = NSTextAlignmentRight;
                    syLabel.text = [NSString stringWithFormat:@"%@天",[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_SYTS"]];
                    [backView addSubview:syLabel];
                    
                    
                    
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 70, 43, 50, 13)];
                    yuqiLabelTip.textAlignment = NSTextAlignmentRight;
                    yuqiLabelTip.font = [UIFont systemFontOfSize:13];
                    [yuqiLabelTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"转让价格";
                   // [backView addSubview:yuqiLabelTip];
                    
                    //项目价值
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/4 + 30, 63, 30, 13)];
                    valueLabel.font = [UIFont systemFontOfSize:13];
                    [valueLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                   // valueLabel.textAlignment = NSTextAlignmentRight;
                    if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CJ"] hasPrefix:@"-"]) {
                        valueLabel.text = @"加价";
                    } else {
                   
                         valueLabel.text = @"让利";
                    }
                    
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont boldSystemFontOfSize:13];
                    [valueLabelTip setTextColor:[ColorUtil colorWithHexString:@"fe8103"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                    if (![[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CJ"] hasPrefix:@"-"]) {
                    
                    
                    valueLabelTip.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CJ"];
                    } else {
                    
                     valueLabelTip.text = [NSString stringWithFormat:@"%.2f",0 -[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_CJ"] floatValue]];
                    
                    }
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                     titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                    valueLabelTip.frame = CGRectMake( ScreenWidth/4 + 60, 63, titleSize.width, 13);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 63, 120, 13)];
                    flagLabel.font = [UIFont systemFontOfSize:13];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = [NSString stringWithFormat:@"元(约%@天利息)",[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_LXTS"]];
                    [backView addSubview:flagLabel];
                    
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2- 10, 43, 60, 13)];
                    giveLabel.font = [UIFont systemFontOfSize:13];
                    [giveLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"转让价格";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:13];
                    [giveLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] floatValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                    giveLabelTip.frame = CGRectMake(ScreenWidth/2 + 50, 43, titleSize1.width, 13);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 43, 60, 13)];
                    flagLabel1.font = [UIFont systemFontOfSize:13];
                    [flagLabel1 setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    
                    [cell.contentView addSubview:backView];
                }
            }
           // return cell;
        }
     return cell;
    }
     return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == table) {
        if ([indexPath row] == [dataList count]) {
            return 50;
        } else {
            return 105;
        }
  
    } else if (tableView == tablePast){
        if ([indexPath row] == [dataListPast count]) {
            return 50;
        } else {
            return 105;
        }
    }
    
    return 95;
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tbleView == table) {
        
    if (indexPath.row == [dataList count]) {
        for (UILabel *label in [moreCell.contentView subviews]) {
            if ([label.text isEqualToString:@"正在加载中..."]) {
               
            } else {
                label.text = @"正在加载中...";
                [self requestList:start limit:limit sortName:sortName val:sortVal tag:kBusinessTagGetJRwdtzloadData];
                [tbleView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    } else {
      
        DetailViewController *cv = [[DetailViewController alloc] init];
        
        if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"flag"] isEqualToString:@"1"]||[[[dataList objectAtIndex:indexPath.row] objectForKey:@"cz" ] isEqualToString:@"1"]|| [[[dataList objectAtIndex:indexPath.row] objectForKey:@"JYZT" ] isEqualToString:@"0"] ) {
            cv.flagbtn = YES;
        }else {
            cv.flagbtn = NO;
            
        }

        
        cv.title = [[dataList objectAtIndex:indexPath.row] objectForKey:@"cpmc"];
        cv.strGqdm = [[dataList objectAtIndex:indexPath.row] objectForKey:@"gqdm"];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
       
    }
    }else if (tbleView == tablePast){
        if (indexPath.row == [dataListPast count]) {
            for (UILabel *label in [moreCellPast.contentView subviews]) {
                if ([label.text isEqualToString:@"正在加载中..."]) {
                    
                } else {
                    label.text = @"正在加载中...";
                     [self requestTransferList:startPast limit:limitPast sortName:sortNamePast val:sortValPast tag:kBusinessTagGetJRcpzrwytz1];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        } else {
            
           // [self btnActionForUserSetting:self];
            
            TransferDetailsViewController *cv = [[TransferDetailsViewController alloc] init];
            cv.wth = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_WTH"];
            cv.gqdm = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_GQDM"];
            if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_KHH"] isEqualToString:[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"khh"]]) {
                cv.flag = YES;
            } else {
            
             cv.flag = NO;
            
            }
            
            
            
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
            
            
            
        }
    }
}


#pragma mark - Recived Methods
//刷新的时候
- (void)recivedPastList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    if ([dataListPast count] > 0) {
        for (NSDictionary *object in dataArray) {
            [dataListPast addObject:object];
        }
    } else {
        dataListPast = dataArray;
    }
    if ([dataArray count] < 10) {
        hasMorePast = NO;
    } else {
        hasMorePast = YES;
        startPast = [NSString stringWithFormat:@"%d", [startPast intValue] + 1];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [tablePast reloadData];
    [_slimeViewPast endRefresh];
}



#pragma mark - Recived Methods
//刷新的时候
- (void)recivedEndRefreshList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    if ([dataList count] > 0) {
        for (NSDictionary *object in dataArray) {
            [dataList addObject:object];
        }
    } else {
        dataList = dataArray;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [table reloadData];
    //[_slimeView endRefresh];
    // hasMore = YES;
}



//处理品牌列表
- (void)recivedCategoryList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    if ([dataList count] > 0) {
        for (NSDictionary *object in dataArray) {
            [dataList addObject:object];
        }
    } else {
        dataList = dataArray;
    }
    if ([dataArray count] < 10) {
        hasMore = NO;
    } else {
        hasMore = YES;
        start = [NSString stringWithFormat:@"%d", [start intValue] + 1];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [table reloadData];
    [_slimeView endRefresh];
}

- (void)recivedTableList:(NSMutableArray *)dataArray business:(kBusinessTag)tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");

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
            //LogOutViewController *cv = [[LogOutViewController alloc] init];
            //cv.hidesBottomBarWhenPushed = YES;
            //[self.navigationController pushViewController:cv animated:YES];
        }
    }else {
    
    
    NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
	if (tag==kBusinessTagGetJRloadData ) {
         NSMutableDictionary *dataArr = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"获取品牌失败"];
        } else {
            //[self recivedCategoryList:dataArray];
            
            allGqlb = [dataArr objectForKey:@"allGqlb"];
            
            //添加指示器及遮罩
            
          
            
        }
    }else if (tag == kBusinessTagGetJRwdtzloadDataAgain){
        
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [dataList removeAllObjects];
            [self recivedCategoryList:[dataArray objectForKey:@"dataList"]];
        }
    } else if (tag == kBusinessTagUserGetEndRefreshList){
        
        //[_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [dataList removeAllObjects];
            [self recivedEndRefreshList:[dataArray objectForKey:@"dataList"]];
        }
    } else  if (tag==kBusinessTagGetJRwdtzloadData) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取品牌失败"];
        } else {
            [self recivedCategoryList:[dataArray objectForKey:@"dataList"]];
        }
    } else if (tag==kBusinessTagGetJRcpzrwytz1 ) {
        // NSMutableDictionary *dataArr = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"获取品牌失败"];
        } else {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self recivedPastList:[dataArray objectForKey:@"dataList"]];
            
            
        }
    }else if (tag == kBusinessTagGetJRcpzrwytz1Again){
        
        [_slimeViewPast endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [dataListPast removeAllObjects];
            [self recivedPastList:[dataArray objectForKey:@"dataList"]];
        }
    }
}
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}

-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alert show];
    
     [self.view makeToast:@"您所在地的网络信号微弱，无法连接到服务" duration:1 position:@"center"];
    
    if (tag == kBusinessTagUserGetList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else if (tag == kBusinessTagUserGetListAgain) {
        start = [NSString stringWithString:startBak];
        [_slimeView endRefresh];
    } else if (tag == kBusinessTagGetStatus) {
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

- (IBAction)transferVC:(id)sender {
    PorductViewController *cv = [[PorductViewController alloc] init];
   // cv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cv animated:YES];
}

@end
