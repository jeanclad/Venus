//
//  VenusFilmViewController.h
//  Venus_001
//
//  Created by 권 회경 on 13. 2. 20..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenusFilmViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (IBAction)buttonPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, retain) NSMutableArray *assets;
@property BOOL nibsRegistered;
@end