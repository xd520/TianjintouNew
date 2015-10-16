//
//  DelegateTodayViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-14.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "DelegateTodayViewController.h"
#import "HMSegmentedControl.h"
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

@interface DelegateTodayViewController (){
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
     NSString *chedanTag;
    
     UISegmentedControl  *segmented;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *waitTableView;
@property (strong, nonatomic) UITableView *shipTableView;
@property (strong, nonatomic) UITableView *finishTableView;


@end

@implementation DelegateTodayViewController


-(void) segmentAction:(UISegmentedControl *)Seg{
    
    
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li",(long)Index);
    
    __weak typeof(self) weakSelf = self;
    
    if (Seg.selectedSegmentIndex == 0) {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
    } else if(Seg.selectedSegmentIndex == 1){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth* Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }else if(Seg.selectedSegmentIndex == 2){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }else if(Seg.selectedSegmentIndex == 3){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth* Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }
}

- (void)viewDidLoad {
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

    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"全部",@"已成交",@"已申报",@"已撤销",nil];
    
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    
    
    segmented.frame = CGRectMake(10, 54 + addHight, ScreenWidth - 20, 30);
    
    
    
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
    
//温馨提示
    
    UIImageView *tip = [[UIImageView alloc] initWithFrame:CGRectMake(10, addHight + 44 + 50, 15, 15)];
    tip.image = [UIImage imageNamed:@"icon_nof"];
    
    [self.view addSubview:tip];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(30, addHight + 44 + 50, ScreenWidth - 40, 15)];
    tipLab.text = @"温馨提示认购产品不能撤单";
     tipLab.backgroundColor = [UIColor clearColor];
    tipLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    tipLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:tipLab];
    
    
    
    //给segmentedControl添加scrollView的联动事件
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 75;
   
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75 + 44 + addHight, ScreenWidth, scrollViewHeight)];
   
    self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*4, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 75 + 44 + addHight, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, scrollViewHeight)];
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
    
    self.finishTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, scrollViewHeight)];
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
    
    self.waitTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, scrollViewHeight)];
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
    
    self.shipTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, scrollViewHeight)];
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
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //获取类别信息
        //购买记录
        
            start = @"1";
            [self requestRecordPastList:@"" tag:kBusinessTagGetJRtodayEntrustPage];
       
            //购买申请
            finishStart = @"1";
            
            [self requestRecordPastList:@"2" tag:kBusinessTagGetJRtodayEntrustPage1];;
       
            //转让记录
            waitStart = @"1";
            
            [self requestRecordPastList:@"6" tag:kBusinessTagGetJRtodayEntrustPage2];
            
     
            //转让申请
            shipStart = @"1";
            
            [self requestRecordPastList:@"8" tag:kBusinessTagGetJRtodayEntrustPage3];
            
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

    
}


- (void)requestRecordPastList:(NSString *)_sbjg tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_sbjg forKey:@"sbjg"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

- (void)requestGiveupList:(NSString *)_sbjg withWtfs:(NSString *)_wtfs tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_sbjg forKey:@"wth"];
    [paraDic setObject:_wtfs forKey:@"wtfs"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}



