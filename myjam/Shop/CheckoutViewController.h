//
//  CheckoutViewController.h
//  myjam
//
//  Created by Azad Johari on 2/2/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartItemViewCell.h"
#import "AppDelegate.h"
//#import "DeliveryOptionViewController.h"
#import "CoreViewController.h"
#import "CartItemViewCell.h"
#import "MJModel.h"
#import "AddressEditViewController.h"
#import "ConfirmFooterView.h"
#import "UIColor+HexString.h"
#import "ShopViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface CheckoutViewController : CoreViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *shopName;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cartList;
@property (strong, nonatomic) NSString* footerType;
@property (retain, nonatomic) IBOutlet UIImageView *shopLogo;
@property (retain, nonatomic) ConfirmFooterView *footerView;
@property (retain, nonatomic) NSString *paymentStatus;


-(void)deliveryOptions:(id)sender;
@end
