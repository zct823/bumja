//
//  MData.h
//  myjam
//
//  Created by nazri on 12/19/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MData : NSObject

@property (nonatomic,retain) NSString *qrcodeId;
@property (nonatomic,retain) NSString *contentProvider;
@property (nonatomic,retain) NSString *contentProviderUID;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *abstract;
@property (nonatomic,retain) NSString *fullText;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *qrcodeType;
@property (nonatomic,retain) NSString *category;
@property (nonatomic,retain) NSString *labelColor;
@property (nonatomic,retain) NSString *imageURL;
@property (nonatomic,retain) UIImage *thumbImage;
@property (nonatomic,retain) NSString *linkType;
@property (nonatomic,retain) NSString *linkQrcodeId;
@property (nonatomic,retain) NSString *linkURL;
@property (nonatomic,retain) NSMutableArray *imageArray;

@property (nonatomic,retain) NSString *subTitleString; // subtitle
// For Share listing
@property (nonatomic,retain) NSString *shareType;

// For URL qrcode
@property (nonatomic,retain) NSString *appTitle;
@property (nonatomic,retain) NSString *urlURL;
@property (nonatomic,retain) NSString *urlName;

// For Calendar qrcode
@property (nonatomic,retain) NSDate *startTimestamp;
@property (nonatomic,retain) NSDate *endTimestamp;
@property (nonatomic,retain) NSString *notes;
@property (nonatomic,retain) NSString *location;

//--These will use for settings--//
@property (nonatomic, retain) NSString *defaultCategoryID;
@property (nonatomic, retain) NSString *defaultCPID;
@property (nonatomic, retain) NSString *defaultCategoryName;
@property (nonatomic, retain) NSString *defaultCPName;
@property (nonatomic, retain) NSString *subscriptionStatus;

// For Jambulite Profile
@property (nonatomic,retain) NSString *addressId;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *postcode;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *country;
@property (nonatomic,retain) NSString *addressIsPrimary;

//--These will use for FavVC--//
@property (nonatomic, retain) NSString *favFolderID;
@property (nonatomic, retain) NSString *favFolderName;

// For email
@property (nonatomic, retain) NSString *aEmail;
@property (nonatomic, retain) NSString *aSubject;
@property (nonatomic, retain) NSString *aBody;
@property (nonatomic, retain) NSString *aQRdesc;

//--These will use for NearMe--//
@property (nonatomic) NSInteger degreeDecimal;

@end
