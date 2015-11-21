//
//  ViewController.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCMainTableViewController.h"
#import "RCServiceManager.h"
#import "RCSubredditObject.h"
#import "RCRedditTableViewCell.h"

@interface RCMainTableViewController () {
    NSArray * subredditObjects;
}

@end

@implementation RCMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RCServiceManager sharedInstance] getHotSubredditsWithCallbackBlock:^(NSArray *hot) {
        subredditObjects = hot;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [subredditObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCRedditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    
//    cell.textLabel.text = [(RCSubredditObject*)[subredditObjects objectAtIndex:indexPath.row] title];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
