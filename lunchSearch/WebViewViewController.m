//
//  WebViewViewController.m
//  lunchSearch
//
//  Created by 小林堂太 on 2014/09/15.
//  Copyright (c) 2014年 dota.kobayashi. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // デリゲートを指定
    self.myWebView.delegate = self;
     
    // URLを指定
    NSURL *url = [NSURL URLWithString:_shopURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
     
    // リクエストを投げる
    [self.myWebView loadRequest:request];
     
}
- (IBAction)backBtn:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end