//
//  JBoxViewController.h
//  myjam
//
//  Created by nazri on 11/7/12.
//  Copyright (c) 2012 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"


@interface JBoxViewController : NewsViewController

@property (retain, nonatomic) NSString *selectedApp;
@property (retain, nonatomic) NSString *selectedShop;
@property (retain, nonatomic) NSString *selectedProduct;

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern;
- (void) refreshTableItemsWithFilterApp:(NSString *)str andSearchedText:(NSString *)pattern;
- (void) refreshTableItemsWithFilterShop:(NSString *)str andSearchedText:(NSString *)pattern;
- (void) refreshTableItemsWithFilterProduct:(NSString *)str andSearchedText:(NSString *)pattern;

@end
