//
//  MoneyInfoViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MoneyInfoViewController.h"
#import "AppDelegate.h"
#import "HMSegmentedControl.h"
#define TSEGSCROLLVIEW 10005
@interface MoneyInfoViewController ()
{
    //当前
    UITableView *tableView;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    SRRefreshView   *_slimeView;
    //历史
    UITableView *tableViewPast;
    NSString *startPast;
    NSString *startBakPast;
    NSString *limitPast;
    NSMutableArray *dataListPast;
    BOOL hasMorePast;
    UITableViewCell *moreCellPast;
    SRRefreshView   *_slimeViewPast;
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    UIToolbar *tooBar;
    UIToolbar *timeTooBar;
    UILabel *dateLStarabel;
    UILabel *dateLEndabel;
    float addHight;
     UISegmentedControl  *segmented;
    
    NSString *notStarDate;
    NSString *notEddDate;
}
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MoneyInfoViewController

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
        
        
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    start = @"0";
    limit = @"10";
    startPast = @"0";
    limitPast = @"10";
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"当日",@"历史",nil];
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    segmented.frame = CGRectMake(20, 54 + addHight, ScreenWidth - 40, 30);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    
    
    segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    segmented.backgroundColor = [UIColor whiteColor];
    segmented.tintColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    
    segmented.multipleTouchEnabled = NO;
    segmented.segmentedControlStyle = UISegmentedControlStyleBezeled;
    
    [segmented addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmented];
    
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 50;
    
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44 + addHight + 50, ScreenWidth, scrollViewHeight)];
    //self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*2, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 44 + addHight, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth,  scrollViewHeight)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]];    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:tableView];
    
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
    [tableView addSubview:_slimeView];
    
    
    tableViewPast = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth , 40, ScreenWidth,  scrollViewHeight - 40)];
    [tableViewPast setDelegate:self];
    [tableViewPast setDataSource:self];
    tableViewPast.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableViewPast setBackgroundColor:[UIColor clearColor]];
    tableViewPast.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:tableViewPast];
    
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
    [tableViewPast addSubview:_slimeViewPast];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(ScreenWidth, self.scrollView.frame.size.height - 200, ScreenWidth, 200)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(ScreenWidth, self.scrollView.frame.size.height - 200, ScreenWidth, 200)];
    timePicker.backgroundColor = [UIColor whiteColor];
    timePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = YES;
    timePicker.hidden = YES;
    [self.scrollView addSubview:timePicker];
    [self.scrollView addSubview:datePicker];
    
    tooBar = [[UIToolbar alloc] initWithFrame:CGRectMake(ScreenWidth, self.scrollView.frame.size.height - 200 - 30, ScreenWidth, 40)];
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
    starLb.text = @"起始日期";
    [tooBar addSubview:starLb];
    
    
    tooBar.hidden = YES;
    [self.scrollView addSubview:tooBar];
    
    timeTooBar = [[UIToolbar alloc] initWithFrame:CGRectMake(ScreenWidth, self.scrollView.frame.size.height - 200 - 30, ScreenWidth, 40)];
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
    starLab.text = @"结束日期";
    [timeTooBar addSubview:starLab];
    timeTooBar.hidden = YES;
    [self.scrollView addSubview:timeTooBar];
    
    [self reloadView];
    
    
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //获取类别信息
        NSString *str =[self dateToStringDate:[NSDate date]];
        
       // str =[str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [self requestRecordList:str withEndDate:str withStart:start withSize:limit tag:kBusinessTagGetJRFundsList];
        
        [self requestRecordList:notStarDate withEndDate:notEddDate withStart:startPast withSize:limitPast tag:kBusinessTagGetJRFundsListPast];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
}


#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
         segmented.selectedSegmentIndex = page;
        
    }
}



