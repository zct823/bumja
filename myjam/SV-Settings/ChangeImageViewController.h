//
//  ChangeImageViewController.h
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/22/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//
#import "ASIFormDataRequest.h"
#import "UJliteProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIKit/UIKit.h>

@interface ChangeImageViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain)UIImageView *proImage;

@end
