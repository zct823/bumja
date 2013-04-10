//
//  FeedbackViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 1/24/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "FeedbackViewController.h"
#import "ShowFeedbackViewController.h"
#import "ASIWrapper.h"
#import "CustomAlertView.h"

#define kFrameHeightOnKeyboardUp 469.0f

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.navigationItem.title = @"Feedback";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = @"Feedback";
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
        self.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
        
        // Init scrollview
        self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
        [self.scroller setContentSize:self.contentView.frame.size];
        [self.scroller addSubview:self.contentView];
        
        self.commentTextView.layer.borderWidth = 1.0f;
        self.commentTextView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.commentTextView.layer.cornerRadius = 8.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // textfield delegate
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.mobileTextField.delegate = self;
    self.commentTextView.delegate = self;
    
    self.contentView.frame = CGRectMake(0, 0.0f, self.contentView.frame.size.width, kFrameHeightOnKeyboardUp+44);
    
    [self.saveButton addTarget:self action:@selector(saveFeedback) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"vwd");
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:NO];
    for (UITextField *aView in [self.contentView subviews]) {
        if ([aView isKindOfClass:[UITextField class]]) {
            aView.text = nil;
        }
    }
    self.commentTextView.text = nil;
}

#pragma mark -
#pragma mark saveFeedback

- (void)saveFeedback
{
    [self.view endEditing:YES];
    
    if ([self.nameTextField.text length] == 0) {
        reqFieldName = @"Name";
        [self triggerRequiredAlert];
    }
    else if ([self.emailTextField.text length] == 0)
    {
        reqFieldName = @"Email";
        [self triggerRequiredAlert];
    }
    else if ([self.mobileTextField.text length] == 0)
    {
        reqFieldName = @"Phone Number";
        [self triggerRequiredAlert];
    }
    else if ([self.commentTextView.text length] == 0)
    {
        reqFieldName = @"Comment";
        [self triggerRequiredAlert];
    }
    else {
        //saved feedback
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
        //NSLog(@"saved");
        [self performSelector:@selector(processSavedFeedback) withObject:nil afterDelay:0.2];
    }
}

- (void)triggerRequiredAlert
{
    NSString *reqMsg = [NSString stringWithFormat:@"%@ is required.",reqFieldName];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Feedback" message:reqMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)processSavedFeedback
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/jambu_feedback.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"name\":\"%@\",\"email\":\"%@\",\"phone_number\":\"%@\",\"comment\":\"%@\"}",
                             self.nameTextField.text,
                             self.emailTextField.text,
                             self.mobileTextField.text,
                             self.commentTextView.text];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if (![status isEqualToString:@"ok"])
        {
            //NSLog(@"Submit feedback error!");
            if ([[resultsDictionary objectForKey:@"message"] isEqualToString:@"Request timed out"]) {
                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"JAM-BU Feedback" message:@"Request timed out. Please retry again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
        else {
            //NSLog(@"Success submit feedback");
            ShowFeedbackViewController *fvc = [[ShowFeedbackViewController alloc] init];
            [self.navigationController pushViewController:fvc animated:YES];
            [fvc release];
        }
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

#pragma mark -
#pragma mark textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    self.commentTextView.contentInset = UIEdgeInsetsZero;
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

#pragma mark -
#pragma mark textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeightOnKeyboardUp)];
    [self.scroller adjustOffsetToIdealIfNeeded];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeightOnKeyboardUp+44)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
