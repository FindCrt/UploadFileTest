//
//  NSString+URLEncode.m
//  coreDataExample_sinaWeibo
//
//  Created by shiwei on 15/10/17.
//  Copyright © 2015年 shiwei. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)

- (NSString *)urlEncode {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (__bridge CFStringRef)self, NULL,
                                                                                 (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
}

@end
