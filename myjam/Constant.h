//
//  Constant.h
//  myjam
//
//  Created by nazri on 1/14/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#ifndef myjam_Constant_h
#define myjam_Constant_h

// Page index tracker
#define kHomeTab        0
#define kShopTab        1
#define kScannerTab     2
#define kBoxTab         3
#define kOthersTab      4

#define SELECTED_VIEW_CONTROLLER_TAG 98456345
#define NOTIFICATION_IMAGE_VIEW_TAG 98456346

//#define APP_API_URL @"http://www.jam-bu.com"

#define APP_API_URL @"http://jambudev.me-tech.com.my"


//#define APP_API_URL @"http://192.168.1.21"

#define SCAN_URL @"www.jam-bu.com"

#define kOPTION_FB          1
#define kOPTION_TWITTER     2

#define kERROR_NO_INTERNET_CONNECTION       1
#define kERROR_NOT_SAVED                    2
#define kERROR_CONTENT_REMOVED              3
#define kERROR_QR_NOT_COMPATIBLE            4
#define kERROR_SCAN_NO_INTERNET_CONNECTION  5

#define kTime 2
#define kDate 1

// fb app id
#define kAppID @"125580110956338"

// in create pages
#define kAlertSave 100
#define kAlertNoConnection 200

//Constant for version check
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// handle swipe
#define kAll        1
#define kNews       2
#define kPromotion  3

#endif
