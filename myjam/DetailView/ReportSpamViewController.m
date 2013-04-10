//
//  ReportSpamViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/26/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ReportSpamViewController.h"
#import "NewsViewController.h"
#import "CustomAlertView.h"
#import "FontLabel.h"

#define kFrame 460.0f

@interface ReportSpamViewController ()

@end

@implementation ReportSpamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //TITLE
        self.title = @"Report";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        [titleView release];
        
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [self setupViews];
    
    self.reportTypes = [[NSMutableDictionary alloc] init];
    // Setup pickerview
    self.pickerView = [[UIPickerView alloc] init];
    // Set pickerview delegate
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    // Set the picker's frame.
    self.pickerView.showsSelectionIndicator = YES;
    
    // Toolbar for pickerView
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    [toolbar setItems:[NSArray arrayWithObjects: spacer, doneButton, nil]];
    
    self.reportTypeTextField.inputAccessoryView = toolbar;
    //set list of pickerView
    self.reportTypeTextField.inputView = self.pickerView;
    
    // Init scrollview
    self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrame+44)];
    [self.scroller addSubview:self.contentView];
    
    // textfield delegate
    self.remarksTextView.delegate = self;
    
    [self.submitButton addTarget:self action:@selector(submitSpam) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupViews
{
    if (![self.qrcodeId isKindOfClass:[NSString class]]) {
        self.qrcodeId = @"";
    } if (![self.productId isKindOfClass:[NSString class]]) {
        self.productId = @"";
    }
    if (![self.newsId isKindOfClass:[NSString class]]) {
        self.newsId = @"";
    }
    if (![self.orderItemId isKindOfClass:[NSString class]]) {
        self.orderItemId = @"";
    }
    //NSLog(@"QRID :%@ PRO :%@,%@,%@",self.qrcodeId,self.productId,self.newsId, self.orderItemId);
    //setup info view
    self.providerLabel.text = self.qrProvider;
    self.titleLabel.text = self.qrTitle;
    self.dateLabel.text = self.qrDate;
    self.categoryLabel.text = self.qrCategory;
    self.typeLabel.text = self.qrType;
    self.abstractLabel.text = self.qrAbstract;
    self.labelView.backgroundColor = [UIColor colorWithHex:self.qrLabelColor];
    self.thumbsView.image = self.qrImage;
    
    self.remarksTextView.layer.borderWidth = 1.0f;
    self.remarksTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.remarksTextView.layer.cornerRadius = 8.0f;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //NSLog(@"vwd");
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:NO];
//    for (UITextField *aView in [self.contentView subviews]) {
//        if ([aView isKindOfClass:[UITextField class]]) {
//            aView.text = nil;
//        }
//    }
    self.remarksTextView.text = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![self.dataArray count]) {
        //        [self performSelectorInBackground:@selector(setupCategoryList) withObject:nil];
        [self setupReportTypeList];
    }
    //NSLog(@"vda");
}

