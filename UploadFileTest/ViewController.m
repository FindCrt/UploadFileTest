//
//  ViewController.m
//  UploadFileTest
//
//  Created by shiwei on 16/2/21.
//  Copyright © 2016年 shiwei. All rights reserved.
//

#import "ViewController.h"
#import "WeiboAuthViewController.h"
#import "TFFileUploadManager.h"

@interface ViewController (){
    NSString *_access_token;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary* weiboAuthInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"weiboAuthInfo"];
    _access_token = [weiboAuthInfo objectForKey:@"access_token"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weiboAuthSuccess:) name:@"weiboAuthSuccess" object:nil];
}

-(void)weiboAuthSuccess:(NSNotification*)notification{
    NSDictionary* weiboAuthInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"weiboAuthInfo"];
    _access_token = [weiboAuthInfo objectForKey:@"access_token"];
}

- (IBAction)postWeibo:(UIButton *)sender {
    if (!_access_token) {
        NSLog(@"还未授权");
        return;
    }
    
    NSString* url = @"https://upload.api.weibo.com/2/statuses/upload.json";
    NSString* content = @"哈哈哈";
    
    NSString* filepath = [[NSBundle mainBundle]pathForResource:@"卡车" ofType:@"png"];
    
    NSDictionary* param = @{@"access_token":_access_token,@"status":content,@"source":@"2582981980"};
    
    [[TFFileUploadManager shareInstance] uploadFileWithURL:url params:param fileKey:@"pic" filePath:filepath completeHander:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            NSLog(@"请求出错 %@",connectionError);
        }else{
            NSLog(@"请求返回：\n%@",response);
        }
    }];
}

- (IBAction)AuthWeibo:(UIBarButtonItem *)sender {
    WeiboAuthViewController *weiboAuthVC = [[WeiboAuthViewController alloc]init];
    [self.navigationController pushViewController:weiboAuthVC animated:YES];
}

@end
