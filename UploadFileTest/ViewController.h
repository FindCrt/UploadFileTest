//
//  ViewController.h
//  UploadFileTest
//
//  Created by shiwei on 16/2/21.
//  Copyright © 2016年 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)postWeibo:(UIButton *)sender;
- (IBAction)AuthWeibo:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

