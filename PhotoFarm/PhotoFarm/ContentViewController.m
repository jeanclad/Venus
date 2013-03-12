//
//  ContentViewController.m
//  TestPageController
//
//  Created by Wontai Ki on 12. 3. 15..
//  Copyright (c) 2012년 Young Soft. All rights reserved.
//

#import "ContentViewController.h"

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
    }
    
    // Navigation Bar 설정
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self performSelector:@selector(viewDidDisappear:) withObject:nil afterDelay:1.0];
}



- (void)viewDidUnload
{
    [self setAlbumTitleImage:nil];
    [self setAlbumSubImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark  -jeanclad
// IOS 6.0 이하 버전에서 landscape로 시작하지 않기 때문에 강제로 설정해주는 부분 (IOS 6.0 이상에서는 Call 되지 않음)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)){
        return YES;
    }
    
    return NO;
}

- (IBAction)bottomButtonPressed:(UIButton *)sender
{
    NSLog(@"3333");
}
@end
