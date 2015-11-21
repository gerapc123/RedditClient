//
//  ViewController.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCMainTableViewController.h"
#import "RCServiceManager.h"
#import "RCSubredditObject.h"
#import "RCRedditTableViewCell.h"
#import "RCLinkDetailViewController.h"

@interface RCMainTableViewController () {
    NSArray * subredditObjects;
    IBOutlet UITableView * myTableView;
}

@end

@implementation RCMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RCServiceManager sharedInstance] getHotSubredditsWithCallbackBlock:^(NSArray *hot) {
        subredditObjects = hot;
        [myTableView reloadData];
    }];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [subredditObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCRedditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    RCSubredditObject * subreddit = (RCSubredditObject*)[subredditObjects objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = subreddit.title;
    cell.authorLabel.text = [NSString stringWithFormat:@"By %@", subreddit.author];
    cell.createdAtLabel.text = [subreddit getCreatedAgo];
    cell.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%d comments", subreddit.numberOfComments];
    if (subreddit.thumbnailImageData) {
        cell.thumbnailImage.image = [UIImage imageWithData:subreddit.thumbnailImageData];
    } else {
        cell.thumbnailImage.image = [UIImage imageNamed:@"placeholder.png"];
    }
    
    return cell;
}

#pragma mark - TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    RCSubredditObject * subreddit = (RCSubredditObject*)[subredditObjects objectAtIndex:indexPath.row];
//    UIPopoverPresentationController * urlDetails = [[UIPopoverPresentationController alloc] initWithPresentedViewController:self presentingViewController:[[UIViewController alloc] init]];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetailLink"])
    {
        NSIndexPath *indexPath = [myTableView indexPathForSelectedRow];
        RCSubredditObject *object = subredditObjects[indexPath.row];
        [(RCLinkDetailViewController*)[segue destinationViewController] setUrl:object.imageURL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
