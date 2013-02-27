//
//  VenusFilmMainViewController.h
//  Venus_001
//
//  Created by 권 회경 on 13. 2. 27..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VenusFilmMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *groups;
}
- (IBAction)buttonPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
