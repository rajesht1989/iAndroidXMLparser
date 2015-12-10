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

@interface ViewController () <UIViewHandlerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewHandler * viewHandler = [[UIViewHandler alloc] init];
    [viewHandler setSuperView:self.view];
    [viewHandler setOwner:self];
    UIView *androidView = [UIView viewForXml:@"activity_android" andHandler:viewHandler];
    NSLog(@"%@",androidView);
//    [androidView setFrame:self.view.bounds];
//    [self.view addSubview:androidView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buttonAction:(UIButton *)button
{
    
}

@end
