//
//  ProductReportViewController.m
//  myjam
//
//  Created by Azad Johari on 3/5/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ProductReportViewController.h"

@interface ProductReportViewController ()

@end

@implementation ProductReportViewController
@synthesize productId, reviewInfo, reportId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andProductId:(NSString *)productid {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.productId = productid;
        //self.navigationItem.title = @"Report";
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
{   self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.frame = self.view.frame;
    [self.view addSubview:self.scrollView];
   
    reviewInfo = [[NSDictionary alloc] initWithDictionary:[[MJModel sharedInstance] getReportInfo:productId]];
    self.productNameLabel.text = [reviewInfo valueForKey:@"product_info"];
    [self.productImage setImageWithURL:[NSURL URLWithString:[reviewInfo valueForKey:@"product_image"]] placeholderImage:[UIImage imageNamed:@"default_icon.png"]];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [_remarksLabel release];
    [_typeReportButton release];
    [_productNameLabel release];
    [_productImage release];
    [reviewInfo release];
    [reportId release];
    [productId release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setProductImage:nil];
    [self setProductNameLabel:nil];
    [self setTypeReportButton:nil];
    [self setRemarksLabel:nil];
    [super viewDidUnload];
}
- (IBAction)buttonTapped:(id)sender {
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 180, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.tag = 0;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.hidden= FALSE;
    [self.view addSubview:myPickerView];
    [myPickerView release];
}

- (IBAction)submitButtonPressed:(id)sender {
    NSDictionary *report = [NSDictionary dictionaryWithDictionary:[[MJModel sharedInstance] sendReportForProduct:productId withStatus:reportId withReview:_remarksLabel]];
    if ([[report valueForKey:@"status"] isEqual:@"ok"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your remarks have been posted succesfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [mydelegate.shopNavController popViewControllerAnimated:YES];
    }
    else{
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"An error has occurred. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark -UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {


        self.typeReportButton.titleLabel.text = [[[reviewInfo valueForKey:@"type_list"] objectAtIndex:row] valueForKey:@"type_name"];
    self.reportId = [[[reviewInfo valueForKey:@"type_list"] objectAtIndex:row] valueForKey:@"type_id"];
    
    
    pickerView.hidden = TRUE;
    
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[reviewInfo valueForKey:@"type_list"] count];

}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;

title = [[[reviewInfo valueForKey:@"type_list"] objectAtIndex:row] valueForKey:@"type_name"];
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}
@end
