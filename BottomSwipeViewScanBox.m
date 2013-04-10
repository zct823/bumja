//
//  BottomSwipeView.m
//  myjam
//
//  Created by nazri on 12/24/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "BottomSwipeViewScanBox.h"
#import "AppDelegate.h"
#import "ASIWrapper.h"
#import <QuartzCore/QuartzCore.h>
#import "BoxViewController.h"

static int kLabelTagStart = 100;
static int kImageTagStart = 1000;

@interface BottomSwipeViewScanBox ()

@end

@implementation BottomSwipeViewScanBox

@synthesize checkedCategories,contentSwitch, label;

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
    [self reloadCategories];
}

- (void)reloadCategories
{
    //NSLog(@"reload categories");
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:NO];
    for (UIView *aView in [self.contentView subviews]) {
        if ([aView isKindOfClass:[UILabel class]] || [aView isKindOfClass:[UIImageView class]]) {
            [aView removeFromSuperview];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self beginProcessData];
    
}

- (IBAction)firstButton:(id)sender
{
    //NSLog(@"FirstButton Will Be Sent");
    //NSLog(@"Reload Data");
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:3];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:4];
    btn1.backgroundColor = [UIColor darkGrayColor];
    btn2.backgroundColor = [UIColor clearColor];
    btn3.backgroundColor = [UIColor clearColor];
    btn4.backgroundColor = [UIColor clearColor];
    
    [self.activityView startAnimating];
    [label setText:nil];
    
    contentSwitch = @"0";
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self performSelector:@selector(setupCatagoryList) withObject:self afterDelay:0.2f];
}

- (IBAction)secondButton:(id)sender
{
    //NSLog(@"SecondButton Will Be Sent");
    //NSLog(@"Reload Data");
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:3];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:4];
    btn1.backgroundColor = [UIColor clearColor];
    btn2.backgroundColor = [UIColor darkGrayColor];
    btn3.backgroundColor = [UIColor clearColor];
    btn4.backgroundColor = [UIColor clearColor];
    
    [self.activityView startAnimating];
    [label setText:nil];
    
    contentSwitch = @"1";
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self performSelector:@selector(setupCatagoryList) withObject:self afterDelay:0.2f];
}

- (IBAction)thirdButton:(id)sender
{
    //NSLog(@"ThirdButton Will Be Sent");
    //NSLog(@"Reload Data");
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:3];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:4];
    btn1.backgroundColor = [UIColor clearColor];
    btn2.backgroundColor = [UIColor clearColor];
    btn3.backgroundColor = [UIColor darkGrayColor];
    btn4.backgroundColor = [UIColor clearColor];
    
    [self.activityView startAnimating];
    [label setText:nil];
    
    contentSwitch = @"2";
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self performSelector:@selector(setupCatagoryList) withObject:self afterDelay:0.2f];
    
}

- (IBAction)fourthButton:(id)sender
{
    //NSLog(@"FourthButton Will Be Sent");
    //NSLog(@"Reload Data");
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:3];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:4];
    btn1.backgroundColor = [UIColor clearColor];
    btn2.backgroundColor = [UIColor clearColor];
    btn3.backgroundColor = [UIColor clearColor];
    btn4.backgroundColor = [UIColor darkGrayColor];
    
    [self.activityView startAnimating];
    [label setText:nil];
    
    contentSwitch = @"3";
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    if([contentSwitch isEqual:@"1"])
    {
        [box.scanv refreshTableItemsWithFilterApp:strData andSearchedText:self.searchTextField.text];
    }else{
        [box.scanv refreshTableItemsWithFilter:strData andSearchedText:self.searchTextField.text];
    }
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
    return [NSString stringWithFormat:@"{\"flag\":\"SCAN_BOX_SWIPE_LIST3\"}"];
}

