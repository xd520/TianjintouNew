//
//  DDList.m
//  DropDownList
//
//  Created by kingyee on 11-9-19.
//  Copyright 2011 Kingyee. All rights reserved.
//

#import "DDList.h"
#import <QuartzCore/QuartzCore.h>
#import "PassValueDelegate.h"
#import "AppDelegate.h"


@implementation DDList

@synthesize  _resultList, _delegate;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.layer.borderWidth = 1;
	self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
   // self.tableView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
	//_resultList = [[NSMutableArray alloc] initWithCapacity:5];
	_resultList = @[@"按名称查询",@"按时间查询"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_resultList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //cell.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    // Configure the cell...
	NSUInteger row = [indexPath row];
	//cell.textLabel.text = [_resultList objectAtIndex:row];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    lab.text = [_resultList objectAtIndex:row];
    lab.font = [UIFont systemFontOfSize:12];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:lab];
    
    
    //cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
	[_delegate passValue:[_resultList objectAtIndex:[indexPath row]]];
    [_delegate passBankCode:[_resultList objectAtIndex:[indexPath row]]];
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}




- (void)dealloc {
	
    self._delegate = nil;
}


@end

