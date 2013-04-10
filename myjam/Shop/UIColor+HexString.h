//
//  UIColor+HexString.h
//  myjam
//
//  Created by Azad Johari on 2/20/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(HexString)

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end
