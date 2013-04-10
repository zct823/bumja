//
//  BottomSwipeViewShareBox.m
//  myjam
//
//  Created by Mohd Zulhilmi on 4/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "BottomSwipeViewShareBox.h"
#import "AppDelegate.h"
#import "ASIWrapper.h"
#import <QuartzCore/QuartzCore.h>
#import "BoxViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.7;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

static int kLabelTagStart = 100;
static int kImageTagStart = 1000;

@interface BottomSwipeViewShareBox ()

@end

@implementation BottomSwipeViewShareBox

@synthesize checkedCategories,contentSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self reloadCategories];
}

//- (void)reloadCategories
//{
//    //NSLog(@"reload categories");
//    [self.scroller setContentOffset:CGPointMake(0, 0) animated:NO];
//    for (UIView *aView in [self.contentView subviews]) {
//        if ([aView isKindOfClass:[UILabel class]] || [aView isKindOfClass:[UIImageView class]]) {
//            [aView removeFromSuperview];
//        }
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self beginProcessData];
    
    self.searchTextField.delegate = self;
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    [btn1 setHidden:YES];
    [btn2 setHidden:YES];
}

- (IBAction)firstButton:(id)sender
{
    //NSLog(@"FirstButton Will Be Sent");
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    btn1.backgroundColor = [UIColor blackColor];
    btn2.backgroundColor = [UIColor clearColor];
    
    contentSwitch = @"0";
    [self performSelector:@selector(reloadCategories) withObject:self afterDelay:0.2f];
    [self performSelector:@selector(setupCatagoryList) withObject:self afterDelay:0.2f];
}

- (IBAction)secondButton:(id)sender
{
    //NSLog(@"SecondButton Will Be Sent");
    //NSLog(@"Reload Data");
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    btn1.backgroundColor = [UIColor clearColor];
    btn2.backgroundColor = [UIColor blackColor];
    
    contentSwitch = @"1";
    [self performSelector:@selector(reloadCategories) withObject:self afterDelay:0.2f];
    [self performSelector:@selector(setupCatagoryList) withObject:self afterDelay:0.2f];
}

