//
//  ProductViewAllViewController.m
//  myjam
//
//  Created by Azad Johari on 2/13/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ProductViewAllViewController.h"
#define kTableCellHeightM 130
@interface ProductViewAllViewController ()

@end

@implementation ProductViewAllViewController
@synthesize shopInfo, catName, productAllArray, tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        self.navigationItem.title = @"JAM-BU Shop";
//        self.title = @"JAM-BU Shop";
//        FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
//        titleView.text = self.title;
//        titleView.textAlignment = NSTextAlignmentCenter;
//        titleView.backgroundColor = [UIColor clearColor];
//        titleView.textColor = [UIColor whiteColor];
//        [titleView sizeToFit];
//        self.navigationItem.titleView = titleView;
//        [titleView release];
//        
//        
//        self.navigationItem.backBarButtonItem =
//        [[[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                          style:UIBarButtonItemStyleBordered
//                                         target:nil
//                                         action:nil] autorelease];
    }
    return self;
}
-(id)initWith:(NSDictionary*)shopInfo andCat:(NSString*)catName{
    
    self = [super initWithNibName:@"ProductViewAllViewController" bundle:nil];
    if (self){
        self.shopInfo = shopInfo;
        self.catName = catName;
        
        
        // ...
    }
    
    return self;
    
}
- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad
{
    self.title = @"JAM-BU Shop";
    FontLabel *titleView = [[FontLabel alloc] initWithFrame:CGRectZero fontName:@"jambu-font.otf" pointSize:22];
    titleView.text = self.title;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    self.navigationItem.titleView = titleView;
    [titleView release];
    
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//    [tempImageView setFrame:self.tableView.frame];
//    
//    self.tableView.backgroundView = tempImageView;
//    [tempImageView release];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 70, 0)];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if ( ([productAllArray count] % 3) == 0){
        return ([productAllArray count]/3)+1;
    }
    else{
        return (([productAllArray count]/3) + 2);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    if(indexPath.row == 0){
        //ShopHeaderViewCell *cell = (ShopHeaderViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        CustomHeaderCell *cell = (CustomHeaderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomHeaderCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
//        cell.shopLabel.text = [self.shopInfo valueForKey:@"shop_name"];
//        if([[self.shopInfo valueForKey:@"shop_top_seller"] isEqual:@"Y"]){
//            cell.topSellerLabel.hidden=NO;
//        }
        UILabel *catNameLabelTemp = [[UILabel alloc] init];
        CGSize expectedLabelSize  = [self.catName sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(150.0, cell.catNameLabel.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
        CGRect newFrame = cell.catNameLabel.frame;
        newFrame.size.width = expectedLabelSize.width;
        cell.catNameLabel.text = catName;
        cell.catNameLabel.frame = newFrame;
        [catNameLabelTemp release];
        
        cell.viewAllButton.hidden = YES;
        return cell;
    }
    
    else{
        
        ProductTableViewCellwoCat *cell = (ProductTableViewCellwoCat*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCellwoCat" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        // Configure the cell...
        [self createCellForIndex:indexPath cell:cell];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 44;
    }
    else{
        return kTableCellHeightM;
    }
}
- (void)createCellForIndex:(NSIndexPath *)indexPath cell:(ProductTableViewCellwoCat *)cell
{
    [cell.transView2 setHidden:YES];
    [cell.transView3 setHidden:YES];
//    if (indexPath.row ==1){
//        UILabel *catNameLabelTemp = [[UILabel alloc] init];
//        
//        CGSize expectedLabelSize  = [self.catName sizeWithFont:[UIFont fontWithName:@"Verdana" size:12.0] constrainedToSize:CGSizeMake(150.0, cell.catNameLabel.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
//        
//        CGRect newFrame = cell.catNameLabel.frame;
//        newFrame.size.width = expectedLabelSize.width;
//        cell.catNameLabel.text = catName;
//        cell.catNameLabel.frame = newFrame;
//        [catNameLabelTemp release];
//        cell.viewAllButton.hidden = YES;
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    //  cell.topLabel1.text =
    MarqueeLabel *productNameLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, 90, 18) rate:20.0f andFadeLength:10.0f];
    productNameLabel.marqueeType = MLContinuous;
    productNameLabel.animationCurve = UIViewAnimationOptionCurveLinear;
    productNameLabel.numberOfLines = 1;
    productNameLabel.opaque = NO;
    productNameLabel.enabled = YES;
    productNameLabel.textAlignment = UITextAlignmentLeft;
    productNameLabel.textColor = [UIColor blackColor];
    productNameLabel.backgroundColor = [UIColor clearColor];
    productNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    productNameLabel.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]  valueForKey:@"product_name"];
    [cell.transView1 addSubview:productNameLabel];
    [productNameLabel release];
