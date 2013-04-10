//
//  ProductHeaderView.h
//  myjam
//
//  Created by Azad Johari on 2/20/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
#import "RateView.h"

@interface ProductHeaderView : UIView

@property (retain, nonatomic) IBOutlet RateView *rateView;
@property (retain, nonatomic) NSString *productId;
@property (retain, nonatomic) IBOutlet UIView *imageCarouselView;
@property (retain, nonatomic) IBOutlet UIButton *leftButton;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;
@property (retain, nonatomic) IBOutlet UILabel *shopName;
@property (retain, nonatomic) IBOutlet UILabel *productName;
@property (retain, nonatomic) IBOutlet UILabel *productCat;
@property (retain, nonatomic) IBOutlet UILabel *productPrice;
@property (retain, nonatomic) IBOutlet UIButton *buyButton1;
@property (retain, nonatomic) IBOutlet UIImageView *productState;
@property (retain, nonatomic) IBOutlet UILabel *productPriceAfterDiscount;
@property (retain, nonatomic) IBOutlet UIView *redLine;


@end
