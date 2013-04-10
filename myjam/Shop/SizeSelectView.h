//
//  RateView.h
//  jambu
//
//  Created by Azad Johari on 2/18/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class SizeSelectView;

@protocol SizeSelectViewDelegate
-(void)sizeview:(SizeSelectView *)sizeView sizeDidChange:(int)size;
-(void)clearSelectedSize;
@end

@interface SizeSelectView : UIView


@property (assign, nonatomic) int size;
@property (assign) BOOL editable;
@property (strong) NSMutableArray *imageViews;
@property (assign, nonatomic) int sizeChoicesNum;
@property (strong, nonatomic) NSMutableArray *sizeChoices;
@property (retain, nonatomic) NSMutableArray *colorsForSize;
@property (strong, nonatomic) NSMutableArray *colorsSize;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id<SizeSelectViewDelegate> delegate;

@end
