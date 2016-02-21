//
//  PostDataConstructer.h
//  coreDataExample_sinaWeibo
//
//  Created by shiwei on 15/10/17.
//  Copyright © 2015年 shiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDataConstructer : NSObject

+(NSData*)formDataWithParams:(NSDictionary*)params contentType:(NSString*)contentType;

@end
