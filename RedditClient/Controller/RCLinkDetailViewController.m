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
}

@end

@implementation RCLinkDetailViewController

@synthesize webView = _webView;
@synthesize imageUrl = _imageUrl;
@synthesize url;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(IBAction) popToMainTable{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveToCameraRoll:(id)sender{
    UIAlertView * alertView = nil;
    if (_imageUrl && ![_imageUrl.absoluteString isEqualToString:@""]) {
        alertView = [[UIAlertView alloc] initWithTitle:@"Save image" message:@"Would you like to save this image ?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil];
    } else {
        alertView = [[UIAlertView alloc] initWithTitle:@"Save image" message:@"No image to save" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    [alertView setDelegate:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertView show];
    });
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[RCServiceManager sharedInstance] getImageWithImageURL:_imageUrl andCallbackBlock:^(NSData *data) {
            UIImage * image = [UIImage imageWithData:data];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
