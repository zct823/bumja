//
//  ASIWrapper.h
//  myjam
//
//  Created by nazri on 12/31/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASIWrapper : NSObject

+ (NSString *)requestPostJSONWithStringURL:(NSString *)url andDataContent:(NSString *)dataContent;

@end
