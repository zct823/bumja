//
//  NSObject+JSONCategories.h
//  myjam
//
//  Created by Azad Johari on 2/8/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlString;
-(NSData*)toJSON;

@end
