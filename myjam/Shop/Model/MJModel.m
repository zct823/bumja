//
//  MJModel.m
//  myjam
//
//  Created by Azad Johari on 2/2/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "MJModel.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#define TOKEN @"02522a2b2726fb0a03bb19f2d8d9524d"

@implementation MJModel

static MJModel *_sharedInstance = nil;
+(MJModel*)sharedInstance{
    if (!_sharedInstance) {
        _sharedInstance = [[MJModel alloc] init];
    }
    return _sharedInstance;
}
-(NSDictionary*) getResponseDict:(NSString*)request withOptions:(NSString*)options{

    NSString *urlString = [NSString stringWithFormat:@"%@%@?token=%@",APP_API_URL,request,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"] copy]];
    //NSLog(@"%@",urlString);
   NSString *dataContent = options;
    //NSLog(@"%@",dataContent);
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
//   NSDictionary *resultsDictionary = [[NSDictionary alloc] initWithDictionary:[response objectFromJSONString]];
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
//    //NSLog(@"%@",resultsDictionary);
    return resultsDictionary;
}

-(NSMutableArray*) getCategoryAndTopShop{
    NSMutableArray *catList = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_list.php"];
    NSString *options = [NSString stringWithFormat:@""];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    NSDictionary *cat;
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            cat = [answer objectForKey:@"list"];
            
            for (id row in cat)
            {
                if ( ![[row objectForKey:@"category_shop_count"] isEqual:[NSNumber numberWithInt:0]]){
//                    //NSLog(@"%@",row);
                    [catList addObject:row];
                }
               
            }
        }
        
    }
    
    [answer release];

 
    return catList;
    
}
-(NSDictionary*) getCategoryForBottomView{
    NSDictionary *answer = [NSDictionary dictionary];
    NSString* request = [NSString stringWithFormat:@"/api/shop_list.php"];
    NSString *options = [NSString stringWithFormat:@""];
   
    answer =  [self getResponseDict:request withOptions:options];

    return answer;

    
}
-(NSMutableDictionary*) getCategoryForBottomViewCat{
    NSMutableDictionary *answer = [NSMutableDictionary dictionary];
    NSString* request = [NSString stringWithFormat:@"/api/shop_list.php"];
    NSString *options = [NSString stringWithFormat:@""];
    
    NSArray *temp =[NSArray arrayWithArray:[[self getResponseDict:request withOptions:options]
                                            objectForKey:@"sort_option"]];
    //NSLog(@"%@", temp);
    [answer setObject:temp forKey:@"list"];
    
    return answer;
    
    
}
-(NSMutableDictionary*)getCategoryForBottomViewPurchased{
     NSMutableDictionary *answer = [NSMutableDictionary dictionary];
    NSString* request = [NSString stringWithFormat:@"/api/shop_purchased_list.php"];
    NSString *options = [NSString stringWithFormat:@""];
    NSArray *temp =[NSArray arrayWithArray:[[self getResponseDict:request withOptions:options]
                                           objectForKey:@"category_list"]];
    //NSLog(@"%@", temp);
    [answer setObject:temp forKey:@"list"];
    return answer;
}
-(NSMutableDictionary*)getCategoryForBottomViewPurchasedCat{
    NSMutableDictionary *answer = [NSMutableDictionary dictionary];
    NSString* request = [NSString stringWithFormat:@"/api/shop_purchased_list.php"];
    NSString *options = [NSString stringWithFormat:@""];
    NSArray *temp =[NSArray arrayWithArray:[[self getResponseDict:request withOptions:options]
                                            objectForKey:@"status_list"]];
    //NSLog(@"%@", temp);
    [answer setObject:temp forKey:@"list"];
    return answer;
}
-(NSMutableArray*) getCategoryAndTopShopFor:(NSString*)searchText cats:(NSString*)catIds arrangedBy:(NSString*)arrange{
    NSMutableArray *catList = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_list.php"];
    NSString *options =[NSString stringWithFormat:@"{\"search_text\":\"%@\",\"search_category\":\"%@\",\"search_sort_by\":\"%@\"}",searchText,catIds,arrange];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    NSDictionary *cat;
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            cat = [answer objectForKey:@"list"];
            
            for (id row in cat)
            {
                if ( ![[row objectForKey:@"category_shop_count"] isEqual:[NSNumber numberWithInt:0]]){
                    
                    [catList addObject:row];
                }
                
            }
            //NSLog(@"%@",catList);
        }
    }
    return catList;
}

