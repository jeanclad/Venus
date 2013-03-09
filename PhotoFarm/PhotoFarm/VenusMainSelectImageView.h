//
//  VenusMainSelectImageView.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 9..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class VenusMainSelectImageView;

@interface VenusMainSelectImageView : UIImageView{
    UIImageView *selectedView;
    ALAsset *asset; 
}

@property (nonatomic, retain) ALAsset *asset;

@end
