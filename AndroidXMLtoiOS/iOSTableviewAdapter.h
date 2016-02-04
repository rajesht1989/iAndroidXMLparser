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

@interface iOSTableviewAdapter : NSObject <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)TBXMLElement *element;
@property(nonatomic)NSArray *data;

@end

@interface AndroidTableViewCell : UITableViewCell
@end
