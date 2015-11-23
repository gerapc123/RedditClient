//
//  ViewController.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#define DEFAULT_ROW_HEIGHT 130
#define DEFAULT_TITLE_WIDTH_WITH_THUMBNAIL 1200
#define DEFAULT_TITLE_WIDTH_WITHOUT_THUMBNAIL 900

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

    cell.titleLabel.text = subreddit.title;
    cell.authorLabel.text = [NSString stringWithFormat:@"By %@", subreddit.author];
    cell.createdAtLabel.text = [subreddit getCreatedAgo];
    cell.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%d comments", subreddit.numberOfComments];
    
    if (subreddit.thumbnailImageData) {
        [cell setConstraintsWithThumbnail:YES];
        cell.thumbnailImage.image = [UIImage imageWithData:subreddit.thumbnailImageData];
    } else {
        cell.thumbnailImage.image = [UIImage imageNamed:@"Reddit-alien.png"];
        [cell setConstraintsWithThumbnail:NO];
        if (![subreddit.thumbnailURL.absoluteString isEqualToString:@""]) {
            [cell setThumbnailImageWithURL:subreddit.thumbnailURL];
        }
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    float retVal = DEFAULT_ROW_HEIGHT;
    
    RCSubredditObject * subreddit = (RCSubredditObject*)[subredditObjects objectAtIndex:indexPath.row];
    CGSize size = [subreddit.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22]}];
    
    float textWidthOneLine = ceilf(size.width);

    float diff = 0;
    if (!subreddit.thumbnailURL || [subreddit.thumbnailURL.absoluteString isEqualToString:@""]) {
        return textWidthOneLine*(DEFAULT_ROW_HEIGHT/DEFAULT_TITLE_WIDTH_WITHOUT_THUMBNAIL);
    } else {
        if (textWidthOneLine > DEFAULT_TITLE_WIDTH_WITH_THUMBNAIL) {
            diff = textWidthOneLine - DEFAULT_TITLE_WIDTH_WITH_THUMBNAIL;
        }
        diff = diff*0.1;
    }
    
    return retVal+diff;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [myTableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"showDetailLink"]) {
        RCSubredditObject *object = subredditObjects[indexPath.row];
        [(RCLinkDetailViewController*)[segue destinationViewController] setUrl:object.linkURL];
        [(RCLinkDetailViewController*)[segue destinationViewController] setImageUrl:object.imageURL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
