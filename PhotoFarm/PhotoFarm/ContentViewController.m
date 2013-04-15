//
//  ContentViewController.m
//  TestPageController
//
//  Created by Wontai Ki on 12. 3. 15..
//  Copyright (c) 2012년 Young Soft. All rights reserved.
//

#import "ContentViewController.h"
#import "GlobalDataManager.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

@synthesize mContentString = _mContentString;
@synthesize mContentLabel = _mContentLabel;

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
    // Do any additional setup after loading the view from its nib.
    if ([self.mContentString isEqualToString:@"Page 0"]){
        self.mContentLabel.text = nil;
        self.albumSubImage.hidden = YES;
    }else{
        self.mContentLabel.text = self.mContentString;
        self.albumTitleImage.hidden = YES;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        NSString *paperFile = [self.currentPagePlistData objectAtIndex:INDEX_PAPER_PHOTO_FILE_NAME];
        NSString *path = [cachesDirectory stringByAppendingPathComponent:paperFile];
    
        NSLog(@"load path = %@", path);
        NSData * loadImageData = [NSData dataWithContentsOfFile:path];
        
        /* FIle Read Error test by jeanclad
        NSError *error = nil;
        NSData * loadImageData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:&error];
        NSLog(@"error = %@", error.localizedDescription);
        -----------------------------------------------------------------------------------------------------------*/

        UIImage *loadImage = [UIImage imageWithData:loadImageData];
        [self.albumtPhotoImage setImage:loadImage];
        [self.view addSubview:self.albumtPhotoImage];
        
        if (_afterDeveloping == YES)
            [self contentPhotoAnimationAfterDeveloping];
    }
    
    // Navigation Bar 설정
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //[self performSelector:@selector(viewDidDisappear:) withObject:nil afterDelay:1.0];
}



- (void)viewDidUnload
{
    [self setAlbumTitleImage:nil];
    [self setAlbumSubImage:nil];
    [self setAlbumtPhotoImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark  -jeanclad
- (void) contentPhotoAnimationAfterDeveloping
{
    CGRect orgRect = self.albumtPhotoImage.frame;
    
    self.albumtPhotoImage.frame = CGRectMake(0-self.albumtPhotoImage.frame.size.width, IP4_IP5_SIZE_HEIGHT+self.albumtPhotoImage.frame.size.height, self.albumtPhotoImage.frame.size.width, self.albumtPhotoImage.frame.size.height);
    [self.albumtPhotoImage setAlpha:0.0f];
    
    //---   알파값을 조금 늦게 변하게 하여 사진이 점점 뚜렷하게 보이도록 한다.
    [UIView beginAnimations:@"albumPhotoImageUpAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:2.0f];
    self.albumtPhotoImage.frame = CGRectMake(orgRect.origin.x, orgRect.origin.y, self.albumtPhotoImage.frame.size.width, self.albumtPhotoImage.frame.size.height);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"albumPhotoImageAlphaUpAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.5f];
    [UIView setAnimationDelay:0.5f];
    [self.albumtPhotoImage setAlpha:1.0f];
    [UIView commitAnimations];


}

// IOS 6.0 이하 버전에서 landscape로 시작하지 않기 때문에 강제로 설정해주는 부분 (IOS 6.0 이상에서는 Call 되지 않음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        return YES;
    }
    
    return NO;
}

@end
