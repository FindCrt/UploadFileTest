//
//  WeiboAuthViewController.m
//  Networking
//
//  Created by shiwei on 15/10/5.
//  Copyright © 2015年 shiwei. All rights reserved.
//

#import "WeiboAuthViewController.h"
#import "FDRequests.h"

@interface WeiboAuthViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WeiboAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* urlString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@",client_id,redirect_uri];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

#pragma mark - webView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //授权成功，跳转，这是就可以退出去了;返回的参数code携带在跳转的url里
    if ([request.URL.absoluteString hasPrefix:redirect_uri]) {
        NSString* query = request.URL.query;
        NSString* code = [[query componentsSeparatedByString:@"="]lastObject];
        
        [self obtainAccessTokenWithCode:code];
        return NO;
    }
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"webView load error: %@",error);
}

-(void)obtainAccessTokenWithCode:(NSString*)code{
    
    NSDictionary* weiboAuthInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"weiboAuthInfo"];
    
    NSDictionary* params = @{
                             @"client_id":client_id,
                             @"client_secret":client_secret,
                             @"grant_type":@"authorization_code",
                             @"code":code,
                             @"redirect_uri":redirect_uri
                             };
    NSDictionary* info = @{
                           @"method":@"POST",
                           @"url":@"https://api.weibo.com/oauth2/access_token",
                           @"params":params
                           };
    [FDRequests requestWithInfo:info callback:^(FDResponse *response) {
        if (response.error) {
            NSLog(@"%@",response.error);
            return ;
        }
        //access_token,uid,expires_in(授权剩余秒数)
        NSDictionary* datas = response.json;
        NSMutableDictionary* temp = weiboAuthInfo.mutableCopy;
        [temp addEntriesFromDictionary:datas];
        
        [[NSUserDefaults standardUserDefaults]setObject:temp forKey:@"weiboAuthInfo"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"weiboAuthSuccess" object:nil];
        });
        
    }];
}

@end
