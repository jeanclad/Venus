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
    ALAsset *asset;
}
- (IBAction)buttonPressed:(UIButton *)sender;

@end
