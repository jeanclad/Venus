//
//  VenusFilmGroupViewController.m
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusFilmGroupViewController.h"
#import "AlbumContentsViewController.h"

@interface VenusFilmGroupViewController ()

@end

@implementation VenusFilmGroupViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = @"DARKROOM IN USE";

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
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {    
        NSString *errorMessage1 = NSLocalizedString(@"DataNotAvailable", @"사진첩 접근 에러");
        NSString *errorMessage2 = nil;
        NSString *errorMessage3 = NSLocalizedString(@"Cancel", @"취소");
        
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage2 = NSLocalizedString(@"PhotoNotAccess", @"사진접근에러 메세지 1");
                break;
            default:
                errorMessage2 = NSLocalizedString(@"ReasonUnknown", @"사진접근에러 메세지 2");
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorMessage1 message:errorMessage2 delegate:self cancelButtonTitle:errorMessage3 otherButtonTitles:nil];
        
        [alert show];

    };
    NSLog(@"Group = %@", groups);
    
//    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces;
    NSUInteger groupTypes = ALAssetsGroupAll;
    [assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSLog (@"returning cell %@ at %@", cell, indexPath);
    
    ALAssetsGroup *groupForCell = [groups objectAtIndex:indexPath.row];
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    cell.imageView.image = posterImage;
    cell.textLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (groups.count > indexPath.row) {
        AlbumContentsViewController *albumContentsViewController = [[AlbumContentsViewController alloc] initWithNibName:@"AlbumContentsViewController" bundle:nil];
        albumContentsViewController.assetsGroup = [groups objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:albumContentsViewController animated:YES];
    }
    
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Alert View delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"button = %d", buttonIndex);
    
   [self.navigationController popToRootViewControllerAnimated:YES];
}

// IOS 6.0 이하 버전에서 landscape로 시작하지 않기 때문에 강제로 설정해주는 부분 (IOS 6.0 이상에서는 Call 되지 않음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        return YES;
    }
    
    return NO;
}
@end
