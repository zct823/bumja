//
//  CPViewController.h
//  myjam
//
//  Created by Mohd Zulhilmi on 21/02/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JSONKit.h"
#import "ASIWrapper.h"

@interface CPViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSString *idString;
}

@property (nonatomic,retain) id tagID;
@property (nonatomic, strong) IBOutlet UITableView *uiTableView; //display tableview
@property (nonatomic, retain) NSMutableArray *tableData; //arrayed variable to populate data

- (id)initWithTagID:(id)tagID;

@end
