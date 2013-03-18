//
//  VenusMainViewController.h
//  PhotoFarm
//
//  Created by 권 회경 on 13. 3. 4..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "VenusPersistList.h"


@interface VenusMainViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>{
    UIButton    *selectedButton;
    ALAsset     *asset;
    CGImageRef thumbnailImageRef;
    UIImage     *thumbnail;
    BOOL        firstSelect;
    VenusPersistList *photoInfoFileList;
    NSMutableArray *reversePlistKeys;
}
@property (nonatomic, strong) ALAsset *asset;
- (IBAction)UnderButtonPressed:(UIButton *)sender;
@end
