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
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    return 25;
}

- (AndroidTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorColor:[UIColor greenColor]];
    AndroidTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AndroidTableViewCell.class) forIndexPath:indexPath];
    [tableViewCell setElement:_element];
    [tableViewCell setDelegate:self];
    return tableViewCell;
}

- (NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings;
{
    swipeSettings.transition = MGSwipeTransitionDrag;
    
    if (direction == MGSwipeDirectionLeftToRight) {
        expansionSettings.buttonIndex = -1;
        expansionSettings.fillOnTrigger = NO;
        return [self createButtons:3];
    }
    else {
        expansionSettings.buttonIndex = -1;
        expansionSettings.fillOnTrigger = NO;
        return [self createButtons:3];
    }
}

- (NSArray *) createButtons: (int) number {
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[3] = {@"Delete", @"More", @"sample"};
    UIColor * colors[3] = {[UIColor redColor], [UIColor lightGrayColor],[UIColor lightGrayColor]};
    for (int i = 0; i < number; ++i) {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right).");
            BOOL autoHide = i != 0;
            return autoHide; //Don't autohide in delete button to improve delete expansion animation
        }];
        [result addObject:button];
    }
    return result;
}

@end


