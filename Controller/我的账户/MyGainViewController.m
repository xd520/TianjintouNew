//
//  MyGainViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyGainViewController.h"
#import "AppDelegate.h"


#define TTABLEVIEW 10001
#define WAITTABLEVIEW 10006
#define SHIPTABLEVIEW 10009
#define TFINISHTABLEVIEW 10002
#define WAITTTR 10007
#define SHIPTTR 10008
#define TTR 10003
#define TFINISHTR 10004
#define TSEGSCROLLVIEW 10005

@interface MyGainViewController (){
    NSString *start;
    NSString *startBak;
    NSString *finishStart;
    NSString *finishStartBak;
    NSString *shipStart;
    NSString *shipStartBak;
    NSString *waitStart;
    NSString *waitStartBak;
    NSString *limit;
    NSMutableArray *dataList;
    NSMutableArray *finishDataList;
    NSMutableArray *waitDataList;
    NSMutableArray *shipDataList;
    BOOL hasMore;
    BOOL waitHasMore;
    BOOL finishHasMore;
    BOOL shipHasMore;
    UITableViewCell *moreCell;
    UITableViewCell *waitMoreCell;
    UITableViewCell *finishMoreCell;
    UITableViewCell *shipMoreCell;
    SRRefreshView   *_slimeView;
    SRRefreshView   *_waitSlimeView;
    SRRefreshView   *_finishSlimeView;
    SRRefreshView   *_shipSlimeView;
  // zhuan  zhuang jilu
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    UIToolbar *tooBar;
    UIToolbar *timeTooBar;
    UILabel *dateLStarabel;
    UILabel *dateLEndabel;
    
    UIDatePicker *datePickerPast;
    UIDatePicker *timePickerPast;
    UIToolbar *tooBarPast;
    UIToolbar *timeTooBarPast;
    UILabel *dateLStarabelPast;
    UILabel *dateLEndabelPast;
    
