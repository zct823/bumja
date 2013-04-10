//
//  MEvent.h
//  myjam
//
//  Created by Mohd Hafiz on 1/25/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEvent : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *location;

@end
