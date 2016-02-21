//
//  FDResponse.m
//  Networking
//
//  Created by shiwei on 15/10/5.
//  Copyright © 2015年 shiwei. All rights reserved.
//

#import "FDResponse.h"

@interface FDResponse ()

@end

@implementation FDResponse

-(instancetype)init{
    
    if (self = [super init]) {
        self.data = [[NSMutableData alloc]init];
    }
    
    return self;
}

-(void)setError:(NSError *)error{
    _error = error;
    
    if (_error) {
        self.data = nil;
        self.headers = nil;
        self.dataLength = 0;
    }
}

-(NSDictionary *)json{
    NSError* error = nil;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:self.data options:(NSJSONReadingAllowFragments) error:&error];
    if (error) {
        NSLog(@"json transform error: %@",error);
        return nil;
    }
    return jsonDic;
}

-(NSString *)text{
    return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

@end