-(NSDictionary*) getPurchasedHistoryFor:(NSString*)searchText cats:(NSString*)catIds arrangedBy:(NSString*)arrange forPage:(NSString*)page{
    //NSMutableArray *catList = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_purchased_list.php"];
    NSString *options =[NSString stringWithFormat:@"{\"page\":\"%@\",\"search_text\":\"%@\",\"search_category\":\"%@\",\"search_status\":\"%@\"}",page,searchText,catIds,arrange];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
  //  NSDictionary *cat;
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            return answer;
            
        }
    }
   // return catList;
    
    return nil;
}
-(NSMutableArray*) getTopListOfItemsFor:(NSString*)shopId{
    NSMutableArray *catList = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_product_list.php"];

    NSString *options =[NSString stringWithFormat:@"{\"shop_id\":%@,\"search_sort\":\"A-Z\"}",shopId];


    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    NSDictionary *cat;
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            cat = [answer objectForKey:@"list"];
            
            for (id row in cat)
            {
                if ( ![[row objectForKey:@"category_product_count"] isEqual:[NSNumber numberWithInt:0]]){
                  
                    [catList addObject:row];
                }
                
            }
            //NSLog(@"%@",catList);
        }
    }
    return catList;
}

-(NSMutableArray*) getFullListOfShopsFor:(NSString*)catId andPage:(NSString*)pageNum{
    NSMutableArray *catList = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_list.php"];
    NSString *options =[NSString stringWithFormat:@"{\"category_id\":%@,\"page\":\"%@\"}",catId,pageNum];
    
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    NSDictionary *cat;
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        { //NSLog(@"%@",answer);
            cat = [[[answer objectForKey:@"list"] objectAtIndex:0]objectForKey:@"shop_list"] ;
            
            for (id row in cat)
            {
                [catList addObject:row];
                //NSLog(@"%@",row);
            }
            //NSLog(@"%@",catList);
        }
    }

    return catList;
    
}
-(NSMutableArray*) getFullListOfProductsFor:(NSString*)shopId inCat:(NSString*)catId andPage:(NSString*)pageNum{
    NSMutableArray *productList = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_product_list.php"];
    NSString *options =[NSString stringWithFormat:@"{\"shop_id\":%@,\"search_sort\":\"A-Z\",\"category_id\":%@,\"page\":\"%@\"}",shopId,catId,pageNum];
 

    //NSLog(@"%@",options);
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    NSDictionary *cat;
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        { //NSLog(@"%@",answer);
            cat = [[[answer objectForKey:@"list"] objectAtIndex:0]objectForKey:@"product_list"] ;
            
            for (id row in cat)
            {
                [productList addObject:row];
                //NSLog(@"%@",row);
            }
            //NSLog(@"%@",productList);
        }
    }
    return productList;
    
}
-(NSDictionary*) getProductInfoFor:(NSString*)prodId{
//    NSDictionary *productDetail = [NSDictionary dictionary];
    NSString* request = [NSString stringWithFormat:@"/api/shop_product_details.php"];
   
     NSString *options =[NSString stringWithFormat:@"{\"product_id\":\"%@\"}",prodId];        NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    NSDictionary *prod = nil;
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        { 
            prod = [answer objectForKey:@"product_info"]  ;
            //NSLog(@"%@",prod);
        }
    }
    return prod;
    
}
-(NSMutableArray*) getProductReviewFor:(NSString*)prodId inPage:(NSString*)pageNum{
    NSMutableArray *productReview = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_product_review_list.php"];
    
 NSString *options =[NSString stringWithFormat:@"{\"product_id\":%@,\"page\":\"%@\"}",prodId,pageNum];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
        NSDictionary *cat;
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            cat = [answer objectForKey:@"review_list"];
            
            for (id row in cat)
            {
                [productReview addObject:row];
           
            }
            //NSLog(@"%@",productReview);
        }
    }
    return productReview;
    
}
-(NSDictionary*) getReviewInfoFor:(NSString*)prodId{
    NSDictionary *reviewInfo = [NSDictionary dictionary];
    NSString* request = [NSString stringWithFormat:@"/api/shop_product_review_write.php"];
    
    NSString *options =[NSString stringWithFormat:@"{\"product_id\":\"%@\"}",prodId];        reviewInfo =  [self getResponseDict:request withOptions:options];
    
    if([reviewInfo count])
    {
        NSString *status = [reviewInfo objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
             return reviewInfo;
        }
        return nil;
   
    }
    
    return nil;
}