//    NSLog(@"IMG1 :%d",3*(indexPath.row-1)+0);
    
    MarqueeLabel *categoryLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 14, 90, 18) rate:20.0f andFadeLength:10.0f];
    categoryLabel.marqueeType = MLContinuous;
    categoryLabel.animationCurve = UIViewAnimationOptionCurveLinear;
    categoryLabel.numberOfLines = 1;
    categoryLabel.opaque = NO;
    categoryLabel.enabled = YES;
    categoryLabel.textAlignment = UITextAlignmentLeft;
    categoryLabel.textColor = [UIColor blackColor];
    categoryLabel.backgroundColor = [UIColor clearColor];
    categoryLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    categoryLabel.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]   valueForKey:@"product_category"];
    [cell.transView1 addSubview:categoryLabel];
    [categoryLabel release];
    
    cell.priceLabel1.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]   valueForKey:@"product_price"];
    //cell.buttonTap1.tag =  3*indexPath.section+0;
    //[cell.transView1 setHidden:NO];
    
    if( [[[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]   valueForKey:@"product_rating"]  isEqual:@"0.0"]){
        cell.rateView1.hidden = FALSE;
    }
    else{
        cell.rateView1.rating = [[[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)]   valueForKey:@"product_rating"] intValue];
        cell.rateView1.editable = FALSE;
        cell.rateView1.selectedImage = [UIImage imageNamed:@"star.png"];
        cell.rateView1.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
        cell.rateView1.maxRating = 5;
        cell.transView1.hidden = FALSE;
    }
    cell.buttonTap1.tag = 3*(indexPath.row-1)+0;
    [cell.button1 setBackgroundImageWithURL:[NSURL URLWithString:[[productAllArray objectAtIndex:(3*(indexPath.row-1)+0)] valueForKey:@"product_image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
    [cell.buttonTap1 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];

    if (3*(indexPath.row-1)+1 < [productAllArray count]){
        
        MarqueeLabel *productNameLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, 90, 18) rate:20.0f andFadeLength:10.0f];
        productNameLabel.marqueeType = MLContinuous;
        productNameLabel.animationCurve = UIViewAnimationOptionCurveLinear;
        productNameLabel.numberOfLines = 1;
        productNameLabel.opaque = NO;
        productNameLabel.enabled = YES;
        productNameLabel.textAlignment = UITextAlignmentLeft;
        productNameLabel.textColor = [UIColor blackColor];
        productNameLabel.backgroundColor = [UIColor clearColor];
        productNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        productNameLabel.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]  valueForKey:@"product_name"];
        [cell.transView2 addSubview:productNameLabel];
        [productNameLabel release];