    UIView *cellBackView;
    float addHight;
     UISegmentedControl  *segmented;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *waitTableView;
@property (strong, nonatomic) UITableView *shipTableView;
@property (strong, nonatomic) UITableView *finishTableView;



@end

@implementation MyGainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) segmentAction:(UISegmentedControl *)Seg{
    
    
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li",(long)Index);
    
    __weak typeof(self) weakSelf = self;
    
    if (Seg.selectedSegmentIndex == 0) {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
    } else if(Seg.selectedSegmentIndex == 1){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }else if(Seg.selectedSegmentIndex == 2){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }else if(Seg.selectedSegmentIndex == 3){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    start = @"1";
    waitStart = @"1";
    shipStart = @"1";
    finishStart = @"1";
    limit = @"10";
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"购买记录",@"购买申请",@"转让记录",@"转让申请",nil];
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    segmented.frame = CGRectMake(10, 54 + addHight, ScreenWidth - 20, 30);
    
    segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    segmented.backgroundColor = [UIColor whiteColor];
    segmented.tintColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    
    
    segmented.multipleTouchEnabled = NO;
    segmented.segmentedControlStyle = UISegmentedControlStyleBezeled;
    
    [segmented addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmented];
    
    
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 50;
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44 + addHight + 50, ScreenWidth, scrollViewHeight)];
    
    self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth * 4, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 44 + addHight + 50, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight - 194)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTag:TTABLEVIEW];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    //加入下拉刷新
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.tag = TTR;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    [self.tableView addSubview:_slimeView];
    [self.scrollView addSubview:self.tableView];
    
    //初始化已发货TableView
    
    self.finishTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 114)];
    self.finishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.finishTableView setTag:TFINISHTABLEVIEW];
    [self.finishTableView setDelegate:self];
    [self.finishTableView setDataSource:self];
    [self.finishTableView setBackgroundColor:[UIColor clearColor]];
    //加入下拉刷新
    _finishSlimeView = [[SRRefreshView alloc] init];
    _finishSlimeView.delegate = self;
    _finishSlimeView.upInset = 0;
    _finishSlimeView.tag = TFINISHTR;
    _finishSlimeView.slimeMissWhenGoingBack = YES;
    _finishSlimeView.slime.bodyColor = [UIColor blackColor];
    _finishSlimeView.slime.skinColor = [UIColor whiteColor];
    _finishSlimeView.slime.lineWith = 1;
    _finishSlimeView.slime.shadowBlur = 4;
    _finishSlimeView.slime.shadowColor = [UIColor blackColor];
    [self.finishTableView addSubview:_finishSlimeView];
    [self.scrollView addSubview:self.finishTableView];
    
    //初始化已发货TableView
   
    self.waitTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 80, ScreenWidth, ScreenHeight - 194)];
    self.waitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.waitTableView setTag:WAITTABLEVIEW];
    [self.waitTableView setDelegate:self];
    [self.waitTableView setDataSource:self];
    [self.waitTableView setBackgroundColor:[UIColor clearColor]];
    
    //加入下拉刷新
    _waitSlimeView = [[SRRefreshView alloc] init];
    _waitSlimeView.delegate = self;
    _waitSlimeView.upInset = 0;
    _waitSlimeView.tag = WAITTTR;
    _waitSlimeView.slimeMissWhenGoingBack = NO;
    _waitSlimeView.slime.bodyColor = [UIColor blackColor];
    _waitSlimeView.slime.skinColor = [UIColor whiteColor];
    _waitSlimeView.slime.lineWith = 1;
    _waitSlimeView.slime.shadowBlur = 4;
    _waitSlimeView.slime.shadowColor = [UIColor blackColor];
    [self.waitTableView addSubview:_waitSlimeView];
    [self.scrollView addSubview:self.waitTableView];
    
    
    //初始化已发货TableView
   
    self.shipTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, ScreenHeight - 114)];
    self.shipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.shipTableView setTag:SHIPTABLEVIEW];
    [self.shipTableView setDelegate:self];
    [self.shipTableView setDataSource:self];
    [self.shipTableView setBackgroundColor:[UIColor clearColor]];
    
    //加入下拉刷新
    _shipSlimeView = [[SRRefreshView alloc] init];
    _shipSlimeView.delegate = self;
    _shipSlimeView.upInset = 0;
    _shipSlimeView.tag = SHIPTTR;
    _shipSlimeView.slimeMissWhenGoingBack = NO;
    _shipSlimeView.slime.bodyColor = [UIColor blackColor];
    _shipSlimeView.slime.skinColor = [UIColor whiteColor];
    _shipSlimeView.slime.lineWith = 1;
    _shipSlimeView.slime.shadowBlur = 4;
    _shipSlimeView.slime.shadowColor = [UIColor blackColor];
    [self.shipTableView addSubview:_shipSlimeView];
    [self.scrollView addSubview:self.shipTableView];
    
   
 //日期的处理  /******************/
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 200, ScreenWidth, 200)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 200, ScreenWidth, 200)];
    timePicker.backgroundColor = [UIColor whiteColor];
    timePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = YES;
    timePicker.hidden = YES;
    [self.scrollView addSubview:timePicker];
    [self.scrollView addSubview:datePicker];
    
    tooBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 200 - 30, ScreenWidth, 40)];
    //tooBar.backgroundColor = [UIColor redColor];
    [tooBar setBackgroundImage:[UIImage imageNamed:@"title_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(ScreenWidth - 40, 5, 30, 30);
    [okBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(upDateView:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.tag = 1;
    [tooBar addSubview:okBtn];
    
    UILabel *starLb= [[UILabel alloc] initWithFrame:CGRectMake(110,0, 100, 40)];
    starLb.font = [UIFont boldSystemFontOfSize:14];
    starLb.textAlignment = NSTextAlignmentCenter;
    starLb.backgroundColor = [UIColor clearColor];
    starLb.text = @"起始日期";
    [tooBar addSubview:starLb];
    
    
    tooBar.hidden = YES;
    [self.scrollView addSubview:tooBar];
    
    timeTooBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 200 - 30, ScreenWidth, 40)];
    //tooBar.backgroundColor = [UIColor redColor];
    [timeTooBar setBackgroundImage:[UIImage imageNamed:@"title_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIButton *okBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn1.frame = CGRectMake(ScreenWidth - 40, 5, 30, 30);
    [okBtn1 setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [okBtn1 addTarget:self action:@selector(upDateView:) forControlEvents:UIControlEventTouchUpInside];
    okBtn1.tag = 2;
    [timeTooBar addSubview:okBtn1];
    
    UILabel *starLab = [[UILabel alloc] initWithFrame:CGRectMake(110,0, 100, 40)];
    starLab.font = [UIFont boldSystemFontOfSize:14];
    starLab.textAlignment = NSTextAlignmentCenter;
    starLab.backgroundColor = [UIColor clearColor];
    starLab.text = @"结束日期";
    [timeTooBar addSubview:starLab];
    timeTooBar.hidden = YES;
    [self.scrollView addSubview:timeTooBar];
    
 /************past 日期的处理**************/
    datePickerPast = [[UIDatePicker alloc] initWithFrame:CGRectMake(ScreenWidth*2, self.scrollView.frame.size.height - 200, ScreenWidth, 200)];
    datePickerPast.backgroundColor = [UIColor whiteColor];
    datePickerPast.datePickerMode = UIDatePickerModeDate;
    timePickerPast = [[UIDatePicker alloc] initWithFrame:CGRectMake(ScreenWidth*2, self.scrollView.frame.size.height - 200, ScreenWidth, 200)];
    timePickerPast.backgroundColor = [UIColor whiteColor];
    timePickerPast.datePickerMode = UIDatePickerModeDate;
    datePickerPast.hidden = YES;
    timePickerPast.hidden = YES;
    [self.scrollView addSubview:timePickerPast];
    [self.scrollView addSubview:datePickerPast];
    
    tooBarPast = [[UIToolbar alloc] initWithFrame:CGRectMake(ScreenWidth*2, self.scrollView.frame.size.height - 200 - 30, ScreenWidth, 40)];
    //tooBar.backgroundColor = [UIColor redColor];
    [tooBarPast setBackgroundImage:[UIImage imageNamed:@"title_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIButton *okBtnPast = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtnPast.frame = CGRectMake(ScreenWidth - 40, 5, 30, 30);
    [okBtnPast setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [okBtnPast addTarget:self action:@selector(upDateView:) forControlEvents:UIControlEventTouchUpInside];
    okBtnPast.tag = 3;
    [tooBarPast addSubview:okBtnPast];
    
    UILabel *starLbPast= [[UILabel alloc] initWithFrame:CGRectMake(110,0, 100, 40)];
    starLbPast.font = [UIFont boldSystemFontOfSize:14];
    starLbPast.textAlignment = NSTextAlignmentCenter;
    starLbPast.backgroundColor = [UIColor clearColor];
    starLbPast.text = @"起始日期";
    [tooBarPast addSubview:starLbPast];
    
    
    tooBarPast.hidden = YES;
    [self.scrollView addSubview:tooBarPast];
    
    timeTooBarPast = [[UIToolbar alloc] initWithFrame:CGRectMake(ScreenWidth*2, self.scrollView.frame.size.height - 200 - 30, ScreenWidth, 40)];
    //tooBar.backgroundColor = [UIColor redColor];
    [timeTooBarPast setBackgroundImage:[UIImage imageNamed:@"title_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIButton *okBtn1Past = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn1Past.frame = CGRectMake(ScreenWidth - 40, 5, 30, 30);
    [okBtn1Past setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [okBtn1Past addTarget:self action:@selector(upDateView:) forControlEvents:UIControlEventTouchUpInside];
    okBtn1Past.tag = 4;
    [timeTooBarPast addSubview:okBtn1Past];
    
    UILabel *starLabPast = [[UILabel alloc] initWithFrame:CGRectMake(110,0, 100, 40)];
    starLabPast.font = [UIFont boldSystemFontOfSize:14];
    starLabPast.textAlignment = NSTextAlignmentCenter;
    starLabPast.backgroundColor = [UIColor clearColor];
    starLabPast.text = @"结束日期";
    [timeTooBarPast addSubview:starLabPast];
    timeTooBarPast.hidden = YES;
    [self.scrollView addSubview:timeTooBarPast];
    
    [self reloadView];
    [self reloadViewPast];
    
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //获取类别信息
        // NSString *str =[self dateToStringDate:[NSDate date]];
        //购买记录
        [self requestRecordList:dateLStarabel.text withEndDate:dateLEndabel.text withWtlb:@"15,1,59" withType:@"1" withStart:start withSize:limit tag:kBusinessTagGetJRcpzrwytz];
        
        //购买申请
        [self requestRecordPastList:@"15,1,59" withType:@"2" withStart:finishStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast];
        //转让记录
        [self requestRecordList:dateLStarabelPast.text withEndDate:dateLEndabelPast.text withWtlb:@"2,60" withType:@"3" withStart:waitStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast1];
        //转让申请
        [self requestRecordPastList:@"2,60" withType:@"4" withStart:shipStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast2];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    /*
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] <= [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *sortArray = [[NSArray alloc] initWithObjects:@"1",@"3",@"4",@"7",@"8",@"2",@"6",@"5",@"13",@"15",@"12",@"20",@"28",@"",nil];
    
    NSArray *array = [sortArray sortedArrayUsingComparator:cmptr];
    NSMutableArray *outputAfter = [[NSMutableArray alloc] init];
    for(NSString *str in array){
        [outputAfter addObject:str];
         }
         NSLog(@"排序后:%@",outputAfter);
    
    */
    
}

#pragma mark - 数据请求方法 1and 3

//请求登陆
- (void)requestRecordList:(NSString *)_startDate withEndDate:(NSString *)_endDate withWtlb:(NSString *)_wtlb withType:(NSString *)_type withStart:(NSString *)_start withSize:(NSString *)_size tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_startDate forKey:@"ksrq"];
    [paraDic setObject:_endDate forKey:@"jsrq"];
    [paraDic setObject:_wtlb forKey:@"wtlb"];
    [paraDic setObject:_type forKey:@"type"];
    [paraDic setObject:_size forKey:@"pageSize"];
    [paraDic setObject:_start forKey:@"pageIndex"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

#pragma mark - 数据请求方法 2and 4

- (void)requestRecordPastList:(NSString *)_startDate withType:(NSString *)_endDate withStart:(NSString *)_start withSize:(NSString *)_size tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
     NSString *str =[self dateToStringDate:[NSDate date]];
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:str forKey:@"ksrq"];
    [paraDic setObject:str forKey:@"jsrq"];
    [paraDic setObject:_startDate forKey:@"wtlb"];
    [paraDic setObject:_endDate forKey:@"type"];
    [paraDic setObject:_size forKey:@"pageSize"];
    [paraDic setObject:_start forKey:@"pageIndex"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}




/*------------购买记录---------------*/
#pragma mark - 购买记录 的选择日期UI设计


-(void)reloadView {
    
    //起始日期
    
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth/2 - 40, 30)];
    startView.backgroundColor = [UIColor whiteColor];
    //startView.layer.borderWidth = 1;
    //startView.layer.borderColor = [[UIColor blackColor] CGColor];
    startView.layer.cornerRadius = 3;
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 20,10, 40, 30)];
    starLabel.font = [UIFont systemFontOfSize:13];
    starLabel.text = @"至";
    starLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:starLabel];
    
    dateLStarabel = [[UILabel alloc] initWithFrame:CGRectMake( 5, 0, 80 , 30)];
    dateLStarabel.backgroundColor = [UIColor whiteColor];
    
    dateLStarabel.lineBreakMode = NSLineBreakByTruncatingTail;
    dateLStarabel.font = [UIFont systemFontOfSize:14];
    dateLStarabel.textAlignment = NSTextAlignmentLeft;
    dateLStarabel.text = [self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:-1]];
    dateLStarabel.userInteractionEnabled = YES;
    
    
    
    [startView addSubview:dateLStarabel];
    
    UIImageView *startImg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 20, 20)];
    startImg.image = [UIImage imageNamed:@"history"];
    startImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    [startImg addGestureRecognizer:singleTap];
    [startView addSubview:startImg];
    [self.scrollView addSubview:startView];
    
    
    
    //截止日期
    
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(180, 10, 120, 30)];
    endView.backgroundColor = [UIColor whiteColor];
    //endView.layer.borderWidth = 1;
    //endView.layer.borderColor = [[UIColor blackColor] CGColor];
    endView.layer.cornerRadius = 3;
    
    
    
    dateLEndabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 30)];
    dateLEndabel.font = [UIFont systemFontOfSize:14];
    dateLEndabel.textAlignment = NSTextAlignmentLeft;
    dateLEndabel.text = [self dateToStringDate:[NSDate date]];
    [endView addSubview:dateLEndabel];
    
    
    startImg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 20, 20)];
    startImg.image = [UIImage imageNamed:@"history"];
    startImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone1:)];
    [startImg addGestureRecognizer:singleTap1];
    [endView addSubview:startImg];
    [self.scrollView addSubview:endView];
    
    
    
    
    
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake( 20, 50, ScreenWidth - 40, 25)];
    queryBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    //queryBtn.layer.borderWidth = 1;
    //queryBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    queryBtn.tag = 10000;
    queryBtn.layer.cornerRadius = 3;
    queryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(queryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:queryBtn];
    
}

