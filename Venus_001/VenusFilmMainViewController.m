//
//  VenusFilmMainViewController.m
//  Venus_001
//
//  Created by 권 회경 on 13. 2. 27..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusFilmMainViewController.h"
#import "AssetsDataIsInaccessibleViewController.h"

@interface VenusFilmMainViewController ()

@end

@implementation VenusFilmMainViewController

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
 
    /*
    //---   아이폰4,5 해상도 대응
    UIScreen *screen = [UIScreen mainScreen];
    float w,h;
    
    if (screen.bounds.size.height== 568) {
        w = 568;
        h = 320;
    }else{
        w = 480;
        h = 320;
    }
    
    
    //---   네비게이션바, Cancel버튼 설정
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, w, 44)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"aaaaaa"];

    [navBar pushNavigationItem:item animated:NO];
    navBar.tintColor = [UIColor blackColor];
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonPressed:)];
    
    [self.view addSubview:navBar];
     */
    
    
    //---   Photo Library에서 Group 불러오기
    if (!assetsLibrary) {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    if (!groups) {
        groups = [[NSMutableArray alloc] init];
    } else {
        [groups removeAllObjects];
    }
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            [groups addObject:group];
        } else {
            [self.tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        AssetsDataIsInaccessibleViewController *assetsDataInaccessibleViewController = [[AssetsDataIsInaccessibleViewController alloc] initWithNibName:@"AssetsDataIsInaccessibleViewController" bundle:nil];
        
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        
        assetsDataInaccessibleViewController.explanation = errorMessage;
        [self presentModalViewController:assetsDataInaccessibleViewController animated:NO];
        //[assetsDataInaccessibleViewController release];
    };
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
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
    [self setTableview:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return groups.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
     NSLog (@"returning cell %@ at %@", cell, indexPath);
    
    NSLog(@"row = %d", indexPath.row);
    
    ALAssetsGroup *groupForCell = [groups objectAtIndex:indexPath.row];
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    cell.imageView.image = posterImage;
    cell.textLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (IBAction)buttonPressed:(UIBarButtonItem *)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
