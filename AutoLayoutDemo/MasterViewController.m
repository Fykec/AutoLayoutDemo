//
//  MasterViewController.m
//  AutoLayoutDemo
//
//  Created by Foster Yin on 12/7/15.
//  Copyright © 2015 JoyBB. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSArray * titles;

@end


@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.titles = @[@"Layout Subviews Demo",
                    @"NSLayoutConstraint Demo",
                    @"VFL Demo",
                    @"Masonry Demo",
                    @"Masonry Layout Margins Demo",
                    @"Masonry Linear Layout Demo",
                    @"Masonry Horizontal Linear Layout Demo",
                    @"Masonry Frame Layout Demo",
                    @"Masonry Grid Layout Demo",
                    @"SnapKit Demo"
                    ];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.title = title;
        controller.viewClassName = [[title stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingString:@"View"];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = self.titles[indexPath.row];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end
