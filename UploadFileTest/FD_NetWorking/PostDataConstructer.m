//
//  PostDataConstructer.m
//  coreDataExample_sinaWeibo
//
//  Created by shiwei on 15/10/17.
//  Copyright © 2015年 shiwei. All rights reserved.
//

#import "PostDataConstructer.h"
#import "NSString+URLEncode.h"

@implementation PostDataConstructer

+(NSData*)formDataWithParams:(NSDictionary*)params contentType:(NSString *)contentType{
    
    NSMutableData* postData = [NSMutableData data];
    
    if ([contentType hasPrefix:@"multipart/form-data"]) {
        
        NSRange range = [contentType rangeOfString:@"="];
        NSAssert(range.location != NSNotFound, @"Content-Type缺少doundary");
        
        NSString* boundary = [contentType substringFromIndex:range.location+1];
        NSData* boundaryData = [[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding];
        
       
        [postData appendData:boundaryData];
        
        NSArray* allKeys = params.allKeys;
        for (NSString* key in params.allKeys) {
            [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            
            id value = [params objectForKey:key];
            if ([value isKindOfClass:[NSData class]]) {
                [postData appendData:value];
            }else{
                [postData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            if (key == allKeys.lastObject) {
                [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }else{
                [postData appendData:boundaryData];
            }
            
        }
    }else{
        
        NSMutableString* postString = [NSMutableString string];
        for (NSString* key in params) {
            
            NSString* value = [NSString stringWithFormat:@"%@",[params valueForKey:key]];
            [postString appendFormat:@"%@=%@",key,[value urlEncode]];
            if (key != params.allKeys.lastObject) {
                [postString appendString:@"&"];
            }
        }
        postData = (NSMutableData*)[postString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    return postData;
}

@end