-(NSDictionary*)submitReview:(NSString*)review forProduct:(NSString*)prodId withRating:(NSString*)rate{
    NSDictionary *reviewStatus = [NSDictionary dictionary];
    NSString* request = [NSString stringWithFormat:@"/api/shop_product_review_submit.php"];
    
     NSString *options =[NSString stringWithFormat:@"{\"product_id\":\"%@\",\"comment\":\"%@\",\"rating\":\"%@\"}",prodId,review,rate];
    reviewStatus =  [self getResponseDict:request withOptions:options];
      //NSLog(@"%@",reviewStatus);
    return reviewStatus;
}
-(NSDictionary*)addToCart:(NSString*)prodId withSize:(NSString*)size andColor:(NSString*)color{
    NSDictionary *reviewStatus = [NSDictionary dictionary];
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_product_add.php"];
    NSString *options;
    //NSLog(@"%@",color);
    
    if ([size isEqualToString:@"none"] && [color isEqualToString:@"none"]){
        options = [NSString stringWithFormat:@"{\"product_id\":\"%@\"}",prodId];  
            }
    else if ([size isEqualToString:@"none"]){
         options =[NSString stringWithFormat:@"{\"product_id\":%@,\"color_id\":\"%@\"}",prodId,color];     
    }
    else if ([color isEqualToString:@"none"]){
     options =[NSString stringWithFormat:@"{\"product_id\":%@,\"size_id\":\"%@\"}",prodId,size];
    }
    else{
  options =[NSString stringWithFormat:@"{\"product_id\":\"%@\",\"size_id\":\"%@\",\"color_id\":\"%@\"}",prodId,size,color]; 
    }
   //NSLog(@"%@",options);
    reviewStatus =  [self getResponseDict:request withOptions:options];
    //NSLog(@"%@",reviewStatus);
    return reviewStatus;
}
-(NSMutableArray*)getCartList{
    NSMutableArray *cartList = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_list.php"];
    NSString *options = [NSString stringWithFormat:@""];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
          
            cartList = [answer valueForKey:@"cart_list"];
        }
        else{
            [cartList addObject:[NSDictionary dictionaryWithObject:@"fail" forKey:@"status"]];
        }
    
    }
    
    
    return cartList;
}
-(NSMutableArray*)getCartListForRow:(NSNumber*)row{
    NSMutableArray *cart = [NSMutableArray array];
    NSMutableArray *cartList = [NSMutableArray array];
    cartList = [self getCartList];
    //NSLog(@"%@",row);
    [cart addObject:[cartList objectAtIndex:[row intValue] ]];
     return cart;
}
-(NSMutableArray*)getCartListForCartId:(NSString*)cartId{
    NSMutableArray *cart = [NSMutableArray array];
    NSMutableArray *cartList = [NSMutableArray array];
    cartList = [self getCartList];
    //NSLog(@"%@",cartId);
    for (id row in cartList){
        if ([[row valueForKey:@"cart_id"] isEqualToString:cartId]){
            [cart addObject:row];
        
        }
    }
    return cart;

}
-(NSMutableArray*)updateProduct:(NSString*)itemId forCart:(NSString*)cartId forQuantity:(NSString*)qty{
 //   NSMutableArray *cartList = [NSMutableArray array];
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_list.php"];
    NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\",\"cart_item_id\":\"%@\",\"quantity\":\"%@\"}",cartId,itemId,qty];
    //NSLog(@"%@",options);
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    if([answer count])
    {
        NSString *status = [answer objectForKey:@"status"];
        
        if ([status isEqualToString:@"ok"])
        {
            return [answer valueForKey:@"cart_list"];
            
        }
        
    }
    
    //return cartList;

    return nil;
}
-(NSDictionary*)getDeliveryDetailforCart:(NSString*)cartId{
    
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_delivery_details.php"];
    NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\"}",cartId];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];

    return answer;
}
-(NSDictionary*)getSavedAddressFor:(NSString*)cartId{
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_delivery_address_list.php"];
    NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\"}",cartId];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    
    return answer;
}
-(NSDictionary*)submitAddressForCart:(NSString*)cartId forAddress:(NSString*)address inCity:(NSString*)city withPostcode:(NSString*)code inState:(NSString*)state inCountry:(NSString*)country{
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_delivery_address_submit.php"];
        NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\",\"delivery_address\":\"%@\",\"delivery_city\":\"%@\",\"delivery_postcode\":\"%@\",\"delivery_state_code\":\"%@\",\"delivery_country_code\":\"%@\"}",cartId,address,city,code,state,country];
    //NSLog(@"%@",options);
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    //NSLog(@"%@", answer);
    return answer;
}
-(NSDictionary*)getDeliveryInfoFor:(NSString*)cartId{
    
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_delivery_option_list.php"];
    NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\"}",cartId];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    
    return answer;
}
-(NSDictionary*)submitDeliveryOptionFor:(NSString*)cartId withOption:(NSString*)optId{
    
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_delivery_option_submit.php"];
     NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\",\"option_id\":\"%@\"}",cartId,optId];
   
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    
    return answer;
}
-(NSDictionary*)getPurchasedHistoryItems{
    NSString* request = [NSString stringWithFormat:@"/api/shop_purchased_list.php"];
    NSString *options =[NSString stringWithFormat:@""];
    
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    
    return answer;
}
-(NSDictionary*)getCheckoutUrlForId:(NSString*)cartId{
     NSString* request = [NSString stringWithFormat:@"/api/shop_checkout.php"];
    NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\"}",cartId];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    
    return answer;
}
-(NSDictionary*)sendAddressSaved:(NSString*)cartId withAddress:(NSString*)addressId{
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_delivery_address_submit.php"];
    NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\",\"address_id\":\"%@\"}",cartId,addressId];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    
    return answer;
}
-(NSDictionary*)getPuchasedInfoForId:(NSString*)orderItemId{
    NSString* request = [NSString stringWithFormat:@"/api/shop_purchased_product_details.php"];
    NSString *options =[NSString stringWithFormat:@"{\"order_item_id\":\"%@\"}",orderItemId];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    
    return [answer valueForKey:@"product_info"];
}
-(NSDictionary*)getAddressForStore:(NSString*)storeId{
    NSString* request = [NSString stringWithFormat:@"/api/shop_details.php"];
    NSString *options =[NSString stringWithFormat:@"{\"shop_id\":\"%@\"}",storeId];
    NSDictionary *answer =  [self getResponseDict:request withOptions:options];
    
    return answer;
}
-(NSDictionary*)getReportInfo:(NSString*)prodId{
    
    NSString* request = [NSString stringWithFormat:@"/api/report_abuse_type.php"];
    NSString *options =[NSString stringWithFormat:@"{\"product_id\":\"%@\"}",prodId];
    NSDictionary *answer = [ [NSDictionary alloc] initWithDictionary:[self getResponseDict:request withOptions:options ]];
    //NSLog(@"answer:%@", answer);
    return [answer autorelease];

}
-(NSDictionary*)sendReportForProduct:(NSString*)prodId withStatus:(NSString*)reportId withReview:(NSString*)remarks{
    NSString* request = [NSString stringWithFormat:@"/api/report_abuse_submit.php"];
     NSString *options =[NSString stringWithFormat:@"{\"product_id\":\"%@\",\"report_type\":\"%@\",\"report_remarks\":\"%@\"}",prodId,reportId,remarks];
    NSDictionary *answer = [ [NSDictionary alloc] initWithDictionary:[self getResponseDict:request withOptions:options ]];
    //NSLog(@"answer:%@", answer);
    return [answer autorelease];
}
-(NSDictionary*) getPurchaseStatus:(NSString*)cartId{
    NSString* request = [NSString stringWithFormat:@"/api/shop_cart_payment_status.php"];
    NSString *options =[NSString stringWithFormat:@"{\"cart_id\":\"%@\"}",cartId];
    NSDictionary *answer = [ [NSDictionary alloc] initWithDictionary:[self getResponseDict:request withOptions:options ]];
    //NSLog(@"answer:%@", answer);
    return [answer autorelease];
}
//-(void)authenticateWithFacebook{
//    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
//    ACAccountType *accountTypeFacebook = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//    
// //   NSDictionary *options = @{ACFacebookAppIdKey
//}
@end

