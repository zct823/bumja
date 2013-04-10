//
//  RateView.h
//  jambu
//
//  Created by Azad Johari on 2/18/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RateView;

@protocol RateViewDelegate
-(void)rateView:(RateView *)rateView ratingDidChange:(int)rating;
@end

@interface RateView : UIView

@property (strong, nonatomic) UIImage *nonSelectedImage;
@property (strong, nonatomic) UIImage *selectedImage;
@property (assign, nonatomic) int rating;
@property (assign) BOOL editable;
@property (strong) NSMutableArray *imageViews;
@property (assign, nonatomic) int maxRating;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id<RateViewDelegate> delegate;

@end
