//
//  DDList.h
//  DropDownList
//
//  Created by kingyee on 11-9-19.
//  Copyright 2011 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate;

@interface DDList : UITableViewController {

	NSArray	*_resultList;
	
}

@property (nonatomic, strong)NSArray	*_resultList;
@property (assign,nonatomic) id <PassValueDelegate> _delegate;


@end
