//
//  UIColor+ExtraMethod.h
//  myjam
//
//  Created by nazri on 11/26/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (ExtraMethod)

// Creates color using hex representation
// hex - must be in format: #FF00CC
// alpha - must be in range 0.0 - 1.0
+ (UIColor*)colorWithHex:(NSString*)hexString;

@end
