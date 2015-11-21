//
//  RCServiceManager.h
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCServiceManager : NSObject <NSURLSessionDataDelegate>

+ (RCServiceManager*)sharedInstance;

-(void)getHotSubredditsWithCallbackBlock:(void (^)(NSArray*))callbackBlock;

@end
