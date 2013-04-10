//
//  NSString+StripeHTML.m
//  myjam
//
//  Created by Azad Johari on 2/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "NSString+StripeHTML.h"

@implementation NSString (StripeHTML)
-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [[self copy] autorelease];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
@end
