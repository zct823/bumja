//
//  AddressEditViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/15/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "AddressEditViewController.h"
#import "CustomAlertView.h"
#import "ASIWrapper.h"
#import "TPKeyboardAvoidingScrollView.h"

#define kFrameHeightOnKeyboardUp 475.0f

@interface AddressEditViewController ()

@end

@implementation AddressEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //TITLE
        self.title = @"Checkout";
        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleView.text = self.title;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Init scrollview
    self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeightOnKeyboardUp+44)];
    [self.scroller addSubview:self.contentView];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        [self.view setBounds:CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    
    self.dictStates = [[NSMutableDictionary alloc] init];
    self.dictCountries = [[NSMutableDictionary alloc] init];
    
    //declare and set data
    [self setupCategoryList];
    
    // textfield delegate
    self.addressTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.postcodeTextField.delegate = self;
    self.stateTextField.delegate = self;
    self.countryTextField.delegate = self;
    
    self.contentView.frame = CGRectMake(0, 0.0f, self.contentView.frame.size.width, kFrameHeightOnKeyboardUp+44);
    
    [self.saveButton addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    
    self.dictStates = [[NSMutableDictionary alloc] init];
    self.dictCountries = [[NSMutableDictionary alloc] init];
    // Setup pickerview
    self.statePickerView = [[UIPickerView alloc] init];
    self.countryPickerView = [[UIPickerView alloc] init];
    // Set pickerview delegate
    self.statePickerView.delegate = self;
    self.countryPickerView.delegate = self;
    self.statePickerView.dataSource = self;
    self.countryPickerView.dataSource = self;
    // Set the picker's frame.
    self.statePickerView.showsSelectionIndicator = YES;
    self.countryPickerView.showsSelectionIndicator = YES;
    // Set tag
    self.statePickerView.tag = 1;
    self.countryPickerView.tag = 2;
    
    // Toolbar for pickerView
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked:)];
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    [toolbar setItems:[NSArray arrayWithObjects: spacer, doneButton, nil]];
    
    self.stateTextField.inputAccessoryView = toolbar;
    self.countryTextField.inputAccessoryView = toolbar;
    //set list of pickerView
    self.stateTextField.inputView = self.statePickerView;
    self.countryTextField.inputView = self.countryPickerView;
    
    //UILabel *addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 320, 50)];
    self.addrLabel.font = [UIFont boldSystemFontOfSize:15];
    self.addrLabel.textAlignment = NSTextAlignmentCenter;
    self.addrLabel.textColor = [UIColor colorWithHex:@"#E01B46"];
    self.addrLabel.backgroundColor = [UIColor clearColor];
    self.addrLabel.text = [NSString stringWithFormat:@"Select Saved Addresses(%d)",self.count];
    self.addrLabel.userInteractionEnabled = YES;
    UIGestureRecognizer *addrLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addrLabelTapSelector)];
    
    [self.addrLabel addGestureRecognizer:addrLabelTap];
}

