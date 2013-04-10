//
//  NSObject+JSONCategories.m
//  myjam
//
//  Created by Azad Johari on 2/8/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "NSDictionary+JSONCategories.h"

@implementation NSDictionary (JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress{
    NSURL *serviceURL = [NSURL URLWithString:urlAddress];
    ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:serviceURL];
    __autoreleasing NSError *error= nil;
    [httpRequest startSynchronous];
    NSData *data = [httpRequest responseData];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    //NSLog(@"%@",result);
    NSDictionary *results = [[result objectFromJSONString] mutableCopy];
    [result release];
    if (error != nil) return nil;
  
    return results;
}
-(NSData*)toJSON{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end
