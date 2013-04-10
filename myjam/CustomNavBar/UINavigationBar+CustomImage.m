//
//  UINavigationBar+CustomImage.m
//  TestApp
//
//  Created by nazri on 10/22/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "UINavigationBar+CustomImage.h"
#import "UIColor+ExtraMethod.h"


@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect
{
//    UIFont* afont = [UIFont fontWithName:@"Harrowprint" size:20];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"Harrowprint" size:20];
//    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    label.textAlignment = UITextAlignmentCenter;
//    label.textColor =[UIColor whiteColor];
//    label.text=self.title;
//    self.navigationItem.titleView = label;
//    [label release];
    
//    [self setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"customfont.otf" size:15]}];
    
    
    // Change the tint color in order to change color of buttons
    UIColor *color = [UIColor colorWithHex:@"#D22042"];
    self.tintColor = color;
    
    UIImage *image = [UIImage imageNamed:@"header_bg"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    [self applyDefaultStyle];
}

- (void)applyDefaultStyle {
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0,3);
    self.layer.shadowOpacity = 0.4f;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
}


@end
