//
//  RateView.m
//  jambu
//
//  Created by Azad Johari on 2/18/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "RateView.h"

@implementation RateView
@synthesize nonSelectedImage = _nonSelectedImage;
@synthesize selectedImage = _selectedImage;
@synthesize rating = _rating;
@synthesize editable = _editable;
@synthesize imageViews = _imageViews;
@synthesize maxRating = _maxRating;
@synthesize midMargin = _midMargin;
@synthesize leftMargin = _leftMargin;
@synthesize minImageSize = _minImageSize;
@synthesize delegate = _delegate;

-(void)baseInit{
    _nonSelectedImage= nil;
    _selectedImage = nil;
    _rating = 0;
    _editable = NO;
    _imageViews = [[NSMutableArray alloc] init];
    _maxRating = 5;
    _midMargin = 2;
    _leftMargin = 0;
    _minImageSize = CGSizeMake(7, 7);
    _delegate = nil;
    self.backgroundColor = [UIColor clearColor];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
        // Initialization code
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self baseInit];
    }
    return self;
}
-(void)refresh{
    UIImageView *imageView = nil;
    for (int i=0; i < self.imageViews.count; ++i){
        if (self.editable){
            imageView = [self.imageViews objectAtIndex:i];
        }
        else{
           imageView = [self.imageViews objectAtIndex:self.imageViews.count-i-1];
        }
        if (self.rating >= i+1){
            imageView.image = self.selectedImage;
        }
        else{
            imageView.image = self.nonSelectedImage;
        }
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.nonSelectedImage == nil) return;
    
    float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2)- (self.midMargin*self.imageViews.count))/self.imageViews.count;
    float imageWidth = MAX(self.minImageSize.width, desiredImageWidth);
    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    
    for (int i = 0 ; i < self.imageViews.count ; ++i){
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i*(self.midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
        
    }
}
-(void) setMaxRating:(int)maxRating{
    _maxRating = maxRating;
    // Remove old image views
    
    for(int i = 0; i < self.imageViews.count; ++i) {
        UIImageView *imageView = (UIImageView *) [self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    // Add new image views
    for(int i = 0; i < maxRating; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];}

-(void)setNonSelectedImage:(UIImage *)image{
    _nonSelectedImage = image;
    [self refresh];
}
-(void)setSelectedImage:(UIImage *)image{
    _selectedImage = image;
    [self refresh];
}
-(void)setRating:(int)rating{
    _rating = rating;
    [self refresh];
}
-(void) handleTouchAtLocation:(CGPoint)touchLocation{
    if (!self.editable) return;
    int newRating = 0;
    for (int i = self.imageViews.count - 1; i >= 0; i--) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        if (touchLocation.x > imageView.frame.origin.x){
            newRating = i +1;
            break;
        }
        
    }
    self.rating = newRating;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate rateView:self ratingDidChange:self.rating];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
