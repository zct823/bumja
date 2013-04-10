//
//  RateView.m
//  jambu
//
//  Created by Azad Johari on 2/18/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "SizeSelectView.h"

@implementation SizeSelectView

@synthesize sizeChoicesNum = _sizeChoicesNum;
@synthesize editable = _editable;
@synthesize imageViews = _imageViews;
@synthesize sizeChoices = _sizeChoices;
@synthesize size = _size;
@synthesize midMargin = _midMargin;
@synthesize leftMargin = _leftMargin;
@synthesize minImageSize = _minImageSize;
@synthesize delegate = _delegate;
@synthesize colorsForSize= _colorsForSize;
@synthesize colorsSize = _colorsSize;

-(void)baseInit{

    _size = 0;
    _editable = NO;
    _imageViews = [[NSMutableArray alloc] init];
    _sizeChoices = [[NSMutableArray alloc] init];
    _sizeChoicesNum = 5;
    _midMargin = 5;
    _leftMargin = 5;
    _minImageSize = CGSizeMake(5, 5);
    _delegate = nil;
    _colorsForSize = [[NSMutableArray alloc] init];
    _colorsSize = [[NSMutableArray alloc] init];
    
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
    if ([[self colorsForSize] count] >1){
        for (int i=0; i < self.imageViews.count; i++){
            
            UILabel *imageView = [self.imageViews objectAtIndex:i];
            imageView.backgroundColor = [UIColor whiteColor];
            if ([[[self.colorsForSize objectAtIndex:i] valueForKey:@"stock_balance"] isEqual:[NSNumber numberWithInt:0]]){
                imageView.text = [NSString stringWithFormat:@" %@",[[[self.sizeChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"size_name"]];
             if ([self.sizeChoices count]>1){
                [imageView.layer setBackgroundColor:[[UIColor blackColor] CGColor]];
                [imageView.layer setOpacity:0.7];
                if (self.size == i){
                     [self.delegate clearSelectedSize];
                }
             }
            }else
            {  imageView.text = [NSString stringWithFormat:@" %@",[[[self.sizeChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"size_name"]];
                
                if (self.size == i){
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
        UILabel *imageView = [self.imageViews objectAtIndex:i];
        imageView.backgroundColor = [UIColor whiteColor];
                
                if (self.size == i){
 if ([self.sizeChoices count]>1){
        if (![[[[self.sizeChoices objectAtIndex:1]objectAtIndex:i] valueForKey:@"stock_balance"]isEqual:[NSNumber numberWithInt:0]])
        {
            imageView.text = [NSString stringWithFormat:@" %@",[[[self.sizeChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"size_name"]];
            [imageView.layer setBorderColor: [[UIColor redColor] CGColor]];
            [imageView.layer setBorderWidth: 2.0];
        }
 }
        else{
        imageView.text = [NSString stringWithFormat:@" %@",[[[self.sizeChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"size_name"]];
            [imageView.layer setBorderColor: [[UIColor redColor] CGColor]];
            [imageView.layer setBorderWidth: 2.0];
            if ([self.sizeChoices count]>1){
                [imageView.layer setBackgroundColor:[[UIColor blackColor] CGColor]];
                [imageView.layer setOpacity:0.7];
            }
            }
                }
        else{
            imageView.text = [NSString stringWithFormat:@" %@",[[[self.sizeChoices objectAtIndex:0]objectAtIndex:i] valueForKey:@"size_name"]];
            

            [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
            [imageView.layer setBorderWidth: 1.0];
              if ([self.sizeChoices count]>1){
            if ([[[[self.sizeChoices objectAtIndex:1] objectAtIndex:i] valueForKey:@"stock_balance"] isEqual:[NSNumber numberWithInt:0] ]){
                if ([self.sizeChoices count]>1){
                [imageView.layer setBackgroundColor:[[UIColor blackColor] CGColor]];
                [imageView.layer setOpacity:0.7];
                }
            }
            }
             
            }
        }
   
    }
        
}

-(void)setSizeChoices:(NSMutableArray *)sizeChoices{
    for (int i=0; i < sizeChoices.count; i++){
        [self.sizeChoices insertObject:[sizeChoices objectAtIndex:i] atIndex:i];
    }
    [self refresh];
}
-(void)layoutSubviews{
    [super layoutSubviews];
  //  if (self.nonSelectedImage == nil) return;
    
  //  float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2)- (self.midMargin*self.imageViews.count))/self.imageViews.count;
    //CGSize tempWidth = CGSizeMake(0,0);
    
    float imageWidth = MAX(self.minImageSize.width, self.frame.size.width);
    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    CGFloat x = 0;
    CGSize expectedLabelSize = CGSizeMake(0,0);
    for (int i = 0 ; i < self.imageViews.count ; i++){
        if (i != 0) {
            x += self.leftMargin + expectedLabelSize.width;
        }
        UILabel *imageView = [self.imageViews objectAtIndex:i];
        
        [imageView setText:[[[self.sizeChoices objectAtIndex:0] objectAtIndex:i] valueForKey:@"size_name"]];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        [imageView setFont:[UIFont fontWithName:@"Verdana" size:24.0] ];
        [imageView setNumberOfLines:1];
        [imageView sizeToFit];
        [imageView setTextAlignment:NSTextAlignmentCenter];
        imageWidth = MAX(40, imageView.frame.size.width);
        expectedLabelSize.width = imageWidth;
        imageView.frame = CGRectMake(x, 0, imageWidth, imageHeight);
        
//        expectedLabelSize = [[NSString stringWithFormat:@"%@",[[[self.sizeChoices objectAtIndex:0] objectAtIndex:i] valueForKey:@"size_name"]]  sizeWithFont:[UIFont fontWithName:@"Verdana" size:24.0] constrainedToSize:CGSizeMake(imageWidth, imageHeight) lineBreakMode:UILineBreakModeWordWrap];
        //CGRect imageFrame = CGRectMake(tempWidth.width, 0, 30, imageHeight);
//        tempWidth.width = tempWidth.width + self.leftMargin + self.midMargin + expectedLabelSize.width;
//        //NSLog(@"size :%f %f",expectedLabelSize.width, x);
    }
}
-(void) setSizeChoicesNum:(int)sizeChoicesNum{
    _sizeChoicesNum = sizeChoicesNum;
    // Remove old image views
    
    for(int i = 0; i < self.imageViews.count; i++) {
        UILabel *imageView = (UILabel *) [self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    // Add new image views
    for(int i = 0; i < sizeChoicesNum; i++) {
        UILabel *imageView = [[UILabel alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];
}

-(void)setSize:(int)size{
    _size = size;
    [self refresh];
}
-(void) handleTouchAtLocation:(CGPoint)touchLocation{
    if (!self.editable) return;
    int newSize = 0;
    for (int i = self.imageViews.count - 1; i >= 0; i--) {
        UIView *imageView = [self.imageViews objectAtIndex:i];
        if (touchLocation.x > imageView.frame.origin.x){
            newSize = i ;
            break;
        }
        
    }
    self.size = newSize;
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
    [self.delegate sizeview:self sizeDidChange:self.size];
}

@end
