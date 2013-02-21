//
//  VenusFilmViewController.m
//  Venus_001
//
//  Created by 권 회경 on 13. 2. 20..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import "VenusFilmViewController.h"

@interface VenusFilmViewController ()

@end

@implementation VenusFilmViewController

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
    
    NSLog(@"bbbbbb");
    
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
@end
