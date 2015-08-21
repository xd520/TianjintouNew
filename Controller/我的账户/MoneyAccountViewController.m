//
//  MoneyAccountViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MoneyAccountViewController.h"
#import "AppDelegate.h"
#import "MyTransferDetailViewController.h"
#import "RechargeFirstViewController.h"
#import "WithdrawFirstViewController.h"


@interface MoneyAccountViewController ()
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
     UISegmentedControl  *segmented;
    
    NSString *isRefresh;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation MoneyAccountViewController

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([isRefresh isEqualToString:@"1"]) {
        startBak = [NSString stringWithString:start];
        start = @"1";
        [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyJrzcPagingAgain];
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    start = @"1";
    limit = @"10";
    
    isRefresh = @"";
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"我的资产",@"我的投资产品",nil];
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    
    segmented.frame = CGRectMake(10, addHight + 54 , ScreenWidth - 20, 30);
    
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
    
    //view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, scrollViewHeight)];
    //[self setApperanceForLabel:label1];
   
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth , 0, ScreenWidth,  scrollViewHeight)];
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
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //获取类别信息
        [self requestLogin:kBusinessTagGetJRMyzc];
        
        [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyJrzcPaging];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
  
 }

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    startBak = [NSString stringWithString:start];
    start = @"1";
    [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyJrzcPagingAgain];
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
                    [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyJrzcPaging];
                    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
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
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"none_product_icon"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ColorUtil colorWithHexString:@"404040"]];
            [tipLabel setText:@"亲，还未有投资产品"];
            tipLabel.backgroundColor = [UIColor clearColor];
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
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor clearColor]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 120)];
                [backView setBackgroundColor:[ColorUtil colorWithHexString:@"fdfdfd"]];
               
                
                
                //品牌
                
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 20, 25)];
                brandLabel.font = [UIFont systemFontOfSize:15];
                [brandLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPMC"];
                [backView addSubview:brandLabel];
                
                
                UILabel *numYQH = [[UILabel alloc] init];
                numYQH.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GZLL"] floatValue]*100];
                numYQH.font = [UIFont systemFontOfSize:25];
                numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
                numYQH.frame = CGRectMake(10, 35, titleSize.width, 25);
                [backView addSubview:numYQH];
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, 60 - 13, 15, 13)];
                lab.text = @"%";
                lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
                lab.font = [UIFont systemFontOfSize:13];
                [backView addSubview:lab];
                
 //投资金额
                UILabel *labMoney = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 60, 14)];
                labMoney.text = @"投资金额";
                labMoney.textColor = [ColorUtil colorWithHexString:@"999999"];
                labMoney.font = [UIFont systemFontOfSize:14];
                [backView addSubview:labMoney];
                
                
                UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, ScreenWidth/2 - 20, 14)];
                moneyLabel.font = [UIFont systemFontOfSize:14];
                [moneyLabel setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [moneyLabel setBackgroundColor:[UIColor clearColor]];
                //moneyLabel.textAlignment = NSTextAlignmentRight;
               // moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[self AddComma:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_TZJE"]] floatValue]];
                moneyLabel.text = [NSString stringWithFormat:@"%@元",[self AddComma:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_TZJE"]]];
                [backView addSubview:moneyLabel];
                
                
                if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"sell"] isEqualToString:@"can"]) {
                    
                    if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GQLB"] isEqualToString:@"98"]||[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GQLB"] isEqualToString:@"Z9"]) {
                        
                        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 30, 70, 30)];
                        lab.backgroundColor = [UIColor grayColor];
                        lab.font = [UIFont systemFontOfSize:14];
                        //lab.layer.borderWidth = 1;
                        lab.textColor = [UIColor whiteColor];
                        lab.layer.masksToBounds = YES;
                        
                        lab.layer.cornerRadius = 4;
                        lab.text = @"转让";
                        lab.textAlignment = NSTextAlignmentCenter;
                        [backView addSubview:lab];
                        
                    } else {
                    
                    
                    
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 30, 80, 30)];
                    lab.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
                    lab.font = [UIFont systemFontOfSize:14];
                    //lab.layer.borderWidth = 1;
                    
                    lab.layer.masksToBounds = YES;
                    lab.layer.cornerRadius = 4;
                    lab.text = @"转让";
                    lab.textColor = [UIColor whiteColor];
                     lab.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:lab];
                    }
                } else {
                
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 30, 70, 30)];
                    lab.backgroundColor = [UIColor grayColor];
                    lab.font = [UIFont systemFontOfSize:14];
                    //lab.layer.borderWidth = 1;
                     lab.textColor = [UIColor whiteColor];
                    lab.layer.masksToBounds = YES;
                    
                    lab.layer.cornerRadius = 4;
                    lab.text = @"转让";
                    lab.textAlignment = NSTextAlignmentCenter;
                     [backView addSubview:lab];
                }
                
                
                
          //付息方式
                UILabel *moneyLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 70, ScreenWidth/2 - 10, 14)];
                moneyLabelTip.font = [UIFont systemFontOfSize:14];
                [moneyLabelTip setTextColor:[ColorUtil colorWithHexString:@"333333"]];
                [moneyLabelTip setBackgroundColor:[UIColor clearColor]];
                moneyLabelTip.textAlignment = NSTextAlignmentRight;
                moneyLabelTip.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_JXFS"];
                [backView addSubview:moneyLabelTip];
                
                
                //到期日期
                
                UILabel *lab2Tip = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 13)];
                //lab2Tip.textAlignment = NSTextAlignmentCenter;
                lab2Tip.textColor = [ColorUtil colorWithHexString:@"999999"];
                lab2Tip.font = [UIFont systemFontOfSize:14];
                lab2Tip.text = @"到期日期";
                [backView addSubview:lab2Tip];
                
                
                UILabel *labRQ = [[UILabel alloc] initWithFrame:CGRectMake(70, 94, 99, 13)];
                labRQ.textAlignment = NSTextAlignmentCenter;
                labRQ.textColor = [ColorUtil colorWithHexString:@"333333"];
                labRQ.font = [UIFont systemFontOfSize:13];
                
                //日期格式转化
                NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_DQRQ"]];
                // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                [strDate insertString:@"-" atIndex:4];
                [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                labRQ.text = [NSString stringWithFormat:@"%@",strDate];
                [backView addSubview:labRQ];

                
                
    //可转让日期
                UILabel *transferTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 95 - 60 - 5, 94, 70, 13)];
                transferTip.textAlignment = NSTextAlignmentCenter;
                transferTip.textColor = [ColorUtil colorWithHexString:@"999999"];
                transferTip.font = [UIFont systemFontOfSize:13];
                transferTip.text = @"可转让日期";
                [backView addSubview:transferTip];
                
                
                UILabel *transferRQ = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 94, 85, 13)];
                transferRQ.textAlignment = NSTextAlignmentCenter;
                transferRQ.textColor = [ColorUtil colorWithHexString:@"333333"];
                transferRQ.font = [UIFont systemFontOfSize:14];
                
                //日期格式转化
                NSMutableString *strDateTip = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPCLRQ"]];
                // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                [strDateTip insertString:@"-" atIndex:4];
                [strDateTip insertString:@"-" atIndex:(strDate.length - 3)];
                transferRQ.text = [NSString stringWithFormat:@"%@",strDateTip];
                [backView addSubview:transferRQ];
                
                
                [cell.contentView addSubview:backView];
                
                
            }
        }
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [dataList count]) {
        for (UILabel *label in [moreCell.contentView subviews]) {
            if ([label.text isEqualToString:@"正在加载中..."]) {
                
            } else {
                label.text = @"正在加载中...";
                [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyJrzcPaging];
                [tbleView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }
    } else {
        //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        // delegate.isON = YES;
        
        if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"sell"] isEqualToString:@"can"]) {
        
             if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GQLB"] isEqualToString:@"98"]||[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GQLB"] isEqualToString:@"Z9"]) {
             }else {
        MyTransferDetailViewController *cv = [[MyTransferDetailViewController alloc] init];
        
        cv.gqdm = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQDM"];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
             }
        }
    }
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == [dataList count]) {
        return 40;
    } else {
        return 130;
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




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scllView {
    //水平滑动的时候就会调用
    if (scllView == _scrollView) {
        CGFloat pageWidth = ScreenWidth;
        NSInteger page = _scrollView.contentOffset.x / pageWidth ;
         segmented.selectedSegmentIndex = page;
        //[self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    }
}

-(void)reloadDataWith:(NSMutableDictionary *)arraydata {
    NSArray *titleTip = @[@"总资产(元)",@"金融资产市值(元)",@"可取资金(元)",@"冻结资金(元)",@"昨日收益(元)",@"累计总收益(元)",@"累计待收益(元)"];
    NSArray *charTip = @[[arraydata objectForKey:@"zzc"],[arraydata objectForKey:@"jrZsz"],[arraydata objectForKey:@"kqzj"],[arraydata objectForKey:@"djje"],[arraydata objectForKey:@"zrljsy"],[arraydata objectForKey:@"jrljzsy"],[arraydata objectForKey:@"jrljdsy"]];
    
    for (int i = 0; i < 7;i++) {
        //int hight = addHight + 44 + 50;
        UIView *view;
        if (i < 4) {
            view =  [[UIView alloc] initWithFrame:CGRectMake(0, 40*i, ScreenWidth , 40)];
            
        } else {
            view =  [[UIView alloc] initWithFrame:CGRectMake(0, 40*i + 10, ScreenWidth , 40)];
        }
        view.backgroundColor = [UIColor whiteColor];
       // view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
       // view.layer.borderWidth = 1;
        
       // view.layer.masksToBounds = YES;
        
       // view.layer.cornerRadius = 4;
        
        if (i == 3 ||i == 6) {
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,39.5, ScreenWidth, 0.5)];
            lineView1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
            [view addSubview:lineView1];
            
        } else {
            if (i == 0 ) {
                UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 0.5)];
                lineView1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
                [view addSubview:lineView1];
                
                UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10,39.5, ScreenWidth - 10, 0.5)];
                lineView2.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
                [view addSubview:lineView2];
                
            } else {
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10,39.5, ScreenWidth - 10, 0.5)];
            lineView1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
            [view addSubview:lineView1];
            }
        }
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 12.5, 160, 15)];
        lab.text = [titleTip objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:14];
        
        // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        lab.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lab];
        
        
        UILabel *labReal = [[UILabel alloc] initWithFrame:CGRectMake(170 , 12.5, ScreenWidth - 170 -10, 15)];
        
        if ([[charTip objectAtIndex:i] doubleValue] > 0) {
            
            NSString *strNum = [NSString stringWithFormat:@"%.2f",[[charTip objectAtIndex:i] doubleValue]];
            
            NSRange range1 = [strNum rangeOfString:@"."];//匹配得到的下标
            
            NSLog(@"rang:%@",NSStringFromRange(range1));
            
            //string = [string substringWithRange:range];//截取范围类的字符串
            
            NSString *string = [strNum substringFromIndex:range1.location];
            
            NSString *str = [strNum substringToIndex:range1.location];
            
            labReal.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
            
        } else {
            
            if (-[[charTip objectAtIndex:i] doubleValue] > 0) {
             
                NSString *strNum = [NSString stringWithFormat:@"%.2f",-[[charTip objectAtIndex:i] doubleValue]];
                
                NSRange range1 = [strNum rangeOfString:@"."];//匹配得到的下标
                
                NSLog(@"rang:%@",NSStringFromRange(range1));
                
                //string = [string substringWithRange:range];//截取范围类的字符串
                
                NSString *string = [strNum substringFromIndex:range1.location];
                
                NSString *str = [strNum substringToIndex:range1.location];
                
                labReal.text = [NSString stringWithFormat:@"-%@%@",[self AddComma:str],string];
                
                
            } else {
            
             labReal.text =[NSString stringWithFormat:@"%.2f", [[charTip objectAtIndex:i] doubleValue]];
            }
            
        }
        
        
        
        labReal.font = [UIFont systemFontOfSize:14];
        if (i == 0) {
            labReal.textColor = [ColorUtil colorWithHexString:@"fe8103"];
        } else {
        labReal.textColor = [ColorUtil colorWithHexString:@"333333"];
        }
        labReal.textAlignment = NSTextAlignmentRight;
        [view addSubview:labReal];
        
        [self.scrollView addSubview:view];
    }
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 300, ScreenWidth - 20, 13)];
    lab.text = @"昨日收益包含昨日到账和未到账收益";
    lab.font = [UIFont systemFontOfSize:13];
    
    // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    lab.textColor = [ColorUtil colorWithHexString:@"999999"];
    
    lab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:lab];
    
    
    //充值
    UIButton *tixianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tixianBtn.frame = CGRectMake(ScreenWidth/4 + 5, 64 + 96 + 80, 70, 30);
    tixianBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    tixianBtn.layer.borderWidth = 1;
    
    tixianBtn.layer.masksToBounds = YES;
    
    tixianBtn.layer.cornerRadius = 15;
    
    [tixianBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    [tixianBtn setTitle:@"充值" forState:UIControlStateNormal];
    //tixianBtn.titleLabel.text = @"充值";
    [tixianBtn addTarget:self action:@selector(moneyMethods:) forControlEvents:UIControlEventTouchUpInside];
    tixianBtn.tag = 1000000;
    tixianBtn.titleLabel.font = [UIFont systemFontOfSize:15];
   // [self.scrollView addSubview:tixianBtn];
    
    //提现
    
    UIButton *chongzhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhiBtn.frame = CGRectMake(ScreenWidth/2 + 5, 64 + 96 + 80, 70, 30);
    chongzhiBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    chongzhiBtn.layer.borderWidth = 1;
    
    chongzhiBtn.layer.masksToBounds = YES;
    
    chongzhiBtn.layer.cornerRadius = 15;
    
    [chongzhiBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    [chongzhiBtn setTitle:@"提现" forState:UIControlStateNormal];
    //chongzhiBtn.titleLabel.text = @"提现";
    
    [chongzhiBtn addTarget:self action:@selector(moneyMethods:) forControlEvents:UIControlEventTouchUpInside];
    chongzhiBtn.tag = 1000001;
    
    chongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
   // [self.scrollView addSubview:chongzhiBtn];
    
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


-(void)moneyMethods:(UIButton *)btn {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[delegate.dictionary objectForKey:@"isBingingCard"] boolValue]) {
        if (btn.tag == 1000000) {//充值
            
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRapplyOutMoneyAgain owner:self];
            
        } else if (btn.tag == 1000001){
           
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRapplyOutMoney owner:self];
        }
  
    } else {
    
        [self.view makeToast:@"请先绑定银行卡" duration:2 position:@"center"];
    }
    
}

