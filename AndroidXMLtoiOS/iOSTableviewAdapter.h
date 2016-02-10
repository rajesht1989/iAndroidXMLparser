//
//  iOSTableviewAdapter.h
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 2/4/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "MGSwipeTableCell.h"


@interface AndroidTableViewCell : MGSwipeTableCell
@end

@interface iOSTableviewAdapter : NSObject <UITableViewDataSource,UITableViewDelegate, MGSwipeTableCellDelegate>

@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic)TBXMLElement *element;
@property(nonatomic)NSArray *data;

@end

