//
//  TFFileUploadManager.h
//  UploadFileTest
//
//  Created by shiwei on 16/2/21.
//  Copyright © 2016年 shiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFFileUploadManager : NSObject<NSURLConnectionDataDelegate>

+(instancetype)shareInstance;

-(void)uploadFileWithURL:(NSString*)urlString params:(NSDictionary*)params fileKey:(NSString*)fileKey filePath:(NSString*)filePath completeHander:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError))completeHander;

@end