#pragma mark - 选择日期的UI设计

-(void)reloadViewPast {
    
    //起始日期
    
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*2 + 20, 10, 120, 30)];
    startView.backgroundColor = [UIColor whiteColor];
    //startView.layer.borderWidth = 1;
    //startView.layer.borderColor = [[UIColor blackColor] CGColor];
    startView.layer.cornerRadius = 3;
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*2 + 140,10, 40, 30)];
    starLabel.font = [UIFont systemFontOfSize:13];
    starLabel.text = @"至";
    starLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:starLabel];
    
    dateLStarabelPast = [[UILabel alloc] initWithFrame:CGRectMake( 5, 0, 80 , 30)];
    dateLStarabelPast.backgroundColor = [UIColor whiteColor];
    
    dateLStarabelPast.lineBreakMode = NSLineBreakByTruncatingTail;
    dateLStarabelPast.font = [UIFont systemFontOfSize:14];
    dateLStarabelPast.textAlignment = NSTextAlignmentLeft;
    dateLStarabelPast.text = [self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:-1]];
    dateLStarabelPast.userInteractionEnabled = YES;
    
    
    
    [startView addSubview:dateLStarabelPast];
    
    UIImageView *startImg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 20, 20)];
    startImg.image = [UIImage imageNamed:@"history"];
    startImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhonePast:)];
    [startImg addGestureRecognizer:singleTap];
    [startView addSubview:startImg];
    [self.scrollView addSubview:startView];
    
    
    
    
    
    //截止日期
    
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*2 + 180, 10, 120, 30)];
    endView.backgroundColor = [UIColor whiteColor];
    //endView.layer.borderWidth = 1;
    //endView.layer.borderColor = [[UIColor blackColor] CGColor];
    endView.layer.cornerRadius = 3;
    
    
    
    dateLEndabelPast = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 30)];
    dateLEndabelPast.font = [UIFont systemFontOfSize:14];
    dateLEndabelPast.textAlignment = NSTextAlignmentLeft;
    dateLEndabelPast.text = [self dateToStringDate:[NSDate date]];
    [endView addSubview:dateLEndabelPast];
    
    
    startImg = [[UIImageView alloc] initWithFrame:CGRectMake(90, 5, 20, 20)];
    startImg.image = [UIImage imageNamed:@"history"];
    startImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone1Past:)];
    [startImg addGestureRecognizer:singleTap1];
    [endView addSubview:startImg];
    [self.scrollView addSubview:endView];
    
    
    
    
    
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake( ScreenWidth*2 + 20, 50, ScreenWidth - 40, 25)];
    queryBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    //queryBtn.layer.borderWidth = 1;
    //queryBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    queryBtn.tag = 10001;
    queryBtn.layer.cornerRadius = 3;
    queryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(queryBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:queryBtn];
    
}

