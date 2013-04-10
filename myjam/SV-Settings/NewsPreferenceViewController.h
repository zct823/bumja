//
//  NewsPreferenceViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 14/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JSONKit.h"
#import "ASIWrapper.h"
#import "TBTabBar.h"

@interface NewsPreferenceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    TBTabBar *TBTB;
}

@property (nonatomic, strong) IBOutlet UITableView *uiTableView; //display tableview
@property (nonatomic, retain) NSMutableArray *tableData; //arrayed variable to populate data
@property (nonatomic, retain) NSString *cpStatus;

@end