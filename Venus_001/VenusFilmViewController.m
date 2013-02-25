//
//  VenusFilmViewController.m
//  Venus_001
//
//  Created by 권 회경 on 13. 2. 20..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusFilmViewController.h"
#import "AssetsLibrary/AssetsLibrary.h"

@interface VenusFilmViewController ()
@end
@implementation VenusFilmViewController
@synthesize assets;

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
   
    ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];

    NSLog(@"start");
    assets = [[NSMutableArray alloc] init];
    [al enumerateGroupsWithTypes:ALAssetsGroupAll
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                          [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                              if (asset){
                                  //ex 1
                                  NSLog(@"%@",asset);
                                  [assets addObject:[asset valueForProperty:ALAssetPropertyURLs]];
                                  
                                  //ex 2
                                  NSLog(@"%d",index);
                                  UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                                  [self performSelectorOnMainThread:@selector(usePhotolibraryimage:) withObject:image waitUntilDone:NO];
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
    NSLog(@"end");

    
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
    [super viewDidUnload];
}

#pragma ALAssetsLibrary selector
- (void)usePhotolibraryimage:(UIImage *)myImage{
    //Do your all UI related and all stuff here
    NSLog(@"assets = %@", assets);
}
@end



