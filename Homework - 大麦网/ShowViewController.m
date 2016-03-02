//
//  ShowViewController.m
//  Homework - 大麦网
//
//  Created by qianfeng on 16/1/15.
//  Copyright (c) 2016年 白. All rights reserved.
//

#import "ShowViewController.h"

@interface ShowViewController ()
@property(nonatomic,copy)NSString * Url;
@end

@implementation ShowViewController
- (instancetype)initWithURL:(NSString *)urlString
{
    if (self = [super init])
    {
        self.Url = urlString;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView * webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.scalesPageToFit = YES;//文字自适应
    [self.view addSubview:webView];
    NSURL * URL = [NSURL URLWithString:self.Url];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
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
