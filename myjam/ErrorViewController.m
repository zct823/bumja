//
//  ErrorViewController.m
//  myjam
//
//  Created by Mohd Hafiz on 1/31/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ErrorViewController.h"

@interface ErrorViewController ()

@end

@implementation ErrorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
    switch (self.errorOption) {
        case kERROR_NO_INTERNET_CONNECTION:
            [imageView setImage:[UIImage imageNamed:@"no_connection_error"]];
            break;
        case kERROR_CONTENT_REMOVED:
            if (screenBounds.size.height != 568) {
                imageView.frame = CGRectMake(0, -56, self.view.frame.size.width, self.view.frame.size.height);
            }
            [imageView setImage:[UIImage imageNamed:@"error_content_not_exist"]];
            break;
        case kERROR_NOT_SAVED:
            if (screenBounds.size.height != 568) {
                imageView.frame = CGRectMake(0, -52, self.view.frame.size.width, self.view.frame.size.height);
            }
            [imageView setImage:[UIImage imageNamed:@"not_save_landing"]];
            break;
        case kERROR_QR_NOT_COMPATIBLE:
            if (screenBounds.size.height != 568) {
                imageView.frame = CGRectMake(0, -56, self.view.frame.size.width, self.view.frame.size.height);
            }
            [imageView setImage:[UIImage imageNamed:@"error_scanning"]];
            break;
        default:
            break;
    }

    
    [self.view addSubview:imageView];
    [imageView release];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
