//
//  NearMeViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 27/03/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Foundation/Foundation.h>
#import "ASIWrapper.h"
#import "CustomAlertView.h"
#import "AppDelegate.h"

@interface NearMeViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *clLocationMgr;
    IBOutlet MKMapView *mkMapView;
}

@property (nonatomic,retain) IBOutlet CLLocationManager *clLocationMgr;
@property (nonatomic,retain) IBOutlet MKMapView *mkMapView;
@property (nonatomic,strong) IBOutlet CLGeocoder *clGeoCoder;
@property (nonatomic) NSInteger setBtnTag;
@property (nonatomic) float currentLat;
@property (nonatomic) float currentLong;
@property (nonatomic) float shopLat;
@property (nonatomic) float shopLong;
@property (nonatomic) NSInteger shopDistance;
@property (nonatomic) NSInteger withRad;
@property (nonatomic,retain) NSString *imageURL;
@property (nonatomic,retain) UIButton *currentLocalBtn;
@property (retain, nonatomic) IBOutlet UIButton *userHeadingBtn;
@property (nonatomic) NSInteger degrees;

@end
