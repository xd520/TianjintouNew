//
//  YuBuyViewController.m
//  添金投
//
//  Created by mac on 15/11/6.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "YuBuyViewController.h"
#import "AppDelegate.h"

@interface YuBuyViewController ()
{
    UITableView *tableView;
    NSMutableArray *dataList;
    UITableViewCell *moreCell;
    SRRefreshView   *_slimeView;
    
}
@end

@implementation YuBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    
    //商品列表
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth,ScreenHeight - 64)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]]; tableView.tableFooterView = [[UIView alloc] init];
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
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRappYyrgjl owner:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRappYyrgjlAgain owner:self];
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
        toastLabel.textAlignment = UITextAlignmentCenter;
        [moreCell.contentView addSubview:toastLabel];
        return moreCell;
    } else {
         cell = [tableView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
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
            brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"CPMC"];
            [backView addSubview:brandLabel];
            
            //持有份额
            UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, 52, 13)];
            fenLabTip.font = [UIFont systemFontOfSize:13];
            [fenLabTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
            
            fenLabTip.text = @"产品代码";
            [backView addSubview:fenLabTip];
            
            UILabel *fenLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 42, ScreenWidth/2 - 10 - 65, 13)];
            fenLabel.font = [UIFont systemFontOfSize:13];
            [fenLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
            fenLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"CPDM"];
            [backView addSubview:fenLabel];
            
            //最新价
            UILabel *newLabTip = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 - 10, 43, 52, 13)];
            newLabTip.font = [UIFont systemFontOfSize:13];
            [newLabTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
            
            newLabTip.text = @"预约金额";
            [backView addSubview:newLabTip];
            
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 55 - 10, 42, ScreenWidth/2 - 20 - 45, 13)];
            newLabel.font = [UIFont systemFontOfSize:13];
            [newLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
            newLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"YYJE"];
            [backView addSubview:newLabel];
            
            //累计盈亏
            UILabel *kuiLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 63, 52, 13)];
            kuiLabTip.font = [UIFont systemFontOfSize:13];
            [kuiLabTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
            
            kuiLabTip.text = @"预约日期";
            [backView addSubview:kuiLabTip];
            
            UILabel *kuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 62, ScreenWidth/2 - 75, 13)];
            kuiLabel.font = [UIFont systemFontOfSize:13];
            [kuiLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
            kuiLabel.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"YYSJ"] ];
            [backView addSubview:kuiLabel];
            //盈亏比例
            
            UILabel *biliLabTip = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 - 10, 63, 52, 13)];
            biliLabTip.font = [UIFont systemFontOfSize:13];
            [biliLabTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
            
            biliLabTip.text = @"认购日期";
            [backView addSubview:biliLabTip];
            
            UILabel *biliLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 10 + 55, 62, ScreenWidth/2 - 20 - 45, 13)];
            biliLabel.font = [UIFont systemFontOfSize:13];
            [biliLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
            
            biliLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"YYRQ"];
            [backView addSubview:biliLabel];
            [cell.contentView addSubview:backView];
        }
         return cell;
    }
    return cell;
}
#pragma mark - Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [dataList count]) {
        return 40;
    } else {
        return 105;
    }
    return 95;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate reloadMoneyView:[dataList objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    */
    
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

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
    if ([[jsonDic objectForKey:@"object"] isKindOfClass:[NSString class]]) {
        
        if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]&&[[jsonDic objectForKey:@"success"] boolValue] == NO) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.logingUser removeAllObjects];
            [delegate.dictionary removeAllObjects];
            [ASIHTTPRequest setSessionCookies:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }else {
        
        
        if (tag==kBusinessTagGetJRappYyrgjl) {
            
            if ([[jsonDic objectForKey:@"success"] boolValue]== NO) {
                //数据异常处理
                [self.view makeToast:@"获取品牌失败"];
            } else {
                [self recivedCategoryList:dataArray];
            }
        } else if (tag == kBusinessTagGetJRappYyrgjlAgain){
            
            [_slimeView endRefresh];
            if ([[jsonDic objectForKey:@"success"] boolValue]== NO) {
                //数据异常处理
                [self.view makeToast:@"获取品牌失败"];
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
