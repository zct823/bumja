//
//  NMProductListsViewController.m
//  myjam
//
//  Created by Mohd Zulhilmi on 1/04/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "NMProductListsViewController.h"
#import "JambuCellNML.h"
#import "AppDelegate.h"
#import "MoreViewController.h"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

@interface NMProductListsViewController ()

@end

@implementation NMProductListsViewController

//@synthesize shopeName;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSString *)returnAPIURL
{
    return [NSString stringWithFormat:@"%@/api/nearme_list.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
}

// Overidden method to change API dataContent
- (NSString *)returnAPIDataContent
{
    NSLog(@"box fav datacontent");
    
    AppDelegate *setDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSLog(@"Coordinates: %f:%f, Radius: %d",(double)setDelegate.currentLat,(double)setDelegate.currentLong,(NSInteger)setDelegate.withRadius);
    
    return [NSString stringWithFormat:@"{\"lat\":\"%f\",\"lng\":\"%f\",\"radius\":\"%d\",\"page\":\"%d\",\"perpage\":\"%d\",\"search\":\"%@\",\"category_id\":\"%@\",\"sort_by\":\"%@\"}",(double)setDelegate.currentLat,(double)setDelegate.currentLong,(NSInteger)setDelegate.withRadius,self.pageCounter, kListPerpage, self.searchedText, self.selectedCategories, @"a_to_z"];
}


- (NSMutableArray *)loadMoreFromServer
{
    NSString *urlString = [self returnAPIURL];
    
    NSString *dataContent = [self returnAPIDataContent];
    
    NSString *response = [ASIWrapper requestPostJSONWithStringURL:urlString andDataContent:dataContent];
    NSLog(@"dataContent: %@\nresponse listings: %@", dataContent,response);
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    NSDictionary *resultsDictionary = [[response objectFromJSONString] copy];
    
    NSString *status = nil;
    NSMutableArray* list = nil;
    
    if([resultsDictionary count])
    {
        status = [resultsDictionary objectForKey:@"status"];
        list = [resultsDictionary objectForKey:@"list"];
        NSMutableArray* resultArray;
        
        if ([status isEqualToString:@"ok"] && [list count])
        {
            self.totalPage = [[resultsDictionary objectForKey:@"pagecount"] intValue];
            
            resultArray = [resultsDictionary objectForKey:@"list"];
            
            for (id row in resultArray)
            {
                MData *aData = [[MData alloc] init];
                
                aData.qrcodeId = [row objectForKey:@"shop_id"];
                aData.category = [row objectForKey:@"category"];
                aData.labelColor = [row objectForKey:@"color"];
                aData.contentProvider = [row objectForKey:@"shop_name"];
                aData.title = [self distanceConverter:[[row objectForKey:@"distance_in_meter"]intValue]];
                aData.date = [row objectForKey:@"date"];
                aData.abstract = [row objectForKey:@"description"];
                aData.type = @"";
                aData.degreeDecimal = [self degreeCalculatorWithLat:[[row objectForKey:@"shop_lat"]doubleValue] andLong:[[row objectForKey:@"shop_lng"]doubleValue]];
                aData.imageURL = [row objectForKey:@"image"];
                aData.shareType = @"";
                
                id objnul = aData.category;
                
                if (objnul != [NSNull null] && aData.labelColor && aData.qrcodeId && aData.title && aData.date && aData.type) {
                    [newData addObject:aData];
                }
                [aData release];
            }
            
            if (![resultArray count] || self.totalPage == 0)
            {
                [self.activityIndicator setHidden:YES];
                
                NSString *aMsg = [resultsDictionary objectForKey:@"message"];
                
                if([aMsg length] < 1)
                {
                    if (self.selectedCategories.length > 0) {
                        aMsg = @"No data matched.";
                    }
                }
                self.loadingLabel.text = [NSString stringWithFormat:@"%@",aMsg];
                [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
                self.loadingLabel.textColor = [UIColor grayColor];
            }
            
            NSLog(@"page now is %d",self.pageCounter);
            NSLog(@"totpage %d",self.totalPage);
            
            // if data is less, then hide the loading view
            if (([newData count] > 0 && [newData count] < kListPerpage)) {
                NSLog(@"here xx");
                [self.activityIndicatorView setHidden:YES];
            }
            
        }
        else
        {
            NSLog(@"Listing error (probably API error) but we treat as no records to close the (null) message.");
            [self.activityIndicatorView setHidden:NO];
            [self.activityIndicator setHidden:YES];
            self.loadingLabel.text = [NSString stringWithFormat:@"No records. Pull to refresh"];
            [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
            self.loadingLabel.textColor = [UIColor grayColor];
        }
        
    }
    
    
    if ([status isEqualToString:@"error"]) {
        [self.activityIndicatorView setHidden:NO];
        [self.activityIndicator setHidden:YES];
        
        NSString *errorMsg = [resultsDictionary objectForKey:@"message"];
        
        if([errorMsg length] < 1)
            errorMsg = @"Failed to retrieve data.";
        
        self.loadingLabel.text = [NSString stringWithFormat:@"%@",errorMsg];
        [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
        self.loadingLabel.textColor = [UIColor grayColor];
        
    }
    
    if ([status isEqualToString:@"ok"] && self.totalPage == 0) {
        NSLog(@"empty");
        [self.activityIndicatorView setHidden:NO];
        [self.activityIndicator setHidden:YES];
        self.loadingLabel.text = [NSString stringWithFormat:@"No records. Pull to refresh"];
        [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
        self.loadingLabel.textColor = [UIColor grayColor];
    }
    
    if ([status isEqualToString:@"ok"] && self.totalPage > 1 && ![[resultsDictionary objectForKey:@"list"] count]) {
        NSLog(@"data empty");
        [self.activityIndicatorView setHidden:YES];
    }
    
    [resultsDictionary release];
    
    return newData;
}

//- (NSString *)distanceCalculator
//{
//    //preserve for reference
//    NSString *total = nil;
//    
//    NSInteger earthRadius = 6371;
//    double toRad = 3.141592653589793 / 180; //Math.PI / 180 (ref jscript)
//    
//    NSLog(@"ToRad: %f",toRad);
//    
//    return total;
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
    NSString *compassFault = nil;
    double updatedHeading;
    double radianConst;
    
    updatedHeading = newHeading.magneticHeading;
    float headingFloat = 0 - newHeading.magneticHeading;
    
    //rotateImg.transform = CGAffineTransformMakeRotation(headingFloat*radianConst);
    float value = updatedHeading;
    if(value >= 0 && value < 23)
    {
        compassFault = [NSString stringWithFormat:@"%f° N",value];
    }
    else if(value >=23 && value < 68)
    {
        compassFault = [NSString stringWithFormat:@"%f° NE",value];
    }
    else if(value >=68 && value < 113)
    {
        compassFault = [NSString stringWithFormat:@"%f° E",value];
    }
    else if(value >=113 && value < 185)
    {
        compassFault = [NSString stringWithFormat:@"%f° SE",value];
    }
    else if(value >=185 && value < 203)
    {
        compassFault = [NSString stringWithFormat:@"%f° S",value];
    }
    else if(value >=203 && value < 249)
    {
        compassFault = [NSString stringWithFormat:@"%f° SE",value];
    }
    else if(value >=249 && value < 293)
    {
        compassFault = [NSString stringWithFormat:@"%f° W",value];
    }
    else if(value >=293 && value < 350)
    {
        compassFault = [NSString stringWithFormat:@"%f° NW",value];
    }
    
    NSLog(@"CompassFault: %@",compassFault);
}

- (NSInteger)degreeCalculatorWithLat:(double)latitude andLong:(double)longitude
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSLog(@"Curr Lat: %f",appDel.currentLat);
    NSLog(@"Curr Long: %f",appDel.currentLong);
    NSLog(@"Curr DecDegree: %d",appDel.currentDecDegree);
    
    float fromLat = degreesToRadians(appDel.currentLat);
    float fromLong = degreesToRadians(appDel.currentLong);
    float toLat = degreesToRadians(latitude);
    float toLong = degreesToRadians(longitude);
    
    float getDegree = radiandsToDegrees(atan2(sin(toLong-fromLong)*cos(toLat), cos(fromLat)*sin(toLat)-sin(fromLat)*cos(toLat)*cos(toLong-fromLong)));
    
    if (getDegree >= 0) { return getDegree; }
    else { return 360+getDegree; }
    
    NSLog(@"Degree: %f",getDegree);
    
    return getDegree;
}

- (NSString *)distanceConverter:(NSInteger)distanceInMeter
{
    NSString *distance = @"";
    
    float distanceInMeter2 = (float)distanceInMeter;
    float convertToKM = distanceInMeter2 / 1000;
    NSString *floatItToKMInString = [NSString stringWithFormat:@"%.1f",(float)convertToKM];
    float floatItToKM = [floatItToKMInString floatValue];
    
    NSLog(@"Convert To KM: %f",convertToKM);
    NSLog(@"Float It To KM: %f",floatItToKM);
    NSLog(@"Float It To Meter: %d",distanceInMeter);
    
    if (floatItToKM < 1.0)
    {
        NSLog(@"Less than 1.0: %@",floatItToKMInString);
        distance = [NSString stringWithFormat:@"%d m",distanceInMeter];
    }
    else
    {
        NSLog(@"More than 1.0 : %@",floatItToKMInString);
        distance = [NSString stringWithFormat:@"%.1f km",(float)convertToKM];
    }
    
    return distance;
}

static inline double radians (double degrees) {return degrees * M_PI/180;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FeedCell";
    
    JambuCellNML *cell = (JambuCellNML *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JambuCellNML" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    for (MarqueeLabel *label in cell.transView.subviews) {
        [label removeFromSuperview];
    }

    MarqueeLabel *shopeName;
    
    MData *fooData = [self.tableData objectAtIndex:indexPath.row];

    shopeName = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, 65, 17) rate:20.0f andFadeLength:10.0f];
    shopeName.marqueeType = MLContinuous;
    shopeName.animationCurve = UIViewAnimationOptionCurveLinear;
    shopeName.numberOfLines = 1;
    shopeName.opaque = NO;
    shopeName.enabled = YES;
    shopeName.textAlignment = NSTextAlignmentLeft;
    shopeName.textColor = [UIColor blackColor];
    shopeName.backgroundColor = [UIColor clearColor];
    shopeName.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    shopeName.text = fooData.category;
    [cell.transView addSubview:shopeName];
    [shopeName release];
    
    shopeName = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 13, 65, 17) rate:20.0f andFadeLength:10.0f];
    shopeName.marqueeType = MLContinuous;
    shopeName.animationCurve = UIViewAnimationOptionCurveLinear;
    shopeName.numberOfLines = 1;
    shopeName.opaque = NO;
    shopeName.enabled = YES;
    shopeName.textAlignment = NSTextAlignmentLeft;
    shopeName.textColor = [UIColor blackColor];
    shopeName.backgroundColor = [UIColor clearColor];
    shopeName.font = [UIFont fontWithName:@"Helvetica" size:10];
    shopeName.text = fooData.category;
    [cell.transView addSubview:shopeName];
    [shopeName release];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSInteger degreeDecimals = fooData.degreeDecimal + appDel.currentDecDegree;
    
    UIImage *imagePointer = [[UIImage imageNamed:@"arrowNaviHR.png"]imageRotatedByDegrees:degreeDecimals];
    UIImageView *pointing = [[UIImageView alloc]initWithImage:imagePointer];

    pointing.frame = CGRectMake(80, 0, 20, 15);
    [cell.transView addSubview:pointing];
    [pointing release];
    
    cell.providerLabel.text = fooData.contentProvider;
    cell.thumbsView.image = [UIImage imageNamed:fooData.imageURL];
    cell.dateLabel.text = fooData.date;
    cell.abstractLabel.text = fooData.abstract;
    cell.categoryLabel.text = fooData.category;
    cell.kmLabel.text = fooData.title;
    cell.labelView.backgroundColor = [UIColor colorWithHex:fooData.labelColor];
    [cell.thumbsView setImageWithURL:[NSURL URLWithString:fooData.imageURL]
                    placeholderImage:[UIImage imageNamed:@"default_icon"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               if (!error) {
                                   
                               }else{
                                   NSLog(@"error retrieve image: %@",error);
                               }
                               
                           }];
    return cell;
}


#pragma mark -
#pragma mark didSelectRow extended action

- (void)processRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"INDEXPATH from JambuCellNML");
    
    MoreViewController *detailView = [[MoreViewController alloc] init];
    detailView.qrcodeId = [[self.tableData objectAtIndex:indexPath.row] qrcodeId];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.otherNavController pushViewController:detailView animated:YES];
    [detailView release];
    
}

- (void) refreshTableItemsWithFilter:(NSString *)str andSearchedText:(NSString *)pattern
{
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    NSLog(@"Filtering favbox list with searched text %@",str);
    self.selectedCategories = @"";
    self.selectedCategories = str;
    self.searchedText = @"";
    self.searchedText = pattern;
    self.pageCounter = 1;
    [self.tableData removeAllObjects];
    self.tableData = [[self loadMoreFromServer] mutableCopy];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
}

- (void)dealloc
{
    [super dealloc];
//    [self.shopeName release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
