//
//  ProductHeaderView.m
//  myjam
//
//  Created by Azad Johari on 2/20/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ProductHeaderView.h"

@implementation ProductHeaderView
@synthesize imageCarouselView=_imageCarouselView;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize shopName = _shopName;
@synthesize productCat = _productCat;
@synthesize productPrice = _productPrice;
@synthesize productName = _productName;
@synthesize productState = _productState;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {    
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
   
    [_buyButton1 release];
    [_productState release];
    [_rateView release];
    [_productPriceAfterDiscount release];
    [_redLine release];
    [super dealloc];
    [_imageCarouselView release];
    [_leftButton release];
    [_rightButton release];
    [_shopName release];
    [_productName release];
    [_productCat release];
    [_productPrice release];
}
@end
