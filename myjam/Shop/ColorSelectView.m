//
//  RateView.m
//  jambu
//
//  Created by Azad Johari on 2/18/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ColorSelectView.h"

@implementation ColorSelectView

@synthesize colorChoicesNum = _colorChoicesNum;
@synthesize editable = _editable;
@synthesize imageViews = _imageViews;
@synthesize colorChoices = _colorChoices;
@synthesize color = _color;
@synthesize midMargin = _midMargin;
@synthesize leftMargin = _leftMargin;
@synthesize minImageSize = _minImageSize;
@synthesize delegate = _delegate;
@synthesize sizesForColor = _sizesForColor;
-(void)baseInit{
    
    _color = 0;
    _editable = NO;
    _imageViews = [[NSMutableArray alloc] init];
    _colorChoices = [[NSMutableArray alloc] init];
    _colorChoicesNum = 5;
    _midMargin = 8;
    _leftMargin = 0;
    _minImageSize = CGSizeMake(5, 5);
    _sizesForColor = [[NSMutableArray alloc] init];
    _delegate = nil;
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
    if ([[self sizesForColor] count] >1){
        for (int i=0; i < self.imageViews.count; i++){
            UIImageView *imageView = [self.imageViews objectAtIndex:i];
            
            if ([[[self.sizesForColor objectAtIndex:i] valueForKey:@"stock_balance"] isEqual:[NSNumber numberWithInt:0]]){
                 
                imageView.backgroundColor = [UIColor colorWithHex:[[[self.colorChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"color_code"]] ;
                [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
                [imageView.layer setBorderWidth: 1.0];
                if ([self.colorChoices count]>1){
                imageView.image = [UIImage imageNamed:@"cross.png"];
                }
                if (self.color == i){
                    [self.delegate clearSelectedColor];
                }

            }else
            {
                imageView.backgroundColor = [UIColor colorWithHex:[[[self.colorChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"color_code"]] ;
                if (self.color == i){
                   [imageView.layer setBorderColor: [[UIColor redColor] CGColor]];
                    [imageView.layer setBorderWidth: 2.0];
                }
                else{
                    [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
                    [imageView.layer setBorderWidth: 1.0];
                }
               
                
            }
            
        }
    }
    else{
        
    
    for (int i=0; i < self.imageViews.count; i++){
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        
        if (self.color == i){
             if ([self.colorChoices count]>1){
            if (![[[[self.colorChoices objectAtIndex:1]objectAtIndex:i] valueForKey:@"stock_balance"]isEqual:[NSNumber numberWithInt:0]]){
                
            imageView.backgroundColor = [UIColor colorWithHex:[[[self.colorChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"color_code"]] ;
            [imageView.layer setBorderColor: [[UIColor redColor] CGColor]];
            [imageView.layer setBorderWidth: 2.0];
            }
            }
            else{
                
                imageView.backgroundColor = [UIColor colorWithHex:[[[self.colorChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"color_code"]] ;
                [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
                [imageView.layer setBorderWidth: 1.0];
                    if ([self.colorChoices count]>1){ 
                imageView.image = [UIImage imageNamed:@"cross.png"];
                    }
            }
        }
        else{
            imageView.backgroundColor = [UIColor colorWithHex:[[[self.colorChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"color_code"]] ;
            [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [imageView.layer setBorderWidth: 1.0];
            if ([self.colorChoices count]>1){
            if ([[[[self.colorChoices objectAtIndex:1] objectAtIndex:i] valueForKey:@"stock_balance"] isEqual:[NSNumber numberWithInt:0] ]){
                imageView.image = [UIImage imageNamed:@"cross.png"];
                //NSLog(@"Out of stock");
            }
        }}
        
    }
}
}
-(void)setColorChoices:(NSMutableArray *)colorChoices{
    for (int i=0; i < colorChoices.count; i++){
        [self.colorChoices insertObject:[colorChoices objectAtIndex:i] atIndex:i];
    }
    [self refresh];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //  if (self.nonSelectedImage == nil) return;
    
    //  float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2)- (self.midMargin*self.imageViews.count))/self.imageViews.count;
    float imageWidth = MAX(self.minImageSize.width, self.frame.size.height);
    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    
    for (int i = 0 ; i < self.imageViews.count ; i++){
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i*(self.midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
        
    }
}
-(void) setColorChoicesNum:(int)colorChoicesNum{
    _colorChoicesNum = colorChoicesNum;
    // Remove old image views
    
    for(int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = (UIImageView *) [self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    // Add new image views
    for(int i = 0; i < colorChoicesNum; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];
}

-(void)setColor:(int)color{
    _color = color;
    [self refresh];
}
-(void) handleTouchAtLocation:(CGPoint)touchLocation{
    if (!self.editable) return;
    int newColor = 0;
    for (int i = self.imageViews.count - 1; i >= 0; i--) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        //NSLog(@"%f",touchLocation.x);
        //NSLog(@"%f",imageView.frame.origin.x);
        if (touchLocation.x > imageView.frame.origin.x){
            newColor = i ;
            break;
        }
        
    }
    self.color = newColor;
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
    [self.delegate colorview:self colorDidChange:self.color];
    
}

@end
