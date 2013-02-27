//
//  VenusFilmViewController.m
//  Venus_001
//
//  Created by 권 회경 on 13. 2. 20..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusFilmViewController.h"
#import "VenusFilmPhotoCell.h"
#import "AssetsLibrary/AssetsLibrary.h"

@interface VenusFilmViewController ()
@end
@implementation VenusFilmViewController
@synthesize assets;
@synthesize cancelButton;
@synthesize nibsRegistered;

- (IBAction)buttonPressed:(UIBarButtonItem *)sender {
/*
    for(int i=0;i<[assets count];i++){
        NSLog(@"뮤터블 : %@",[assets objectAtIndex:i]);
    }
 */

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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
	// Do any additional setup after loading the view.
    nibsRegistered = NO;
    NSString *string1 = NSLocalizedString(@"Cancel", @"취소");
    [cancelButton setTitle:string1];
   
    ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];

    assets = [[NSMutableArray alloc] init];
    [al enumerateGroupsWithTypes:ALAssetsGroupAll
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                          [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                              if (asset){
                                  //ex 1
                                  //NSLog(@"%@",asset);
                                  [assets addObject:[asset valueForProperty:ALAssetPropertyURLs]];
                                  
                                  //ex 2
                                  NSLog(@"%d",index);
                                  //UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                                  UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
                                  [self performSelectorOnMainThread:@selector(usePhotolibraryimage:) withObject:image waitUntilDone:NO];
//                                  [self performSelectorOnMainThread:@selector(reload:) withObject:image waitUntilDone:NO];

                              }
                          }];
                      }failureBlock:^(NSError *error){
                          // User did not allow access to library
                          // .. handle error
                          NSString *errorMessage = nil;
                          switch ([error code]) {
                              case ALAssetsLibraryAccessUserDeniedError:
                              case ALAssetsLibraryAccessGloballyDeniedError:
                                  errorMessage = @"The user has declined access to it.";
                                  break;
                                  
                              default:
                                  errorMessage = @"Reason unkwon.";
                                  break;
                          }
     }];

    
    /*
     UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// IOS 6.0 이하 버전에서 landscape로 시작하지 않기 때문에 강제로 설정해주는 부분 (IOS 6.0 이상에서는 Call 되지 않음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        return YES;
    }
    
    return NO;
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [super viewDidUnload];
}

#pragma ALAssetsLibrary selector
//- (void)usePhotolibraryimage:(UIImage *)myImage{
- (void)usePhotolibraryimage:(CGImageRef )myImage{
    //Do your all UI related and all stuff here
    //NSLog(@"assets = %@", assets);
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.assets.count / 4;
    NSLog(@"assets count = %d, line count = %d", self.assets.count, count);
    return (count+1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"VenusFilmPhotoCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        nibsRegistered = YES;
    }
    VenusFilmPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellTableIdentifier];
    
    //NSUInteger row = [indexPath row];
    //NSDictionary *rowData = [self.assets objectAtIndex:row];
    
    //cell.name = [rowData objectForKey:@"Name"];
    //cell.color = [rowData objectForKey:@"Color"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0; // Same number we used in Interface Builder
}
@end



