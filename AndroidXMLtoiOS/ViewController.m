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
    UIView *androidView = [UIView viewForXml:@"activity_main" andHandler:viewHandler];
    NSLog(@"%@",androidView);
//    [androidView setFrame:self.view.bounds];
//    [self.view addSubview:androidView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buttonAction:(UIButton *)button {
    
}

@end
