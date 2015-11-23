//
//  RCRedditTableViewCell.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCRedditTableViewCell.h"
#import "RCServiceManager.h"

@implementation RCRedditTableViewCell {
    IBOutlet NSLayoutConstraint *titleXConstraint;
    CGFloat titleXOriginalConstraint;
    IBOutlet NSLayoutConstraint *commentsXConstraint;
    CGFloat commentsXOriginalConstraint;
}

@synthesize titleLabel;
@synthesize numberOfCommentsLabel;
@synthesize createdAtLabel;
@synthesize authorLabel;
@synthesize thumbnailImage = _thumbnailImage;

- (void)awakeFromNib {
    titleXOriginalConstraint = titleXConstraint.constant;
    commentsXOriginalConstraint = commentsXConstraint.constant;
}

-(void)setThumbnailImageWithURL:(NSURL*)url {
    [[RCServiceManager sharedInstance] getImageWithImageURL:url andCallbackBlock:^(NSData *imageData) {
        if (imageData) {
            _thumbnailImage.image = [UIImage imageWithData:imageData];
            [self setConstraintsWithThumbnail:YES];
        } else {
            _thumbnailImage.image = [UIImage imageNamed:@"Reddit-alien.png"];
        }
    }];
}

-(void)setConstraintsWithThumbnail:(BOOL)withThumbnail{
    _thumbnailImage.hidden = NO;
    [self layoutIfNeeded];
    if (withThumbnail) {
        _thumbnailImage.alpha = .0;
        _thumbnailImage.hidden = NO;
        
        titleXConstraint.constant = titleXOriginalConstraint;
        commentsXConstraint.constant = commentsXOriginalConstraint;
        
        [UIView animateWithDuration:.25 animations:^{
            [self layoutIfNeeded];
            _thumbnailImage.alpha = 1;
        }];
    } else {
        _thumbnailImage.alpha = 1.0;
        titleXConstraint.constant = -_thumbnailImage.frame.size.width;
        commentsXConstraint.constant = -_thumbnailImage.frame.size.width;
        
        [UIView animateWithDuration:.25 animations:^{
            [self layoutIfNeeded];
            _thumbnailImage.alpha = .0;
        } completion:^(BOOL finished) {
            _thumbnailImage.hidden = YES;
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