/*------------00000000000---------------*/
#pragma mark - 选择日期按钮方法

- (void)callPhone:(UIGestureRecognizer *)sender
{
    //UIView *view = [sender view];
    tooBar.hidden = NO;
    datePicker.hidden = NO;
    timeTooBar.hidden = YES;
    timePicker.hidden = YES;
    datePicker.date = [self dateFromString:dateLStarabel.text];
    
}

- (void)callPhonePast:(UIGestureRecognizer *)sender
{
    //UIView *view = [sender view];
    tooBarPast.hidden = NO;
    datePickerPast.hidden = NO;
    timeTooBarPast.hidden = YES;
    timePickerPast.hidden = YES;
    datePickerPast.date = [self dateFromString:dateLStarabelPast.text];
    
}



-(void) upDateView:(UIButton *)btn{
    if (btn.tag == 1) {
        tooBar.hidden = YES;
        datePicker.hidden = YES;
        dateLStarabel.text = [self dateToStringDate:datePicker.date];
    } else if (btn.tag == 2){
        timeTooBar.hidden = YES;
        timePicker.hidden = YES;
        dateLEndabel.text = [self dateToStringDate:timePicker.date];
        
    } else if (btn.tag == 3){
        tooBarPast.hidden = YES;
        datePickerPast.hidden = YES;
        dateLStarabelPast.text = [self dateToStringDate:datePickerPast.date];
    } else if (btn.tag == 4){
        timeTooBarPast.hidden = YES;
        timePickerPast.hidden = YES;
        dateLEndabelPast.text = [self dateToStringDate:timePickerPast.date];
    
    }
}

- (void)alterMessage:(NSString *)messageString{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [al show];
}


- (void)countDay {
    
    NSDate *nowDate = [NSDate date];
    NSDate *beginDate = [self dateFromString:dateLStarabel.text];
    NSDate *endDate = [self dateFromString:dateLEndabel.text];
    NSDate *earlyDate = [beginDate earlierDate:endDate];
    NSDate *laterDate =[endDate laterDate:nowDate];
    
    
    
    
    
    if ([earlyDate isEqualToDate:endDate] && ![earlyDate isEqualToDate:beginDate]) {
        
        [self alterMessage:@"开始时间不得晚于结束时间"];
        return;
        
    } else if (![nowDate isEqualToDate:laterDate]&&[endDate isEqualToDate:laterDate]) {
        
        [self alterMessage:@"结束时间不得晚于今天"];
        return;
    } else {
        
        //添加指示器及遮罩
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //[self requestCategoryList:dateLStarabel.text withEnd:dateLEndabel.text withTag:kBusinessTagGetFundslistAgain];
            start = @"1";
            
            [self requestRecordList:dateLStarabel.text withEndDate:dateLEndabel.text withWtlb:@"15,1,59" withType:@"1" withStart:start withSize:limit tag:kBusinessTagGetJRcpzrwytz];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        
        
        
    }
    
    
    /*
     NSDateComponents *beginComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:beginDate];
     NSInteger beginWeekDay = [beginComponets weekday];
     
     NSDateComponents *endComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:endDate];
     NSInteger endWeekDay = [endComponets weekday];
     
     if (beginWeekDay == 1 || beginWeekDay == 7 || endWeekDay == 1 || endWeekDay == 7) {
     
     [self alterMessage:@"结束或开始时间不得为周末"];
     return;
     
     }
     
     NSTimeInterval time = [endDate timeIntervalSinceDate:beginDate];
     
     float oneWeekDay = 7 - beginWeekDay;
     
     float allDay = time / (24 * 60 * 60);
     
     float day = 0.0;
     
     if(allDay > oneWeekDay + 2){
     float otherDay = allDay - (oneWeekDay + 2);
     
     float ResidualDay = otherDay - ((int)otherDay / 7) * 2;
     
     day = ResidualDay + oneWeekDay;
     }else{
     day = endWeekDay - beginWeekDay;
     }
     
     
     //dateLTotalabel.text = [NSString stringWithFormat:@"%d天",(int)day];
     */
}

