//
//  ScanViewController.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "ModalViewControllerDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "MapKit/MKReverseGeocoder.h"

@class UniversalResultParser;
@class ParsedResult;
@class ResultAction;

@interface ScanQRViewController : UIViewController<ZXingDelegate,UIActionSheetDelegate,ModalViewControllerDelegate, MKReverseGeocoderDelegate> {
    NSArray *actions;
    ParsedResult *result;
    UINavigationController *scanNavController;
    NSString *mapCoords;
}

@property (nonatomic, retain) ZXingWidgetController *widController;
@property (nonatomic,assign) NSArray *actions;
@property (nonatomic,assign) ParsedResult *result;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityView;
@property (retain, nonatomic) IBOutlet UILabel *waitLabel;


- (void)openScanner;


@end
