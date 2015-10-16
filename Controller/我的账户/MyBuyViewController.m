//
//  MyBuyViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyBuyViewController.h"
#import "AppDelegate.h"
 int count;

@interface MyBuyViewController ()
{
    UITableView *tableView;
    NSMutableArray *dataList;
    UITableViewCell *moreCell;
    SRRefreshView   *_slimeView;
    float addHight;
    
    UILabel *SelectLable;
    UIImageView *isOpenView;
   
    UIView *dateView;
    UITextField *nameText;
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    UIToolbar *tooBar;
    UIToolbar *timeTooBar;
    UILabel *dateLStarabel;
    UILabel *dateLEndabel;
    
}
@end

@implementation MyBuyViewController

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
    
   /*
    
   UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(10,addHight + 44+ 10, 160, 30)];
    nameView.backgroundColor = [UIColor whiteColor];
    nameView.layer.cornerRadius = 2;
    nameView.layer.masksToBounds = YES;
    nameText = [[UITextField alloc] initWithFrame:CGRectMake(5, 8, 150, 14)];
    nameText.backgroundColor = [UIColor whiteColor];
    nameText.placeholder = @"输入产品名称模糊查询";
   
    nameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    // sureText.keyboardType = UIKeyboardTypeNumberPad;
    nameText.font = [UIFont systemFontOfSize:14];
    nameText.delegate = self;
    [nameView addSubview:nameText];
    [self.view addSubview:nameView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(175,addHight + 44+ 10, 45, 30);
    sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 2;
    
    [sureBtn setTitle:@"查询" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [sureBtn addTarget:self action:@selector(sureMehtods:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureBtn];
    
    
   
    SelectLable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 90, addHight + 44 + 10, 80, 30)];
    SelectLable.backgroundColor = [UIColor clearColor];
    SelectLable.textColor = [ColorUtil colorWithHexString:@"999999"];
    SelectLable.font = [UIFont systemFontOfSize:13];
    SelectLable.textAlignment = NSTextAlignmentLeft;

    SelectLable.text = @"按名称查询";
    //SelectLable.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
   
    isOpenView = [[UIImageView alloc] initWithFrame:CGRectMake(80 - 15, 5/2 + 5, 10, 15)];
    isOpenView.image = [UIImage imageNamed:@"dropdown.png"];
    [SelectLable addSubview:isOpenView];
    SelectLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDDList:)];
    
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [SelectLable addGestureRecognizer:singleTap1];
    
    [self.view addSubview:SelectLable];
    
    */
    
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0,addHight + 44+ 10, ScreenWidth, 40)];
    dateView.backgroundColor = [UIColor clearColor];
    
    
    [self reloadView];
    
    //dateView.hidden = YES;
    [self.view addSubview:dateView];
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 44 + addHight + 50, ScreenWidth,  ScreenHeight - 64)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]];
    //tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
    
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
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ScreenHeight - 200, ScreenWidth, 200)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ScreenHeight - 200, ScreenWidth, 200)];
    timePicker.backgroundColor = [UIColor whiteColor];
    timePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = YES;
    timePicker.hidden = YES;
    [self.view addSubview:timePicker];
    [self.view addSubview:datePicker];
    
    tooBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,ScreenHeight - 200 - 30, ScreenWidth, 40)];
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
    [self.view addSubview:tooBar];
    
    timeTooBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200 - 30, ScreenWidth, 40)];
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
    [self.view addSubview:timeTooBar];
    
    
    
    
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //获取类别信息
        
        [self requestMoney:kBusinessTagGetJRjrzcjywdsy];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
}

