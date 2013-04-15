//
//  VenusMainViewController.h
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>
#import "VenusScroll.h"
#import "VenusProgressViewController.h"
#import "chemicalAnimation.h"
#import "VenusPhotoPaperController.h"
#import "VenusSaveItemController.h"

#define MYDEVICE_IPHONE5                1
#define MYDEVICE_ETC                    2
#define IP5_SIZE_WIDTH                  568
#define IP4_SIZE_WIDTH                  480
#define IP4_IP5_SIZE_HEIGHT             320

#define SELECT_RIGHT_MOVE_X_IP5         284
#define SELECT_RIGHT_MOVE_X_IP4         240
#define SELECT_RIGHT_MOVE_Y             50

#define SELECT_BUTTON_MOVE_X_IP5        80
#define SELECT_BUTTON_MOVE_X_IP4        60
#define SELECT_BUTTON_MOVE_Y            60

#define PINCETTE_SIZE_WIDTH             95
#define PINCETTE_SIZE_HEIGHT            68

#define PREVIEW_ORIGIN_X                    0
#define PREVIEW_ORIGIN_Y                    0
#define PREVIEW_NO_MOVE_FRAME_SIZE_WIDTH    140
#define PREVIEW_NO_MOVE_FRAME_SIZE_HEIGHT   140

#define PAPER_PHOTO_SIZE                    200
#define PAPERLESS_PHOTO_SIZE                320

#define PREVIEW_FRAME_SIZE_WIDTH            200
#define PREVIEW_FRAME_SIZE_HEIGHT           200
#define PREVIEW_PHOTO_SIZE_WIDTH            200
#define PREVIEW_PHOTO_SIZE_HEIGHT           200

#define PREVIEW_NOT_PAPER_PHOTO_ORIGIN_X        0
#define PREVIEW_NOT_PAPER_PHOTO_ORIGIN_Y        0
#define PREVIEW_NOT_PAPER_PHOTO_SIZE_WIDTH      200
#define PREVIEW_NOT_PAPER_PHOTO_SIZE_HEIGHT     200

#define PREVIEW_POLAROID_PHOTO_ORIGIN_X         25
#define PREVIEW_POLAROID_PHOTO_ORIGIN_Y         5
#define PREVIEW_POLAROID_PHOTO_SIZE_WIDTH       150
#define PREVIEW_POLAROID_PHOTO_SIZE_HEIGHT      150

#define PREVIEW_ROLLED_UP_PHOTO_ORIGIN_X        20
#define PREVIEW_ROLLED_UP_PHOTO_ORIGIN_Y        15
#define PREVIEW_ROLLED_UP_PHOTO_SIZE_WIDTH      160
#define PREVIEW_ROLLED_UP_PHOTO_SIZE_HEIGHT     160

#define PREVIEW_SPRING_PHOTO_ORIGIN_X           15
#define PREVIEW_SPRING_PHOTO_ORIGIN_Y           15
#define PREVIEW_SPRING_PHOTO_SIZE_WIDTH         170
#define PREVIEW_SPRING_PHOTO_SIZE_HEIGHT        170

#define PREVIEW_VINTAGE_PHOTO_ORIGIN_X          15
#define PREVIEW_VINTAGE_PHOTO_ORIGIN_Y          15
#define PREVIEW_VINTAGE_PHOTO_SIZE_WIDTH        170
#define PREVIEW_VINTAGE_PHOTO_SIZE_HEIGHT       170

#define PREVIEW_CRUMPLED_PHOTO_ORIGIN_X         0
#define PREVIEW_CRUMPLED_PHOTO_ORIGIN_Y         0
#define PREVIEW_CRUMPLED_PHOTO_SIZE_WIDTH      200
#define PREVIEW_CRUMPLED_PHOTO_SIZE_HEIGHT     200

#define PREVIEW_FOLDED_PHOTO_ORIGIN_X           0
#define PREVIEW_FOLDED_PHOTO_ORIGIN_Y           0
#define PREVIEW_FOLDED_PHOTO_SIZE_WIDTH         200
#define PREVIEW_FOLDED_PHOTO_SIZE_HEIGHT        200

#define CHEMICAL_ROTATION_ANGLE         100
#define BEAKER_ROTATION_ANGLE           -100
#define PROGRRESS_FILL_IMAGE_ALPHA      0.7f

#define BEAKER_DROP_WATER_TIME          3.0f

#define SELECTED_BUTTON_MOVE_Y          50
#define PINCETTE_MOVE_X                 50
#define PINCETTE_MOVE_Y                 50
#define SMALL_STEEL_MOVE_Y              100
#define BIG_STEEL_MOVE_Y                420
#define MAINVIEW_ANIMATION_DURATION     0.5f
#define MAINVIEW_ANIMATION_DELAY        0.5f

#define BIG_BEAKER_START_X_IP4          50
#define BIG_BEAKER_END_X_IP4            IP4_SIZE_WIDTH-50
#define BIG_BEAKER_START_Y_IP4          50
#define BIG_BEAKER_END_Y_IP4            IP4_IP5_SIZE_HEIGHT-50

#define DEVELOPING_PHOTO_ALPHA           0.3f

#define kUpdateInterval    (1.0f/60.0f)

@interface VenusMainViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>{
    NSInteger         myDevice;
    UIButton    *firstNotSelectedButton;
    UIButton    *selectedButton;
    
    ALAsset     *asset;
    CGImageRef thumbnailImageRef;
    //UIImage     *thumbnail;
    
    VenusPhotoPaperController   *venusPhotoPaperController;
    
    BOOL        firstSelect;
    BOOL        developing;
    //UIImage     *_bg;
    //UIImage     *preview_img;
    UIImageView *waterImageView;
    UIImageView *darkRoomOffSteelImageView;
    UIImageView *darkRoomOnSteelImageView;
    UIImageView *secondPinceeteImageView;
    UIView      *developingImageView;
    UIImageView *developingPhotoImageView;
    UIImageView *developingPaperImageView;
    
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
    
    CMMotionManager *motionManager;
    CMAcceleration acceleration;
    CGFloat photoXVelocity;
    CGFloat photoYVelocity;
    CGPoint currentPoint;
    CGFloat photoDevelopingAlpha;
    UIProgressView *devleopingProgress;
    CGFloat developingProgressLevel;
    
    NSDate *lastUpdateTime;
    
    VenusSaveItemController *venusSaveItemController;
}

@property (nonatomic, strong) ALAsset *asset;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *MainSecondView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *underBarItemView;

@property (weak, nonatomic) IBOutlet UIImageView *room;
@property (weak, nonatomic) IBOutlet UIButton *lightButton;
@property (weak, nonatomic) IBOutlet UIImageView *darkRoomInUseTitle;
@property (weak, nonatomic) IBOutlet UIImageView *lamp;
@property (weak, nonatomic) IBOutlet UIImageView *bigSteel;


- (IBAction)UnderButtonPressed:(UIButton *)sender;
- (IBAction)lightSwitchPressed:(UIButton *)sender;

@end
