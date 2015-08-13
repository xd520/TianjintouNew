//
//  HideViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-11.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "HideViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

#define SHIPTABLEVIEW 10009

@interface HideViewController ()
{
    UITableView *tableView;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    SRRefreshView   *_slimeView;
    float addHight;
    BOOL deleteVisable;
}
@end

@implementation HideViewController

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
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 44 + addHight, ScreenWidth,  ScreenHeight - 64)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTag:SHIPTABLEVIEW];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.tableFooterView = [[UIView alloc] init];
    
    //手势滑动
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [tableView addGestureRecognizer:leftSwipeGestureRecognizer];
    [tableView addGestureRecognizer:rightSwipeGestureRecognizer];
    
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
    
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //获取类别信息
        
        [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyFavoritesData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    

    //
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    //startBak = [NSString stringWithString:start];
    start = @"1";
     [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyFavoritesDataAgain];
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
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 94/2)/2, 100, 94/2, 89/2)];
            [iconImageView setImage:[UIImage imageNamed:@"收藏"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
            tipLabel.backgroundColor = [UIColor clearColor];
            [tipLabel setText:@"没有任何创建项目哦~"];
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
                [cell setBackgroundColor:[UIColor clearColor]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth , 115)];
                [backView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
                
                //品牌
                
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, ScreenWidth - 20, 15)];
                brandLabel.font = [UIFont systemFontOfSize:15];
                [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"GQQC"];
                [backView addSubview:brandLabel];
                
                
                UILabel *numYQH = [[UILabel alloc] init];
                numYQH.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"PMLL"] floatValue]*100];
                numYQH.font = [UIFont systemFontOfSize:28];
                numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
                numYQH.frame = CGRectMake(10, 35, titleSize.width, 28);
                
                [backView addSubview:numYQH];
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(titleSize.width + 10, 63 - 13, 15, 13)];
                lab.text = @"%";
                lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                lab.font = [UIFont systemFontOfSize:13];
                [backView addSubview:lab];
                
                //到期日期
                UILabel *classLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 71,ScreenWidth/4 + 5 , 14)];
                classLabTip.text = @"到期日期";
                classLabTip.font = [UIFont systemFontOfSize:14];
                classLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:classLabTip];
                
                
                UILabel *labRQ = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, ScreenWidth/4 + 5, 13)];
                
                //labRQ.textAlignment = NSTextAlignmentCenter;
                
                labRQ.textColor = [ColorUtil colorWithHexString:@"333333"];
                
                labRQ.font = [UIFont systemFontOfSize:14];
                
                
                
                //日期格式转化
                
                NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"SCSJ"]];
                
                // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                
                [strDate insertString:@"-" atIndex:4];
                
                [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                
                labRQ.text = [NSString stringWithFormat:@"%@",strDate];
                
                [backView addSubview:labRQ];

                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/4 + 15, 70, 1, 34)];
                lineView.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
                [backView addSubview:lineView];
                
                
                
                
                
                //剩余可投资金额
                UILabel *remainLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 + 30, 71,ScreenWidth/2 - 35, 13)];
                remainLab.text =@"剩余可投资金额";
                remainLab.font = [UIFont systemFontOfSize:13];
                remainLab.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:remainLab];
                
                UILabel *remainLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/4 + 30, 90,ScreenWidth/2 - 35 , 13)];
                remainLabTip.text = [NSString stringWithFormat:@"%@元",[[dataList objectAtIndex:[indexPath row]] objectForKey:@"SYKT"]];
                remainLabTip.font = [UIFont systemFontOfSize:13];
                remainLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
                [backView addSubview:remainLabTip];
               
                UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*3/4 + 5, 70, 1, 34)];
                lineView1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
                [backView addSubview:lineView1];
                
                
                
                //状态
                
                UILabel *ztLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth*3/4 + 25, 71, ScreenWidth/4 - 35, 15)];
                ztLabel.text = @"状态";
                ztLabel.font = [UIFont systemFontOfSize:14];
                ztLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
                [backView addSubview:ztLabel];
                
                
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth*3/4 + 25, 90, ScreenWidth/4 - 35, 13)];
                
                if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"JYZT"] isEqualToString:@"-2"]) {
                   dateLabel.text = @"可投资";
                    dateLabel.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                } else {
                    dateLabel.text = @"已抢光";
                    dateLabel.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                
                }
                
                dateLabel.font = [UIFont systemFontOfSize:13];
                [backView addSubview:dateLabel];
                
                
                
                if ([indexPath row] != 0) {
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
                    [subView setBackgroundColor:[ColorUtil colorWithHexString:@"dcdcdc"]];
                    [backView addSubview:subView];
                }
                    
                    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 114.5, ScreenWidth, 0.5)];
                    [subView1 setBackgroundColor:[ColorUtil colorWithHexString:@"dcdcdc"]];
                    [backView addSubview:subView1];
               
                
                
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
        return 125;
    }
    return 95;
}

