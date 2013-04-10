//
//  UniversalResultParser.h
//  ZXingWidget
//
//  Created by Romain Pechayre on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultParser.h"
#import "SMSTOResultParser.h"
#import "URLResultParser.h"
#import "TelResultParser.h"
#import "URLTOResultParser.h"
#import "SMSResultParser.h"
#import "PlainEmailResultParser.h"
#import "MeCardParser.h"
#import "EmailDoCoMoResultParser.h"
#import "BookmarkDoCoMoResultParser.h"
#import "GeoResultParser.h"
#import "TextResultParser.h"
#import "CBarcodeFormat.h"
#import "ProductResultParser.h"
#import "BizcardResultParser.h"
#import "AddressBookAUResultParser.h"
#import "VCardResultParser.h"
#import "SMTPResultParser.h"
#import "ISBNResultParser.h"
#import "EmailAddressResultParser.h"

@interface UniversalResultParser : ResultParser {
  //NSMutableArray *parsers;
}

//@property(nonatomic,retain) NSMutableArray *parsers;

+ (void)initWithDefaultParsers;
+ (ParsedResult *)parsedResultForString:(NSString *)s
                                 format:(BarcodeFormat)format;
@end
