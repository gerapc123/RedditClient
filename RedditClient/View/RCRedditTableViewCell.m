//
//  RCRedditTableViewCell.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCRedditTableViewCell.h"
#import "RCServiceManager.h"

@implementation RCRedditTableViewCell

@synthesize titleLabel;
@synthesize numberOfCommentsLabel;
@synthesize createdAtLabel;
@synthesize authorLabel;
@synthesize thumbnailImage = _thumbnailImage;

- (void)awakeFromNib {
}

-(void)setThumbnailImageWithURL:(NSURL*)url {
    [[RCServiceManager sharedInstance] getImageWithImageURL:url andCallbackBlock:^(NSData *imageData) {
        if (imageData) {
            _thumbnailImage.image = [UIImage imageWithData:imageData];
        } else {
            _thumbnailImage.image = [UIImage imageNamed:@"Reddit-alien.png"];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