#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == TSEGSCROLLVIEW) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
         segmented.selectedSegmentIndex = page;
        
        //添加指示器及遮罩
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //获取类别信息
            //购买记录
            
            if (page == 0) {
                start = @"1";
                
                [self requestRecordPastList:@"" tag:kBusinessTagGetJRtodayEntrustPageAgain];
            }else if (page == 1){
                //购买申请
                finishStart = @"1";
                
                [self requestRecordPastList:@"2" tag:kBusinessTagGetJRtodayEntrustPage1Again];;
            } else if(page == 2){
                //转让记录
                waitStart = @"1";
                
                [self requestRecordPastList:@"6" tag:kBusinessTagGetJRtodayEntrustPage2Again];
                
            } else if (page == 3){
                //转让申请
                shipStart = @"1";
                
                [self requestRecordPastList:@"8" tag:kBusinessTagGetJRtodayEntrustPage3Again];
                
            }

            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        
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
    if (refreshView.tag == TTR) {
       // startBak = [NSString stringWithString:start];
        start = @"1";
         [self requestRecordPastList:@"" tag:kBusinessTagGetJRtodayEntrustPageAgain];
    } else if (refreshView.tag == TFINISHTR) {
       // finishStartBak = [NSString stringWithString:finishStart];
        finishStart = @"1";
        [self requestRecordPastList:@"2" tag:kBusinessTagGetJRtodayEntrustPage1Again];
    } else if (refreshView.tag == WAITTTR) {
       // waitStartBak = [NSString stringWithString:waitStart];
        waitStart = @"1";
         [self requestRecordPastList:@"6" tag:kBusinessTagGetJRtodayEntrustPage2Again];
    } else if (refreshView.tag == SHIPTTR) {
       // shipStartBak = [NSString stringWithString:shipStart];
        shipStart = @"1";
         [self requestRecordPastList:@"8" tag:kBusinessTagGetJRtodayEntrustPage3Again];
    }
    
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TTABLEVIEW) {
        if ([indexPath row] == [dataList count]) {
            if (hasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"正在加载中..."]) {
                        
                    } else {
                        label.text = @"正在加载中...";
                         [self requestRecordPastList:@"" tag:kBusinessTagGetJRtodayEntrustPage];
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
                        [self requestRecordPastList:@"2" tag:kBusinessTagGetJRtodayEntrustPage1];
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
                         [self requestRecordPastList:@"6" tag:kBusinessTagGetJRtodayEntrustPage2];
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
                         [self requestRecordPastList:@"8" tag:kBusinessTagGetJRtodayEntrustPage3];
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
    }
    
    
}