- (void)setupCatagoryList
{
    //NSLog(@"setupCatagoryList. checked %d",[checkedCategories count]);
    
    NSDictionary *categories;
    
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
    
    NSString *setList, *setId, *setIdName, *setIdCount = nil;
    
    if ([contentSwitch isEqual: @"0"] || contentSwitch == nil)
    {
        setList = @"news_categories";
        setId = @"category_id";
        setIdName = @"category_name";
        setIdCount = @"total_news";
    }
    else if([contentSwitch isEqual:@"1"])
    {
        setList = @"app_categories";
        setId = @"qrcode_type";
        setIdName = @"qrcode_type";
        setIdCount = @"total_qrcode";
    }
    else if([contentSwitch isEqual:@"2"])
    {
        setList = @"shop_categories";
        setId = @"category_id";
        setIdName = @"category_name";
        setIdCount = @"total_shop";
    }
    else if([contentSwitch isEqual:@"3"])
    {
        setList = @"product_categories";
        setId = @"category_id";
        setIdName = @"category_name";
        setIdCount = @"total_product";
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
            CGFloat labelHeight = 17;
            CGFloat horizontalGap = 20;
            CGFloat verticalGap = 16;
            
            CGFloat leftX = 10;
            CGFloat leftY = 5;
            CGFloat rightX = leftX + labelWidth + horizontalGap;
            CGFloat rightY = 5;
            
            int item = 0;
            qrcodeTypeDict = [[NSMutableDictionary alloc] init];
            // setup label and check image
            if (![categories isEqual:[NSNull null]])
            {
                for (id row in categories)
                {
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
                    
                    if([contentSwitch isEqual:@"1"]){
                        imgView.tag = kImageTagStart + item;
                        [qrcodeTypeDict setObject:[row objectForKey:setId] forKey:[NSString stringWithFormat:@"%d",item]];
                    }else{
                        imgView.tag = kImageTagStart + [[row objectForKey:setId] intValue];
                    }
                    imgView.image = [UIImage imageNamed:@"checkbox_on"];
                    
                    
                    // If already checked before no need to set hidden
                    if (![self isAlreadyChecked:imgView.tag]) {
                        [imgView setHidden:YES];
                    }
                    
                    label = [[UILabel alloc] initWithFrame: labelFrame];
                    
                    
                    if([contentSwitch isEqual:@"1"]){
                        [label setTag:kLabelTagStart + item];
                    }else{
                        [label setTag:kLabelTagStart + [[row objectForKey:setId] intValue]];
                    }
                    
                    [label setText: [NSString stringWithFormat:@"%@ (%@)",[row objectForKey:setIdName], [row objectForKey:setIdCount]]];
                    
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setFont:[UIFont systemFontOfSize:12]];
                    [label setNumberOfLines:0];
                    [label sizeToFit];
                    
                    if ([row objectForKey:setIdCount] == 0) {
                        [label setTextColor:[UIColor darkGrayColor]];
                        
                    }else{
                        label.userInteractionEnabled = YES;
                        [label setTextColor: [UIColor whiteColor]];
                    }
                    
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
            }
            else
            {
                if ([contentSwitch isEqual:@"1"])
                {
                    isSearchDisabled = YES;
                    [self.searchTextField setEnabled:NO];
                    
                    label = [[UILabel alloc] initWithFrame: CGRectMake(5, self.scroller.frame.size.height/2-30, self.scroller.frame.size.width-10, 44)];
                    [label setText:@"You don't have any apps yet."];
                    [label setTextColor: [UIColor whiteColor]];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setFont:[UIFont systemFontOfSize:14]];
                    [label setNumberOfLines:0];
                    [self.contentView addSubview: label];
                    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, self.scroller.frame.size.height)];
                }
                else
                {
                    isSearchDisabled = YES;
                    [self.searchTextField setEnabled:NO];
                    
                    label = [[UILabel alloc] initWithFrame: CGRectMake(5, self.scroller.frame.size.height/2-30, self.scroller.frame.size.width-10, 44)];
                    [label setText:@"Selections on current tab is yet not available. Please try again later."];
                    [label setTextColor: [UIColor whiteColor]];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    [label setBackgroundColor:[UIColor clearColor]];
                    [label setFont:[UIFont systemFontOfSize:14]];
                    [label setNumberOfLines:0];
                    [self.contentView addSubview: label];
                    [self.scroller setContentSize:CGSizeMake(self.contentView.frame.size.width, self.scroller.frame.size.height)];
                }
            }
        }
        else
        {
            //NSLog(@"Connection Failed");
            
            isSearchDisabled = YES;
            [self.searchTextField setEnabled:NO];
            
            label = [[UILabel alloc] initWithFrame: CGRectMake(5, self.scroller.frame.size.height/2-30, self.scroller.frame.size.width-10, 44)];
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
    
    [resultsDictionary release];
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
        if([contentSwitch isEqual:@"1"])
        {
            //NSLog(@"%@",[qrcodeTypeDict objectForKey:val]);
            [checkedCategories setObject:[qrcodeTypeDict objectForKey:val] forKey:val];
        }
        else{
            [checkedCategories setObject:val forKey:val];
        }
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
