//
//  MJModel.h
//  myjam
//
//  Created by Azad Johari on 2/2/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIWrapper.h"

@interface MJModel : NSObject
+ (MJModel*) sharedInstance;
-(NSMutableArray*) getCategoryAndTopShop;
-(NSMutableArray*) getCategoryAndTopShopFor:(NSString*)searchText cats:(NSString*)catIds arrangedBy:(NSString*)arrange;
-(NSMutableArray*) getFullListOfShopsFor:(NSString*)shopId andPage:(NSString*)pageNum;
-(NSMutableArray*) getTopListOfItemsFor:(NSString*)shopId;
-(NSMutableArray*) getFullListOfProductsFor:(NSString*)shopId inCat:(NSString*)catId andPage:(NSString*)pageNum;
-(NSDictionary*) getProductInfoFor:(NSString*)prodId;
-(NSMutableArray*) getProductReviewFor:(NSString*)prodId inPage:(NSString*)pageNum;
-(NSDictionary*) getReviewInfoFor:(NSString*)prodId;
-(NSDictionary*)submitReview:(NSString*)review forProduct:(NSString*)prodId withRating:(NSString*)rate;
-(NSDictionary*)addToCart:(NSString*)prodId withSize:(NSString*)size andColor:(NSString*)color;
-(NSMutableArray*)getCartList;
-(NSMutableArray*)getCartListForRow:(NSNumber*)row;
-(NSMutableArray*)getCartListForCartId:(NSString*)cartId;
-(NSMutableArray*)updateProduct:(NSString*)itemId forCart:(NSString*)cartId forQuantity:(NSString*)qty;
-(NSDictionary*)getDeliveryDetailforCart:(NSString*)cartId;

-(NSDictionary*)submitAddressForCart:(NSString*)cartId forAddress:(NSString*)address inCity:(NSString*)city withPostcode:(NSString*)code inState:(NSString*)state inCountry:(NSString*)country;
-(NSDictionary*)getDeliveryInfoFor:(NSString*)cartId;
-(NSDictionary*)submitDeliveryOptionFor:(NSString*)cartId withOption:(NSString*)optId;
-(NSDictionary*) getCategoryForBottomView;
-(NSDictionary*)getPurchasedHistoryItems;
-(NSDictionary*) getPurchaseStatus:(NSString*)cartId;
-(NSDictionary*)getCheckoutUrlForId:(NSString*)cartId;
-(NSDictionary*)getPuchasedInfoForId:(NSString*)orderItemId;
-(NSDictionary*)getAddressForStore:(NSString*)storeId;
-(NSDictionary*)getCategoryForBottomViewPurchased;

-(NSDictionary*) getPurchasedHistoryFor:(NSString*)searchText cats:(NSString*)catIds arrangedBy:(NSString*)arrange forPage:(NSString*)page;


-(NSDictionary*)getReportInfo:(NSString*)prodId;
-(NSDictionary*)sendReportForProduct:(NSString*)prodId withStatus:(NSString*)reportId withReview:(NSString*)remarks;
-(NSDictionary*)sendAddressSaved:(NSString*)cartId withAddress:(NSString*)addressId;
@end
