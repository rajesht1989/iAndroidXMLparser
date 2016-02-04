//
//  iOSTableviewAdapter.m
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 2/4/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "iOSTableviewAdapter.h"
#import "AndroidView.h"

@interface AndroidTableViewCell ()

@property(nonatomic, assign)TBXMLElement *element;

@end

@implementation AndroidTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setElement:(TBXMLElement *)element {
    if (!_element) {
        _element = element;
        AndroidViewHandler *handler = [[AndroidViewHandler alloc] init];
        [handler setSuperView:self.contentView];
        AndroidView *view = [AndroidView viewForElement:element handler:handler];
        NSLog(@"%@",view);
    }
}

@end

@implementation iOSTableviewAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (AndroidTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AndroidTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AndroidTableViewCell.class) forIndexPath:indexPath];
    [tableViewCell setElement:_element];
    return tableViewCell;
}

@end


