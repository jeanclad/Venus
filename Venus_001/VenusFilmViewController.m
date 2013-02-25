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
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", getObjects:assets);
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
                                  NSLog(@"%@",asset);
                                  [assets addObject:asset];
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

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
