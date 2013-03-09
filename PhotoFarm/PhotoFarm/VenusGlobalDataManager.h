//
//  VenusGlobalDataManager.h
//  PhotoFarm
//
//  Created by kwon hoekyung on 13. 3. 9..
//  Copyright (c) 2013년 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VenusGlobalDataManager : NSObject{
    ALAsset *asset;
}
+ (VenusGlobalDataManager *) sharedGlobalDataManager;

@property (nonatomic, retain) ALAsset *asset;

@end


