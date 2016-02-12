//
//  MainTableController.m
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 2/10/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "MainTableController.h"
#import "ViewController.h"

@interface MainTableController ()
@property(nonatomic)NSArray *listOfFiles;
@end
@implementation MainTableController
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}
 */

- (NSArray *)listOfFiles {
    if (!_listOfFiles) {
        NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
        NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.zml'"];
        _listOfFiles = [dirContents filteredArrayUsingPredicate:fltr];
    }
    return _listOfFiles;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOfFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    [cell.textLabel setText:_listOfFiles[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *viewController = [ViewController new];
    [viewController setZmlName:_listOfFiles[indexPath.row]];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
