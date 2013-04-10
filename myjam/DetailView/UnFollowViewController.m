//
//  UnFollowViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 28/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "UnFollowViewController.h"
#import "AppDelegate.h"

@interface UnFollowViewController ()

@end

@implementation UnFollowViewController

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
    // Do any additional setup after loading the view from its nib.
    
    //CGRect warningLblFrame = CGRectMake(10, 10, 260, 50);
    FontLabel *warningLabel = [[FontLabel alloc] initWithFrame:CGRectMake(30, 10, 260, 50) fontName:@"jambu-font.otf" pointSize:22];
    
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.text = @"Are you sure you";
    [self.view addSubview:warningLabel];
    
    warningLabel = [[FontLabel alloc] initWithFrame:CGRectMake(30, 35, 260, 50) fontName:@"jambu-font.otf" pointSize:22];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.text = @"wish to unfollow";
    [self.view addSubview:warningLabel];

    warningLabel = [[FontLabel alloc] initWithFrame:CGRectMake(30, 105, 260, 50) fontName:@"jambu-font.otf" pointSize:22];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.text = [NSString stringWithFormat:@"%@",self.categoryName];
    [self.view addSubview:warningLabel];

    warningLabel = [[FontLabel alloc] initWithFrame:CGRectMake(30, 165, 260, 50) fontName:@"jambu-font.otf" pointSize:22];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.text = @"And all their";
    [self.view addSubview:warningLabel];
    
    warningLabel = [[FontLabel alloc] initWithFrame:CGRectMake(30, 190, 260, 50) fontName:@"jambu-font.otf" pointSize:22];
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.textColor = [UIColor whiteColor];
    warningLabel.backgroundColor = [UIColor clearColor];
    warningLabel.text = @"categories?";
    [self.view addSubview:warningLabel];
    
}

- (IBAction)okButtonAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyUnfollowProcess" object:self];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyClose" object:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
