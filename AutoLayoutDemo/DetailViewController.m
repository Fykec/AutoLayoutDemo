//
//  DetailViewController.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/7/15.
//  Copyright © 2015 JoyBB. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.autoresizesSubviews = YES;
    
    UIView *demoView = [[NSClassFromString(self.viewClassName) alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    demoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:demoView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
