//
//  RCSubredditObject.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCSubredditObject.h"
#import "RCServiceManager.h"

#define HOURS_IN_A_DAY 24
#define SECONDS_IN_A_MINUT 60

@implementation RCSubredditObject

@synthesize subredditId         = _subredditId;
@synthesize title               = _title;
@synthesize author              = _author;
@synthesize thumbnailURL        = _thumbnailURL;
@synthesize imageURL            = _imageURL;
@synthesize linkURL             = _linkURL;
@synthesize createdAt           = _createdAt;
@synthesize numberOfComments    = _numberOfComments;
@synthesize score               = _score;
@synthesize thumbnailImageData  = _thumbnailImageData;

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    if (!self){
        self = [super init];
    }
    _subredditId = [dict objectForKey:@"subreddit_id"];
    _title = [dict objectForKey:@"title"];
    _author = [dict objectForKey:@"author"];
    _numberOfComments = [[dict objectForKey:@"num_comments"] intValue];
    _score = [[dict objectForKey:@"score"] intValue];
    _linkURL = [NSURL URLWithString:[dict objectForKey:@"url"]];
    
    NSTimeInterval epocTime = [[dict objectForKey:@"created_utc"] floatValue];
    _createdAt = [NSDate dateWithTimeIntervalSince1970:epocTime];
    
    _imageURL = nil;
    NSDictionary * sourceDict = [[[[dict objectForKey:@"preview"] objectForKey:@"images"] objectAtIndex:0] objectForKey:@"source"];
    if (sourceDict && [sourceDict objectForKey:@"url"]) {
        _imageURL = [NSURL URLWithString:[sourceDict objectForKey:@"url"]];
    }
    
    _thumbnailURL = [NSURL URLWithString:[dict objectForKey:@"thumbnail"]];
    if (![_thumbnailURL.absoluteString isEqualToString:@""]) {
        [[RCServiceManager sharedInstance] getImageWithImageURL:_thumbnailURL andCallbackBlock:^(NSData *imageData) {
            _thumbnailImageData = imageData;
        }];
    }
    
    return self;
}

-(NSString*)getCreatedAgo{
    float interval = [_createdAt timeIntervalSinceNow]*-1;
    
    NSString * dateString = @"";
    if (interval < SECONDS_IN_A_MINUT) {
        dateString = [NSString stringWithFormat:@"Posted %d seconds ago", (int)interval];
    } else {
        int hours = interval/(SECONDS_IN_A_MINUT*SECONDS_IN_A_MINUT);
        dateString = [NSString stringWithFormat:@"Posted %d hours ago", hours];
        
        if (hours > HOURS_IN_A_DAY) {
            int days = hours/HOURS_IN_A_DAY;
            hours = hours%HOURS_IN_A_DAY;
            dateString = [NSString stringWithFormat:@"Posted %d days %d hours ago", days, hours];
        }
    }
    return dateString;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"\n Id: %@ \n Title: %@ \n Author: %@ \n ThumbnailURL: %@ \n Comments: %d \n Score: %d \n ImageURL: %@ \n CreatedAt: %@ \n CreatedAt: %@\n\n\n", _subredditId, _title, _author, _thumbnailURL.absoluteString, _numberOfComments, _score, _imageURL.absoluteString, [_createdAt description], [self getCreatedAgo]];
}


@end
