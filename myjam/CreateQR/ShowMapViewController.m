//
//  ShowMapViewController.m
//  myjam
//
//  Created by nazri on 12/18/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import "ShowMapViewController.h"
#import "MapViewController.h"
#import "SimpleAnnotation.h"
#import "FontLabel.h"

#define kDEFAULT_LATITUDE_SPAN  0.01
#define kDEFAULT_LANGITUDE_SPAN 0.01

@interface ShowMapViewController ()

@end

@implementation ShowMapViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //TITLE
        self.title = @"Map Preview";
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
    
    [self.mapActivity startAnimating];
    
    // map stuff setting up
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    [self.locationManager setDelegate:self];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    
    [self addAnnotationToMap];
    //NSLog(@"address: %@", self.mapAddress);
    
    [DejalBezelActivityView removeViewAnimated:YES];
}

- (void)addAnnotationToMap
{
    cc2d = [ShowMapViewController getLocationFromAddressString:self.mapAddress];
    
    MKCoordinateRegion region;
    region.center = cc2d;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = kDEFAULT_LATITUDE_SPAN; // Change these values to change the zoom
    span.longitudeDelta = kDEFAULT_LANGITUDE_SPAN;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    
    SimpleAnnotation *searchAnnotation = [[SimpleAnnotation alloc] initWithCoordinate:cc2d];
    [self.mapView addAnnotation:searchAnnotation];
    
    [searchAnnotation release];
    [self.mapActivity stopAnimating];
}

+ (CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr
{
//    NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
//                        [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSString *locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:nil];
//    NSArray *items = [locationStr componentsSeparatedByString:@","];
//    
//    double lat = 0.0;
//    double lon = 0.0;
//    
//    if([items count] >= 4 && [[items objectAtIndex:0] isEqualToString:@"200"]) {
//        lat = [[items objectAtIndex:2] doubleValue];
//        lon = [[items objectAtIndex:3] doubleValue];
//    }
//    else {
//        //NSLog(@"Address, %@ not found: Error %@",addressStr, [items objectAtIndex:0]);
//    }
    
//    double latitude = 0.0;
//    double longitude = 0.0;
    
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    
    NSDictionary *googleResponse = [[NSString stringWithContentsOfURL: [NSURL URLWithString: req] encoding: NSUTF8StringEncoding error: nil] objectFromJSONString];
    
    //NSLog(@"%@",googleResponse);
    
    NSDictionary    *resultsDict = [googleResponse valueForKey:  @"results"];   // get the results dictionary
    NSDictionary   *geometryDict = [resultsDict valueForKey: @"geometry"];   // geometry dictionary within the  results dictionary
    NSDictionary   *locationDict = [geometryDict valueForKey: @"location"];   // location dictionary within the geometry dictionary
    
    NSArray *latArray = [locationDict valueForKey: @"lat"];
    NSString *latString = [latArray lastObject];     // (one element) array entries provided by the json parser
    
    NSArray *lngArray = [locationDict valueForKey: @"lng"];
    NSString *lngString = [lngArray lastObject];     // (one element) array entries provided by the json parser

    
    CLLocationCoordinate2D location;
    location.latitude = [latString doubleValue];
    location.longitude = [lngString doubleValue];
    
    return location;
}

#pragma mark - MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //NSLog(@"Debug - didUpdateUserLocation");
    
}

#pragma mark - CLLocationManager methods.

// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mapView release];
    [_mapActivity release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMapView:nil];
    [self setMapActivity:nil];
    [super viewDidUnload];
}
- (IBAction)showCurrentLocation:(id)sender
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (IBAction)showPin:(id)sender
{
    [self.mapView setCenterCoordinate:cc2d animated:YES];
}
@end
