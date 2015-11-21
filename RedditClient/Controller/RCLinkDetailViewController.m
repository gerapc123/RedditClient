//
//  RCLinkDetailViewController.m
//  RedditClient
//
//  Created by Ger on 11/21/15.
//  Copyright © 2015 Ger. All rights reserved.
//

#import "RCLinkDetailViewController.h"



@interface RCLinkDetailViewController () {

}

@end

@implementation RCLinkDetailViewController

@synthesize webView = _webView;
@synthesize url;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    // Do any additional setup after loading the view.
}

-(IBAction) popToMainTable{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