-(void)reloadView {
    
    //起始日期
    
    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth + 8.5, 8,52 , 13)];
    endLabTip.text = @"开始日期";
    endLabTip.font = [UIFont systemFontOfSize:13];
    endLabTip.backgroundColor = [UIColor clearColor];
    endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
    [self.scrollView addSubview:endLabTip];
    
    
    
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth + 62, 0, (ScreenWidth - 184)/2, 30)];
    startView.backgroundColor = [UIColor whiteColor];
    startView.layer.borderWidth = 1;
    startView.layer.borderColor = [[ColorUtil colorWithHexString:@"dedede"] CGColor];
    startView.layer.cornerRadius = 3;
    startView.layer.masksToBounds = YES;

    
    
    dateLStarabel = [[UILabel alloc] initWithFrame:CGRectMake( 5, 0, (ScreenWidth - 184)/2 - 7 , 30)];
    dateLStarabel.backgroundColor = [UIColor whiteColor];
    dateLStarabel.textColor = [ColorUtil colorWithHexString:@"333333"];
    dateLStarabel.lineBreakMode = NSLineBreakByTruncatingTail;
    dateLStarabel.font = [UIFont systemFontOfSize:13];
   // dateLStarabel.textAlignment = NSTextAlignmentCenter;
    
    notStarDate = [self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:-1 withDay:-2]];
    
    dateLStarabel.text = [notStarDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateLStarabel.userInteractionEnabled = YES;
    
    
    
    [startView addSubview:dateLStarabel];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    [startView addGestureRecognizer:singleTap];
    
    [self.scrollView addSubview:startView];
    
    
    
    
    
    //截止日期
    
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth + 67 + (ScreenWidth - 184)/2,8.5, 52, 13)];
    starLabel.font = [UIFont systemFontOfSize:13];
    starLabel.text = @"结束日期";
    starLabel.backgroundColor = [UIColor clearColor];
    starLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
    starLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:starLabel];
    
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth + 124 + (ScreenWidth - 184)/2, 0, (ScreenWidth - 184)/2, 30)];
    endView.backgroundColor = [UIColor whiteColor];
    endView.layer.borderWidth = 1;
    endView.layer.borderColor = [[ColorUtil colorWithHexString:@"dedede"] CGColor];
    endView.layer.cornerRadius = 3;
    endView.layer.masksToBounds = YES;
    
    
    
    dateLEndabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (ScreenWidth - 184)/2 - 7, 30)];
    dateLEndabel.font = [UIFont systemFontOfSize:13];
    dateLEndabel.textColor = [ColorUtil colorWithHexString:@"333333"];
   // dateLEndabel.textAlignment = NSTextAlignmentCenter;
    
    notEddDate = [self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:0 withDay:-1]];
    dateLEndabel.text = [notEddDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [endView addSubview:dateLEndabel];
    
    
    
    
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone1:)];
    [endView addGestureRecognizer:singleTap1];
    [self.scrollView addSubview:endView];
    
    
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake( ScreenWidth*2 - 50, 0,  40, 30)];
    queryBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    //queryBtn.layer.borderWidth = 1;
    //queryBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    queryBtn.layer.cornerRadius = 3;
    queryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [queryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(queryBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:queryBtn];
    
}

- (void)callPhone:(UIGestureRecognizer *)sender
{
    //UIView *view = [sender view];
    tooBar.hidden = NO;
    datePicker.hidden = NO;
    timeTooBar.hidden = YES;
    timePicker.hidden = YES;
    datePicker.date = [self dateFromString:dateLStarabel.text];
    
}