- (void)beginProcessData
{
    isSearchDisabled = NO;
    
    checkedCategories = [[NSMutableDictionary alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    [self.scroller setContentSize:self.contentView.frame.size];
    [self.scroller addSubview:self.contentView];
    [self.scroller bringSubviewToFront:self.activityView];
    [self.view addSubview:self.scroller];
    
    self.searchTextField.delegate = self;
    CGFloat buttonHeight = 35.0f;
    UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBtn.frame = CGRectMake((self.view.bounds.size.width/2)-(160/2), self.view.frame.size.height-(buttonHeight+15), 160, buttonHeight);    //your desired size
    myBtn.clipsToBounds = YES;
    myBtn.layer.cornerRadius = 12.0f;
    [myBtn.layer setBorderWidth:2];
    [myBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    myBtn.backgroundColor = [UIColor colorWithHex:@"#D22042"];
    [myBtn setShowsTouchWhenHighlighted:YES];
    [myBtn setTitle:@"Continue" forState:UIControlStateNormal];
    [myBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [myBtn setTintColor:[UIColor whiteColor]];
    [myBtn addTarget:self action:@selector(handleContinueButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeSwipeButton addTarget:self action:@selector(bringBottomViewDown) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myBtn];
    
    UISwipeGestureRecognizer *twoFingerSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(bringBottomViewDown)];
    [twoFingerSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [twoFingerSwipe setDelaysTouchesBegan:YES];
    [twoFingerSwipe setNumberOfTouchesRequired:2];
    
    [[self view] addGestureRecognizer:twoFingerSwipe];
    
    
    UIPanGestureRecognizer *slideRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:nil];
    slideRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:slideRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];
    //NSLog(@"YES %f - %f",translation.y, translation.x);
    
    if(gestureRecognizer.numberOfTouches == 2){
        //NSLog(@"2");
        if (translation.y > 0) {
            //NSLog(@"slide down now");
            [self bringBottomViewDown];
            return YES;
        }
    }
    else{
        //NSLog(@"%d",gestureRecognizer.numberOfTouches);
    }
    
    //NSLog(@"NO");
    return NO;
}

- (void)bringBottomViewDown
{
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mydelegate handleSwipeUp]; // Bring bottom view down
}

- (void)handleContinueButton
{
    //NSLog(@"handleContinueButton");
    [self bringBottomViewDown];
    
    if (!isSearchDisabled) {
        //        [self performSelectorOnMainThread:@selector(processCategoryFilter) withObject:nil waitUntilDone:NO];
        //        [self processCategoryFilter];
        AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [DejalBezelActivityView activityViewForView:mydelegate.window withLabel:@"Loading ..." width:100];
        
        [self performSelector:@selector(processCategoryFilter) withObject:nil afterDelay:1.0];
    }
    
}

- (void)processCategoryFilter
{
    
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    BoxViewController *box = [mydelegate.boxNavController.viewControllers objectAtIndex:0];
    NSMutableString *strData = [NSMutableString stringWithFormat:@""];
    int i = 0;
    for (id row in checkedCategories) {
        if (i == 0) {
            strData = [NSString stringWithFormat:@"%@", [checkedCategories objectForKey:row]];
        }else{
            strData = [NSString stringWithFormat:@"%@,%@",strData,[checkedCategories objectForKey:row]];
        }
        
        i++;
    }
    
    //NSLog(@"data: %@",strData);
    
    //    [hm.nv refreshTableItemsWithFilter:strData];
    //    [box.scanv refreshTableItemsWithFilter:strData andSearchedText:self.searchTextField.text];
//    if([contentSwitch isEqual:@"1"])
//    {

    [box.sbvc refreshTableItemsWithFilter:strData andSearchedText:self.searchTextField.text];


//    }else{
//        [box.scanv refreshTableItemsWithFilter:strData andSearchedText:self.searchTextField.text];
//    }

    //    [DejalBezelActivityView removeViewAnimated:YES];
}

- (IBAction)clearButton:(id)sender
{
    if (!isSearchDisabled) {
        [checkedCategories removeAllObjects];
        self.searchTextField.text = @"";
    }
    
    [self handleContinueButton];
}

- (NSString *)returningAPIString
{
    return [NSString stringWithFormat:@"%@/api/swipe_box.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

- (NSString *)returningDataContent
{
    return [NSString stringWithFormat:@"{\"flag\":\"SCAN_BOX_SWIPE_LIST\"}"];
}

- (void)setupCatagoryList
{
    //NSLog(@"setupCatagoryList. checked %d",[checkedCategories count]);
    
    /*NSDictionary *categories;
    
    NSString *urlString = [self returningAPIString];
    //NSLog(@"(BottomSwipeView) Vardumping UrlString: %@",urlString);
    NSString *dataContent = [self returningDataContent];
    //NSLog(@"(BottomSwipeView) Vardumping dataContent: %@",dataContent);
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    //NSLog(@"(BottomSwipeView) Vardumping response: %@",response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    //NSLog(@"(BottomSwipeView) Vardumping resultsDictionary: %@",resultsDictionary);
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
    //BottomSwipeView Customization after action
    
    NSString *setList, *setId, *setIdName = nil;
    
    if ([contentSwitch isEqual: @"0"] || contentSwitch == nil)
    {
        setList = @"news_categories";
        setId = @"category_id";
        setIdName = @"category_name";
    }
    else if([contentSwitch isEqual:@"1"])
    {
        setList = @"app_categories";
        setId = @"fav_folder_id";
        setIdName = @"fav_folder_name";
    }
    
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            isSearchDisabled = NO;
            [self.searchTextField setEnabled:YES];
            
            categories = [resultsDictionary objectForKey:setList];
            
            CGFloat totalHeight = 10;
            CGRect labelFrame;
            CGRect imgFrame;
            
            CGFloat imgWidth = 10;
            CGFloat labelWidth = 130;
            CGFloat labelHeight = 14;
            CGFloat horizontalGap = 20;
            CGFloat verticalGap = 22;
            
            CGFloat leftX = 10;
            CGFloat leftY = 0;
            CGFloat rightX = leftX + labelWidth + horizontalGap;
            CGFloat rightY = 0;
            
            int item = 0;
            
            // setup label and check image
            for (id row in categories) {
                
                if ((item%2) == 0) { // left column
                    imgFrame = CGRectMake(leftX, leftY + 2, imgWidth, imgWidth);
                    labelFrame = CGRectMake( leftX + imgWidth + 5,
                                            leftY,
                                            labelWidth,
                                            labelHeight);
                    leftY += labelHeight + verticalGap;
                    
                }
                else{
                    imgFrame = CGRectMake(rightX, rightY + 2, imgWidth, imgWidth);
                    labelFrame = CGRectMake( rightX + imgWidth + 5,
                                            rightY,
                                            labelWidth,
                                            labelHeight);
                    rightY += labelHeight + verticalGap;
                }
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgFrame]; //create ImageView
                imgView.tag = kImageTagStart + [[row objectForKey:setId] intValue];
                imgView.image = [UIImage imageNamed:@"checkbox_on"];
                
                
                // If already checked before no need to set hidden
                if (![self isAlreadyChecked:imgView.tag]) {
                    [imgView setHidden:YES];
                }
                
                UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
                [label setTag:kLabelTagStart + [[row objectForKey:setId] intValue]];
                [label setText: [row objectForKey:setIdName]];
                [label setTextColor: [UIColor whiteColor]];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setFont:[UIFont systemFontOfSize:12]];
                [label setNumberOfLines:0];
                [label sizeToFit];
                
                label.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCategory:)];
                [label addGestureRecognizer:tapRecognizer];
                
                // add img checkbox and label to contentView
                [self.contentView addSubview: imgView];
                [self.contentView addSubview: label];
                
                item++;
                [tapRecognizer release];
                [imgView release];
                [label release];
            }
            
            // set scrollerview to fit size of catogery list
            totalHeight += leftY;
            [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, totalHeight)];
            
        }else{
            //NSLog(@"Connection Failed");
            
            isSearchDisabled = YES;
            [self.searchTextField setEnabled:NO];
            
            UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake(5, self.scroller.frame.size.height/2-30, self.scroller.frame.size.width-10, 44)];
            [label setText:@"Connection Failed.\nPlease try again later."];
            [label setTextColor: [UIColor whiteColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setNumberOfLines:0];
            [self.contentView addSubview: label];
            [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, self.scroller.frame.size.height)];
            
        }
    }
    [self.activityView stopAnimating];
    
    [resultsDictionary release];*/
}

- (BOOL)isAlreadyChecked:(int)key
{
    if ([checkedCategories objectForKey:[NSString stringWithFormat:@"%d",key-kImageTagStart]]) {
        return YES;
    }
    
    return NO;
}

- (void)handleTapCategory:(id)sender
{
    //NSLog(@"tapped on label %d",[(UIGestureRecognizer *)sender view].tag);
    int imgTag = kImageTagStart + [(UIGestureRecognizer *)sender view].tag - kLabelTagStart;
    NSString *val = [NSString stringWithFormat:@"%d", imgTag-kImageTagStart];
    
    UIImageView *imgv = (UIImageView *)[self.view viewWithTag:imgTag];
    if ([imgv isHidden]) {
        [imgv setHidden:NO];
        [checkedCategories setObject:val forKey:val];
    }
    else{
        [imgv setHidden:YES];
        [checkedCategories removeObjectForKey:val];
    }
}

#pragma mark -
#pragma mark Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    //    textField.contentInset = UIEdgeInsetsZero;
//    self.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
    originFrame = self.view.frame;
    
    CGRect textFieldRect = [self.view convertRect:textField.frame fromView:textField];
    CGRect viewRect = [self.view convertRect:self.view.frame fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }else{
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
//    [self.view setFrame:viewFrame];
    self.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-PORTRAIT_KEYBOARD_HEIGHT-70, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
//    [self.view setFrame:viewFrame];
    self.view.frame = originFrame;
    
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //    [checkedCategories release];
    [_scroller release];
    [_contentView release];
    [_activityView release];
    [_continueButton release];
    [_searchTextField release];
    [_closeSwipeButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScroller:nil];
    [self setContentView:nil];
    [self setActivityView:nil];
    [self setContinueButton:nil];
    [self setSearchTextField:nil];
    [self setCloseSwipeButton:nil];
    [super viewDidUnload];
}

@end
