//
//  FDRequests.m
//  Networking
//
//  Created by shiwei on 15/10/5.
//  Copyright © 2015年 shiwei. All rights reserved.
//


#import "FDRequests.h"
#import "PostDataConstructer.h"
#import "NSString+URLEncode.h"

@interface FDRequests ()<NSURLConnectionDataDelegate>

@property (nonatomic, copy) NSString* method;

@property (nonatomic, strong) NSMutableURLRequest* request;
@property (nonatomic, strong) NSURLConnection* connection;

@property (nonatomic, copy) FDRequestsCallBack callback;

@property (nonatomic, strong) FDResponse* response;

@end

static BOOL _userSession = NO;
@implementation FDRequests

+(void)useSession:(BOOL)use{
    _userSession = use;
}

+(void)getWithUrl:(NSString *)url params:(NSDictionary *)params callback:(FDRequestsCallBack)callback{
    NSDictionary* requestInfo = @{
                                  @"url":url,
                                  @"params":params,
                                  @"method":@"GET"
                                  };
    [self requestWithInfo:requestInfo callback:callback];
}

+(void)requestWithInfo:(NSDictionary *)info callback:(FDRequestsCallBack)callback{
    FDRequests* newRequest = [[FDRequests alloc]initWithRequestInfo:info];
    newRequest.callback = callback;
    [newRequest start];
}

-(instancetype)initWithRequestInfo:(NSDictionary*)RequestInfo{
    if (self = [super init]) {
        
        self.method = [RequestInfo valueForKey:@"method"]?:@"GET";
        
        NSString* urlString = [RequestInfo valueForKey:@"url"];
        NSURL* URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequestCachePolicy cachePolicy = [[RequestInfo valueForKey:@"cachePolicy"] integerValue];
        NSTimeInterval timeoutInterval = [[RequestInfo valueForKey:@"timeout"] integerValue];
        
        self.request = [NSMutableURLRequest requestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
        self.request.HTTPMethod = self.method;
        NSDictionary* headers =[RequestInfo valueForKey:@"headers"];
        if (headers) {
            self.request.allHTTPHeaderFields = headers;

        }
        
        NSDictionary* params = [RequestInfo valueForKey:@"params"];
        
        
        if ([self.method isEqualToString:@"GET"]) {
            NSMutableString* query = [NSMutableString string];
            for (NSString* key in params) {
                
                NSString* value = [NSString stringWithFormat:@"%@",[params valueForKey:key]];
                [query appendFormat:@"%@=%@",key,[value urlEncode]];
                if (key != params.allKeys.lastObject) {
                    [query appendString:@"&"];
                }
            }
            urlString = [urlString stringByAppendingFormat:@"?%@",query];
            self.request.URL = [NSURL URLWithString:urlString];
            
        }else if ([self.method isEqualToString:@"POST"]){
            
            NSString* contentType = [headers objectForKey:@"Content-Type"];
            NSData* body = [PostDataConstructer formDataWithParams:params contentType:contentType];

            self.request.HTTPBody = body;
        }
        
    }
    
    return self;
}

-(void)start{
    self.response = [[FDResponse alloc]init];
    
    if (_userSession) {
        
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* newTask = [session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                
                [self finishWithSuccess:NO error:error];
                return;
            }
            self.response.data = (NSMutableData*)data;
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                self.response.headers = ((NSHTTPURLResponse*)response).allHeaderFields;
                self.response.dataLength = response.expectedContentLength;
            }
            [self finishWithSuccess:YES error:nil];
        }];
        
        [newTask resume];
        
    }else{
        self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
        [self.connection start];
    }
    
}

-(void)finishWithSuccess:(BOOL)success error:(NSError*)error{
    if (!success) {
        self.response.error = error;
    }
#if DEBUG
    //NSLog(@"%@",self.response.text);
#endif
    self.callback(self.response);
}

+(FDResponse *)syncRequestWithUrl:(NSString *)rul params:(NSDictionary *)params{
    if (params == nil) {
        params = @{};
    }
    NSDictionary* requestInfo = @{
                                  @"url":rul,
                                  @"params":params,
                                  @"method":@"GET"
                                  };
    return [self syncRequestWithInfo:requestInfo];
}

+(FDResponse *)syncRequestWithInfo:(NSDictionary *)info{
    FDRequests* newRequest = [[FDRequests alloc]initWithRequestInfo:info];
    
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:newRequest.request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"sync request error:%@",error);
        return nil;
    }
    FDResponse* myResponse = [[FDResponse alloc]init];
    myResponse.data = (NSMutableData*)data;
    myResponse.URL = newRequest.request.URL;
    return myResponse;
}

#pragma mark - connection data delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        self.response.headers = ((NSHTTPURLResponse*)response).allHeaderFields;
        self.response.dataLength = response.expectedContentLength;
        self.response.statusCode = ((NSHTTPURLResponse*)response).statusCode;
    }
    self.response.URL = response.URL;
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.response.data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
}

- (nullable NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self finishWithSuccess:YES error:nil];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self finishWithSuccess:NO error:error];
}

#pragma mark - upload

+(void)uploadFileWithInfo:(NSDictionary *)info filePath:(NSString *)filePath callback:(FDRequestsCallBack)callback{
    
    FDRequests* request = [[FDRequests alloc]initWithRequestInfo:info];
    request.callback = callback;
    [request start];
    
}

@end
