//
//  RCLinkDetailViewController.h
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCLinkDetailViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView * webView;
@property (nonatomic, retain) NSURL * url;

@end