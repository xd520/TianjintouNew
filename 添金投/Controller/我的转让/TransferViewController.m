//
//  TransferViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "TransferViewController.h"
#import "AppDelegate.h"
#import "MyTransferDetailViewController.h"

@interface TransferViewController ()
{
    UITableView *table;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    SRRefreshView   *_slimeView;
}
@end

@implementation TransferViewController

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
    startBak = @"";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight - 64)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
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
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestCategoryList:start limit:limit tag:kBusinessTagGetJRcpzrwyzrloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    startBak = [NSString stringWithString:start];
    start = @"1";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestCategoryList:start limit:limit tag:kBusinessTagGetJRcpzrwyzrloadDataAgain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (void)tableView:(UITableView *)tbleView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [dataList count]) {
        if (hasMore) {
            for (UILabel *label in [cell.contentView subviews]) {
                if ([label.text isEqualToString:@"*****正在加载*****"]) {
                    
                } else {
                    label.text = @"*****正在加载*****";
                    [self requestCategoryList:start limit:limit tag:kBusinessTagGetJRcpzrwyzrloadData];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        }
    }
}

#pragma mark - 投资按钮实现方法

-(void)touziBtn:(UIButton *)btn {
    
    
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
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(131.5, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
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
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 125)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 20, 120)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5 , 25, 25)];
                
                imageView.image = [UIImage imageNamed:@"icon_mai"];
                
                [backView addSubview:imageView];
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 9.5, ScreenWidth - 35 - 30, 15)];
                brandLabel.font = [UIFont boldSystemFontOfSize:15];
                [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQMC"];
                [backView addSubview:brandLabel];
                //预期年化收益率
                UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 80, 17)];
                yuqiLabel.font = [UIFont boldSystemFontOfSize:17];
                [yuqiLabel setTextColor:[UIColor redColor]];
                yuqiLabel.text = [NSString stringWithFormat:@"%.2f%@",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GZLL"] floatValue]*100,@"%"];
                [backView addSubview:yuqiLabel];
                
                UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 67, 100, 13)];
                yuqiLabelTip.font = [UIFont boldSystemFontOfSize:13];
                [yuqiLabelTip setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                
                yuqiLabelTip.text = @"预期收益率";
                [backView addSubview:yuqiLabelTip];
                
                //项目价值
                UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 44, 60, 13)];
                valueLabel.font = [UIFont boldSystemFontOfSize:13];
                [valueLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                valueLabel.textAlignment = NSTextAlignmentRight;
                valueLabel.text = @"项目价值:";
                //[backView addSubview:valueLabel];
                
                UILabel *valueLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(170, 44, 60, 13)];
                valueLabelTip.font = [UIFont boldSystemFontOfSize:13];
                [valueLabelTip setTextColor:[UIColor redColor]];
                valueLabelTip.textAlignment = NSTextAlignmentLeft;
                valueLabelTip.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CBJ"];
               // [backView addSubview:valueLabelTip];
                
                
                
                //转让价格 (10, 98.5, ScreenWidth/2 - 30, 13)
                UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 98.5, 60, 13)];
                giveLabel.font = [UIFont boldSystemFontOfSize:13];
                [giveLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                giveLabel.textAlignment = NSTextAlignmentRight;
                giveLabel.text = @"转让价格:";
                [backView addSubview:giveLabel];
                
                UILabel *giveLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 98.5, ScreenWidth/2 - 80, 13)];
                giveLabelTip.font = [UIFont boldSystemFontOfSize:13];
                [giveLabelTip setTextColor:[UIColor redColor]];
                giveLabelTip.textAlignment = NSTextAlignmentLeft;
                giveLabelTip.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_ZXSZ"];
                [backView addSubview:giveLabelTip];
                
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 89, ScreenWidth - 20, 1)];
                lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
                [backView addSubview:lineView];
                
                //投资按钮
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(ScreenWidth - 20 - 60, 50, 50, 25);
                button.tag = [indexPath row];
                button.backgroundColor = [UIColor orangeColor];
                [button setTitle:@"转让" forState:UIControlStateNormal];
                button.layer.cornerRadius = 3;
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button addTarget:self action:@selector(touziBtn:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:button];
                
                
                
                //下次结息日
                
                UILabel *remaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 98.5, ScreenWidth/2 - 30, 13)];
                remaiLabel.font = [UIFont boldSystemFontOfSize:13];
                [remaiLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                remaiLabel.textAlignment = NSTextAlignmentRight;
                remaiLabel.text = [NSString stringWithFormat:@"下次结息日:%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_DQRQ"]];
                //[backView addSubview:remaiLabel];
                
                
                
                
                // 剩余时间
                
                UILabel *syLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 10, 98.5, ScreenWidth/2 - 40, 13)];
                syLabel.font = [UIFont boldSystemFontOfSize:13];
                [syLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
                syLabel.textAlignment = NSTextAlignmentRight;
                syLabel.text = [NSString stringWithFormat:@"剩余时间:%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_SYTS"]];
                [backView addSubview:syLabel];
                
                
                
                
                [cell.contentView addSubview:backView];
            }
        }
        return cell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 125;
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [dataList count]) {
        for (UILabel *label in [moreCell.contentView subviews]) {
            if ([label.text isEqualToString:@"正在加载中..."]) {
                
            } else {
                label.text = @"正在加载中...";
                [self requestCategoryList:start limit:limit tag:kBusinessTagGetJRcpzrwyzrloadData];
                [tbleView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    } else {
        //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
       // delegate.isON = YES;
        MyTransferDetailViewController *cv = [[MyTransferDetailViewController alloc] init];
      
        cv.gqdm = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQDM"];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
        
    }
}


#pragma mark - Request Methods
//获取品牌列表
- (void)requestCategoryList:(NSString *)_start limit:(NSString *)_limit tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求品牌列表");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    //获取类别信息
    
    //[paraDic setObject:@"0,-2" forKey:@"jyzt"];
    //[paraDic setObject:allGqlb forKey:@"gqlb"];
    [paraDic setObject:_limit forKey:@"pageSize"];
    [paraDic setObject:_start forKey:@"pageNO"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
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
    [_slimeView endRefresh];
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
    NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
    
    if (tag==kBusinessTagGetJRcpzrwyzrloadData ) {
        // NSMutableDictionary *dataArr = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"获取品牌失败"];
        } else {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self recivedCategoryList:[dataArray objectForKey:@"dataList"]];
            
            
        }
    }else if (tag == kBusinessTagGetJRcpzrwyzrloadDataAgain){
        
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [dataList removeAllObjects];
            [self recivedCategoryList:[dataArray objectForKey:@"dataList"]];
        }
    }
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
