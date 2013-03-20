//
//  VenusMainViewController.h
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface VenusMainViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>{
    UIButton    *selectedButton;
    ALAsset     *asset;
    CGImageRef thumbnailImageRef;
    UIImage     *thumbnail;
    BOOL        firstSelect;
}
@property (nonatomic, strong) ALAsset *asset;
- (IBAction)UnderButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *underBarItemView;

@end
