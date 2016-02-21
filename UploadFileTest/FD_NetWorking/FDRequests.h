//
//  FDRequests.h
//  Networking
//
//  Created by shiwei on 15/10/5.
//  Copyright © 2015年 shiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDResponse.h"

typedef void(^FDRequestsCallBack)(FDResponse* response);

@interface FDRequests : NSObject

+(void)useSession:(BOOL)use;

+(void)getWithUrl:(NSString*)url params:(NSDictionary*)params callback:(FDRequestsCallBack)callback;

//info's key contain method,url,cachePolicy,params,headers,cookies,files
+(void)requestWithInfo:(NSDictionary*)info callback:(FDRequestsCallBack)callback;

@end