//        NSLog(@"IMG2 :%d",3*(indexPath.row-1)+1);
        
        MarqueeLabel *categoryLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 14, 90, 18) rate:20.0f andFadeLength:10.0f];
        categoryLabel.marqueeType = MLContinuous;
        categoryLabel.animationCurve = UIViewAnimationOptionCurveLinear;
        categoryLabel.numberOfLines = 1;
        categoryLabel.opaque = NO;
        categoryLabel.enabled = YES;
        categoryLabel.textAlignment = UITextAlignmentLeft;
        categoryLabel.textColor = [UIColor blackColor];
        categoryLabel.backgroundColor = [UIColor clearColor];
        categoryLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        categoryLabel.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]   valueForKey:@"product_category"];
        [cell.transView2 addSubview:categoryLabel];
        [categoryLabel release];
        
        cell.priceLabel2.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]   valueForKey:@"product_price"];
        //cell.buttonTap2.tag =  3*indexPath.section+1;
        [cell.transView2 setHidden:NO];
        
        if( [[[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]   valueForKey:@"product_rating"]  isEqual:@"0.0"]){
            cell.rateView2.hidden = FALSE;
        }
        else{
            cell.rateView2.rating = [[[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)]   valueForKey:@"product_rating"] intValue];
            cell.rateView2.editable = FALSE;
            cell.rateView2.selectedImage = [UIImage imageNamed:@"star.png"];
            cell.rateView2.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
            cell.rateView2.maxRating = 5;
            cell.transView2.hidden = FALSE;
        }
        cell.buttonTap2.tag = 3*(indexPath.row-1)+1;
        [cell.button2 setBackgroundImageWithURL:[NSURL URLWithString:[[productAllArray objectAtIndex:(3*(indexPath.row-1)+1)] valueForKey:@"product_image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
        [cell.buttonTap2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    if (3*(indexPath.row-1)+2 < [productAllArray count]){
        //        cell.catLabel3.text = [[[[productAllArray objectAtIndex:indexPath.section]valueForKey:@"product_list"] objectAtIndex:2] valueForKey:@"product_name"];
        //        cell.productLabel3.text =[[[[productAllArray objectAtIndex:indexPath.section]valueForKey:@"product_list"] objectAtIndex:2] valueForKey:@"product_category"];
        
        MarqueeLabel *productNameLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, 90, 18) rate:20.0f andFadeLength:10.0f];
        productNameLabel.marqueeType = MLContinuous;
        productNameLabel.animationCurve = UIViewAnimationOptionCurveLinear;
        productNameLabel.numberOfLines = 1;
        productNameLabel.opaque = NO;
        productNameLabel.enabled = YES;
        productNameLabel.textAlignment = UITextAlignmentLeft;
        productNameLabel.textColor = [UIColor blackColor];
        productNameLabel.backgroundColor = [UIColor clearColor];
        productNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        productNameLabel.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]  valueForKey:@"product_name"];
        [cell.transView3 addSubview:productNameLabel];
        [productNameLabel release];
//        NSLog(@"IMG3 :%d",3*(indexPath.row-1)+2);
        
        MarqueeLabel *categoryLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 14, 90, 18) rate:20.0f andFadeLength:10.0f];
        categoryLabel.marqueeType = MLContinuous;
        categoryLabel.animationCurve = UIViewAnimationOptionCurveLinear;
        categoryLabel.numberOfLines = 1;
        categoryLabel.opaque = NO;
        categoryLabel.enabled = YES;
        categoryLabel.textAlignment = UITextAlignmentLeft;
        categoryLabel.textColor = [UIColor blackColor];
        categoryLabel.backgroundColor = [UIColor clearColor];
        categoryLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        categoryLabel.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]   valueForKey:@"product_category"];
        [cell.transView3 addSubview:categoryLabel];
        [categoryLabel release];
        
        cell.priceLabel3.text = [[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]   valueForKey:@"product_price"];
        //cell.buttonTap3.tag =  3*indexPath.section+2;
        [cell.transView3 setHidden:NO];
        
        if( [[[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]   valueForKey:@"product_rating"]  isEqual:@"0.0"]){
            cell.rateView3.hidden = FALSE;
        }
        else{
            cell.rateView3.rating = [[[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)]   valueForKey:@"product_rating"] intValue];
            cell.rateView3.editable = FALSE;
            cell.rateView3.selectedImage = [UIImage imageNamed:@"star.png"];
            cell.rateView3.nonSelectedImage = [UIImage imageNamed:@"grey_star.png"];
            cell.rateView3.maxRating = 5;
            cell.transView3.hidden = FALSE;
        }
        cell.buttonTap3.tag = 3*(indexPath.row-1)+2;
        [cell.button3 setBackgroundImageWithURL:[NSURL URLWithString:[[productAllArray objectAtIndex:(3*(indexPath.row-1)+2)] valueForKey:@"product_image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
        [cell.buttonTap3 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)tapAction:(id)sender{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading ..." width:100];
    
    [self performSelector:@selector(showProductDetail:) withObject:sender afterDelay:0.1];
}

-(void)showProductDetail:(id)sender {
    
    DetailProductViewController *detailViewController = [[DetailProductViewController alloc] initWithNibName:@"DetailProductViewController" bundle:nil];
//    NSLog(@"%@",productAllArray);
    NSString *prodId = [[productAllArray  objectAtIndex:[sender tag] ] valueForKey:@"product_id" ];
    detailViewController.productInfo = [[MJModel sharedInstance] getProductInfoFor:prodId];
    detailViewController.buyButton =  [[NSString alloc] initWithString:@"ok"];
    detailViewController.productId = [prodId mutableCopy];
//    //------------------------------------------------------------
//    detailViewController.productAllArray = self.productAllArray;
//    detailViewController.productArray = self.productArray;
//    detailViewController.shopInfo = self.shopInfo;
//    //------------------------------------------------------------
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
}

- (IBAction)locateStore:(id)sender {
    ShopAddressViewController *detailViewController = [[ShopAddressViewController alloc] init];
    // NSLog(@"%@",_shopInfo);
    detailViewController.shopId = [self.shopInfo valueForKey:@"shop_id"];
    AppDelegate *mydelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [mydelegate.shopNavController pushViewController:detailViewController animated:YES];
    // [detailViewController release];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

-(void) dealloc{
    [productAllArray release];
    [shopInfo release];
    [catName release];
    [tableView release];
    [super dealloc];
}
@end
