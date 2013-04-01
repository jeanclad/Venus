//
//  VenusMainViewController.h
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "VenusScroll.h"
#import "VenusProgressViewController.h"
#import "chemicalAnimation.h"

#define PREVIEW_FRAME_SIZE_WIDTH    140
#define PREVIEW_FRAME_SIZE_HEIGHT    140
#define PREVIEW_PHOTO_SIZE_WIDTH    130
#define PREVIEW_PHOTO_SIZE_HEIGHT   130

#define SELECT_RIGHT_MOVE_X_IP5   284
#define SELECT_RIGHT_MOVE_X_IP4   240
#define SELECT_RIGHT_MOVE_Y        50

#define CHEMICAL_ROTATION_ANGLE     100
#define PROGRRESS_FILL_IMAGE_ALPHA  0.7

#define BEAKER_DROP_WATER_TIME      1.0f

#define SELECTED_BUTTON_MOVE_Y  50
#define PINCETTE_MOVE_X         50
#define PINCETTE_MOVE_Y         50
#define SMALL_STEEL_MOVE_Y      100
#define BIG_STEEL_MOVE_Y        420
#define MAINVIEW_ANIMATION_DELAY      0.3f

typedef enum {
    BIG_STEEL_IMAGE,
    SMALL_STEEL_IMAGE
}steelSize;


@interface VenusMainViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>{
    UIButton    *selectedButton;
    ALAsset     *asset;
    CGImageRef thumbnailImageRef;
    //UIImage     *thumbnail;
    UIImage *mainPhotoView;
    BOOL        firstSelect;
    BOOL        MainVIewMoved;
    UIImage     *_bg;
    UIImage     *preview_img;
    
    //---   Scroll View
    UIScrollView * paperScrollView;
	UIView * paperContentView;
	UIPageControl * paperPageControl;
    
    VenusScroll *chemicalScrollView;
	UIView * chemicalContentView;
	UIPageControl * chemicalPageControl;
    NSMutableArray *chemicalImageView;
    
    VenusProgressViewController *beakerView;
    NSTimer *waitBaekerProgressTimer;
    NSTimer *stopBeakerProgressTimer;
    NSTimer *fillBeakerTimer;
    float wantProgressLevel;
    
    chemicalAnimation *chemicalAni;
}
@property (nonatomic, strong) ALAsset *asset;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *underBarItemView;
@property (weak, nonatomic) IBOutlet UIImageView *bigSteelImage;
@property (weak, nonatomic) IBOutlet UIImageView *smallSteelImage;
@property (weak, nonatomic) IBOutlet UIImageView *pincetteImage;

- (IBAction)UnderButtonPressed:(UIButton *)sender;
- (UIImage*) makeThumbnailImage:(UIImage*)image onlyCrop:(BOOL)bOnlyCrop Size:(float)size;

@end
