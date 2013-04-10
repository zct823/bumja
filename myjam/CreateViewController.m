//
//  CreateViewController.m
//  myjam
//
//  Created by Mohd Hafiz on 2/7/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "CreateViewController.h"
#import "AppDelegate.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Manually change the selected tabButton
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate.tabView activateController:mydelegate.pageIndex];
    for (int i = 0; i < [mydelegate.tabView.tabItemsArray count]; i++) {
        if (i == mydelegate.pageIndex) {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:YES];
        } else {
            [[mydelegate.tabView.tabItemsArray objectAtIndex:i] toggleOn:NO];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
