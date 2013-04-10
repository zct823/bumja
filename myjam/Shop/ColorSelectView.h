//
//  RateView.h
//  jambu
//
//  Created by Azad Johari on 2/18/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexString.h"
@class ColorSelectView;

@protocol ColorSelectViewDelegate
-(void)colorview:(ColorSelectView *)colorView colorDidChange:(int)color;
-(void)clearSelectedColor;
@end

@interface ColorSelectView : UIView


@property (assign, nonatomic) int color;
@property (assign) BOOL editable;
@property (strong) NSMutableArray *imageViews;
@property (assign, nonatomic) int colorChoicesNum;
@property (assign, nonatomic) NSMutableArray *sizesForColor;
@property (strong, nonatomic) NSMutableArray *colorChoices;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id<ColorSelectViewDelegate> delegate;

@end
