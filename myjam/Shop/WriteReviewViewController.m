//
//  WriteReviewViewController.m
//  myjam
//
//  Created by Azad Johari on 2/1/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "WriteReviewViewController.h"

@interface WriteReviewViewController ()

@end

@implementation WriteReviewViewController
@synthesize ratingValue,productInfo= _productInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //TITLE
        self.title = @"Review";
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
    // Setup screen for retina 4
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 568);
    } else {
        // code for 3.5-inch screen
        self.view.frame = CGRectMake(0,0,self.view.bounds.size.width, 480);
    }

    self.scroller = (TPKeyboardAvoidingScrollView *)self.view;
    
    [self.scroller setContentSize:self.scrollView.frame.size];
    [self.scroller addSubview:self.scrollView];
    
        
    self.productReview.layer.borderWidth = 1.0f;
    self.productReview.layer.borderColor = [[UIColor grayColor] CGColor];
    self.productReview.layer.cornerRadius = 8.0f;
    
    
    self.rateView.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
    self.rateView.selectedImage = [UIImage imageNamed:@"star.png"];
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    self.ratingValue = [_productInfo valueForKey:@"rating"];
    self.rateView.rating = [[_productInfo valueForKey:@"rating"] intValue];
    self.productName.text = [_productInfo valueForKey:@"product_name"];
    //NSLog(@"Product Name: %@",self.productName.text);
    self.shopName.text = [_productInfo valueForKey:@"shop_name"];
    
    MarqueeLabel *shopeName = [[MarqueeLabel alloc] initWithFrame:CGRectMake(181, 79, 119, 21) rate:20.0f andFadeLength:10.0f];
    shopeName.marqueeType = MLContinuous;
    shopeName.animationCurve = UIViewAnimationOptionCurveLinear;
    shopeName.numberOfLines = 1;
    shopeName.opaque = NO;
    shopeName.enabled = YES;
    shopeName.textAlignment = NSTextAlignmentLeft;
    shopeName.textColor = [UIColor blackColor];
    shopeName.backgroundColor = [UIColor whiteColor];
    shopeName.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    shopeName.text = self.productName.text;
    [self.scrollView addSubview:shopeName];
    [shopeName release];
    
    self.productReview.text = [_productInfo valueForKey:@"comment"];
    //self.view.contentSize = self.view.frame.size;
    //self.scrollView.frame = self.view.frame;
    //self.scrollView.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height);
    //self.view.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    CGSize expectedLabelSize  = [[_productInfo valueForKey:@"product_name"] sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(180.0, self.productName.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    
    
    CGRect newFrame = self.productName.frame;
    newFrame.size.width = expectedLabelSize.width;
    self.productName.frame = newFrame;
   
    self.lineMiddle.frame = CGRectMake(120 ,self.lineMiddle.frame.origin.y,200-expectedLabelSize.width, 1);
    
    [self.view addSubview:self.scrollView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_shopName release];
    [_productName release];
    [_productReview release];
    [ratingValue release];
    [_rateView release];
    [_lineMiddle release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setShopName:nil];
    [self setProductName:nil];
    [self setProductReview:nil];
 
    [self setRateView:nil];
    [self setLineMiddle:nil];
    [super viewDidUnload];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
- (IBAction)submitReview:(id)sender {
    NSDictionary *answer = [[MJModel sharedInstance] submitReview:self.productReview.text forProduct:[_productInfo valueForKey:@"product_id"] withRating:self.ratingValue];
    //NSLog(@"%@",answer);
    if ([[answer valueForKey:@"status"] isEqual:@"ok"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Succesful"
                              message: @"Comment has successfully been added"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"CommentWritten"
         object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)rateView:(RateView *)rateView ratingDidChange:(int)rating {
    self.ratingValue =  [NSString stringWithFormat:@"%d", rating];
}

- (IBAction)visitShop:(id)sender {
    
    
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for (int i=0 ; i< [mydelegate.shopNavController.viewControllers count]; i++){
        //NSLog(@"%@",[[mydelegate.shopNavController.viewControllers objectAtIndex:i] class] );
        
        if( [[[mydelegate.shopNavController.viewControllers objectAtIndex:i] class] isEqual:[ShopDetailListingViewController class]])
        {
            //NSLog(@"ok");
            
            [mydelegate.shopNavController popToViewController:[mydelegate.shopNavController.viewControllers objectAtIndex:i] animated:YES];
            break;
            
        }
        
        
    }
    
    
    
}
@end
