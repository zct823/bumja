//
//  ShowSocialViewController.h
//  myjam
//
//  Created by nazri on 1/22/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowSocialViewController : UIViewController

@property (retain,nonatomic) IBOutlet UIButton *fbButton;
@property (retain,nonatomic) IBOutlet UIButton *twButton;
@property (retain,nonatomic) IBOutlet UIButton *utubeButton;
@property (retain,nonatomic) IBOutlet UIButton *fsquareButton;

- (IBAction)createSocial:(id)sender;

@end
