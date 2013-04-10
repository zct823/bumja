//
//  CoreViewController.h
//  jambu
//
//  Created by Azad Johari on 2/4/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>
#import "CustomAlertView.h"
#import "ASIWrapper.h"
#import "ASIHTTPRequest.h"
#import <Twitter/Twitter.h>
#import "Social/Social.h"
@interface CoreViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
     SLComposeViewController *mySLComposerSheet;
}
-(void)setNavBarTitle:(NSString*)text;
- (void)shareImageOnFBwith:(NSString*)qrcode andImage:(UIImage*)image;
-(void)shareImageOnTwitterFor:(NSString*)qrcodeId andImage:(UIImage*)image;
- (void)shareImageOnEmailWithId:(NSString*)qrcodeId withImage:(UIImage*)image;
@end
