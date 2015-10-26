//
//  PublicViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-11.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "PublicViewController.h"
#import "AppDelegate.h"
#import "WebDetailViewController.h"

@interface PublicViewController ()
{
     float addHight;
     UISegmentedControl  *segmented;
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
   
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@end

@implementation PublicViewController

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
    
    start = @"1";
    limit = @"20";
    startBak = @"";
    startPast = @"1";
    limitPast = @"10";
    startBakPast = @"";
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"添金投公告",@"添金投新闻",nil];
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    

    
    segmented.frame = CGRectMake(20, addHight + 44 + 10, ScreenWidth - 40, 30);
    
    segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    segmented.backgroundColor = [UIColor whiteColor];
    segmented.tintColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    
    segmented.multipleTouchEnabled = NO;
    segmented.segmentedControlStyle = UISegmentedControlStyleBezeled;
    
    [segmented addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    //[self.view addSubview:segmented];
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
   // [self.view addSubview:self.scrollView];
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0 , 44 + addHight, ScreenWidth,  ScreenHeight - 64)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[UIColor clearColor]];    table.tableFooterView = [[UIView alloc] init];
    
   // [self.scrollView addSubview:table];
    
    [self.view addSubview:table];
    
    
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
    
    
    tablePast = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth , 0, ScreenWidth,  ScreenHeight - 114)];
    [tablePast setDelegate:self];
    [tablePast setDataSource:self];
    tablePast.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tablePast setBackgroundColor:[UIColor clearColor]];
    tablePast.tableFooterView = [[UIView alloc] init];
    
    //[self.scrollView addSubview:tablePast];
    
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
        
        //夏金所公告
        [self requestCategoryList:@"999" tag:kBusinessTagGetJRinfolist];
        
        //夏金所新闻
      //  [self requestCategoryList:@"997" tag:kBusinessTagGetJRinfolist1];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV {
    if (scrollV == _scrollView) {
        CGFloat pageWidth = _scrollView.frame.size.width;
        NSInteger page = _scrollView.contentOffset.x / pageWidth;
        segmented.selectedSegmentIndex = page;
       
        
    }
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView == _slimeView) {
        
        startBak = [NSString stringWithString:start];
        start = @"1";
        
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self requestCategoryList:@"999" tag:kBusinessTagGetJRinfolistAgain];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                
            });
        });
        
    } else if (refreshView == _slimeViewPast){
        startBakPast = [NSString stringWithString:start];
        startPast = @"1";
       
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            
            [self requestCategoryList:@"997" tag:kBusinessTagGetJRinfolist1Again];
            
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
                    [self requestCategoryList:@"999" tag:kBusinessTagGetJRinfolist];
                   
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        }
    }
    } else if (tbleView == tablePast){
   if ([indexPath row] == [dataListPast count]) {
        if (hasMorePast) {
            for (UILabel *label in [cell.contentView subviews]) {
                if ([label.text isEqualToString:@"*****正在加载*****"]) {
                    
                } else {
                    
                    label.text = @"*****正在加载*****";
                    
                    [self requestCategoryList:@"997" tag:kBusinessTagGetJRinfolist1];
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
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                    [backView setBackgroundColor:[ColorUtil colorWithHexString:@"fafafa"]];
                    //品牌
                    
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 120, 39)];
                    brandLabel.backgroundColor = [UIColor clearColor];
                    brandLabel.font = [UIFont boldSystemFontOfSize:15];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"646464"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"TITLE"];
                    [backView addSubview:brandLabel];
                    
                    
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, ScreenWidth - 240, 39)];
                    timeLabel.font = [UIFont systemFontOfSize:13];
                    [timeLabel setTextColor:[ColorUtil colorWithHexString:@"646464"]];
                    [timeLabel setBackgroundColor:[UIColor clearColor]];
                    timeLabel.backgroundColor = [UIColor clearColor];
                    timeLabel.textAlignment = NSTextAlignmentRight;
                    
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"PUBTIME"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    [strDate insertString:@"-" atIndex:4];
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    timeLabel.text = [NSString stringWithFormat:@"%@",strDate];
                    
                    
                    
                    [backView addSubview:timeLabel];
                    
                    
                    
                    
                    
                   
                    if ([indexPath row] != [dataList count] - 1) {
                        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth - 10, 1)];
                        [subView setBackgroundColor:[ColorUtil colorWithHexString:@"dcdcdc"]];
                        [backView addSubview:subView];
                    } else {
                    
                        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
                        [subView setBackgroundColor:[ColorUtil colorWithHexString:@"dcdcdc"]];
                      [backView addSubview:subView];
                    }
                    
                    [cell.contentView addSubview:backView];
                    
                    
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                    [backView setBackgroundColor:[ColorUtil colorWithHexString:@"fafafa"]];
                    //品牌
                    
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 39)];
                    brandLabel.backgroundColor = [UIColor clearColor];
                    brandLabel.font = [UIFont boldSystemFontOfSize:15];
                    [brandLabel setTextColor:[ColorUtil colorWithHexString:@"646464"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"TITLE"];
                    [backView addSubview:brandLabel];
                    
                    
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, ScreenWidth - 240, 39)];
                    timeLabel.font = [UIFont systemFontOfSize:13];
                    [timeLabel setTextColor:[ColorUtil colorWithHexString:@"646464"]];
                    [timeLabel setBackgroundColor:[UIColor clearColor]];
                    timeLabel.backgroundColor = [UIColor clearColor];
                    timeLabel.textAlignment = NSTextAlignmentRight;
                    
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataListPast objectAtIndex:[indexPath row]] objectForKey:@"PUBTIME"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    [strDate insertString:@"-" atIndex:4];
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    timeLabel.text = [NSString stringWithFormat:@"%@",strDate];
                    
                    [backView addSubview:timeLabel];
                    
                    
                    if ([indexPath row] != [dataListPast count] - 1) {
                        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth - 10, 1)];
                        [subView setBackgroundColor:[ColorUtil colorWithHexString:@"dcdcdc"]];
                        [backView addSubview:subView];
                    } else {
                        
                        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
                        [subView setBackgroundColor:[ColorUtil colorWithHexString:@"dcdcdc"]];
                        [backView addSubview:subView];
                    }

                     
                    [cell.contentView addSubview:backView];
                    
                    
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
             return cell;
        }
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == table) {
        if ([indexPath row] == [dataList count]) {
            return 40;
        } else {
            return 40;
        }
        
    } else if (tableView == tablePast){
        if ([indexPath row] == [dataListPast count]) {
            return 40;
        } else {
            return 40;
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
                     [self requestCategoryList:@"999" tag:kBusinessTagGetJRinfolist];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        } else {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
            WebDetailViewController *goodsDetailViewController = [[WebDetailViewController alloc] init];
            
            goodsDetailViewController.name = [[dataList objectAtIndex:indexPath.row] objectForKey:@"TITLE"];
            goodsDetailViewController.Id = [[dataList objectAtIndex:indexPath.row] objectForKey:@"ID"];
            
            goodsDetailViewController.hidesBottomBarWhenPushed = YES;
            [tbleView deselectRowAtIndexPath:indexPath animated:YES];
            [self.navigationController pushViewController:goodsDetailViewController animated:NO];
        }
    }else if (tbleView == tablePast){
        if (indexPath.row == [dataListPast count]) {
            for (UILabel *label in [moreCellPast.contentView subviews]) {
                if ([label.text isEqualToString:@"正在加载中..."]) {
                    
                } else {
                    label.text = @"正在加载中...";
                     [self requestCategoryList:@"997" tag:kBusinessTagGetJRinfolist1];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        } else {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
            WebDetailViewController *goodsDetailViewController = [[WebDetailViewController alloc] init];
            
            goodsDetailViewController.name = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"TITLE"];
            goodsDetailViewController.Id = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"ID"];
            
            goodsDetailViewController.hidesBottomBarWhenPushed = YES;
            [tbleView deselectRowAtIndexPath:indexPath animated:YES];
            [self.navigationController pushViewController:goodsDetailViewController animated:NO];
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
    if ([dataArray count] < 20) {
        hasMore = NO;
    } else {
        hasMore = YES;
        start = [NSString stringWithFormat:@"%d", [start intValue] + 1];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [table reloadData];
    [_slimeView endRefresh];
}

#pragma mark - Request Methods
//获取品牌列表
- (void)requestCategoryList:(NSString *)_str tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求品牌列表");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    //获取类别信息
    [paraDic setObject:_str forKey:@"classId"];
    [paraDic setObject:start forKey:@"pageIndex"];
    [paraDic setObject:limit forKey:@"pageSize"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
    
}


#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
	if (tag==kBusinessTagGetJRinfolist) {
        //[HUD hide:YES];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            
            [self.view makeToast:@"获取品牌失败"];
            
        } else {
            [self recivedCategoryList:dataArray];
        }
    }  else if (tag==kBusinessTagGetJRinfolistAgain) {
        // [HUD hide:YES];
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:@"获取品牌失败"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } else {
            [dataList removeAllObjects];
            [self recivedCategoryList:dataArray];
        }
    } else if (tag==kBusinessTagGetJRinfolist1) {
        //[HUD hide:YES];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            
            [self.view makeToast:@"获取品牌失败"];
            
        } else {
            [self recivedPastList:dataArray];
        }
    }  else if (tag==kBusinessTagGetJRinfolist1Again) {
        // [HUD hide:YES];
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:@"获取品牌失败"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } else {
            [dataList removeAllObjects];
            [self recivedPastList:dataArray];
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}

-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
  
    
    [self.view makeToast:@"您所在地的网络信号微弱，无法连接到服务" duration:1 position:@"center"];
    
   if (tag == kBusinessTagGetJRinfolist) {
        start = [NSString stringWithString:startBak];
        [_slimeView endRefresh];
   } else if(tag == kBusinessTagGetJRinfolist1Again){
       startPast = [NSString stringWithString:startBakPast];
       [_slimeViewPast endRefresh];
   
   }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
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
