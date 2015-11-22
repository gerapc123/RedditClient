//
//  RCSubredditObject.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCSubredditObject.h"
#import "RCServiceManager.h"

#define DAY_HOURS 24
#define HOUR_SECONDS 60

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
    
    
    
    
    NSTimeInterval epocTime = [[dict objectForKey:@"created"] floatValue];
//    NSTimeInterval currentEpocTime = [[NSDate date] timeIntervalSince1970];
//    NSTimeInterval diferencia = epocTime - (currentEpocTime-3*60.0*60.0);
    _createdAt = [NSDate dateWithTimeIntervalSince1970:epocTime];
    NSLog(@"Title:%@ || %@", _title, _createdAt);
    
    
    
    
    
    
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
    float interval = [_createdAt timeIntervalSinceNow];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    NSData * newDate = dateFormatter
    
    NSString * dateString = @"";
    if (interval < HOUR_SECONDS) {
        dateString = [NSString stringWithFormat:@"Posted %d seconds ago", (int)interval];
    } else {
        int hours = interval/(HOUR_SECONDS*2);
        dateString = [NSString stringWithFormat:@"Posted %d hours ago", hours];
        
        if (hours > DAY_HOURS) {
            int days = hours/DAY_HOURS;
            hours = hours%DAY_HOURS;
            dateString = [NSString stringWithFormat:@"Posted %d days %d hours ago", days, hours];
        }
    }
    return dateString;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"\n Id: %@ \n Title: %@ \n Author: %@ \n ThumbnailURL: %@ \n Comments: %d \n Score: %d \n ImageURL: %@ \n CreatedAt: %@ \n CreatedAt: %@\n\n\n", _subredditId, _title, _author, _thumbnailURL.absoluteString, _numberOfComments, _score, _imageURL.absoluteString, [_createdAt description], [self getCreatedAgo]];
}


@end
