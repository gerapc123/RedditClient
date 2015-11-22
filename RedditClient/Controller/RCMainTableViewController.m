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
    IBOutlet UIActivityIndicatorView * activityIndicator;
}

@end

@implementation RCMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [activityIndicator startAnimating];
    [[RCServiceManager sharedInstance] getHotSubredditsWithCallbackBlock:^(NSArray *hot) {
        subredditObjects = hot;
        dispatch_async(dispatch_get_main_queue(), ^{
            [myTableView reloadData];
        });
        [activityIndicator stopAnimating];
        activityIndicator.hidden = YES;
    }];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [subredditObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCRedditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    RCSubredditObject * subreddit = (RCSubredditObject*)[subredditObjects objectAtIndex:indexPath.row];

    cell.userInteractionEnabled = NO;
    cell.titleLabel.text = subreddit.title;
    cell.authorLabel.text = [NSString stringWithFormat:@"By %@", subreddit.author];
    cell.createdAtLabel.text = [subreddit getCreatedAgo];
    cell.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%d comments", subreddit.numberOfComments];
    
    if (subreddit.thumbnailImageData) {
        cell.thumbnailImage.image = [UIImage imageWithData:subreddit.thumbnailImageData];
        cell.userInteractionEnabled = YES;
    } else {
        cell.thumbnailImage.image = [UIImage imageNamed:@"Reddit-alien.png"];
        if (![subreddit.thumbnailURL.absoluteString isEqualToString:@""]) {
            [cell setThumbnailImageWithURL:subreddit.thumbnailURL];
            cell.userInteractionEnabled = YES;
        }
    }

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [myTableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"showDetailLink"])
    {
        RCSubredditObject *object = subredditObjects[indexPath.row];
        [(RCLinkDetailViewController*)[segue destinationViewController] setUrl:object.imageURL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
