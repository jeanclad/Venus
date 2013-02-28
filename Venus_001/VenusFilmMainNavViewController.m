//
//  VenusFilmMainNavViewController.m
//  Venus_001
//
//  Created by 권 회경 on 13. 2. 28..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusFilmMainNavViewController.h"

@interface VenusFilmMainNavViewController ()

@end

@implementation VenusFilmMainNavViewController

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
    
    self.title = @"My Title";
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log in"
                                                                       style:UIBarButtonItemStylePlain target:self                                   action:@selector(ActLogin:)];
//    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [[self navigationItem] setBackBarButtonItem: leftButtonItem];
}

-(IBAction) ActLogin:(id)sender
{
    NSLog(@"Log-in Action");
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
@end
