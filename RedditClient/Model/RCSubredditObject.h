//
//  RCSubredditObject.h
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCSubredditObject : NSObject

@property (nonatomic, retain) NSString  * subredditId;
@property (nonatomic, retain) NSString  * title;
@property (nonatomic, retain) NSString  * author;
@property (nonatomic, retain) NSURL     * thumbnailURL;
@property (nonatomic, retain) NSURL     * imageURL;
@property (nonatomic, retain) NSDate    * createdAt;
@property (nonatomic) int numberOfComments;
@property (nonatomic) int score;

-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(NSString*)getCreatedAgo;

@end
