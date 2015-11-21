//
//  RCServiceManager.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCServiceManager.h"
#import "RCSubredditObject.h"

#define HOT_REDDITS_URL @"https://www.reddit.com/hot.json"

@implementation RCServiceManager {
    int counterTest;
 
    NSURLSession * urlSession;
}

+ (RCServiceManager*)sharedInstance {
    static RCServiceManager * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[RCServiceManager alloc] init];
    });
    
    return _sharedInstance;
}

-(instancetype)init{
    if (!self) {
        self = [super init];
    }
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    [config setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
    config.timeoutIntervalForRequest = 30.0;
    config.timeoutIntervalForResource = 50.0;
    
    urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    return self;
}

-(void)getHotSubredditsWithCallbackBlock:(void (^)(NSArray*))callbackBlock{
    NSURLRequest * hotRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?limit=50", HOT_REDDITS_URL]]];
    
    NSURLSessionDataTask * hotJsonData = [urlSession dataTaskWithRequest:hotRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError * _error = nil;
        id jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:0 error:&_error];
        
        if ([jsonSerialization isKindOfClass:[NSDictionary class]]) {
            NSMutableArray * subreddits = [self getSubrreditsWithDictionry:jsonSerialization];
            callbackBlock(subreddits);
        } else {
            NSLog(@"%@", [_error description]);
        }
        
    }];
    [hotJsonData resume];
}

-(NSMutableArray*)getSubrreditsWithDictionry:(NSDictionary*)subrreditsDict{
    NSMutableArray * redditObjects = [NSMutableArray new];
    
    NSArray * children = [[subrreditsDict objectForKey:@"data"] objectForKey:@"children"];
    for (NSDictionary * aSubreddit in children) {
        NSDictionary * dataDict = [aSubreddit objectForKey:@"data"];
        RCSubredditObject * aRedditObject = [[RCSubredditObject alloc] initWithDictionary:dataDict];
        [redditObjects addObject:aRedditObject];
    }
    
    return redditObjects;
}

-(void)getImageWithImageURL:(NSURL*) url andCallbackBlock:(void (^)(NSData*))callbackBlock {
    NSURLSessionDownloadTask *getImageTask =
    [urlSession downloadTaskWithURL:url
                  completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                      NSData * responseData = [NSData dataWithContentsOfURL:location];
                      callbackBlock(responseData);
                  }];
    [getImageTask resume];
}

@end
