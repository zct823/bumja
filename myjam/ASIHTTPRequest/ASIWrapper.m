//
//  ASIWrapper.m
//  myjam
//
//  Created by nazri on 12/31/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "ASIWrapper.h"

@implementation ASIWrapper

+ (NSString *)requestPostJSONWithStringURL:(NSString *)url andDataContent:(NSString *)dataContent
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[dataContent dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:4];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response;
    if (!error) {
        response = [request responseString];
//        //NSLog(@"response: %@",response);
        return response;
    }else{
//        NSError *error = [request error];
        NSString *error = [NSString stringWithFormat:@"%@",[request error]];
        //NSLog(@"error: %@",error);
        
        if (!([error rangeOfString:@"timed out"].location == NSNotFound)) {
            return [NSString stringWithFormat:@"{\"status\":\"error\",\"message\":\"Request timed out.\"}"];
        }else if (!([error rangeOfString:@"connection failure"].location == NSNotFound)) {
            return [NSString stringWithFormat:@"{\"status\":\"error\",\"message\":\"Connection failure occured.\"}"];
        }
        return [NSString stringWithFormat:@"{\"status\":\"error\"}"];
    }
    
    [request release];
}

@end