- (void)requestMoney:(NSString *)_start withSize:(NSString *)_size tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_start forKey:@"pageIndex"];
    [paraDic setObject:_size forKey:@"pageSize"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
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
        start = [NSString stringWithFormat:@"%d", [start intValue] + 1];
    }
    [tableView reloadData];
    [_slimeView endRefresh];
}



#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
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
    
    if (tag== kBusinessTagGetJRMyzc) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            [self reloadDataWith:dataArray];
        }
    } else if (tag==kBusinessTagGetJRmyJrzcPaging) {
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
            isRefresh = @"1";
            [self recivedDataList:dataArray];
        }
    }else if (tag == kBusinessTagGetJRmyJrzcPagingAgain){
         NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        [_slimeView endRefresh];
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [self.view makeToast:@"刷新商品失败"];
        } else {
            [dataList removeAllObjects];
            [self recivedDataList:dataArray];
        }
    
    }  else if (tag== kBusinessTagGetJRapplyOutMoney) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.view makeToast:[dataArray objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.strVC = @"1";
            
                WithdrawFirstViewController *cv = [[WithdrawFirstViewController alloc] init];
                cv.dic = dataArray;
                cv.flag = @"1";
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            
        }
    } else if (tag== kBusinessTagGetJRapplyOutMoneyAgain) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[dataArray objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.strVC = @"1";
            
                RechargeFirstViewController *cv = [[RechargeFirstViewController alloc] init];
                cv.dic = dataArray;
                cv.flag = @"1";
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            
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
   
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
