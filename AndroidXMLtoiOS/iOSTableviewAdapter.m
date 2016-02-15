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
@property(nonatomic, weak)NSIndexPath *indexPath;
@property(nonatomic, assign)AndroidView *cellRootView;

@end

@implementation AndroidTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setElement:(TBXMLElement *)element {
    if (!_element) {
        _element = element;
        AndroidViewHandler *handler = [[AndroidViewHandler alloc] init];
        [handler setSuperView:self.contentView];
        self.cellRootView = [AndroidView viewForElement:element handler:handler];
        NSLog(@"%@",self.cellRootView);
    }
}

@end

@interface iOSTableviewAdapter ()

@property(nonatomic,weak)NSArray *dataArray;
@property(nonatomic,weak)NSArray *rightSwipeArray;
@property(nonatomic,weak)NSArray *leftSwipeArray;

@end

@implementation iOSTableviewAdapter

- (NSArray *)dataArray {
    if (!_dataArray) {
        AndroidView *parentView = (AndroidView *)self.tableView.superview;
        _dataArray = parentView.superParentView.dataDictCollection[parentView.identifier];
    }
    return _dataArray;
}

- (NSArray *)rightSwipeArray {
    if (!_rightSwipeArray) {
        AndroidView *parentView = (AndroidView *)self.tableView.superview;
        _rightSwipeArray = parentView.superParentView.onRightSwipeMenuDictCollection[parentView.identifier];
    }
    return _rightSwipeArray;
}

- (NSArray *)leftSwipeArray {
    if (!_leftSwipeArray) {
        AndroidView *parentView = (AndroidView *)self.tableView.superview;
        _leftSwipeArray = parentView.superParentView.onLeftSwipeMenuDictCollection[parentView.identifier];
    }
    return _leftSwipeArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dataArray] count];
}

- (AndroidTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AndroidTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AndroidTableViewCell.class) forIndexPath:indexPath];
    [tableViewCell setElement:_element];
    [tableViewCell setDelegate:self];
    [tableViewCell setIndexPath:indexPath];
    [self configureCell:tableViewCell indexPath:indexPath];
    return tableViewCell;
}

- (void)configureCell:(AndroidTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    AndroidView *rootView = cell.cellRootView;
    
    for (NSString *aKey in rootView.subviewInSuperParentDict) {
        AndroidView *aView = rootView.subviewInSuperParentDict[aKey];
        if (aView.isDynamicContent) {
            [aView setContent:[self.dataArray[indexPath.row] objectForKey:aKey]];
        }
    }
}

- (NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
{
    swipeSettings.transition = MGSwipeTransitionDrag;
    
    if (direction == MGSwipeDirectionLeftToRight) {
        if (self.rightSwipeArray.count == 1) {
            expansionSettings.buttonIndex = 0;
            expansionSettings.fillOnTrigger = 1;
        }
        return [self createButtonsFromArray:self.rightSwipeArray];
    }
    else {
        if (self.leftSwipeArray.count == 1) {
            expansionSettings.buttonIndex = 0;
            expansionSettings.fillOnTrigger = 1;
        }
        return [self createButtonsFromArray:self.leftSwipeArray];
    }
}

- (NSArray *)createButtonsFromArray: (NSArray *)array {
    NSMutableArray * result = [NSMutableArray array];
    for (NSDictionary *aButton in array) {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:aButton[@"name"] backgroundColor:[UIColor grayColor] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"%ld,%@",(long)((AndroidTableViewCell *)sender).indexPath.row,aButton[@"name"]);
            [[(AndroidView *)self.tableView.superview owner] showAlert:[NSString stringWithFormat:@"In Row : %ld, Selected Action :%@",(long)((AndroidTableViewCell *)sender).indexPath.row,aButton[@"name"]]];
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

@end

