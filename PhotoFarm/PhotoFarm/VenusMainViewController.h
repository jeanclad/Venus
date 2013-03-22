//
//  VenusMainViewController.h
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define SELECT_RIGHT_MOVE_X_IP5   284
#define SELECT_RIGHT_MOVE_X_IP4   240
#define SELECT_RIGHT_MOVE_Y        50

typedef enum {
    BIG_STEEL_IMAGE,
    SMALL_STEEL_IMAGE
}steelSize;

@interface VenusMainViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>{
    UIButton    *selectedButton;
    ALAsset     *asset;
    CGImageRef thumbnailImageRef;
    UIImage     *thumbnail;
    BOOL        firstSelect;
    BOOL        MainVIewMoved;
    
    //---   Scroll View
    UIScrollView * paperScrollView;
	UIView * paperContentView;
	UIPageControl * paperPageControl;
    
    UIScrollView *chemicalScrollView;
	UIView * chemicalContentView;
	UIPageControl * chemicalPageControl;
}
@property (nonatomic, strong) ALAsset *asset;
- (IBAction)UnderButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *underBarItemView;
@property (weak, nonatomic) IBOutlet UIImageView *beakerImage;
@property (weak, nonatomic) IBOutlet UIImageView *bigSteelImage;
@property (weak, nonatomic) IBOutlet UIImageView *smallSteelImage;
@property (weak, nonatomic) IBOutlet UIImageView *pincetteImage;

@end