-(void) upDateView:(UIButton *)btn{
    if (btn.tag == 1) {
        tooBar.hidden = YES;
        datePicker.hidden = YES;
        notStarDate = [self dateToStringDate:datePicker.date];
        dateLStarabel.text = [notStarDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
       // dateLStarabel.text = [self dateToStringDate:datePicker.date];
    } else if (btn.tag == 2){
        timeTooBar.hidden = YES;
        timePicker.hidden = YES;
        notEddDate = [self dateToStringDate:timePicker.date];
        dateLEndabel.text = [notEddDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
    }
}

- (void)alterMessage:(NSString *)messageString{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [al show];
}


- (void)countDay {
    
    NSDate *nowDate = [self getPriousorLaterDateFromDate:[NSDate date] withMonth:0 withDay:-1];
    NSDate *beginDate = [self dateFromString:notStarDate];
    NSDate *endDate = [self dateFromString:notEddDate];
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
            
            startBakPast = [NSString stringWithString:startPast];
            startPast = @"0";
            
            [self requestRecordList:notStarDate withEndDate:notEddDate withStart:startPast withSize:limitPast tag:kBusinessTagGetJRFundsListPastAgain];
            
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



-(void)queryBtn{
    [self countDay];
    
    
}

- (void)callPhone1:(UITouch *)sender
{
    timeTooBar.hidden = NO;
    timePicker.hidden = NO;
    tooBar.hidden = YES;
    datePicker.hidden = YES;
    timePicker.date = [self dateFromString:notEddDate];
}

#pragma mark - date A months Ago
//给一个时间，给一个数，正数是以后n个月，负数是前n个月；
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month withDay:(int)day

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    [comps setMonth:month];
    [comps setDay:day];
    
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




#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView == _slimeView) {
        startBak = [NSString stringWithString:start];
        start = @"0";
        NSString *str =[self dateToStringDate:[NSDate date]];
        [self requestRecordList:str withEndDate:str withStart:start withSize:limit tag:kBusinessTagGetJRFundsListAgain];
    } else if (refreshView == _slimeViewPast){
        startBakPast = [NSString stringWithString:startPast];
        startPast = @"0";
        [self requestRecordList:notStarDate withEndDate:notEddDate withStart:startPast withSize:limitPast tag:kBusinessTagGetJRFundsListPastAgain];
        
    }
    
}
#pragma mark - UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scView
{
    if (scView == tableView) {
        [_slimeView scrollViewDidScroll];
    } else if (scView == tableViewPast){
        [_slimeViewPast scrollViewDidScroll];
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == tableView) {
        [_slimeView scrollViewDidEndDraging];
    } else if (scrollView == tableViewPast) {
        [_slimeViewPast scrollViewDidEndDraging];
    }
    
}

- (void)tableView:(UITableView *)tbleView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tbleView == tableView) {
        
        if ([indexPath row] == [dataList count]) {
            if (hasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"*****正在加载*****"]) {
                        
                    } else {
                        label.text = @"*****正在加载*****";
                        NSString *str =[self dateToStringDate:[NSDate date]];
                       
                        [self requestRecordList:str withEndDate:str withStart:start withSize:limit tag:kBusinessTagGetJRFundsList];
                       // [self requestRecordList:[str stringByReplacingOccurrencesOfString:@"-" withString:@""] withEndDate:[str stringByReplacingOccurrencesOfString:@"-" withString:@""] withStart:start withSize:limit tag:kBusinessTagGetJRFundsList];
                        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
        
    } else if (tbleView == tableViewPast) {
        
        if ([indexPath row] == [dataListPast count]) {
            if (hasMorePast) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"*****正在加载*****"]) {
                        
                    } else {
                        label.text = @"*****正在加载*****";
                        //[self requestRecordList:[dateLStarabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""] withEndDate:[dateLEndabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""] withStart:startPast withSize:limitPast tag:kBusinessTagGetJRFundsListPast]
                        [self requestRecordList:notStarDate withEndDate:notEddDate withStart:startPast withSize:limitPast tag:kBusinessTagGetJRFundsListPast];
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
- (NSInteger)tableView:(UITableView *)tabView numberOfRowsInSection:(NSInteger)section
{
    if (tabView == tableView) {
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

- (NSString *)AddComma:(NSString *)string{//添加逗号
    
    NSString *str=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    
    int numl=(int)[str length];
    NSLog(@"%d",numl);
    
    if (numl>3&&numl<7) {
        return [NSString stringWithFormat:@"%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else if (numl>6){
        return [NSString stringWithFormat:@"%@,%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-6)],
                [str substringWithRange:NSMakeRange(numl-6,3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else{
        return str;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    if (tbleView == tableView) {
        
        if ([dataList count] == 0) {
            
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
            [backView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
            //图标
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"none_charger_icon"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
            tipLabel.backgroundColor = [UIColor clearColor];
            [tipLabel setText:@"您还没有相关记录哦~"];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
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
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 100)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    //业务类别
                    UILabel *classLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,65 , 15)];
                    
                    
                        classLabTip.text = @"资金变动";
                   
                    
                    classLabTip.font = [UIFont systemFontOfSize:15];
                    classLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:classLabTip];
                    
                    
                    //发生余额(元)
                    UILabel *remainLab = [[UILabel alloc] init];
                   // NSString *adc;
                    
                    if (![[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_SRJE"] floatValue] <= 0) {
                        remainLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                        remainLab.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_SRJE"]  floatValue]];
                        
                    } else{
                        remainLab.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_FCJE"]  floatValue]];
                        remainLab.textColor = [ColorUtil colorWithHexString:@"047f47"];
                    }

                    
                    /*
                    NSRange range1 = [adc rangeOfString:@"."];//匹配得到的下标
                    
                    NSString *string = [adc substringFromIndex:range1.location];
                    
                    NSString *str = [adc substringToIndex:range1.location];
                    
                    remainLab.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    */
                    remainLab.font = [UIFont systemFontOfSize:15];
                    
                    
                    
                    CGSize titleSize = [remainLab.text sizeWithFont:remainLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
                    remainLab.frame = CGRectMake(75, 10,titleSize.width, 15);
                    [backView addSubview:remainLab];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(remainLab.frame.size.width + remainLab.frame.origin.x, 10, 13, 15)];
                    flagLabel.font = [UIFont systemFontOfSize:15];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    //资金余额(元)
                    
                    UILabel *reLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10 , 32,65 , 15)];
                    reLabTip.text = @"资金余额";
                    reLabTip.font = [UIFont systemFontOfSize:15];
                    reLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:reLabTip];
                    
                    
                    
                    UILabel *reLab = [[UILabel alloc] initWithFrame:CGRectMake( 75, 32,ScreenWidth - 75 , 15)];
                    /*
                    if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] floatValue] > 0) {
                        
                        
                        NSRange range = [[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] rangeOfString:@"."];//匹配得到的下标
                        
                        NSLog(@"rang:%@",NSStringFromRange(range));
                        
                        //string = [string substringWithRange:range];//截取范围类的字符串
                        
                        
                        
                        NSString *string1 = [[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] substringFromIndex:range.location];
                        
                        NSString *str1 = [[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] substringToIndex:range.location];
                        
                        reLab.text = [NSString stringWithFormat:@"%@%@元",[self AddComma:str1],string1];
                        
                    } else {
                        reLab.text = @"0.00元";
                    }
                    */
                    
                    reLab.text =[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] doubleValue]];
                    reLab.font = [UIFont systemFontOfSize:15];
                    reLab.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [backView addSubview:reLab];
                    
                    // 处理结果
                    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 54,65 , 15)];
                    endLabTip.text = @"处理摘要";
                    endLabTip.font = [UIFont systemFontOfSize:15];
                    endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:endLabTip];
                    
                    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 54,ScreenWidth - 85 , 15)];
                    endLab.text =[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_ZY"];
                    endLab.font = [UIFont systemFontOfSize:13];
                    endLab.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [backView addSubview:endLab];
                    
                    
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 76,ScreenWidth - 20 , 14)];
                    //日期格式转化
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_RQ"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    [strDate insertString:@"-" atIndex:4];
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    dateLab.text = [NSString stringWithFormat:@"%@  %@",strDate,[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_FSSJ"]];
                    dateLab.font = [UIFont systemFontOfSize:14];
                    dateLab.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:dateLab];
                    
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 1)];
                    [subView setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    if ([indexPath row] != 0) {
                        [backView addSubview:subView];
                    }
                    
                    
                    [cell.contentView addSubview:backView];
                    
                }
            }
        }
        return cell;
    } else if (tbleView == tableViewPast){
        
        if ([dataListPast count] == 0) {
            
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
            [backView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
            //图标
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"none_charger_icon"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:13]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
            [tipLabel setText:@"您还没有相关记录哦~"];
            tipLabel.backgroundColor = [UIColor clearColor];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
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
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 100)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    //业务类别
                    UILabel *classLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,65 , 15)];
                    
                    
                    classLabTip.text = @"资金变动";
                    
                    
                    
                    
                    classLabTip.font = [UIFont systemFontOfSize:15];
                    classLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:classLabTip];
                    
                    
                    //发生余额(元)
                    UILabel *remainLab = [[UILabel alloc] init];
                  //  NSString *adc;
                    
                    
                    
                    
                    
                    
                    if (![[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_SRJE"] floatValue] <= 0) {
                        remainLab.textColor = [ColorUtil colorWithHexString:@"047f47"];
                        remainLab.text = [NSString stringWithFormat:@"%.2f",[[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_SRJE"]  floatValue]];
                        
                    } else{
                        remainLab.text = [NSString stringWithFormat:@"%.2f",[[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_FCJE"]  floatValue]];
                        remainLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    }
                    
                    /*
                      if ([adc floatValue] > 1 && [adc floatValue] < 900000000) {
                    
                    
                    
                    
                    NSRange range1 = [adc rangeOfString:@"."];//匹配得到的下标
                    
                    NSString *string = [adc substringFromIndex:range1.location];
                    
                    NSString *str = [adc substringToIndex:range1.location];
                    
                    remainLab.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                      }else {
                      remainLab.text = [NSString stringWithFormat:@"%.2f",[adc floatValue]];
                      
                      }
                          
                     */
                          
                    remainLab.font = [UIFont systemFontOfSize:15];
                    
                    
                    
                    CGSize titleSize = [remainLab.text sizeWithFont:remainLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
                    remainLab.frame = CGRectMake(75, 10,titleSize.width, 15);
                    [backView addSubview:remainLab];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(remainLab.frame.size.width + remainLab.frame.origin.x, 10, 15, 15)];
                    flagLabel.font = [UIFont systemFontOfSize:15];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    //资金余额(元)
                    
                    UILabel *reLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 32,65 , 15)];
                    reLabTip.text = @"资金余额";
                    reLabTip.font = [UIFont systemFontOfSize:15];
                    reLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:reLabTip];
                    
                    
                    
                    UILabel *reLab = [[UILabel alloc] initWithFrame:CGRectMake(10 + 65, 32,ScreenWidth - 75 , 15)];
                     reLab.text = [NSString stringWithFormat:@"%.2f元",[[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] doubleValue]];
                    
                    /*
                    if ([[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] floatValue] > 1 && [[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] floatValue] < 900000000) {
                        
                        
                        NSRange range = [[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] rangeOfString:@"."];//匹配得到的下标
                        
                        NSLog(@"rang:%@",NSStringFromRange(range));
                        
                        //string = [string substringWithRange:range];//截取范围类的字符串
                        
                        
                        
                        NSString *string1 = [[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] substringFromIndex:range.location];
                        
                        NSString *str1 = [[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] substringToIndex:range.location];
                        
                        reLab.text = [NSString stringWithFormat:@"%@%@元",[self AddComma:str1],string1];
                        
                    } else {
                        if ([[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] floatValue] == 0) {
                             reLab.text = @"0.00元";
                        } else {
                        
                            reLab.text = [NSString stringWithFormat:@"%.2f元",[[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] floatValue]];
                        }
                       
                    }
                    */
                    reLab.font = [UIFont systemFontOfSize:15];
                    reLab.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [backView addSubview:reLab];
                    
                    // 处理结果
                    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 54,65 , 15)];
                    endLabTip.text = @"处理摘要";
                    endLabTip.font = [UIFont systemFontOfSize:15];
                    endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:endLabTip];
                    
                    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 54,ScreenWidth - 85 , 15)];
                    endLab.text =[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_ZY"];
                    endLab.font = [UIFont systemFontOfSize:15];
                    endLab.textColor = [ColorUtil colorWithHexString:@"333333"];
                    [backView addSubview:endLab];
                    
                    
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 76,ScreenWidth - 20 , 14)];
                    //日期格式转化
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_RQ"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    [strDate insertString:@"-" atIndex:4];
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    dateLab.text = [NSString stringWithFormat:@"%@  %@",strDate,[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"FID_FSSJ"]];
                    dateLab.font = [UIFont systemFontOfSize:14];
                    dateLab.textColor = [ColorUtil colorWithHexString:@"999999"];
                    [backView addSubview:dateLab];
                    
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 1)];
                    [subView setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    if ([indexPath row] != 0) {
                        [backView addSubview:subView];
                    }
                    
                    
                    [cell.contentView addSubview:backView];
                    
                }
            }
        }
        return cell;
    }
    return nil;
}

