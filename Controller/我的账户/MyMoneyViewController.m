//
//  MyMoneyViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-11.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "AppDelegate.h"

#define TTABLEVIEW 10001
#define TFINISHTABLEVIEW 10002
#define SHIPTABLEVIEW 10009
#define TFINISHTR 10004
#define SHIPTTR 10008
#define TTR 10003
#define TSEGSCROLLVIEW 10005

@interface MyMoneyViewController (){
    NSString *start;
    NSString *startBak;
    NSString *finishStart;
    NSString *finishStartBak;
    NSString *shipStart;
    NSString *shipStartBak;
   
    NSString *limit;
    NSMutableArray *dataList;
    NSMutableArray *finishDataList;
    NSMutableArray *shipDataList;
    BOOL hasMore;
    BOOL finishHasMore;
    BOOL shipHasMore;
    UITableViewCell *moreCell;
    UITableViewCell *finishMoreCell;
    UITableViewCell *shipMoreCell;
    SRRefreshView   *_slimeView;
    SRRefreshView   *_finishSlimeView;
    SRRefreshView   *_shipSlimeView;
    // zhuan  zhuang jilu
    UIView *cellBackView;
    float addHight;
     UISegmentedControl  *segmented;
}
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *shipTableView;
@property (strong, nonatomic) UITableView *finishTableView;

@end

@implementation MyMoneyViewController

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
        
        
        
    } else if(Seg.selectedSegmentIndex == 2){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    start = @"1";
    finishStart = @"1";
    shipStart = @"1";
    limit = @"10";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"未使用",@"已使用",@"已过期",nil];
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    segmented.frame = CGRectMake(20,addHight + 44 + 10, ScreenWidth - 40, 30);
    
    segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    segmented.backgroundColor = [UIColor whiteColor];
    segmented.tintColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    
    
    
    segmented.multipleTouchEnabled = NO;
    segmented.segmentedControlStyle = UISegmentedControlStyleBezeled;
    
    [segmented addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmented];
    

    
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 50;
    
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50 + 44 + addHight, ScreenWidth, scrollViewHeight)];
    
    self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*3, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 114, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 104)];
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
    
    self.finishTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 104)];
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
    
    self.shipTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, ScreenHeight - 104)];
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
        //未使用
        
        start = @"1";
        [self requestRecordPastList:@"2" withStart:start milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData];
        
        //已使用
        finishStart = @"1";
        
        [self requestRecordPastList:@"3" withStart:finishStart milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData1];
        
       
        
        
        //已过期
        shipStart = @"1";
        
        [self requestRecordPastList:@"4" withStart:shipStart milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData2];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

}

- (void)requestRecordPastList:(NSString *)_sbjg withStart:(NSString *)_start milit:(NSString *)_limit tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_sbjg forKey:@"type"];
    [paraDic setObject:_start forKey:@"pageIndex"];
    [paraDic setObject:_limit forKey:@"pageSize"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}


