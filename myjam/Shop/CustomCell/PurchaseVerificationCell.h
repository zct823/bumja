//
//  PurchaseVerificationCell.h
//  myjam
//
//  Created by Azad Johari on 2/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseVerificationCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *orderLabel;
@property (retain, nonatomic) IBOutlet UILabel *modelLabel;
@property (retain, nonatomic) IBOutlet UILabel *qtyLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@end
