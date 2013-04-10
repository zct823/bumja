//
//  SimpleAnnotation.h
//  HelloThis
//
//  Created by nazri on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"


@interface SimpleAnnotation : NSObject <MKAnnotation>
{
    NSString *title;
    CLLocationCoordinate2D coordinate;
    NSString *pid;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *pid;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c2d;

@end