-(void)reloadView {
    
    //起始日期
    
    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(8.5, 8,52 , 13)];
    endLabTip.text = @"开始日期";
    endLabTip.font = [UIFont systemFontOfSize:13];
    endLabTip.backgroundColor = [UIColor clearColor];
    endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
    [dateView addSubview:endLabTip];
    
    
    
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake( 62, 0,(ScreenWidth - 184)/2, 30)];
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
    
    
    
    dateLStarabel.text = [[self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:-1 withDay:-2]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateLStarabel.userInteractionEnabled = YES;
    
    
    
    [startView addSubview:dateLStarabel];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    [startView addGestureRecognizer:singleTap];
    
    [dateView addSubview:startView];
    
    
    
    
    
    //截止日期
    
    
    UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(67 + (ScreenWidth - 184)/2,8.5, 52, 13)];
    starLabel.font = [UIFont systemFontOfSize:13];
    starLabel.text = @"结束日期";
    starLabel.backgroundColor = [UIColor clearColor];
    starLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
    starLabel.textAlignment = NSTextAlignmentCenter;
    [dateView addSubview:starLabel];
    
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(124 + (ScreenWidth - 184)/2, 0, (ScreenWidth - 184)/2, 30)];
    endView.backgroundColor = [UIColor whiteColor];
    endView.layer.borderWidth = 1;
    endView.layer.borderColor = [[ColorUtil colorWithHexString:@"dedede"] CGColor];
    endView.layer.cornerRadius = 3;
    endView.layer.masksToBounds = YES;
    
    
    
    dateLEndabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (ScreenWidth - 184)/2 - 7, 30)];
    dateLEndabel.font = [UIFont systemFontOfSize:13];
    dateLEndabel.textColor = [ColorUtil colorWithHexString:@"333333"];
   // dateLEndabel.textAlignment = NSTextAlignmentCenter;
    
    dateLEndabel.text = [[self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:0 withDay:-1]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [endView addSubview:dateLEndabel];
    
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone1:)];
    [endView addGestureRecognizer:singleTap1];
    [dateView addSubview:endView];
    
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame:CGRectMake( ScreenWidth - 50, 0,  40, 30)];
    queryBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    //queryBtn.layer.borderWidth = 1;
    //queryBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    queryBtn.layer.cornerRadius = 3;
    queryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [queryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(queryBtn) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:queryBtn];
    
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
        
        dateLStarabel.text = [[self dateToStringDate:datePicker.date] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        // dateLStarabel.text = [self dateToStringDate:datePicker.date];
    } else if (btn.tag == 2){
        timeTooBar.hidden = YES;
        timePicker.hidden = YES;
        
        dateLEndabel.text = [[self dateToStringDate:timePicker.date] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
    }
}

- (void)alterMessage:(NSString *)messageString{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [al show];
}

-(void)sureMehtods:(UIButton *)btn{
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self requestCategerWithName:kBusinessTagGetJRjrzcjywdsyName];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
}



- (void)countDay {
    
    NSDate *nowDate = [self getPriousorLaterDateFromDate:[NSDate date] withMonth:0 withDay:-1];
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
            [self requestCategerWithDate:dateLStarabel.text withSize:dateLEndabel.text tag:kBusinessTagGetJRjrzcjywdsyDate];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        
        
        
    }
    
    
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
    timePicker.date = [self dateFromString:dateLEndabel.text];
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
    [_ddList.view setFrame:CGRectMake(ScreenWidth - 90, 80 + addHight, 80, 0)];
    //[self setDDListHidden:YES];
    count = 0;
    
}


- (void)setDDListHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0 : 70;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [_ddList.view setFrame:CGRectMake(ScreenWidth - 90, 80 + addHight, 80, height)];
    [UIView commitAnimations];
}

- (void)passBankCode:(NSString *)value{
    // bankName = value;
    if ([value isEqualToString:@"按时间查询"]) {
        dateView.hidden = NO;
        tableView.frame = CGRectMake(0 , 44 + addHight + 90, ScreenWidth,  ScreenHeight - 64 - 90);
        
        
    } else {
     dateView.hidden = YES;
      tableView.frame = CGRectMake(0 , 44 + addHight + 50, ScreenWidth,  ScreenHeight - 64 - 50);
    
    }
    
    
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




#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
   [self requestMoney:kBusinessTagGetJRjrzcjywdsyAgain];
}
#pragma mark - UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}




