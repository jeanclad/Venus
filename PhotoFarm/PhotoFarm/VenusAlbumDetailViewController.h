//
//  VenusAlbumDetailViewController.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 12..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenusAlbumDetailViewController : UIViewController
- (IBAction)buttonPressed:(UIButton *)sender;

@property (strong, nonatomic) NSMutableArray *currentPagePlistData;
@property (weak, nonatomic) IBOutlet UIImageView *detailPagePhotoVIew;
@end