-(void)countDayLast{
    
    NSDate *nowDate = [NSDate date];
    NSDate *beginDate = [self dateFromString:dateLStarabelPast.text];
    NSDate *endDate = [self dateFromString:dateLEndabelPast.text];
    NSDate *earlyDate = [beginDate earlierDate:endDate];
    NSDate *laterDate =[endDate laterDate:nowDate];
    
    
    if ([earlyDate isEqualToDate:endDate] && ![earlyDate isEqualToDate:beginDate]) {
        
        [self alterMessage:@"开始时间不得晚于结束时间"];
        return;
        
    } else if (![nowDate isEqualToDate:laterDate]&&[endDate isEqualToDate:laterDate]) {
        
        [self alterMessage:@"结束时间不得晚于今天"];
        return;
    } else {
        
        //添加指示器及遮罩
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //[self requestCategoryList:dateLStarabel.text withEnd:dateLEndabel.text withTag:kBusinessTagGetFundslistAgain];
             waitStart = @"1";
            
             [self requestRecordList:dateLStarabelPast.text withEndDate:dateLEndabelPast.text withWtlb:@"2,60" withType:@"3" withStart:waitStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        
    }
    

}

-(void)queryBtn:(UIButton *)btn{
    if (btn.tag == 10000) {
         [self countDay];
    } else if (btn.tag == 10001) {
    
     [self countDayLast];
    
    }
}

- (void)callPhone1:(UITouch *)sender
{
    timeTooBar.hidden = NO;
    timePicker.hidden = NO;
    tooBar.hidden = YES;
    datePicker.hidden = YES;
    timePicker.date = [self dateFromString:dateLEndabel.text];
}

- (void)callPhone1Past:(UITouch *)sender
{
    timeTooBarPast.hidden = NO;
    timePickerPast.hidden = NO;
    tooBarPast.hidden = YES;
    datePickerPast.hidden = YES;
    timePickerPast.date = [self dateFromString:dateLEndabelPast.text];
}

#pragma mark - date A months Ago
//给一个时间，给一个数，正数是以后n个月，负数是前n个月；
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    [comps setMonth:month];
    [comps setDay:-1];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}

#pragma mark - date change Metholds

- (NSString *)dateToStringDate:(NSDate *)Date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //HH:mm:ss zzz
    NSString *destDateString = [dateFormatter stringFromDate:Date];
    // destDateString = [destDateString substringToIndex:10];
    
    return destDateString;
}


- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[formatter dateFromString:dateString];
    
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date1 timeIntervalSinceReferenceDate] + 8*3600)];
    return newDate;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scllView {
    if (scllView == _scrollView) {
        CGFloat pageWidth = ScreenWidth;
        NSInteger page = _scrollView.contentOffset.x / pageWidth ;
        
        segmented.selectedSegmentIndex = page;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == TTABLEVIEW) {
        [_slimeView scrollViewDidScroll];
    } else if (scrollView.tag == TFINISHTABLEVIEW) {
        [_finishSlimeView scrollViewDidScroll];
    } else if (scrollView.tag == WAITTABLEVIEW) {
        [_waitSlimeView scrollViewDidScroll];
    } else if (scrollView.tag == SHIPTABLEVIEW) {
        [_shipSlimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == TTABLEVIEW) {
        [_slimeView scrollViewDidEndDraging];
    } else if (scrollView.tag == TFINISHTABLEVIEW) {
        [_finishSlimeView scrollViewDidEndDraging];
    } else if (scrollView.tag == WAITTABLEVIEW) {
        [_waitSlimeView scrollViewDidEndDraging];
    } else if (scrollView.tag == SHIPTABLEVIEW) {
        [_shipSlimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    // NSString *str =[self dateToStringDate:[NSDate date]];
    if (refreshView.tag == TTR) {
        startBak = [NSString stringWithString:start];
        start = @"1";
        [self requestRecordList:dateLStarabel.text withEndDate:dateLEndabel.text withWtlb:@"15,1,59" withType:@"1" withStart:start withSize:limit tag:kBusinessTagGetJRcpzrwytzAgain];
    } else if (refreshView.tag == TFINISHTR) {
        finishStartBak = [NSString stringWithString:finishStart];
        finishStart = @"1";
        [self requestRecordPastList:@"15,1,59" withType:@"2" withStart:finishStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPastAgain];
    } else if (refreshView.tag == WAITTTR) {
        waitStartBak = [NSString stringWithString:waitStart];
        waitStart = @"1";
        [self requestRecordList:dateLStarabelPast.text withEndDate:dateLEndabelPast.text withWtlb:@"2,60" withType:@"3" withStart:waitStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast1Again];
    } else if (refreshView.tag == SHIPTTR) {
        shipStartBak = [NSString stringWithString:shipStart];
        shipStart = @"1";
        [self requestRecordPastList:@"2,60" withType:@"4" withStart:shipStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast2Again];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSString *str =[self dateToStringDate:[NSDate date]];

    if (tableView.tag == TTABLEVIEW) {
        if ([indexPath row] == [dataList count]) {
            if (hasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"正在加载中..."]) {
                        
                    } else {
                        label.text = @"正在加载中...";
                         [self requestRecordList:dateLStarabel.text withEndDate:dateLEndabel.text withWtlb:@"15,1,59" withType:@"1" withStart:start withSize:limit tag:kBusinessTagGetJRcpzrwytz];
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
    } else if (tableView.tag == TFINISHTABLEVIEW) {
        if ([indexPath row] == [finishDataList count]) {
            if (finishHasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"正在加载中..."]) {
                        
                    } else {
                        label.text = @"正在加载中...";
                          [self requestRecordPastList:@"15,1,59" withType:@"2" withStart:finishStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast];
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
    } else if (tableView.tag == WAITTABLEVIEW) {
        if ([indexPath row] == [waitDataList count]) {
            if (waitHasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"正在加载中..."]) {
                        
                    } else {
                        label.text = @"正在加载中...";
                          [self requestRecordList:dateLStarabelPast.text withEndDate:dateLEndabelPast.text withWtlb:@"2,60" withType:@"3" withStart:waitStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast1];
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
    } else if (tableView.tag == SHIPTABLEVIEW) {
        if ([indexPath row] == [shipDataList count]) {
            if (shipHasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"正在加载中..."]) {
                        
                    } else {
                        label.text = @"正在加载中...";
                           [self requestRecordPastList:@"2,60" withType:@"4" withStart:shipStart withSize:limit tag:kBusinessTagGetJRcpzrwytzPast2];
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (tableView.tag == TTABLEVIEW) {
        if ([dataList count] == 0) {
            return 1;
        } else if (hasMore) {
            return [dataList count] + 1;
        } else {
            return [dataList count];
        }
    } else if(tableView.tag == WAITTABLEVIEW){
        if ([waitDataList count] == 0) {
            return 1;
        } else if (waitHasMore) {
            return [waitDataList count] + 1;
        } else {
            return [waitDataList count];
        }
    } else if(tableView.tag == SHIPTABLEVIEW){
        if ([shipDataList count] == 0) {
            return 1;
        } else if (shipHasMore) {
            return [shipDataList count] + 1;
        } else {
            return [shipDataList count];
        }
    } else {
        if ([finishDataList count] == 0) {
            return 1;
        } else if (finishHasMore) {
            return [finishDataList count] + 1;
        } else {
            return [finishDataList count];
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if (tbleView.tag == TTABLEVIEW) {
        if ([dataList count] == 0) {
            if (YES) {
                
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"none_product_icon"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                 tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有记录哦~"];
                [cellBackView addSubview:tipLabel];
                [cell.contentView addSubview:cellBackView];
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
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    
                    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 60)];
                    [firstView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                    
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 12,ScreenWidth - 20 , 16)];
                    dateLab.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
                    
                    dateLab.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPMC"];
                    dateLab.font = [UIFont systemFontOfSize:16];
                    dateLab.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [firstView addSubview:dateLab];
                    //时间
                    UILabel *reLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 36,ScreenWidth/2 - 20 , 13)];
                    //日期格式转化
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_WTRQ"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    [strDate insertString:@"-" atIndex:4];
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    reLab.text = [NSString stringWithFormat:@"%@  %@",strDate,[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_WTSJ"]];
                    reLab.font = [UIFont systemFontOfSize:13];
                    reLab.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [firstView addSubview:reLab];
                    
                    UILabel *reLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 23, 36,13, 13)];
                    reLabTip.text = @"元";
                    reLabTip.font = [UIFont systemFontOfSize:13];
                    reLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [firstView addSubview:reLabTip];
                    
                    
                    // 处理结果
                    
                    
                    UILabel *endLab = [[UILabel alloc] init];
                    endLab.text =[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BJ"];
                    endLab.font = [UIFont systemFontOfSize:13];
                    endLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    
                    CGSize titleSize = [endLab.text sizeWithFont:endLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                    
                    endLab.frame = CGRectMake(ScreenWidth - 23 - titleSize.width, 36,titleSize.width, 13);
                    
                    [firstView addSubview:endLab];
                    
                    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 23 - titleSize.width - 5 - 13*4, 36,13*4 , 13)];
                    endLabTip.text = @"购买金额";
                    endLabTip.font = [UIFont systemFontOfSize:13];
                    endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [firstView addSubview:endLabTip];
                    
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 1)];
                    [subView setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    if ([indexPath row] != 0) {
                        [firstView addSubview:subView];
                    }
                    
                    [cell.contentView addSubview:firstView];
                    
                }
            }
        }
        return cell;
    } else if (tbleView.tag == TFINISHTABLEVIEW) {
        if ([finishDataList count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"none_product_icon"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有记录哦~"];
                [cellBackView addSubview:tipLabel];
                [cell.contentView addSubview:cellBackView];
            }
        } else {
            if ([indexPath row] == [finishDataList count]) {
                finishMoreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                finishMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [finishMoreCell setBackgroundColor:[UIColor clearColor]];
                finishMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [finishMoreCell.contentView addSubview:toastLabel];
                return finishMoreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        [cell setBackgroundColor:[UIColor clearColor]];
                        //添加背景View
                        
                        UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 60)];
                        [firstView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                        
                        UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 12,ScreenWidth - 20 , 16)];
                        dateLab.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
                      
                        dateLab.text = [[finishDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPMC"];
                        dateLab.font = [UIFont systemFontOfSize:16];
                        dateLab.textColor = [ColorUtil colorWithHexString:@"333333"];
                        [firstView addSubview:dateLab];
                     //时间
                        UILabel *reLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 36,ScreenWidth/2 - 20 , 13)];
                        //日期格式转化
                        NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[finishDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_WTRQ"]];
                        // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                        [strDate insertString:@"-" atIndex:4];
                        [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                        reLab.text = [NSString stringWithFormat:@"%@  %@",strDate,[[finishDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_WTSJ"]];
                        reLab.font = [UIFont systemFontOfSize:13];
                        reLab.textColor = [ColorUtil colorWithHexString:@"999999"];
                        [firstView addSubview:reLab];
                        
                        UILabel *reLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 23, 36,13, 13)];
                        reLabTip.text = @"元";
                        reLabTip.font = [UIFont systemFontOfSize:13];
                        reLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
                        [firstView addSubview:reLabTip];
                        
                        
                        // 处理结果
                       
                        
                        UILabel *endLab = [[UILabel alloc] init];
                        endLab.text =[[finishDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BJ"];
                        endLab.font = [UIFont systemFontOfSize:13];
                        endLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                        
                        CGSize titleSize = [endLab.text sizeWithFont:endLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                        
                        endLab.frame = CGRectMake(ScreenWidth - 23 - titleSize.width, 36,titleSize.width, 13);
                        
                        [firstView addSubview:endLab];
                        
                        UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 23 - titleSize.width - 5 - 13*4, 36,13*4 , 13)];
                        endLabTip.text = @"购买金额";
                        endLabTip.font = [UIFont systemFontOfSize:13];
                        endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                        [firstView addSubview:endLabTip];
                        
                        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 1)];
                        [subView setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                        if ([indexPath row] != 0) {
                            [firstView addSubview:subView];
                        }

                        
                        [cell.contentView addSubview:firstView];
                        
                    }
            }
        }
        return cell;
    } else if (tbleView.tag == WAITTABLEVIEW) {
        if ([waitDataList count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"none_product_icon"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                 tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有记录哦~"];
                [cellBackView addSubview:tipLabel];
                [cell.contentView addSubview:cellBackView];
            }
        } else {
            if ([indexPath row] == [waitDataList count]) {
                waitMoreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                waitMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [waitMoreCell setBackgroundColor:[UIColor clearColor]];
                waitMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [waitMoreCell.contentView addSubview:toastLabel];
                return waitMoreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    
                    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 60)];
                    [firstView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                    
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 12,ScreenWidth - 20 , 16)];
                    dateLab.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
                    
                    dateLab.text = [[waitDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPMC"];
                    dateLab.font = [UIFont systemFontOfSize:16];
                    dateLab.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [firstView addSubview:dateLab];
                    //时间
                    UILabel *reLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 36,ScreenWidth/2 - 20 , 13)];
                    //日期格式转化
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[waitDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_WTRQ"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    [strDate insertString:@"-" atIndex:4];
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    reLab.text = [NSString stringWithFormat:@"%@  %@",strDate,[[waitDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_WTSJ"]];
                    reLab.font = [UIFont systemFontOfSize:13];
                    reLab.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [firstView addSubview:reLab];
                    
                    UILabel *reLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 23, 36,13, 13)];
                    reLabTip.text = @"元";
                    reLabTip.font = [UIFont systemFontOfSize:13];
                    reLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [firstView addSubview:reLabTip];
                    
                    
                    // 处理结果
                    
                    
                    UILabel *endLab = [[UILabel alloc] init];
                    endLab.text =[[waitDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BJ"];
                    endLab.font = [UIFont systemFontOfSize:13];
                    endLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    
                    CGSize titleSize = [endLab.text sizeWithFont:endLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                    
                    endLab.frame = CGRectMake(ScreenWidth - 23 - titleSize.width, 36,titleSize.width, 13);
                    
                    [firstView addSubview:endLab];
                    
                    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 23 - titleSize.width - 5 - 13*4, 36,13*4 , 13)];
                    endLabTip.text = @"购买金额";
                    endLabTip.font = [UIFont systemFontOfSize:13];
                    endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [firstView addSubview:endLabTip];
                    
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 1)];
                    [subView setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    if ([indexPath row] != 0) {
                        [firstView addSubview:subView];
                    }

                    
                    [cell.contentView addSubview:firstView];
                    
                }
            }
        }
        return cell;
    } else if (tbleView.tag == SHIPTABLEVIEW) {
        if ([shipDataList count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"none_product_icon"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                 tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有记录哦~"];
                [cellBackView addSubview:tipLabel];
                [cell.contentView addSubview:cellBackView];
            }
        } else {
            if ([indexPath row] == [shipDataList count]) {
                shipMoreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
               
                shipMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [shipMoreCell setBackgroundColor:[UIColor clearColor]];
                shipMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [shipMoreCell.contentView addSubview:toastLabel];
                return shipMoreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    
                    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 60)];
                    [firstView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                    
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 12,ScreenWidth - 20 , 16)];
                    dateLab.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
                    
                    dateLab.text = [[shipDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPMC"];
                    dateLab.font = [UIFont systemFontOfSize:16];
                    dateLab.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [firstView addSubview:dateLab];
                    //时间
                    UILabel *reLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 36,ScreenWidth/2 - 20 , 13)];
                    //日期格式转化
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[shipDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_WTRQ"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    [strDate insertString:@"-" atIndex:4];
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    reLab.text = [NSString stringWithFormat:@"%@  %@",strDate,[[shipDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_WTSJ"]];
                    reLab.font = [UIFont systemFontOfSize:13];
                    reLab.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [firstView addSubview:reLab];
                    
                    UILabel *reLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 23, 36,13, 13)];
                    reLabTip.text = @"元";
                    reLabTip.font = [UIFont systemFontOfSize:13];
                    reLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [firstView addSubview:reLabTip];
                    
                    
                    // 处理结果
                    
                    
                    UILabel *endLab = [[UILabel alloc] init];
                    endLab.text =[[shipDataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BJ"];
                    endLab.font = [UIFont systemFontOfSize:13];
                    endLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    
                    CGSize titleSize = [endLab.text sizeWithFont:endLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                    
                    endLab.frame = CGRectMake(ScreenWidth - 23 - titleSize.width, 36,titleSize.width, 13);
                    
                    [firstView addSubview:endLab];
                    
                    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 23 - titleSize.width - 5 - 13*4, 36,13*4 , 13)];
                    endLabTip.text = @"购买金额";
                    endLabTip.font = [UIFont systemFontOfSize:13];
                    endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [firstView addSubview:endLabTip];
                    
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 1)];
                    [subView setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    if ([indexPath row] != 0) {
                        [firstView addSubview:subView];
                    }

                    
                    [cell.contentView addSubview:firstView];
                    
                }
            }
        }
        return cell;
    }
    
    return nil;
}

