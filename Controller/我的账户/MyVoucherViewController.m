//
//  MyVoucherViewController.m
//  添金投
//
//  Created by mac on 15/10/9.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MyVoucherViewController.h"
#import "AppDelegate.h"

@interface MyVoucherViewController ()
{
    UITableView *tableView;
    NSMutableArray *dataList;
    UITableViewCell *moreCell;
    SRRefreshView   *_slimeView;
}
@end

@implementation MyVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 64, ScreenWidth,  ScreenHeight - 64)];
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
    
    [self requestMyVoucher:kBusinessTagGetJRforappMyLpq];
    
    //
}


#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{

    [self requestMyVoucher:kBusinessTagGetJRforappMyLpq];
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
            [tipLabel setText:@"您还没有礼品券哦~"];
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
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor clearColor]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth , 145)];
                [backView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                
                //活动码：
                
                UILabel *classLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,52 , 14)];
                classLabTip.text = @"活动码:";
                classLabTip.font = [UIFont systemFontOfSize:14];
                classLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:classLabTip];
                
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 10, ScreenWidth - 72, 14)];
                brandLabel.font = [UIFont boldSystemFontOfSize:14];
                [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"HDM"];
                [backView addSubview:brandLabel];
                
               //活动券说明
                
                UILabel *classLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 32,80 , 14)];
                classLab.text = @"活动券说明:";
                classLab.font = [UIFont systemFontOfSize:14];
                classLab.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:classLab];
                
                
                UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 32, ScreenWidth - 100, 14)];
                moneyLabel.font = [UIFont boldSystemFontOfSize:14];
                [moneyLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [moneyLabel setBackgroundColor:[UIColor clearColor]];
                moneyLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"HDJSM"];
                [backView addSubview:moneyLabel];
                
            //开始使用日期：
                UILabel *classdate = [[UILabel alloc] initWithFrame:CGRectMake(10, 54,94 , 14)];
                classdate.text = @"开始使用日期:";
                classdate.font = [UIFont systemFontOfSize:14];
                classdate.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:classdate];
                
                
                UILabel *moneydate = [[UILabel alloc] initWithFrame:CGRectMake(104, 54, ScreenWidth - 104, 14)];
                moneydate.font = [UIFont boldSystemFontOfSize:14];
                [moneydate setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [moneydate setBackgroundColor:[UIColor clearColor]];
                moneydate.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"KSSYRQ"];
                [backView addSubview:moneydate];
                
                
            //结束使用日期：
                UILabel *classdateEnd = [[UILabel alloc] initWithFrame:CGRectMake(10, 76,94 , 14)];
                classdateEnd.text = @"结束使用日期:";
                classdateEnd.font = [UIFont systemFontOfSize:14];
                classdateEnd.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:classdateEnd];
                
                
                UILabel *moneydateEnd = [[UILabel alloc] initWithFrame:CGRectMake(104, 76, ScreenWidth - 104, 14)];
                moneydateEnd.font = [UIFont boldSystemFontOfSize:14];
                [moneydateEnd setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [moneydateEnd setBackgroundColor:[UIColor clearColor]];
                moneydateEnd.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"JSSYRQ"];
                [backView addSubview:moneydateEnd];
                
                
            //活动券状态：
                UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(10, 98,80 , 14)];
                class.text = @"活动券状态:";
                class.font = [UIFont systemFontOfSize:14];
                class.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:class];
                
                
                UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(90, 98, ScreenWidth - 90, 14)];
                money.font = [UIFont boldSystemFontOfSize:14];
                [money setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [money setBackgroundColor:[UIColor clearColor]];
                money.text = [self getVoucherStr:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"HDQZT"]];
                [backView addSubview:money];
                
                
            //赠送时间：
                UILabel *timeTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 120,66 , 14)];
                timeTip.text = @"赠送时间:";
                timeTip.font = [UIFont systemFontOfSize:14];
                timeTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:timeTip];
                
                
                UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(76, 120, ScreenWidth - 86, 14)];
                time.font = [UIFont boldSystemFontOfSize:14];
                [time setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [time setBackgroundColor:[UIColor clearColor]];
                time.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"ZSSJ"];
                [backView addSubview:time];
               
                [cell.contentView addSubview:backView];
                
                
            }
        }
        return cell;
    }
    return cell;
}


-(NSString *)getVoucherStr:(NSString *)str{
    NSString *string;
    if ([str isEqualToString:@"0"]) {
        string = @"未使用";
    } else {
    string = @"已赠送";
    }
    return string;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == [dataList count]) {
        return 40;
    } else {
        return 150;
    }
    return 95;
}

#pragma mark - Recived Methods
//处理品牌列表
- (void)recivedCategoryList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    if ([dataList count] > 0) {
        [dataList removeAllObjects];
        for (NSDictionary *object in dataArray) {
            [dataList addObject:object];
        }
    } else {
        dataList = dataArray;
    }
    [tableView reloadData];
    [_slimeView endRefresh];
}

- (void)requestMyVoucher:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}



#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    if (tag== kBusinessTagGetJRforappMyLpq) {
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            [self recivedCategoryList:dataArray];
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
    [_slimeView endRefresh];
    //}
    [[NetworkModule sharedNetworkModule] cancel:tag];
}




- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
