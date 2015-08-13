//
//  MyUserMangerViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyUserMangerViewController.h"
#import "AppDelegate.h"
#import "WebDetailViewController.h"

@interface MyUserMangerViewController ()
{
   
    float addHight;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    UITableView *table;
    SRRefreshView   *_slimeView;
    NSString *start;
    NSString *startBak;
    NSString *limit;
}

@end

@implementation MyUserMangerViewController

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
  
    start = @"1";
    limit = @"10";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth, ScreenHeight - 64)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[UIColor clearColor]];
    table.tableFooterView = [[UIView alloc] init];
    
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
    
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestCategoryList:@"997" tag:kBusinessTagGetJRinfolist];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
 
    
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    startBak = [NSString stringWithString:start];
    start = @"1";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestCategoryList:@"997" tag:kBusinessTagGetJRinfolistAgain];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
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
    } else if (hasMore) {
        return [dataList count] + 1;
    } else {
        return [dataList count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    if ([indexPath row] == [dataList count]) {
        moreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
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
        cell = [tableView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == [dataList count]) {
        return 40;
    } else {
        return 40;
    }
    return 95;
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [dataList count]) {
        for (UILabel *label in [moreCell.contentView subviews]) {
            if ([label.text isEqualToString:@"正在加载中..."]) {
                
            } else {
                label.text = @"正在加载中...";
                [self requestCategoryList:@"997" tag:kBusinessTagGetJRinfolist];
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
}


- (void)tableView:(UITableView *)tbleView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [dataList count]) {
        if (hasMore) {
            for (UILabel *label in [cell.contentView subviews]) {
                if ([label.text isEqualToString:@"*****正在加载*****"]) {
                    
                } else {
                    label.text = @"*****正在加载*****";
                    [self requestCategoryList:@"997" tag:kBusinessTagGetJRinfolist];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        }
    }
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [table reloadData];
    [_slimeView endRefresh];
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
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}

-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
    //[HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    if (tag == kBusinessTagGetJRinfolist) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else if (tag == kBusinessTagGetJRinfolistAgain) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_slimeView endRefresh];
        
    }
    
    
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



-(void)dealloc {
    [_slimeView removeFromSuperview];
    _slimeView = nil;
    [table removeFromSuperview];
    table = nil;
    [moreCell removeFromSuperview];
    [dataList removeAllObjects];
    dataList = nil;
    moreCell = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



@end