#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataList count] == 0) {
        return 1;
    } else {
        return [dataList count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
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
            [tipLabel setText:@"您还没有已获收益哦~"];
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
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor clearColor]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth , 30)];
                [backView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                
                //品牌
                
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
                brandLabel.font = [UIFont boldSystemFontOfSize:14];
                [brandLabel setTextColor:[ColorUtil colorWithHexString:@"646464"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPMC"];
                [backView addSubview:brandLabel];
                
                
                UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, ScreenWidth - 240, 30)];
                moneyLabel.font = [UIFont boldSystemFontOfSize:12];
                [moneyLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                [moneyLabel setBackgroundColor:[UIColor clearColor]];
                moneyLabel.textAlignment = NSTextAlignmentRight;
                moneyLabel.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GQSL"]];
                [backView addSubview:moneyLabel];
  //secondView
                UIView *secondView  = [[UIView alloc] initWithFrame:CGRectMake(0,31, ScreenWidth , 49)];
                [secondView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                
                UILabel *classLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 8,ScreenWidth/2 - 20 , 13)];
                classLab.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_LX"];
                classLab.font = [UIFont systemFontOfSize:13];
                classLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
                [secondView addSubview:classLab];
                
      //收益
                UILabel *classLabTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 29,ScreenWidth/2 - 20 , 13)];
                classLabTip.text = @"收益";
                classLabTip.font = [UIFont systemFontOfSize:13];
                classLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                [secondView addSubview:classLabTip];
                
                
        //产品收益率(元)
                UILabel *remainLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 20, 8,ScreenWidth/2 - 40 , 13)];
                remainLab.text =[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GZLL"];
                remainLab.font = [UIFont systemFontOfSize:13];
                remainLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
                [secondView addSubview:remainLab];
                
                UILabel *remainLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 20, 29,ScreenWidth/2 - 40 , 13)];
                remainLabTip.text = @"产品收益率(%)";
                remainLabTip.font = [UIFont systemFontOfSize:12];
                remainLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                [secondView addSubview:remainLabTip];
                
                [cell.contentView addSubview:secondView];
                
                
                
                //投资金额(元)
                
                UIView *viewYQ = [[UIView alloc] initWithFrame:CGRectMake(0,81, (ScreenWidth - 2)/3, 49)];
                [viewYQ setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                
                UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 99, 13)];
                lab1.textAlignment = NSTextAlignmentCenter;
                lab1.textColor = [ColorUtil colorWithHexString:@"333333"];
                lab1.font = [UIFont systemFontOfSize:13];
                lab1.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_FXRQ"];
                [viewYQ addSubview:lab1];
                
                UILabel *lab1Tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, 99, 13)];
                lab1Tip.textAlignment = NSTextAlignmentCenter;
                lab1Tip.textColor = [ColorUtil colorWithHexString:@"999999"];
                lab1Tip.font = [UIFont systemFontOfSize:13];
                lab1Tip.text = @"付息日期";
                [viewYQ addSubview:lab1Tip];
                
                [cell.contentView addSubview:viewYQ];
                
                
                //投资日期
                
                UIView *viewRQ = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - 2)/3 + 1,81, (ScreenWidth - 2)/3, 49)];
                [viewRQ setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                
                UILabel *labRQ = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 99, 13)];
                labRQ.textAlignment = NSTextAlignmentCenter;
                labRQ.textColor = [ColorUtil colorWithHexString:@"333333"];
                labRQ.font = [UIFont systemFontOfSize:13];
               
                
                labRQ.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_JXFS"] ;
                [viewRQ addSubview:labRQ];
                
                
                
                UILabel *lab2Tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, 99, 13)];
                lab2Tip.textAlignment = NSTextAlignmentCenter;
                lab2Tip.textColor = [ColorUtil colorWithHexString:@"999999"];
                lab2Tip.font = [UIFont systemFontOfSize:12];
                lab2Tip.text = @"付息方式";
                [viewRQ addSubview:lab2Tip];
                
                [cell.contentView addSubview:viewRQ];
                
                
                //已认购金额
                
                UIView *viewFX = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - 2)*2/3 + 2,81, (ScreenWidth - 2)/3, 49)];
                [viewFX setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                
                UILabel *labFX = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 99, 13)];
                labFX.textAlignment = NSTextAlignmentCenter;
                labFX.textColor = [ColorUtil colorWithHexString:@"333333"];
                labFX.font = [UIFont systemFontOfSize:13];
                
                labFX.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCYE_LCBJ"];
                [viewFX addSubview:labFX];
                
                UILabel *lab3Tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, 99, 13)];
                lab3Tip.textAlignment = NSTextAlignmentCenter;
                lab3Tip.textColor = [ColorUtil colorWithHexString:@"999999"];
                lab3Tip.font = [UIFont systemFontOfSize:12];
                lab3Tip.text = @"本金(元)";
                [viewFX addSubview:lab3Tip];
                
                [cell.contentView addSubview:viewFX];
                
                [cell.contentView addSubview:backView];
                
                
            }
        }
        return cell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == [dataList count]) {
        return 40;
    } else {
        return 140;
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
    [tableView reloadData];
    [_slimeView endRefresh];
}

- (void)requestCategerWithName:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:nameText.text forKey:@"cpmc"];
    //[paraDic setObject:_size forKey:@"pageSize"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}


- (void)requestCategerWithDate:(NSString *)_str withSize:(NSString *)_size   tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_str forKey:@"ksrq"];
    [paraDic setObject:_size forKey:@"jsrq"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}




- (void)requestMoney:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    //[paraDic setObject:_start forKey:@"pageIndex"];
    //[paraDic setObject:_size forKey:@"pageSize"];
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
    
    if (tag==kBusinessTagGetJRjrzcjywdsy) {
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
            [self recivedCategoryList:dataArray];
        }
    }else if (tag == kBusinessTagGetJRjrzcjywdsyAgain){
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [dataList removeAllObjects];
            [self recivedCategoryList:dataArray];
        }
        
    } else if (tag==kBusinessTagGetJRjrzcjywdsyDate) {
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
            [dataList removeAllObjects];
            [self recivedCategoryList:dataArray];
        }
    } else if (tag==kBusinessTagGetJRjrzcjywdsyName) {
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
            [dataList removeAllObjects];
            [self recivedCategoryList:dataArray];
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

#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