*/

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
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有订单记录哦~"];
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
               // return moreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    UIView *backView;
                    
                    if ([indexPath row] == 0) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                    } else {
                    
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                       backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 120)];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                    
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 14)];
                    brandLabel.font = [UIFont systemFontOfSize:14];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CPMC"];
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 60, 14)];
                    delegateLabel.font = [UIFont systemFontOfSize:14];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                   // delegateLabel.textAlignment = NSTextAlignmentRight;
                    delegateLabel.text = @"申请类型";
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31, ScreenWidth - 120 - 70, 14)];
                    yuqiLabel.font = [UIFont systemFontOfSize:14];
                    [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    yuqiLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_LBMC"];
                    [backView addSubview:yuqiLabel];
                    //申报结果
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 14)];
                    yuqiLabelTip.font = [UIFont systemFontOfSize:14];
                    [yuqiLabelTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"申报结果";
                    [backView addSubview:yuqiLabelTip];
                    
                    UILabel *shenbaoTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, ScreenWidth - 120 - 70, 14)];
                    shenbaoTip.font = [UIFont systemFontOfSize:14];
                    [shenbaoTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    shenbaoTip.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    [backView addSubview:shenbaoTip];
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 73, 60, 14)];
                    giveLabel.font = [UIFont systemFontOfSize:14];
                    [giveLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    //giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"成交金额";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:14];
                    [giveLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] doubleValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    giveLabelTip.frame = CGRectMake(70, 73, titleSize1.width, 14);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 73, 14, 14)];
                    flagLabel1.font = [UIFont systemFontOfSize:14];
                    [flagLabel1 setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    //flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    

                    
                    
                    //委托金额
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 14)];
                    valueLabel.font = [UIFont systemFontOfSize:14];
                    [valueLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                   // valueLabel.textAlignment = NSTextAlignmentRight;
                    valueLabel.text = @"委托金额";
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont systemFontOfSize:14];
                    [valueLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                    NSString *abc;
                    
                    if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]) {
                         abc = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    } else  {
                    
                        abc = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] doubleValue]];
                    }
                    
                   
                    
                    NSRange range1 = [abc rangeOfString:@"."];//匹配得到的下标
                    
                    NSLog(@"rang:%@",NSStringFromRange(range1));
                    
                    //string = [string substringWithRange:range];//截取范围类的字符串
                    
                    
                    
                    NSString *string = [abc substringFromIndex:range1.location];
                    
                    NSString *str = [abc substringToIndex:range1.location];
                    
                    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    
                    
                    
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    valueLabelTip.frame = CGRectMake(70, 94, titleSize.width, 14);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 94, 14, 14)];
                    flagLabel.font = [UIFont systemFontOfSize:14];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    
                   
                    
                    if (![[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]&&[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_SBJG"] isEqualToString:@"2"]) {
                        //投资按钮
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(ScreenWidth - 20 - 80, 50, 80, 30);
                        button.tag = [indexPath row];
                        button.backgroundColor = [UIColor orangeColor];
                        [button setTitle:@"撤单" forState:UIControlStateNormal];
                        button.layer.cornerRadius = 3;
                        button.titleLabel.font = [UIFont systemFontOfSize:15];
                        [button addTarget:self action:@selector(touziBtn:) forControlEvents:UIControlEventTouchUpInside];
                        button.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
                        button.layer.cornerRadius = 4;
                        button.layer.masksToBounds = YES;
                       
                         [backView addSubview:button];
                    }
                    
                   
                    
                    
                    [cell.contentView addSubview:backView];
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
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有订单记录哦~"];
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
                    
                    UIView *backView;
                    
                    if ([indexPath row] == 0) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                    } else {
                        
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                         backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 120)];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                   
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 14)];
                    brandLabel.font = [UIFont systemFontOfSize:14];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CPMC"];
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 60, 14)];
                    delegateLabel.font = [UIFont systemFontOfSize:14];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    // delegateLabel.textAlignment = NSTextAlignmentRight;
                    delegateLabel.text = @"申请类型";
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31, ScreenWidth - 120 - 70, 14)];
                    yuqiLabel.font = [UIFont systemFontOfSize:14];
                    [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    yuqiLabel.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_LBMC"];
                    [backView addSubview:yuqiLabel];
                    //申报结果
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 14)];
                    yuqiLabelTip.font = [UIFont systemFontOfSize:14];
                    [yuqiLabelTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"申报结果";
                    [backView addSubview:yuqiLabelTip];
                    
                    UILabel *shenbaoTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, ScreenWidth - 120 - 70, 14)];
                    shenbaoTip.font = [UIFont systemFontOfSize:14];
                    [shenbaoTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    shenbaoTip.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    [backView addSubview:shenbaoTip];
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 73, 60, 14)];
                    giveLabel.font = [UIFont systemFontOfSize:14];
                    [giveLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    //giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"成交金额";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:14];
                    [giveLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    
                    
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] doubleValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    giveLabelTip.frame = CGRectMake(70, 73, titleSize1.width, 14);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 73, 14, 14)];
                    flagLabel1.font = [UIFont systemFontOfSize:14];
                    [flagLabel1 setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    //flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    
                    
                    
                    
                    //委托金额
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 14)];
                    valueLabel.font = [UIFont systemFontOfSize:14];
                    [valueLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    // valueLabel.textAlignment = NSTextAlignmentRight;
                    valueLabel.text = @"委托金额";
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont systemFontOfSize:14];
                    [valueLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                   // NSString *abc  = [NSString stringWithFormat:@"%.2f",[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] doubleValue]];
                    
                    NSString *abc;
                    
                    if ([[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]) {
                        abc = [NSString stringWithFormat:@"%.2f",[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    } else  {
                        
                        abc = [NSString stringWithFormat:@"%.2f",[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] doubleValue]];
                    }
                    

                    
                    
                    NSRange range1 = [abc rangeOfString:@"."];//匹配得到的下标
                    
                    NSLog(@"rang:%@",NSStringFromRange(range1));
                    
                    //string = [string substringWithRange:range];//截取范围类的字符串
                    
                    
                    
                    NSString *string = [abc substringFromIndex:range1.location];
                    
                    NSString *str = [abc substringToIndex:range1.location];
                    
                    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    
                    
                    
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    valueLabelTip.frame = CGRectMake(70, 94, titleSize.width, 14);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 94, 14, 14)];
                    flagLabel.font = [UIFont systemFontOfSize:14];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    
                    
                    
                    if (![[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]&&[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_SBJG"] isEqualToString:@"2"]) {
                        //投资按钮
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(ScreenWidth - 20 - 80, 50, 80, 30);
                        button.tag = [indexPath row];
                        button.backgroundColor = [UIColor orangeColor];
                        [button setTitle:@"撤单" forState:UIControlStateNormal];
                        button.layer.cornerRadius = 3;
                        button.titleLabel.font = [UIFont systemFontOfSize:15];
                        [button addTarget:self action:@selector(touziBtn:) forControlEvents:UIControlEventTouchUpInside];
                        button.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
                        button.layer.cornerRadius = 4;
                        button.layer.masksToBounds = YES;
                        
                        [backView addSubview:button];
                    }
                    
                    
                    
                    
                    [cell.contentView addSubview:backView];
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
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有订单记录哦~"];
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
                    
                    UIView *backView;
                    
                    if ([indexPath row] == 0) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                    } else {
                        
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 120)];
                    }
                    
                    
                   // cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                   // UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 120)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 14)];
                    brandLabel.font = [UIFont systemFontOfSize:14];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CPMC"];
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 60, 14)];
                    delegateLabel.font = [UIFont systemFontOfSize:14];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    // delegateLabel.textAlignment = NSTextAlignmentRight;
                    delegateLabel.text = @"申请类型";
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31, ScreenWidth - 120 - 70, 14)];
                    yuqiLabel.font = [UIFont systemFontOfSize:14];
                    [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    yuqiLabel.text = [[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_LBMC"];
                    [backView addSubview:yuqiLabel];
                    //申报结果
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 14)];
                    yuqiLabelTip.font = [UIFont systemFontOfSize:14];
                    [yuqiLabelTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"申报结果";
                    [backView addSubview:yuqiLabelTip];
                    
                    UILabel *shenbaoTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, ScreenWidth - 120 - 70, 14)];
                    shenbaoTip.font = [UIFont systemFontOfSize:14];
                    [shenbaoTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    shenbaoTip.text = [[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    [backView addSubview:shenbaoTip];
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 73, 60, 14)];
                    giveLabel.font = [UIFont systemFontOfSize:14];
                    [giveLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    //giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"成交金额";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:14];
                    [giveLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] doubleValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    giveLabelTip.frame = CGRectMake(70, 73, titleSize1.width, 14);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 73, 14, 14)];
                    flagLabel1.font = [UIFont systemFontOfSize:14];
                    [flagLabel1 setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    //flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    
                    
                    
                    
                    //委托金额
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 14)];
                    valueLabel.font = [UIFont systemFontOfSize:14];
                    [valueLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    // valueLabel.textAlignment = NSTextAlignmentRight;
                    valueLabel.text = @"委托金额";
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont systemFontOfSize:14];
                    [valueLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                   // NSString *abc  = [NSString stringWithFormat:@"%.2f",[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] doubleValue]];
                    
                    NSString *abc;
                    
                    if ([[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]) {
                        abc = [NSString stringWithFormat:@"%.2f",[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    } else  {
                        
                        abc = [NSString stringWithFormat:@"%.2f",[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] doubleValue]];
                    }
                    

                    
                    NSRange range1 = [abc rangeOfString:@"."];//匹配得到的下标
                    
                    NSLog(@"rang:%@",NSStringFromRange(range1));
                    
                    //string = [string substringWithRange:range];//截取范围类的字符串
                    
                    
                    
                    NSString *string = [abc substringFromIndex:range1.location];
                    
                    NSString *str = [abc substringToIndex:range1.location];
                    
                    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    
                    
                    
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    valueLabelTip.frame = CGRectMake(70, 94, titleSize.width, 14);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 94, 14, 14)];
                    flagLabel.font = [UIFont systemFontOfSize:14];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    
                    
                    
                    if (![[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]&&[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_SBJG"] isEqualToString:@"2"]) {
                        //投资按钮
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(ScreenWidth - 20 - 80, 50, 80, 30);
                        button.tag = [indexPath row];
                        button.backgroundColor = [UIColor orangeColor];
                        [button setTitle:@"撤单" forState:UIControlStateNormal];
                        button.layer.cornerRadius = 3;
                        button.titleLabel.font = [UIFont systemFontOfSize:15];
                        [button addTarget:self action:@selector(touziBtn:) forControlEvents:UIControlEventTouchUpInside];
                        button.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
                        button.layer.cornerRadius = 4;
                        button.layer.masksToBounds = YES;
                        
                        [backView addSubview:button];
                    }
                    
                    
                    
                    
                    [cell.contentView addSubview:backView];
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
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有订单记录哦~"];
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
                    
                    UIView *backView;
                    
                    if ([indexPath row] == 0) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                    } else {
                        
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 120)];
                    }
                    
                   // cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                   // UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 120)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 14)];
                    brandLabel.font = [UIFont systemFontOfSize:14];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CPMC"];
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 60, 14)];
                    delegateLabel.font = [UIFont systemFontOfSize:14];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    // delegateLabel.textAlignment = NSTextAlignmentRight;
                    delegateLabel.text = @"申请类型";
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31, ScreenWidth - 120 - 70, 14)];
                    yuqiLabel.font = [UIFont systemFontOfSize:14];
                    [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    yuqiLabel.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_LBMC"];
                    [backView addSubview:yuqiLabel];
                    //申报结果
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 14)];
                    yuqiLabelTip.font = [UIFont systemFontOfSize:14];
                    [yuqiLabelTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"申报结果";
                    [backView addSubview:yuqiLabelTip];
                    
                    UILabel *shenbaoTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, ScreenWidth - 120 - 70, 14)];
                    shenbaoTip.font = [UIFont systemFontOfSize:14];
                    [shenbaoTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    shenbaoTip.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    [backView addSubview:shenbaoTip];
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 73, 60, 14)];
                    giveLabel.font = [UIFont systemFontOfSize:14];
                    [giveLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    //giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"成交金额";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:14];
                    [giveLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] doubleValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    giveLabelTip.frame = CGRectMake(70, 73, titleSize1.width, 14);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 73, 14, 14)];
                    flagLabel1.font = [UIFont systemFontOfSize:14];
                    [flagLabel1 setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    //flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    
                    
                    
                    
                    //委托金额
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 14)];
                    valueLabel.font = [UIFont systemFontOfSize:14];
                    [valueLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    // valueLabel.textAlignment = NSTextAlignmentRight;
                    valueLabel.text = @"委托金额";
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont systemFontOfSize:14];
                    [valueLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                   // NSString *abc  = [NSString stringWithFormat:@"%.2f",[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] doubleValue]];
                    
                    NSString *abc;
                    
                    if ([[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]) {
                        abc = [NSString stringWithFormat:@"%.2f",[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    } else  {
                        
                        abc = [NSString stringWithFormat:@"%.2f",[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] doubleValue]];
                    }
                    

                    
                    
                    NSRange range1 = [abc rangeOfString:@"."];//匹配得到的下标
                    
                    NSLog(@"rang:%@",NSStringFromRange(range1));
                    
                    //string = [string substringWithRange:range];//截取范围类的字符串
                    
                    
                    
                    NSString *string = [abc substringFromIndex:range1.location];
                    
                    NSString *str = [abc substringToIndex:range1.location];
                    
                    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    
                    
                    
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    valueLabelTip.frame = CGRectMake(70, 94, titleSize.width, 14);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 94, 14, 14)];
                    flagLabel.font = [UIFont systemFontOfSize:14];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    
                    
                    
                    if (![[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]&&[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_SBJG"] isEqualToString:@"2"]) {
                        //投资按钮
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(ScreenWidth - 20 - 80, 50, 80, 30);
                        button.tag = [indexPath row];
                        button.backgroundColor = [UIColor orangeColor];
                        [button setTitle:@"撤单" forState:UIControlStateNormal];
                        button.layer.cornerRadius = 3;
                        button.titleLabel.font = [UIFont systemFontOfSize:15];
                        [button addTarget:self action:@selector(touziBtn:) forControlEvents:UIControlEventTouchUpInside];
                        button.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
                        button.layer.cornerRadius = 4;
                        button.layer.masksToBounds = YES;
                        
                        [backView addSubview:button];
                    }
                    
                    
                    
                    
                    [cell.contentView addSubview:backView];
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
                if ([indexPath row] == 0) {
                    return 120;
                } else {
                    
                    return 130;
                }

            }
        }
    } else if (tableView.tag == TFINISHTABLEVIEW) {
        if ([finishDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [finishDataList count]) {
                return 40;
            } else {
                if ([indexPath row] == 0) {
                    return 120;
                } else {
                    
                    return 130;
                }

            }
        }
    } else if (tableView.tag == WAITTABLEVIEW) {
        if ([waitDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [waitDataList count]) {
                return 40;
            } else {
                if ([indexPath row] == 0) {
                     return 120;
                } else {
                
                return 130;
                }
            }
        }
    } else if (tableView.tag == SHIPTABLEVIEW) {
        if ([shipDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [shipDataList count]) {
                return 40;
            } else {
                if ([indexPath row] == 0) {
                    return 120;
                } else {
                    
                    return 130;
                }

            }
        }
    }
    
    
    return 95 ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            if ([chedanTag isEqualToString:@"1"]) {
                [self requestGiveupList:[[dataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTH"] withWtfs:[[dataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTFS"] tag:kBusinessTagGetJRentrustWithdraw];
            } else if ([chedanTag isEqualToString:@"2"]){
                [self requestGiveupList:[[finishDataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTH"] withWtfs:[[finishDataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTFS"] tag:kBusinessTagGetJRentrustWithdraw1];
            } else if ([chedanTag isEqualToString:@"3"]){
                
                [self requestGiveupList:[[waitDataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTH"] withWtfs:[[waitDataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTFS"] tag:kBusinessTagGetJRentrustWithdraw2];
            } else if ([chedanTag isEqualToString:@"4"]){
                [self requestGiveupList:[[shipDataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTH"] withWtfs:[[shipDataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTFS"] tag:kBusinessTagGetJRentrustWithdraw3];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        
    }
}





-(void)touziBtn:(UIButton *)btn{
    
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"撤单" message:@"是否要进行撤单操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = btn.tag;
    chedanTag = @"1";
    [outAlert show];
    
    
    
    
}

-(void)touziBtn1:(UIButton *)btn{
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"撤单" message:@"是否要进行撤单操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = btn.tag;
    chedanTag = @"2";
    [outAlert show];
    
    
}

-(void)touziBtn2:(UIButton *)btn{
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"撤单" message:@"是否要进行撤单操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = btn.tag;
    chedanTag = @"3";
    [outAlert show];
    
}

-(void)touziBtn3:(UIButton *)btn{
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"撤单" message:@"是否要进行撤单操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = btn.tag;
    chedanTag = @"4";
    [outAlert show];
    
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
        start = [NSString stringWithFormat:@"%d", [start intValue] + [limit intValue]];
    }
    
    [self.tableView reloadData];
    [_slimeView endRefresh];
}
//处理已发货订单
- (void)recivedFinishOrderList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理已发货订单数据");
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
        finishStart = [NSString stringWithFormat:@"%d", [finishStart intValue] + [limit intValue]];
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
        waitStart = [NSString stringWithFormat:@"%d", [waitStart intValue] + [limit intValue]];
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
        shipStart = [NSString stringWithFormat:@"%d", [shipStart intValue] + [limit intValue]];
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
    
    if (tag==kBusinessTagGetJRtodayEntrustPage) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
           
            [self recivedNoOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag==kBusinessTagGetJRtodayEntrustPageAgain){
        
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [dataList removeAllObjects];
            [self recivedNoOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRtodayEntrustPage1) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [self recivedFinishOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRtodayEntrustPage1Again){
        
        [_finishSlimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [finishDataList removeAllObjects];
            [self recivedFinishOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRtodayEntrustPage2) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [self recivedWaitOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRtodayEntrustPage2Again){
        
        [_waitSlimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [waitDataList removeAllObjects];
            [self recivedWaitOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRtodayEntrustPage3) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [self recivedShipOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRtodayEntrustPage3Again){
        
        [_shipSlimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [shipDataList removeAllObjects];
            [self recivedShipOrderList:[jsonDic objectForKey:@"object"]];
        }
    }else if (tag == kBusinessTagGetJRentrustWithdraw){
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:@"撤销订单失败" duration:2 position:@"center"];
        } else {
            [self.view makeToast:@"撤销成功" duration:2 position:@"center"];
            start = @"1";
            [self requestRecordPastList:@"" tag:kBusinessTagGetJRtodayEntrustPageAgain];
            finishStart = @"1";
            [self requestRecordPastList:@"2" tag:kBusinessTagGetJRtodayEntrustPage1Again];
            waitStart = @"1";
            [self requestRecordPastList:@"6" tag:kBusinessTagGetJRtodayEntrustPage2Again];
            shipStart = @"1";
            [self requestRecordPastList:@"8" tag:kBusinessTagGetJRtodayEntrustPage3Again];
            
        }
    } else if (tag == kBusinessTagGetJRentrustWithdraw1){
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:@"撤销订单失败" duration:2 position:@"center"];
        } else {
            [self.view makeToast:@"撤销成功" duration:2 position:@"center"];
            start = @"1";
            [self requestRecordPastList:@"" tag:kBusinessTagGetJRtodayEntrustPageAgain];
            finishStart = @"1";
            [self requestRecordPastList:@"2" tag:kBusinessTagGetJRtodayEntrustPage1Again];
            waitStart = @"1";
            [self requestRecordPastList:@"6" tag:kBusinessTagGetJRtodayEntrustPage2Again];
            shipStart = @"1";
            [self requestRecordPastList:@"8" tag:kBusinessTagGetJRtodayEntrustPage3Again];
        }
    } else if (tag == kBusinessTagGetJRentrustWithdraw2){
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:@"撤销订单失败" duration:2 position:@"center"];
        } else {
            [self.view makeToast:@"撤销成功" duration:2 position:@"center"];
            start = @"1";
            [self requestRecordPastList:@"" tag:kBusinessTagGetJRtodayEntrustPageAgain];
            finishStart = @"1";
            [self requestRecordPastList:@"2" tag:kBusinessTagGetJRtodayEntrustPage1Again];
            waitStart = @"1";
            [self requestRecordPastList:@"6" tag:kBusinessTagGetJRtodayEntrustPage2Again];
            shipStart = @"1";
            [self requestRecordPastList:@"8" tag:kBusinessTagGetJRtodayEntrustPage3Again];
        }
    } else if (tag == kBusinessTagGetJRentrustWithdraw3){
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:@"撤销订单失败" duration:2 position:@"center"];
        } else {
            [self.view makeToast:@"撤销成功" duration:2 position:@"center"];
            start = @"1";
            [self requestRecordPastList:@"" tag:kBusinessTagGetJRtodayEntrustPageAgain];
            finishStart = @"1";
            [self requestRecordPastList:@"2" tag:kBusinessTagGetJRtodayEntrustPage1Again];
            waitStart = @"1";
            [self requestRecordPastList:@"6" tag:kBusinessTagGetJRtodayEntrustPage2Again];
            shipStart = @"1";
            [self requestRecordPastList:@"8" tag:kBusinessTagGetJRtodayEntrustPage3Again];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
   
   [self.navigationController popViewControllerAnimated:YES];
}
@end
