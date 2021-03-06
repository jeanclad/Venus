//
//  VenusAlbumDetailViewController.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 12..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenusSaveItemController.h"

@interface VenusAlbumDetailViewController : UIViewController <UIActionSheetDelegate> {
    VenusSaveItemController *venusSaveItemController;
    UIActivityIndicatorView *indicatorView;
    UIActionSheet *deleteActionSheet;
    UIActionSheet *SnsActionSheet;
}
- (IBAction)buttonPressed:(UIButton *)sender;

@property (weak, nonatomic) NSString *selectedKey;
@property (weak, nonatomic) IBOutlet UIView *DetailContentView;
@property (weak, nonatomic) IBOutlet UIImageView *detailPagePhotoVIew;
@property (weak, nonatomic) IBOutlet UIImageView *detailPageLabelView;
@property (strong, nonatomic) UIImage *loadImage;

@property (weak, nonatomic) IBOutlet UILabel *paperLable;
@property (weak, nonatomic) IBOutlet UILabel *chemicalLabel;

@end
