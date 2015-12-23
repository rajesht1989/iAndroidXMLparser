//
//  ViewController.m
//  AndroidXMLtoiOS
//
//  Created by Rajesh on 11/23/15.
//  Copyright © 2015 Org. All rights reserved.
//

#import "ViewController.h"
#import "XMLReader.h"
#import "AView.h"

@interface ViewController () <AViewHandlerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AViewHandler * viewHandler = [[AViewHandler alloc] init];
    [viewHandler setSuperView:self.view];
    [viewHandler setOwner:self];
    UIView *androidView = [UIView viewForXml:@"LinearLayout" andHandler:viewHandler];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:viewHandler.superView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHandler.superView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:androidView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHandler.superView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0]];
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    NSLog(@"%@",androidView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buttonAction:(UIButton *)button {
    
}

@end