- (void)tableView:(UITableView *)tbleView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tbleView.tag == SHIPTABLEVIEW) {
        
         NSLog(@"%ld  %ld",indexPath.row,[dataList count]);
        
        if ([indexPath row] == [dataList count]) {
            if (hasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"正在加载中..."]) {
                        
                    } else {
                        label.text = @"正在加载中...";
                         [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyFavoritesData];
                       
                        
                        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
    }
    
    
}


/*

- (void)tableView:(UITableView *)tbleView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tbleView.tag == SHIPTABLEVIEW) {
    NSLog(@"%ld  %ld",indexPath.row,[dataList count]);
        if ([indexPath row]== [dataList count]) {
            if (hasMore) {
                for (UILabel *label in [cell.contentView subviews]) {
                    if ([label.text isEqualToString:@"*****正在加载*****"]) {
                        
                    } else {
                        label.text = @"*****正在加载*****";
                        [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyFavoritesData];
                        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                }
            }
        }
        
    }
}
*/


- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tbleView == tableView) {
        
        if (indexPath.row == [dataList count]) {
            for (UILabel *label in [moreCell.contentView subviews]) {
                if ([label.text isEqualToString:@"正在加载中..."]) {
                    
                } else {
                    label.text = @"正在加载中...";
                    [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyFavoritesData];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                }
            }
        } else {
            
            DetailViewController *cv = [[DetailViewController alloc] init];
            cv.title = [[dataList objectAtIndex:indexPath.row] objectForKey:@"CPMC"];
            cv.strGqdm = [[dataList objectAtIndex:indexPath.row] objectForKey:@"CPDM"];
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
            
        }
    }
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (dataList.count > 0) {
        
    
    
   CGPoint point = [sender locationInView:tableView];
    
     NSIndexPath * indexPath = [tableView indexPathForRowAtPoint:point];
    
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:[[dataList objectAtIndex:indexPath.row] objectForKey:@"GQQC"] message:@"是否要进行删除操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = indexPath.row;
    [outAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
           
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setObject:[[dataList objectAtIndex:alertView.tag] objectForKey:@"CPDM"] forKey:@"cpdm"];
            [paraDic setObject:[[dataList objectAtIndex:alertView.tag] objectForKey:@"KEYID"] forKey:@"keyid"];
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRmyFavoritesDataremove owner:self];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        
    }
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


- (void)requestMoney:(NSString *)_start withSize:(NSString *)_size tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_start forKey:@"pageIndex"];
    [paraDic setObject:_size forKey:@"pageSize"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}




#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    if (tag==kBusinessTagGetJRmyFavoritesData) {
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [self recivedCategoryList:dataArray];
        }
    }else if (tag == kBusinessTagGetJRmyFavoritesDataAgain){
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [dataList removeAllObjects];
            [self recivedCategoryList:dataArray];
        }
        
    } else if (tag == kBusinessTagGetJRmyFavoritesDataremove){
       // NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [jsonDic objectForKey:@"msg"];
            start = @"1";
            [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyFavoritesDataAgain];
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