#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == TSEGSCROLLVIEW) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
         segmented.selectedSegmentIndex = page;
       // [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
        
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
                
                  [self requestRecordPastList:@"2" withStart:start milit:limit tag:kBusinessTagGetJRmyCoinmyCoinDataAgain];
            }else if (page == 1){
                //购买申请
                finishStart = @"1";
                
                  [self requestRecordPastList:@"3" withStart:finishStart milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData1Again];
            } else if(page == 2){
                //转让记录
               shipStart = @"1";
                
                  [self requestRecordPastList:@"4" withStart:shipStart milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData2Again];
                
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
    }   else if (scrollView.tag == SHIPTABLEVIEW) {
        [_shipSlimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.tag == TTABLEVIEW) {
        [_slimeView scrollViewDidEndDraging];
    } else if (scrollView.tag == TFINISHTABLEVIEW) {
        [_finishSlimeView scrollViewDidEndDraging];
    }  else if (scrollView.tag == SHIPTABLEVIEW) {
        [_shipSlimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView.tag == TTR) {
        startBak = [NSString stringWithString:start];
        start = @"1";
         [self requestRecordPastList:@"2" withStart:start milit:limit tag:kBusinessTagGetJRmyCoinmyCoinDataAgain];
    } else if (refreshView.tag == TFINISHTR) {
        finishStartBak = [NSString stringWithString:finishStart];
        finishStart = @"1";
         [self requestRecordPastList:@"3" withStart:finishStart milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData1Again];
    } else if (refreshView.tag == SHIPTTR) {
        shipStartBak = [NSString stringWithString:shipStart];
        shipStart = @"1";
         [self requestRecordPastList:@"4" withStart:shipStart milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData2Again];
    }
    
}

 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (tableView.tag == TTABLEVIEW) {
         if ([indexPath row] == [dataList count]) {
             if (hasMore) {
                 for (UILabel *label in [cell.contentView subviews]) {
                     if ([label.text isEqualToString:@"正在加载中..."]) {
 
                     } else {
                         label.text = @"正在加载中...";
                           [self requestRecordPastList:@"2" withStart:start milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData];
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
                           [self requestRecordPastList:@"3" withStart:finishStart milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData1];
                         [tableView deselectRowAtIndexPath:indexPath animated:YES];
                     }
                 }
             }
         }
     }   else if (tableView.tag == SHIPTABLEVIEW) {
         if ([indexPath row] == [shipDataList count]) {
             if (shipHasMore) {
                 for (UILabel *label in [cell.contentView subviews]) {
                     if ([label.text isEqualToString:@"正在加载中..."]) {
 
                     } else {
                         label.text = @"正在加载中...";
                            [self requestRecordPastList:@"4" withStart:shipStart milit:limit tag:kBusinessTagGetJRmyCoinmyCoinData2];
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
    }  else if(tableView.tag == SHIPTABLEVIEW){
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
                [iconImageView setImage:[UIImage imageNamed:@"none_charger_icon"]];
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
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 59)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 16)];
                    brandLabel.font = [UIFont systemFontOfSize:16];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"KYJE"];
                    brandLabel.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    CGSize titleSize = [ brandLabel.text sizeWithFont: brandLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
                     brandLabel.frame = CGRectMake(10, 10, titleSize.width, 16);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:brandLabel];
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(brandLabel.frame.size.width + brandLabel.frame.origin.x, 10, 80, 16)];
                    flagLabel.font = [UIFont boldSystemFontOfSize:15];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"添金币";
                    [backView addSubview:flagLabel];
                    

                    
                    
                    
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 100, 13)];
                    delegateLabel.font = [UIFont systemFontOfSize:13];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                   // delegateLabel.textAlignment = NSTextAlignmentRight;
                   
                    
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:indexPath.row] objectForKey:@"JSRQ"]];
                    
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    
                    [strDate insertString:@"-" atIndex:4];
                    
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    
                     delegateLabel.text = strDate;
                    
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, 35, 100, 13)];
                    yuqiLabel.font = [UIFont systemFontOfSize:13];
                    [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    yuqiLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"NOTE"];
                    yuqiLabel.textAlignment = NSTextAlignmentRight;
                    [backView addSubview:yuqiLabel];
                  
                    
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
                [iconImageView setImage:[UIImage imageNamed:@"none_charger_icon"]];
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
                    cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                        //添加背景View
                        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 59)];
                        [backView setBackgroundColor:[UIColor whiteColor]];
                        
                        
                        //品牌
                        UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 15)];
                        brandLabel.font = [UIFont boldSystemFontOfSize:16];
                        [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                        [brandLabel setBackgroundColor:[UIColor clearColor]];
                        brandLabel.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"KYJE"];
                        brandLabel.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                        CGSize titleSize = [ brandLabel.text sizeWithFont: brandLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
                        brandLabel.frame = CGRectMake(10, 10, titleSize.width, 16);
                        // WithFrame:CGRectMake(170, 44, 60, 13)
                        
                        [backView addSubview:brandLabel];
                        
                        UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(brandLabel.frame.size.width + brandLabel.frame.origin.x, 10, 80, 16)];
                        flagLabel.font = [UIFont boldSystemFontOfSize:15];
                        [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                        flagLabel.textAlignment = NSTextAlignmentLeft;
                        flagLabel.text = @"添金币";
                        [backView addSubview:flagLabel];
                        
                        
                        
                        
                        
                        [backView addSubview:brandLabel];
                        //认购发行
                        
                        UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 100, 13)];
                        delegateLabel.font = [UIFont systemFontOfSize:13];
                        //[delegateLabel setTextColor:[UIColor redColor]];
                        [delegateLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                        //delegateLabel.textAlignment = NSTextAlignmentRight;
                        NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"JSRQ"]];
                        
                        // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                        
                        [strDate insertString:@"-" atIndex:4];
                        
                        [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                        
                        delegateLabel.text = strDate;

                       // delegateLabel.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"JSRQ"];
                        [backView addSubview:delegateLabel];
                        
                        
                        UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, 35, 100, 13)];
                        yuqiLabel.font = [UIFont systemFontOfSize:13];
                       [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                        yuqiLabel.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"NOTE"];
                         yuqiLabel.textAlignment = NSTextAlignmentRight;
                        [backView addSubview:yuqiLabel];
                        
                        
                        [cell.contentView addSubview:backView];
                    }
                }
            }
        }
        return cell;
    }  else if (tbleView.tag == SHIPTABLEVIEW) {
        if ([shipDataList count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ColorUtil colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"none_charger_icon"]];
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
                    [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 59)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 15)];
                    brandLabel.font = [UIFont boldSystemFontOfSize:16];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"KYJE"];
                    brandLabel.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                    CGSize titleSize = [ brandLabel.text sizeWithFont: brandLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
                    brandLabel.frame = CGRectMake(10, 10, titleSize.width, 16);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:brandLabel];
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(brandLabel.frame.size.width + brandLabel.frame.origin.x, 10, 80, 16)];
                    flagLabel.font = [UIFont boldSystemFontOfSize:15];
                    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"添金币";
                    [backView addSubview:flagLabel];
                    
                    
                    
                    
                    
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 100, 13)];
                    delegateLabel.font = [UIFont systemFontOfSize:13];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                   // delegateLabel.textAlignment = NSTextAlignmentRight;
                   // delegateLabel.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"JSRQ"];
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"JSRQ"]];
                    
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    
                    [strDate insertString:@"-" atIndex:4];
                    
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    
                    delegateLabel.text = strDate;

                    
                    
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, 35, 100, 13)];
                    yuqiLabel.font = [UIFont systemFontOfSize:13];
                    [yuqiLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                    yuqiLabel.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"NOTE"];
                     yuqiLabel.textAlignment = NSTextAlignmentRight;
                    [backView addSubview:yuqiLabel];
                    
                    
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
    
    // NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
    if (tag==kBusinessTagGetJRmyCoinmyCoinData) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            
            [self recivedNoOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag==kBusinessTagGetJRmyCoinmyCoinDataAgain){
        
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [dataList removeAllObjects];
            [self recivedNoOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRmyCoinmyCoinData1) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [self recivedFinishOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRmyCoinmyCoinData1Again){
        
        [_finishSlimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [finishDataList removeAllObjects];
            [self recivedFinishOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRmyCoinmyCoinData2) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [self recivedShipOrderList:[jsonDic objectForKey:@"object"]];
        }
    } else if (tag == kBusinessTagGetJRmyCoinmyCoinData2Again){
        
        [_shipSlimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [shipDataList removeAllObjects];
            [self recivedShipOrderList:[jsonDic objectForKey:@"object"]];
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
    

}





- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
