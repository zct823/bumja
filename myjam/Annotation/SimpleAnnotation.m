//
//  SimpleAnnotation.m
//  HelloThis
//
//  Created by nazri on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleAnnotation.h"

@implementation SimpleAnnotation

@synthesize title, coordinate, pid;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c2d {
	[super init];
	coordinate = c2d;
	return self;
}

- (void)dealloc {
	[title release];
    [pid release];
	[super dealloc];
}

@end
