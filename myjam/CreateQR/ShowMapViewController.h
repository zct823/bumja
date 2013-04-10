//
//  ShowMapViewController.h
//  myjam
//
//  Created by nazri on 12/18/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "MapKit/MapKit.h"

@interface ShowMapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationCoordinate2D cc2d;
}

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *mapActivity;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *mapAddress;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)showCurrentLocation:(id)sender;
- (IBAction)showPin:(id)sender;
+ (CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr;


@end
