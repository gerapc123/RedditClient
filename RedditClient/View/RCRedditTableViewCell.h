//
//  RCRedditTableViewCell.h
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCRedditTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel * titleLabel;
@property (nonatomic, retain) IBOutlet UILabel * numberOfCommentsLabel;
@property (nonatomic, retain) IBOutlet UILabel * createdAtLabel;
@property (nonatomic, retain) IBOutlet UILabel * authorLabel;
@property (nonatomic, retain) IBOutlet UIImageView * thumbnailImage;


@end
