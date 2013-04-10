//
//  PrevMapNMViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 8/04/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "PrevMapNMViewController.h"

@interface PrevMapNMViewController ()

@end

@implementation PrevMapNMViewController

@synthesize shopID, shopLat, shopLong, mkMapView, locationManager, geoCoder, imageURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        FontLabel *titleViewUsingFL = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
        titleViewUsingFL.text = @"Map Preview";
        titleViewUsingFL.textAlignment = NSTextAlignmentCenter;
        titleViewUsingFL.backgroundColor = [UIColor clearColor];
        titleViewUsingFL.textColor = [UIColor whiteColor];
        [titleViewUsingFL sizeToFit];
        self.navigationItem.titleView = titleViewUsingFL;
        [titleViewUsingFL release];
        
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
    
    NSLog(@"Initiating CLGeoCoder...");
    if (!self.geoCoder)
    {
        self.geoCoder = [[CLGeocoder alloc]init];
    }
    
    self.mkMapView.delegate = self;
    
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self.mkMapView setShowsUserLocation:YES];
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    NSLog(@"Shop ID: %d",shopID);
    [self.mkMapView setShowsUserLocation:YES];
    [self getShopCoordNDistFromAPI];
    [self locateShop];
}

- (void)getShopCoordNDistFromAPI
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/nearme_map.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSString *dataContent = [NSString stringWithFormat:@"{\"lat\":\"%f\",\"lng\":\"%f\",\"radius\":\"%d\"}",appDel.currentLat,appDel.currentLong,appDel.withRadius];
    
    NSLog(@"UrlString %@ and datacontent %@",urlString,dataContent);
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"request %@\n%@\n\nresponse retrieveData: %@", urlString, dataContent, response);
    NSDictionary *resultsDictionary = [[response objectFromJSONString] mutableCopy];
    
    NSLog(@"dict %@",resultsDictionary);
    
    if([resultsDictionary count])
    {
        NSString *status = [resultsDictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            MKPointAnnotation *pointAnnotation = nil;
            
            for (id row in [resultsDictionary objectForKey:@"list"])
            {
                NSLog(@"row shopID: %@",[row objectForKey:@"shop_id"]);
                NSInteger shopIDInt = [[row objectForKey:@"shop_id"]intValue];
                NSInteger shopIDIntCurr = shopID;
                
                if (shopIDInt == shopIDIntCurr)
                {
                    NSLog(@"row shopID detected: %d",shopIDIntCurr);
                    shopLat = [[row objectForKey:@"shop_lat"]doubleValue];
                    self->clc2dpoint.latitude = [[row objectForKey:@"shop_lat"]doubleValue];
                    shopLong = [[row objectForKey:@"shop_lng"]doubleValue];
                    self->clc2dpoint.longitude = [[row objectForKey:@"shop_lng"]doubleValue];
                    pointAnnotation = [[MKPointAnnotation alloc]init];
                    pointAnnotation.coordinate = clc2dpoint;
                    pointAnnotation.title = [row objectForKey:@"shop_name"];
                    self.imageURL = [row objectForKey:@"shop_logo"];
                    [self.mkMapView addAnnotation:pointAnnotation];
                    [pointAnnotation release];
                }
            }
        }
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Near Me" message:@"Connection error. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    static NSString *identifier = @"PrevMapNMViewController";
    
    MKAnnotationView *mkAnnotationView = (MKAnnotationView *)[self.mkMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (mkAnnotationView == nil)
    {
        mkAnnotationView = [[[MKAnnotationView alloc]
                             initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
    }
    
    //image changes/resizes goes here
    UIImage *setAnnotationImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]];
    UIImage *thumbAnnotateImage = nil;
    CGSize setSize = CGSizeMake(70,70);
    
    UIGraphicsBeginImageContext(setSize);
    
    CGRect thumbCGRect = CGRectZero;
    thumbCGRect.origin = CGPointZero;
    thumbCGRect.size.width  = setSize.width;
    thumbCGRect.size.height = setSize.height;
    [setAnnotationImage drawInRect:thumbCGRect];
    thumbAnnotateImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    mkAnnotationView.image = thumbAnnotateImage;
    
    //UIImageView *imageForCallOut = [[UIImageView alloc]initWithImage:thumbAnnotateImage];
    
    //The part of map callOut
//    UIButton *moreInformationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [moreInformationButton addTarget:self action:@selector(clicked:)
//                    forControlEvents:UIControlEventTouchUpInside];
//    //mkAnnotationView.leftCalloutAccessoryView = imageForCallOut;
//    mkAnnotationView.rightCalloutAccessoryView = moreInformationButton;
//    moreInformationButton.frame = CGRectMake(0, 0, 30, 30);
//    moreInformationButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    moreInformationButton.contentHorizontalAlignment =
//    UIControlContentHorizontalAlignmentCenter;
    
    mkAnnotationView.canShowCallout = TRUE;
    
    [self.geoCoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"PlaceMarks: %@",placemarks);
         NSLog(@"PlaceMark: %@",placemark);
         NSLog(@"Error: %@",error);
         
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"LocatedAt: %@",locatedAt);
         
         //Print the location to console
         mapView.userLocation.title = @"I am Here!";
         mapView.userLocation.subtitle = [NSString stringWithFormat:@"%@",locatedAt];
         
     }];
    
    return mkAnnotationView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // To get current Lat/Long (current user position)
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    
    [self.mkMapView setRegion:[self.mkMapView regionThatFits:region] animated:YES];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"DidFinishLoadingMap");
    
    //MKMapRect zoomedIn = MKMapRectNull;
    
    for (id <MKAnnotation> currentAnnotation in mapView.annotations)
    {
//        MKMapPoint annotationPoints = MKMapPointForCoordinate(self->clc2dpoint);
//        MKMapRect pointRect = MKMapRectMake(annotationPoints.x, annotationPoints.y, 0.1, 0.1);
//        zoomedIn = MKMapRectUnion(zoomedIn, pointRect);
        [mapView selectAnnotation:currentAnnotation animated:FALSE];
    }
    
    //[mapView setVisibleMapRect:zoomedIn animated:YES];
    
    //Turn off auto go to current location.
    //[self.mkMapView setShowsUserLocation:NO];
}

- (void)locateShop
{
    //Zoom Shop Location
    
    MKMapRect zoomedIn = MKMapRectNull;
    MKMapPoint annotationPoints = MKMapPointForCoordinate(self->clc2dpoint);
    MKMapRect pointRect = MKMapRectMake(annotationPoints.x, annotationPoints.y, 0.1, 0.1);
    zoomedIn = MKMapRectUnion(zoomedIn, pointRect);
    [mkMapView setVisibleMapRect:zoomedIn animated:YES];
}

/*
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    for(MKAnnotationView *annotationView in views)
    {
        if(annotationView.annotation == mv.userLocation)
        {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            
            CLLocationCoordinate2D location=mv.userLocation.coordinate;
            
            region.span = span;
            region.center = location;
            
            [mv setRegion:region animated:TRUE];
            [mv regionThatFits:region];
        }
    }
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [mkMapView release];
    [geoCoder release];
    [locationManager release];
}

@end
