//
//  NearMeViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 27/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "NearMeViewController.h"
#import "NMTabViewController.h"

@interface NearMeViewController ()

@end

@implementation NearMeViewController
@synthesize clLocationMgr, mkMapView, clGeoCoder, currentLong, currentLat, userHeadingBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        FontLabel *titleView = [[[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22]autorelease];
        titleView.text = @"Near Me";
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textColor = [UIColor whiteColor];
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;
        
        if (!self.clGeoCoder)
        {
            self.clGeoCoder = [[CLGeocoder alloc]init];
        }
        
        self.mkMapView.delegate = self;
        
        clLocationMgr = [[CLLocationManager alloc]init];
        [clLocationMgr setDelegate:self];
        
        [clLocationMgr setDistanceFilter:kCLDistanceFilterNone];
        [clLocationMgr setDesiredAccuracy:kCLLocationAccuracyBest];
        
        [self.mkMapView setShowsUserLocation:YES];
        [clLocationMgr startUpdatingLocation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    [self.mkMapView setShowsUserLocation:YES];
    
    //MKUserTrackingBarButtonItem *trackingBtn = [[MKUserTrackingBarButtonItem alloc]initWithMapView:self.mkMapView];

    UIImage *buttonImage = [UIImage imageNamed:@"greyButtonHighlight.png"];
    UIImage *buttonImageHighlight = [UIImage imageNamed:@"greyButton.png"];
    UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
    
    //Configure the button
    userHeadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [userHeadingBtn addTarget:self action:@selector(startShowingUserHeading:) forControlEvents:UIControlEventTouchUpInside];
    //Add state images
    [userHeadingBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [userHeadingBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [userHeadingBtn setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    
    //Position and Shadow
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        userHeadingBtn.frame = CGRectMake(5,screenBounds.origin.y+370,39,30);
    } else {
        // code for 3.5-inch screen
        userHeadingBtn.frame = CGRectMake(5,screenBounds.origin.y+280,39,30);
    }
    
    //userHeadingBtn.frame = CGRectMake(5,30,39,30);
    userHeadingBtn.layer.cornerRadius = 8.0f;
    userHeadingBtn.layer.masksToBounds = NO;
    userHeadingBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    userHeadingBtn.layer.shadowOpacity = 0.8;
    userHeadingBtn.layer.shadowRadius = 1;
    userHeadingBtn.layer.shadowOffset = CGSizeMake(0, 1.0f);
    
    [self.mkMapView addSubview:userHeadingBtn];
    
    [DejalBezelActivityView activityViewForView:self.mkMapView withLabel:@"Preparing Map..." width:100];

}

#pragma mark User Heading
- (IBAction) startShowingUserHeading:(id)sender{
    
    if(self.mkMapView.userTrackingMode == 0){
        [self.mkMapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
        
        //Turn on the position arrow
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationBlue.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
        
    }
    else if(self.mkMapView.userTrackingMode == 1){
        [self.mkMapView setUserTrackingMode: MKUserTrackingModeFollowWithHeading animated: YES];
        
        //Change it to heading angle
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationHeadingBlue"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    else if(self.mkMapView.userTrackingMode == 2){
        [self.mkMapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    
    
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if(self.mkMapView.userTrackingMode == 0){
        [self.mkMapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [userHeadingBtn setImage:buttonArrow forState:UIControlStateNormal];
    }
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // To get current Lat/Long (current user position)
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    
    [self.mkMapView setRegion:[self.mkMapView regionThatFits:region] animated:YES];
    
    // Get Current Position
    self.currentLat = (float)self.mkMapView.userLocation.coordinate.latitude;
    self.currentLong = (float)self.mkMapView.userLocation.coordinate.longitude;
    NSLog(@"Current Lat/Long: %f:%f",self.currentLat,self.currentLong);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    if (annotation == self.mkMapView.userLocation)
    {
        return nil;
    }
    
    static NSString *identifier = @"NearMeViewController";
    
    MKAnnotationView *mkAnnotationView = (MKAnnotationView *)[self.mkMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
   
    if (mkAnnotationView == nil)
    {
        mkAnnotationView = [[[MKAnnotationView alloc]
                             initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
    }
    
    //image changes/resizes goes here
    UIImage *setAnnotationImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
    UIImage *thumbAnnotateImage = nil;
    CGSize setSize = CGSizeMake(50,50);
    
    UIGraphicsBeginImageContext(setSize);
    
    CGRect thumbCGRect = CGRectZero;
    thumbCGRect.origin = CGPointZero;
    thumbCGRect.size.width  = setSize.width;
    thumbCGRect.size.height = setSize.height;
    [setAnnotationImage drawInRect:thumbCGRect];
    thumbAnnotateImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    mkAnnotationView.image = thumbAnnotateImage;
    
    //The part of map callOut
    UIButton *moreInformationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [moreInformationButton addTarget:self action:@selector(clicked:)
                    forControlEvents:UIControlEventTouchUpInside];
    mkAnnotationView.rightCalloutAccessoryView = moreInformationButton;
    moreInformationButton.frame = CGRectMake(0, 0, 30, 30);
    moreInformationButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    moreInformationButton.contentHorizontalAlignment =
    UIControlContentHorizontalAlignmentCenter;
    moreInformationButton.tag = self.setBtnTag;
    
    //mkPinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    //mkAnnotationView.animatesDrop = true;
    mkAnnotationView.canShowCallout = TRUE;
    
    [self.clGeoCoder reverseGeocodeLocation: clLocationMgr.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"PlaceMarks: %@",placemarks);
         NSLog(@"PlaceMark: %@",placemark);
         
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"LocatedAt: %@",locatedAt);
         
         //Print the location to console
         mapView.userLocation.title = @"I am Here!";
         mapView.userLocation.subtitle = locatedAt;
         
     }];
    
    return mkAnnotationView;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"DidFinishLoadingMap");
    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
        
        [mapView selectAnnotation:currentAnnotation animated:FALSE];
    }
    
    //Turn off auto go to current location.
    [self.mkMapView setShowsUserLocation:NO];
    
    //[self performSelectorInBackground:@selector(retrieveMapDataFromAPI) withObject:self];
    //[DejalBezelActivityView removeViewAnimated:YES];
}

/*
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"Region Did Change Animated");
 
    //[self performSelectorInBackground:@selector(retrieveMapDataFromAPI) withObject:nil];
}
*/

-(void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    [self performSelectorInBackground:@selector(retrieveMapDataFromAPI) withObject:self];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"Tapped on Annotation");
    //MKAnnotation *tappedSite = (MKAnnotation *)[view annotation];
    //NSNumber *companyIDThatWasClickedExample = [tappedSite companyID];
    //NSLog(@"example: %@",companyIDThatWasClickedExample);
}

- (void)clicked:(id)sender
{
    NSLog(@"clicked sender: %d",[sender tag]);
}

- (void)retrieveMapDataFromAPI
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/nearme_map.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"lat\":\"%f\",\"lng\":\"%f\",\"radius\":\"10000\"}",self.currentLat,self.currentLong];
    
    NSLog(@"UrlString %@ and datacontent %@",urlString,dataContent);
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"request %@\n%@\n\nresponse retrieveData: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        //NSDictionary* resultProfile;
        
        if ([status isEqualToString:@"ok"])
        {
            MKPointAnnotation *mkPointAnnotation = nil;
            CLLocationCoordinate2D ctrpoint;
            
            for (id row in [resultsDictionary objectForKey:@"list"])
            {
                ctrpoint.latitude = [[row objectForKey:@"shop_lat"] doubleValue];
                ctrpoint.longitude = [[row objectForKey:@"shop_lng"]doubleValue];
                mkPointAnnotation = [[MKPointAnnotation alloc]init];
                [mkPointAnnotation setCoordinate:ctrpoint];
                [mkPointAnnotation setTitle:[row objectForKey:@"shop_name"]];
                //[mkPointAnnotation setSubtitle:@"Jalan Ni"];
                self.imageURL = [row objectForKey:@"shop_logo"];
                self.setBtnTag = 1;
                [self.mkMapView addAnnotation:mkPointAnnotation];
                [mkPointAnnotation release];
            }
        }
        /*
        else
        {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Near Me" message:@"An error has occured. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
         */
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Near Me" message:@"Connection error. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [DejalBezelActivityView removeViewAnimated:YES];
    [self.mkMapView setShowsUserLocation:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [self.mkMapView dealloc];
    [self.mkMapView release];
    [clLocationMgr dealloc];
    [clLocationMgr release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

@end
