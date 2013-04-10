//
//  ProductTableViewCellwoCat.h
//  myjam
//
//  Created by Azad Johari on 2/12/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomHeader.h"
#import "RateView.h"
@interface ProductTableViewCellwoCat : UITableViewCell
@property (retain, nonatomic) IBOutlet UIButton *button1;
@property (retain, nonatomic) IBOutlet UIButton *button2;
@property (retain, nonatomic) IBOutlet UIButton *button3;
@property (retain, nonatomic) IBOutlet UIButton *buttonTap1;
@property (retain, nonatomic) IBOutlet UIButton *buttonTap2;
@property (retain, nonatomic) IBOutlet UIButton *buttonTap3;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel1;
@property (retain, nonatomic) IBOutlet UILabel *productLabel1;
@property (retain, nonatomic) IBOutlet UILabel *catLabel1;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel2;
@property (retain, nonatomic) IBOutlet UILabel *productLabel2;
@property (retain, nonatomic) IBOutlet UILabel *catLabel2;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel3;
@property (retain, nonatomic) IBOutlet UILabel *productLabel3;
@property (retain, nonatomic) IBOutlet UILabel *catLabel3;
@property (retain, nonatomic) IBOutlet RateView *rateView1;
@property (retain, nonatomic) IBOutlet RateView *rateView2;
@property (retain, nonatomic) IBOutlet RateView *rateView3;
@property (retain, nonatomic) IBOutlet UILabel *catNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *viewAllButton;
@property (retain, nonatomic) IBOutlet UIImageView *middleLine;
@property (retain, nonatomic) IBOutlet UIView *transView2;
@property (retain, nonatomic) IBOutlet UIView *transView3;
@property (retain, nonatomic) IBOutlet UIView *transView1;

@end
