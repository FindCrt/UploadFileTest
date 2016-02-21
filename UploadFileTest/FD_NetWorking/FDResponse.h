//
//  FDResponse.h
//  Networking
//
//  Created by shiwei on 15/10/5.
//  Copyright © 2015年 shiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDResponse : NSObject

@property (nonatomic, copy) NSURL* URL;

@property (nonatomic, strong) NSMutableData* data;

@property (nonatomic, assign) NSInteger statusCode;

@property (nonatomic, strong) NSDictionary* headers;

@property (nonatomic, assign) NSInteger dataLength;

@property (nonatomic, strong) NSError* error;

-(NSDictionary*)json;
-(NSString*)text;


@end