-(NSString *)getClassMethod:(NSString *)str {
    NSString *string;
    if ([str isEqualToString:@"1"]) {
        string = @"入金";
    } else if ([str isEqualToString:@"2"]){
        string = @"出金";
    } else if ([str isEqualToString:@"4"]){
        string = @"查询";
    } else if ([str isEqualToString:@"8"]){
        string = @" 开户";
    }else if ([str isEqualToString:@"16"]){
        string = @"销户";
    }
    return string;
}

-(NSString *)getEndMethod:(NSString *)str {
    NSString *string;
    if ([str isEqualToString:@"0"]) {
        string = @"待处理";
    } else if ([str isEqualToString:@"1"]){
        string = @"正在处理";
    } else if ([str isEqualToString:@"-812"]){
        string = @"交易状态查询返回结果为处理中";
    } else if ([str isEqualToString:@"111"]){
        string = @" 交易成功";
    }
    return string;
    
}




-(CGFloat)tableView:(UITableView *)tabView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tabView == tableView) {
        if ([indexPath row] == [dataList count]) {
            return 40;
        } else {
            return 100;
        }
        
    } else {
        if ([indexPath row] == [dataListPast count]) {
            return 40;
        } else {
            return 100;
        }
    }
    return 95;
}

#pragma mark - Recived Methods
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
    [tableView reloadData];
    [_slimeView endRefresh];
}



