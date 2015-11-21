//
//  RCRedditTableViewCell.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCRedditTableViewCell.h"

@implementation RCRedditTableViewCell

@synthesize titleLabel;
@synthesize numberOfCommentsLabel;
@synthesize createdAtLabel;
@synthesize authorLabel;
@synthesize thumbnailImage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
