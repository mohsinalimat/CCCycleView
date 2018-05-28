//
//  CCCycleDemoController.m
//  CCCycleViewDemo
//
//  Created by zacks on 2018/5/22.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "CCCycleDemoController.h"

@interface CCCycleDemoController ()

@end

@implementation CCCycleDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"CycleImgaeView";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"CycleView";
    }else{
        cell.textLabel.text = @"MarqueeSeque";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"detailSegue" sender:nil];
    }else if (indexPath.row == 1){
        [self performSegueWithIdentifier:@"cycleView" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"marqueeSeque" sender:nil];
        
    }
}

@end
