//
//  PrevMapNMViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 8/04/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ASIWrapper.h"

@interface PrevMapNMViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D clc2dpoint;
    IBOutlet MKMapView *mkMapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mkMapView;
@property (nonatomic, retain) IBOutlet CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet CLGeocoder *geoCoder;
@property (nonatomic) NSInteger shopID;
@property (nonatomic) double shopLat;
@property (nonatomic) double shopLong;
@property (nonatomic,retain) NSString *imageURL;

@end