- (void)setupReportTypeList
{
    // Init the category data
    if (![self.orderItemId isEqual:@""]) {
        //NSLog(@"1");
        [self retrieveReportTypeForPurchasedItemFromAPI];
    }
    else if (![self.productId isEqual:@""]) {
        //NSLog(@"2");
        [self retrieveReportTypeForProductFromAPI];
    } else {
        //NSLog(@"3");
        [self retrieveReportTypeForBoxFromAPI];
    }
    // Set list for pickerView
    self.dataArray = [[NSMutableArray alloc] initWithArray:[self.reportTypes allKeys]];
    [self.dataArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark -
#pragma mark retrieveReportType

- (void)retrieveReportTypeForBoxFromAPI
{
//    NSString *flag = @"GET_REPORT_TYPES_NEWS";
    NSString *urlString = [NSString stringWithFormat:@"%@/api/report_abuse_type.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"news_id\":\"%@\"}",self.newsId];
    NSDictionary *rep;
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            rep = [resultsDictionary objectForKey:@"type_list"];
            
            for (id row in rep)
            {
                [self.reportTypes setObject:[row objectForKey:@"type_id"] forKey:[row objectForKey:@"type_name"]];
            }
        }else{
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Report" message:@"Connection failure. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = kAlertNoConnection;
            [alert show];
            [alert release];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)retrieveReportTypeForProductFromAPI
{
    NSString *proId = self.productId;
    NSString *urlString = [NSString stringWithFormat:@"%@/api/report_abuse_type.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"product_id\":\"%@\"}",proId];
    NSDictionary *rep;
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    //NSLog(@"resp: %@",response);
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
    
        if ([status isEqualToString:@"ok"])
        {
            rep = [resultsDictionary objectForKey:@"type_list"];
        
            for (id row in rep)
            {
                [self.reportTypes setObject:[row objectForKey:@"type_id"] forKey:[row objectForKey:@"type_name"]];
            }
        }else{
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Report" message:@"Connection failure. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = kAlertNoConnection;
            [alert show];
            [alert release];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    }
}

- (void)retrieveReportTypeForPurchasedItemFromAPI
{
//    NSString *proId = self.productId;
    NSString *urlString = [NSString stringWithFormat:@"%@/api/report_abuse_type.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"order_item_id\":\"%@\"}",self.orderItemId];
    NSDictionary *rep;
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    //NSLog(@"resp: %@",response);
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            rep = [resultsDictionary objectForKey:@"type_list"];
            
            for (id row in rep)
            {
                [self.reportTypes setObject:[row objectForKey:@"type_id"] forKey:[row objectForKey:@"type_name"]];
            }
        }else{
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Report" message:@"Connection failure. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = kAlertNoConnection;
            [alert show];
            [alert release];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}


#pragma mark -
#pragma mark submitSpam

- (void)submitSpam
{
    [self.view endEditing:YES];
    
    if ([self.reportTypeTextField.text length] == 0) {
        reqFieldName = @"Type of report";
        [self triggerRequiredAlert];
    }
    else if ([self.remarksTextView.text length] == 0)
    {
        reqFieldName = @"Remarks";
        [self triggerRequiredAlert];
    }
    else {
        //go to processSubmitSpam
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
        //NSLog(@"saved");
        if (![self.productId isEqual:@""]) {
            [self performSelector:@selector(processSubmitSpamForProduct) withObject:nil afterDelay:0.2];
        } else {
            [self performSelector:@selector(processSubmitSpamForBox) withObject:nil afterDelay:0.2];
        }
    }
}

- (void)triggerRequiredAlert
{
    NSString *reqMsg = [NSString stringWithFormat:@"%@ is required.",reqFieldName];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Reporting Spam" message:reqMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark submitProcess

- (void)processSubmitSpamForBox
{
    NSString *flag = @"SUBMIT_REPORT_NEWS";
    NSString *urlString = [NSString stringWithFormat:@"%@/api/report_abuse.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"flag\":\"%@\",\"qrcode_id\":\"%@\",\"type_id\":\"%@\",\"remarks\":\"%@\"}",
                             flag,
                             self.qrcodeId,
                             self.reportTypeId,
                             self.remarksTextView.text];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
        
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Reporting Spam" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"Success submit spam");
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)processSubmitSpamForProduct
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/report_abuse_submit.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    
    NSString *dataContent = [NSString stringWithFormat:@"{\"product_id\":\"%@\",\"report_type\":\"%@\",\"report_remarks\":\"%@\"}",
                        self.productId,
                        self.reportTypeId,
                        self.remarksTextView.text];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"abc: %@, def:%@",dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        NSString *msg = [resultsDictionary objectForKey:@"message"];
            
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Reporting Spam" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        if ([status isEqualToString:@"ok"])
        {
            //NSLog(@"Success submit spam");
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

#pragma mark -
#pragma mark textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    self.remarksTextView.contentInset = UIEdgeInsetsZero;
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
#pragma mark UIPickerView Delegate
// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.dataArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //NSLog(@"option selected %d", row);
    
    self.reportTypeTextField.text = [self.dataArray objectAtIndex:row];
}

- (IBAction)pickerDoneClicked:(id)sender
{
    //    UITextField *catBox = (UITextField *)[self.view viewWithTag:10];
    if (![self.reportTypeTextField.text length]) {
        self.reportTypeTextField.text = [self.dataArray objectAtIndex:0];
    }
    
    self.reportTypeId = [self.reportTypes objectForKey:self.reportTypeTextField.text];
    [self.reportTypeTextField resignFirstResponder];
    //NSLog(@"ID :%@",self.reportTypeId);
}

- (IBAction)pickerCancelClicked
{
    self.reportTypeTextField.text = nil;
    [self.reportTypeTextField resignFirstResponder];
}

//#pragma mark -
//#pragma mark textField delegate
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrame)];
//    [self.scroller adjustOffsetToIdealIfNeeded];
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrame+44)];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_qrcodeId release];
    [_qrTitle release];
    [_qrProvider release];
    [_qrDate release];
    [_qrAbstract release];
    [_qrType release];
    [_qrCategory release];
    [_qrLabelColor release];
    [_qrImage release];
    [_titleLabel release];
    [_dateLabel release];
    [_providerLabel release];
    [_abstractLabel release];
    [_thumbsView release];
    [_typeLabel release];
    [_categoryLabel release];
    [_labelView release];
    [_reportTypeTextField release];
    [_remarksTextView release];
    [_submitButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setQrcodeId:nil];
    [self setQrTitle:nil];
    [self setQrProvider:nil];
    [self setQrDate:nil];
    [self setQrAbstract:nil];
    [self setQrType:nil];
    [self setQrCategory:nil];
    [self setQrLabelColor:nil];
    [self setQrImage:nil];
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [self setProviderLabel:nil];
    [self setAbstractLabel:nil];
    [self setThumbsView:nil];
    [self setTypeLabel:nil];
    [self setCategoryLabel:nil];
    [self setLabelView:nil];
    [self setReportTypeTextField:nil];
    [self setRemarksTextView:nil];
    [self setSubmitButton:nil];
    [super viewDidUnload];
}

@end
