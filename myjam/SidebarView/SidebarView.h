//
//  SidebarView.h
//  myjam
//
//  Created by nazri on 11/19/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarCartCell.h"
#import "MJModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SideBarFooterCell.h"
#import "CheckoutViewController.h"
#import "SidebarTableHeaderView.h"
@interface SidebarView : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (retain, nonatomic) IBOutlet UILabel *contactLabel;
@property (retain, nonatomic) IBOutlet UILabel *calenderLabel;
@property (retain, nonatomic) IBOutlet UILabel *mapsLabel;
@property (retain, nonatomic) IBOutlet UILabel *socialLabel;
@property (retain, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (retain, nonatomic) IBOutlet UILabel *faqLabel;
@property (retain, nonatomic) IBOutlet UILabel *aboutLabel;
@property (retain, nonatomic) IBOutlet UILabel *logoutLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *emailLabel;
@property (retain, nonatomic) IBOutlet UILabel *mobileLabel;
@property (retain, nonatomic) IBOutlet UILabel *settingsLabel;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *cartItems;

- (void) reloadImage;
- (void)pushProfileViewController;

@end