#pragma mark - Recived Methods
//处理品牌列表
- (void)recivedDataList:(NSMutableArray *)dataArray
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
        start = [NSString stringWithFormat:@"%d", [start intValue] + 10];
    }
    [tableView reloadData];
    [_slimeView endRefresh];
}

- (void)recivedPastDataList:(NSMutableArray *)dataArray
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
        startPast = [NSString stringWithFormat:@"%d", [startPast intValue] + 10];
    }
    [tableViewPast reloadData];
    [_slimeViewPast endRefresh];
}


#pragma mark - Request Methods
//请求登陆
- (void)requestRecordList:(NSString *)_startDate withEndDate:(NSString *)_endDate withStart:(NSString *)_start withSize:(NSString *)_size tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_startDate forKey:@"ksrq"];
    [paraDic setObject:_endDate forKey:@"jsrq"];
    [paraDic setObject:_size forKey:@"rowcount"];
    [paraDic setObject:_start forKey:@"rowindex"];
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
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
    
    if (tag==kBusinessTagGetJRFundsList) {
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
             [self.view makeToast:@"刷新商品失败"];
        } else {
             if ([jsonDic objectForKey:@"object"] != [NSNull null]) {
            [self recivedDataList:dataArray];
             }
        }
    }else if (tag == kBusinessTagGetJRFundsListAgain){
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [dataList removeAllObjects];
             if ([jsonDic objectForKey:@"object"] != [NSNull null]) {
            [self recivedDataList:dataArray];
             }else {
              [_slimeView endRefresh];
             }
        }
        
    } else if (tag==kBusinessTagGetJRFundsListPast) {
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"] == YES) {
                
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:NO];
                
            } else {
                
                [self.view makeToast:@"获取项目失败"];
            }
            
        } else {
             if ([jsonDic objectForKey:@"object"] != [NSNull null]) {
            [self recivedPastDataList:dataArray];
             }
        }
    }else if (tag == kBusinessTagGetJRFundsListPastAgain){
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        [_slimeViewPast endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [dataListPast removeAllObjects];
              if ([jsonDic objectForKey:@"object"] != [NSNull null]) {
            [self recivedPastDataList:dataArray];
              }else {
            [_slimeView endRefresh];
        }
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
@end