- (void)setupCategoryList
{
    // Init the category data
    [self getDataFromAddressInfo];
    
    // Set list for pickerView
    ////NSLog(@"dictstates :%@",self.dictStates);
        self.stateArray = [[NSMutableArray alloc] initWithArray:[self.dictStates allKeys]];
        [self.stateArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        self.countryArray = [[NSMutableArray alloc] initWithArray:[self.dictCountries allKeys]];
        [self.countryArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

}

- (void)addrLabelTapSelector
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    [self performSelector:@selector(listAddress) withObject:nil afterDelay:0.2];
}

- (void)listAddress
{
    //*** TO HOOK UP WITH ADDRLABEL ***//
    
    if (self.count != 0)
    {
        [self.view endEditing:YES];
        
        DeliverySelSavAddrViewController *detailViewController = [[DeliverySelSavAddrViewController alloc] init];
        detailViewController.getCartID = self.cartId;
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Saved Address" message:@"You haven't save any address yet. You may save your address in Settings - Update Jambulite Profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

#pragma mark -
#pragma mark PickerView action button

- (void)getDataFromAddressInfo
{
    NSDictionary *states;
    NSDictionary *countries;
    //NSLog(@"address :%@",self.addressInfo);
    
        if (![[self.addressInfo objectForKey:@"state_list"] isKindOfClass:[NSNull class]] && [[self.addressInfo objectForKey:@"status"] isEqualToString:@"ok"])
        {
            states = [self.addressInfo objectForKey:@"state_list"];
            for (id row in states) {
                [self.dictStates setObject:[row objectForKey:@"state_code"] forKey:[row objectForKey:@"state_name"]];
            }
            countries = [self.addressInfo objectForKey:@"country_list"];
            for (id row in countries) {
                [self.dictCountries setObject:[row objectForKey:@"country_code"] forKey:[row objectForKey:@"country_name"]];
            }
            self.addressTextField.text = [self.addressInfo objectForKey:@"delivery_address"];
            self.cityTextField.text = [self.addressInfo objectForKey:@"delivery_city"];
            self.postcodeTextField.text = [self.addressInfo objectForKey:@"delivery_postcode"];
            self.count = [[self.addressInfo objectForKey:@"saved_address_count"] integerValue];
            
            for (int i = 0; i <[[self.addressInfo valueForKey:@"state_list"] count]; i++ ){
                if ([[self.addressInfo valueForKey:@"delivery_state_code"] isEqual:[[[self.addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_code"]])
                {
                    self.stateTextField.text = [[[self.addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_name"];
                    self.stateId =[[[self.addressInfo valueForKey:@"state_list"] objectAtIndex:i] valueForKey:@"state_code"];
                    break;
                }
            }
            for (int i = 0; i <[[self.addressInfo objectForKey:@"country_list"] count]; i++ ){
                if ([[self.addressInfo objectForKey:@"delivery_country_code"] isEqual:[[[self.addressInfo objectForKey:@"country_list"] objectAtIndex:i] objectForKey:@"country_code"]])
                {
                    self.countryTextField.text = [[[self.addressInfo objectForKey:@"country_list"] objectAtIndex:i] objectForKey:@"country_name"];
                    self.countryId =[[[self.addressInfo objectForKey:@"country_list"] objectAtIndex:i] objectForKey:@"country_code"];
                    return;
                }
            }
        }else{
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Create Failed" message:@"Connection failure. Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = kAlertNoConnection;
            [alert show];
            [alert release];
            [self.navigationController popViewControllerAnimated:YES];
        }
}

- (IBAction)pickerDoneClicked:(id)sender
{
    //NSLog(@"curr :%d",self.currTag);
    if (self.currTag == 1) {
        if (![self.stateTextField.text length]) {
            self.stateTextField.text = [self.stateArray objectAtIndex:0];
        }
        //self.stateId = [self.dictStates objectForKey:self.stateTextField.text];
        self.stateId = self.stateTextField.text;
        [self.stateTextField resignFirstResponder];
    } else if (self.currTag == 2) {
        if (![self.countryTextField.text length]) {
            self.countryTextField.text = [self.countryArray objectAtIndex:0];
        }
        //self.countryId = [self.dictCountries objectForKey:self.countryTextField.text];
        self.countryId = self.countryTextField.text;
        [self.countryTextField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark saveAddress

- (void)saveAddress
{
    [self.view endEditing:YES];
    
    if ([self.addressTextField.text length] == 0) {
        reqFieldName = @"Address";
        [self triggerRequiredAlert];
    }
    else if ([self.postcodeTextField.text length] == 0)
    {
        reqFieldName = @"Postcode";
        [self triggerRequiredAlert];
    }
    else if ([self.stateTextField.text length] == 0)
    {
        reqFieldName = @"State";
        [self triggerRequiredAlert];
    }
    else if ([self.countryTextField.text length] == 0)
    {
        reqFieldName = @"Country";
        [self triggerRequiredAlert];
    }
    else {
        //save address
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
        //NSLog(@"saved");
        [self performSelector:@selector(processSaveAddress) withObject:nil afterDelay:0.2];
    }
}

- (void)triggerRequiredAlert
{
    NSString *reqMsg = [NSString stringWithFormat:@"%@ is required.",reqFieldName];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Address Profile" message:reqMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)processSaveAddress
{
    NSDictionary *status = [[MJModel sharedInstance] submitAddressForCart:self.cartId forAddress:self.addressTextField.text  inCity:self.cityTextField.text withPostcode:self.postcodeTextField.text inState:self.stateId inCountry:self.countryId];
    //NSLog(@"cartID :%@, add :%@, city :%@,  pcode :%@, state :%@, country :%@",self.cartId,self.addressTextField.text,self.cityTextField.text,self.postcodeTextField.text,self.stateId,self.countryId);
    
    if ([[status valueForKey:@"status" ] isEqual:@"ok"]){
        NSDictionary *dictTemp = [[MJModel sharedInstance] getDeliveryInfoFor:self.cartId];
        
        if ([[dictTemp valueForKey:@"delivery_option_list"] count] ==1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            
        }else{
            
            DeliveryChoiceViewController *detailViewController = [[DeliveryChoiceViewController alloc] initWithNibName:@"DeliveryChoiceViewController" bundle:nil andCartId:self.cartId];
            
            AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
    [DejalBezelActivityView removeViewAnimated:YES];
}

#pragma mark -
#pragma mark UIPickerView Delegate
// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [self.stateArray count];
    }
    else
        return [self.countryArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [self.stateArray objectAtIndex: row];
    }
    else
        return [self.countryArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //NSLog(@"option selected %d", row);
    if (pickerView.tag == 1) {
        self.stateTextField.text = [self.stateArray objectAtIndex:row];
    }
    else
        self.countryTextField.text = [self.countryArray objectAtIndex:row];
}

#pragma mark -
#pragma mark textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, kFrameHeightOnKeyboardUp)];
    [self.scroller adjustOffsetToIdealIfNeeded];
    self.currTag = textField.tag;
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

- (void)dealloc {
    [_addressTextField release];
    [_cityTextField release];
    [_postcodeTextField release];
    [_stateTextField release];
    [_countryTextField release];
    [_dictStates release];
    [_dictCountries release];
    [_stateId release];
    [_countryId release];
    [_saveButton release];
    [_cartId release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setAddressTextField:nil];
    [self setCityTextField:nil];
    [self setPostcodeTextField:nil];
    [self setStateTextField:nil];
    [self setCountryTextField:nil];
    [self setDictStates:nil];
    [self setDictCountries:nil];
    [self setStateId:nil];
    [self setCountryId:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
}

@end
