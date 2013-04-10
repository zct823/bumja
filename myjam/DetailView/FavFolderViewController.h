//
//  FavFolderViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 25/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JSONKit.h"
#import "ASIWrapper.h"
#import "CustomAlertView.h"

@class MoreViewController;

@interface FavFolderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int currentCellTag;
}

@property (nonatomic,assign) MoreViewController *delegate;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *tableData;
@property (nonatomic,retain) NSString *qrcodeId;
@property (nonatomic,retain) NSString *favHead;
@property (nonatomic,retain) NSString *purrFav;
@property (nonatomic,retain) NSIndexPath *oldIndexPath;

- (IBAction)continueBtn:(id)sender;

@end
