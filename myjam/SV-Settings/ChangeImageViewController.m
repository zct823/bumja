//
//  ChangeImageViewController.m
//  myjam
//
//  Created by ME-Tech Mac User 2 on 2/22/13.
//  Copyright (c) 2013 me-tech. All rights reserved.
//

#import "ChangeImageViewController.h"
#import "ASIFormDataRequest.h"
//#import "ASIWrapper.h"
#import "AppDelegate.h"

@interface ChangeImageViewController ()

@end

@implementation ChangeImageViewController
@synthesize proImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self performSelectorInBackground:@selector(changeImaged) withObject:self];
    [self changeImaged];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Please wait..." width:100];
    // Do any additional setup after loading the view from its nib.
}

- (void)changeImaged
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    }
}

#pragma mark -
#pragma mark imagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    
    if([mediaType isEqualToString:(NSString *) kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.proImage = [[UIImageView alloc ] initWithImage:image];
        [self performSelectorInBackground:@selector(uploadImage) withObject:self];
        //        self.isImageChanged = YES;
        //        //NSLog(@"check if image changed %d",isImageChanged);
    }
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Image changed" message:@"Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //alert.tag = kAlertNoConnection;
    [alert show];
    [alert release];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearImageCache
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
}

-(void)uploadImage
{
    NSString *flag = @"CHANGE_PIC";
    NSData *imgData = UIImageJPEGRepresentation(self.proImage.image, 70);
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/settings_jambulite_profile.php?token=%@",APP_API_URL,[[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenString"]mutableCopy]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:url];
    [asiRequest addPostValue:flag forKey:@"flag"];
    [asiRequest addData:imgData withFileName:@"currImage.jpg" andContentType:@"image/jpeg" forKey:@"image"];
    [asiRequest setTimeOutSeconds:20];
    [asiRequest setShouldContinueWhenAppEntersBackground:YES];
    [asiRequest startSynchronous];
    NSError *error = [asiRequest error];
    if (!error) {
        NSString *response = [asiRequest responseString];
        //NSLog(@"%@",response);
        //Muz: Aku tambah method ni untuk clearkan cacheImage library yang kita guna.. sebab kita upload gambar baru, kita bagitau app buang gambar yang kita simpan sebelum ni
        [self clearImageCache];
        
        UJliteProfileViewController *ujlite = [[UJliteProfileViewController alloc] init];
        [ujlite reloadView];
        [ujlite release];
        SidebarView *sbar = [[SidebarView alloc] init];
        [sbar reloadImage];
        [sbar release];
    }else{
        NSString *error = [NSString stringWithFormat:@"%@",[asiRequest error]];
        //NSLog(@"error: %@",error);
        
        if (!([error rangeOfString:@"timed out"].location == NSNotFound)) {
            //NSLog(@"%@",[NSString stringWithFormat:@"{\"status\":\"error\",\"message\":\"Request timed out.\"}"]);
        }else if (!([error rangeOfString:@"connection failure"].location == NSNotFound)) {
            //NSLog(@"%@",[NSString stringWithFormat:@"{\"status\":\"error\",\"message\":\"Connection failure occured.\"}"]);
        }
        else [NSString stringWithFormat:@"{\"status\":\"error\"}"];
    }
    //NSLog(@"%@",[asiRequest responseString]);
    
    [url release];
//    [asiRequest release];
//    [imgData release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [super dealloc];
    [proImage release];
}
@end
