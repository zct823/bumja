//
//  ConnectionClass.m
//  myjam
//
//  Created by Mohd Hafiz on 1/31/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ConnectionClass.h"
#import "Reachability.h"

@implementation ConnectionClass

-(id)init
{
    return [super init];
}

+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

@end
