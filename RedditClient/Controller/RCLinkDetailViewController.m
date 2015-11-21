//
//  RCLinkDetailViewController.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCLinkDetailViewController.h"
#import "RCServiceManager.h"

@interface RCLinkDetailViewController () {
    UIImage * image;
}

@end

@implementation RCLinkDetailViewController

@synthesize webView = _webView;
@synthesize url;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    image = nil;
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(IBAction) popToMainTable{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveToCameraRoll:(id)sender{
    [[RCServiceManager sharedInstance] getImageWithImageURL:url andCallbackBlock:^(NSData *data) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Save Image" message:@"Would you like to save this image ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil];
        [alertView setDelegate:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
        
        image = [UIImage imageWithData:data];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