#pragma mark - Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSInteger row = [indexPath row];
    if (tableView.tag == TTABLEVIEW) {
        if ([dataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [dataList count]) {
                return 40;
            } else {
                return 60;
            }
        }
    } else if (tableView.tag == TFINISHTABLEVIEW) {
        if ([finishDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [finishDataList count]) {
                return 40;
            } else {
                return 60;
            }
        }
    } else if (tableView.tag == WAITTABLEVIEW) {
        if ([waitDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [waitDataList count]) {
                return 40;
            } else {
                return 60;
            }
        }
    } else if (tableView.tag == SHIPTABLEVIEW) {
        if ([shipDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [shipDataList count]) {
                return 40;
            } else {
                return 60;
            }
        }
    }
    
    
    return 95 ;
}

#pragma mark - Recived Methods
//处理未发货订单
- (void)recivedNoOrderList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理未发货订单");
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
   
    [self.tableView reloadData];
    [_slimeView endRefresh];
}




//处理已发货订单
- (void)recivedFinishOrderList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理已发货订单数据");
    /*
  //获取月份
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    
    
    for (NSDictionary *object in dataArray) {
       if ([finishDataList count] > 0) {
        
        for (NSDictionary *obj in finishDataList){
            if ([[obj objectForKey:@"mouths"] isEqualToString:[[object objectForKey:@"FID_WTRQ"] substringWithRange:NSMakeRange(4,2)]]) {
                [[obj objectForKey:@"array"] addObject:object];
        
            } else {
                NSMutableDictionary *dictionay = [NSMutableDictionary dictionary];
                [dictionay setObject:[[object objectForKey:@"FID_WTRQ"] substringWithRange:NSMakeRange(4,2)] forKey:@"mouths"];
                [dictionay setObject:object forKey:@"array"];
                
                [finishDataList addObject:dictionay];
            }
      
        }
        
    } else {
        NSMutableDictionary *dictionay = [NSMutableDictionary dictionary];
        [dictionay setObject:[[object objectForKey:@"FID_WTRQ"] substringWithRange:NSMakeRange(4,2)] forKey:@"mouths"];
        [dictionay setObject:object forKey:@"array"];
        
        [finishDataList addObject:dictionay];
    
        }
    }
    */
    
    if ([finishDataList count] > 0) {
        for (NSDictionary *object in dataArray) {
            [finishDataList addObject:object];
        }
    } else {
        finishDataList = dataArray;
    }
    
    if ([dataArray count] < 10) {
        finishHasMore = NO;
    } else {
        finishHasMore = YES;
        finishStart = [NSString stringWithFormat:@"%d", [finishStart intValue] + 1];
    }
    
    [self.finishTableView reloadData];
    [_finishSlimeView endRefresh];
}

//处理已完成订单
- (void)recivedWaitOrderList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理已发货订单数据");
    if ([waitDataList count] > 0) {
        for (NSDictionary *object in dataArray) {
            [waitDataList addObject:object];
        }
    } else {
        waitDataList = dataArray;
    }
    if ([dataArray count] < 10) {
        waitHasMore = NO;
    } else {
        waitHasMore = YES;
        waitStart = [NSString stringWithFormat:@"%d", [waitStart intValue] + 1];
    }
    
    [self.waitTableView reloadData];
    [_waitSlimeView endRefresh];
}

//处理已完成订单
- (void)recivedShipOrderList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理已发货订单数据");
    if ([shipDataList count] > 0) {
        for (NSDictionary *object in dataArray) {
            [shipDataList addObject:object];
        }
    } else {
        shipDataList = dataArray;
    }
    if ([dataArray count] < 10) {
        shipHasMore = NO;
    } else {
        shipHasMore = YES;
        shipStart = [NSString stringWithFormat:@"%d", [shipStart intValue] + 1];
    }
    
    [self.shipTableView reloadData];
    [_shipSlimeView endRefresh];
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
    
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if (tag==kBusinessTagGetJRcpzrwytz) {
            
            if (dataArray == nil) {
                //数据异常处理
                [self.view makeToast:@"获取未发货订单失败"];
            } else {
                
                if ([start isEqualToString:@"1"]) {
                    [dataList removeAllObjects];
                }
                
                [self recivedNoOrderList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag==kBusinessTagGetJRcpzrwytzAgain){
           
            [_slimeView endRefresh];
            if (dataArray == nil) {
                //数据异常处理
                [self.view makeToast:@"获取未发货订单失败"];
            } else {
                [dataList removeAllObjects];
                [self recivedNoOrderList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag == kBusinessTagGetJRcpzrwytzPast) {
            
            if (dataArray == nil) {
                //数据异常处理
                [self.view makeToast:@"获取已发货订单失败"];
            } else {
                [self recivedFinishOrderList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag == kBusinessTagGetJRcpzrwytzPastAgain){
           
            [_finishSlimeView endRefresh];
            if (dataArray == nil) {
                //数据异常处理
                [self.view makeToast:@"获取已发货订单失败"];
            } else {
                [finishDataList removeAllObjects];
                [self recivedFinishOrderList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag == kBusinessTagGetJRcpzrwytzPast1) {
            
            if (dataArray == nil) {
                //数据异常处理
                [self.view makeToast:@"获取已发货订单失败"];
            } else {
                if ([waitStart isEqualToString:@"1"]) {
                    [waitDataList removeAllObjects];
                }
                
                [self recivedWaitOrderList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag == kBusinessTagGetJRcpzrwytzPast1Again){
           
            [_waitSlimeView endRefresh];
            if (dataArray == nil) {
                //数据异常处理
                [self.view makeToast:@"获取已发货订单失败"];
            } else {
                [waitDataList removeAllObjects];
                [self recivedWaitOrderList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag == kBusinessTagGetJRcpzrwytzPast2) {
            
            if (dataArray == nil) {
                //数据异常处理
                [self.view makeToast:@"获取已发货订单失败"];
            } else {
                [self recivedShipOrderList:[dataArray objectForKey:@"dataList"]];
            }
        } else if (tag == kBusinessTagGetJRcpzrwytzPast2Again){
            
            [_shipSlimeView endRefresh];
            if (dataArray == nil) {
                //数据异常处理
                [self.view makeToast:@"获取已发货订单失败"];
            } else {
                [shipDataList removeAllObjects];
                [self recivedShipOrderList:[dataArray objectForKey:@"dataList"]];
            }
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
    
}
-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务（＋﹏＋）" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
